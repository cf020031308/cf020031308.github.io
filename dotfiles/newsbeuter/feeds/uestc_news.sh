#!/bin/bash -

echo "<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom'>
  <title> 成电新闻网 </title>
  <id> uestc:is </id>
  <updated>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</updated>"
curl -kL "https://news.uestc.edu.cn/?n=UestcNews.Front.Category.Page&CatId=$1" 2>&- | pup 'div#Degas_news_list > ul li json{}' | jq -r '.[] | if .children[0].class == "thumb" then .children[1:] else .children end | . as $li | "
<entry>
  <title>\($li[0].children[0].text)</title>
  <id>\($li[0].children[0].href)</id>
  <published>\($li[1].text)</published>
  <link href=\"\($li[0].children[0].href)\">\($li[0].children[0].href)</link>
  <author><name> UESTC </name></author>
</entry>"' | sed 's;<link href="/;<link href="https://news.uestc.edu.cn/;'

echo ""
echo "</feed>"
