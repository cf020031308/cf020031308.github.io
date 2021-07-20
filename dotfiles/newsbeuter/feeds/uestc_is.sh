#!/bin/bash -

year=$(date -u "+%Y")
echo "<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom'>
  <title> 电子科大信息与软件工程学院 </title>
  <id> uestc:is </id>
  <updated>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</updated>"
curl "https://www.is.uestc.edu.cn/" 2>&- | pup 'li.annce-cont:first-of-type li json{}' | jq -r '.[].children[0] as $li | "
<entry>
  <title>\($li.children[0].title)</title>
  <id>\($li.children[0].href)</id>
  <published>\($li.children[1].text)</published>
  <link href=\"\($li.children[0].href)\">\($li.children[0].href)</link>
  <author><name> UESTC </name></author>
</entry>"' | sed 's;<link href="/;<link href="https://is.uestc.edu.cn/;' | sed "s;<published>;<published>${year}-;"

echo ""
echo "</feed>"
