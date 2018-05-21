#!/bin/sh -

utctime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
tpl=$(cat <<AWK
BEGIN{print "\
<?xml version='1.0' encoding='utf-8'?>\
<feed xmlns='http://www.w3.org/2005/Atom'>\
  <title>Hacker News</title>\
  <id>hacker:news</id>\
  <updated>$utctime</updated>\
"}
{printf "\
  <entry>\
    <title>%s</title>\
    <id>%s</id>\
    <published>$utctime</published>\
    <link href=\"%s\">%s</link>\
    <author><name>Roy</name></author>\
  </entry>\
", \$2, \$1, \$1, \$1}
END{prnit "</feed>"}
AWK
)
curl https://news.ycombinator.com/best 2>&- | xmllint --html --xpath "//table[@class='itemlist']/tr[@class='athing']/td[@class='title'][last()]/a[1]/text() | //table[@class='itemlist']/tr[@class='athing']/td[@class='title'][last()]/a[1]/@href" - | sed 's/href="/\
/g' | sed '1d' | awk -F'"' "$tpl"
