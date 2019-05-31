#!/bin/bash -

echo "<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom'>
  <title> 电子科大研究生招生网 </title>
  <id> uestc:recuite </id>
  <updated>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</updated>"
curl "https://yz.uestc.edu.cn/shuoshizhaosheng/" 2>&- | pup 'table.box li:parent-of(span) json{}' | jq -r '.[] as $li | "
<entry>
  <title>\($li.children[0].title)</title>
  <id>\($li.children[0].href)</id>
  <published>\($li.children[1].text)</published>
  <link href=\"\($li.children[0].href)\">\($li.children[0].href)</link>
  <author><name> UESTC </name></author>
</entry>"' | sed 's;<link href="/;<link href="https://yz.uestc.edu.cn/;'
echo ""
echo "</feed>"
