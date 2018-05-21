#!/bin/sh -

watch_list='{BTC_ETH, BTC_ZEC, BTC_XMR, USDT_BTC, USDT_ETH, USDT_ZEC, USDT_ETC, USDT_XMR}'
api="https://poloniex.com/public?command=returnTicker"

prices=`proxychains4 curl 2>&- $api | jq "with_entries(.value |= (.last | tonumber))"`
btc=`echo "$prices" | jq ".USDT_BTC"`
if [ $btc ]; then
    time=`date +"%H:%M:%S"`
    utctime=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
    watches=`echo "$prices" | jq "$watch_list"`
    cat <<FEED
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

  <title>Poloniex</title>
  <id>poloniex:prices</id>
  <updated>$utctime</updated>

  <entry>
    <title>$time BTC: \$$btc</title>
    <id>poloniex:prices:$utctime</id>
    <published>$utctime</published>
    <content type="html"><![CDATA[
      <pre><code>
      $watches
      </code></pre>
    ]]></content>
    <author><name>Roy</name></author>
  </entry>

</feed>
FEED
fi
