#!/bin/sh -

utctime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
tpl=$(cat <<AWK
BEGIN{print "\
<?xml version='1.0' encoding='utf-8'?>\
<feed xmlns='http://www.w3.org/2005/Atom'>\
  <title> 电子科大研究生招生网 </title>\
  <id> uestc:recuite </id>\
  <updated>$utctime</updated>\
"}
{printf "\
  <entry>\
    <title>%s</title>\
    <id>%s</id>\
    <published>$utctime</published>\
    <link href=\"%s\">%s</link>\
    <author><name> UESTC </name></author>\
  </entry>\
", \$2, \$1, \$1, \$1}
END{prnit "</feed>"}
AWK
)
curl "http://yz.uestc.edu.cn/shuoshizhaosheng/" 2>&- | xmllint 2>&- --html --xpath '//div[@id="mcontent"]//table[@class="box"][1]//li/a/@*' - | sed 's/ href="/\
/g' | sed -e '1d' -e 's/" title="/ /' -e 's/"$//' | awk "$tpl"
