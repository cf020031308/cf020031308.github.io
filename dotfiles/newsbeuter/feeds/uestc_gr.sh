#!/bin/bash -

cat <<FEED | sed '/^ \{1,\}<published>/s/\([0-9]\{4\}\)年\([0-9]\{1,2\}\)月\([0-9]\{1,2\}\)日/\1-\2-\3/' 
<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom' xml:base="http://gr.uestc.edu.cn">
  <id> uestc:graduate </id>
  <updated>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</updated>"
$(curl "http://gr.uestc.edu.cn/tongzhi/$1" 2>&- | pup 'title, .topic_item_c json{}' | jq -r '.[] | if .tag == "title" then
"  <title> \(.text) </title>" else "
<entry>
  <title>\(.children[0].children[0].text)</title>
  <id>\(.children[0].children[0].href)</id>
  <published>\(.children[1].text)</published>
  <link href=\"\(.children[0].children[0].href)\">\(.children[0].children[0].href)</link>
  <author><name> UESTC </name></author>
</entry>"
end
')

</feed>
FEED
