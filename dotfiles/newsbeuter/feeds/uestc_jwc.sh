#!/bin/bash -

if [ "$1" ]; then
    url="https://www.jwc.uestc.edu.cn/web/News!queryList.action?partId=$1"
else
    url="https://www.jwc.uestc.edu.cn/web/News!queryHard.action#"
fi
echo "<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom'>
  <title> 电子科大教务处 </title>
  <id> uestc:is </id>
  <updated>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</updated>"
curl "${url}" 2>&- | pup 'div.section_Content div.textAreo json{}' | jq -r '.[] as $li | "
<entry>
  <title>\($li.children[0].text)</title>
  <id>\($li.children[0].newsid)</id>
  <published>\($li.children[1].text)</published>
  <link href=\"\($li.children[0].newsid)\">\($li.children[0].newsid)</link>
  <author><name> UESTC </name></author>
</entry>"' | sed 's;<link href=";<link href="https://www.jwc.uestc.edu.cn/web/News!view.action?id=;' | sed '/<published>/s;/;-;g'

echo ""
echo "</feed>"
