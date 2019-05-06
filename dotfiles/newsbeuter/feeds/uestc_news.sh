#!/bin/bash -

utctime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
tpl=$(cat <<AWK
{printf "\
  <entry>\
    <title>%s</title>\
    <id>%s</id>\
    <published>%s</published>\
    <link href=\"https://news.uestc.edu.cn%s\">https://news.uestc.edu.cn%s</link>\
    <author><name> UESTC </name></author>\
    <content>%s</content>\
  </entry>\n\
", \$2, \$1, \$3, \$1, \$1, \$4}
AWK
)

cat <<EOF
<?xml version='1.0' encoding='utf-8'?>
<feed xmlns='http://www.w3.org/2005/Atom'>
  <title> 电子科大新闻 </title>
  <id> uestc:news </id>
  <updated>$utctime</updated>
EOF

sep="	"
for catid in 66 67 68 72; do
    curl "https://news.uestc.edu.cn/?n=UestcNews.Front.Category.Page&CatId=$catid" 2>&- | xmllint 2>&- --html --xpath '
//div[@id="Degas_news_list"]/ul/li/h3/a/@href |
//div[@id="Degas_news_list"]/ul/li/h3/a/text() |
//div[@id="Degas_news_list"]/ul/li/span[@class="time"]/text() |
//div[@id="Degas_news_list"]/ul/li/p[@class="desc"]/text()
' - | sed -n 'H;$x;$s/[[:space:]]//g;$p' | sed 's/href="/\
/g' | sed -E -e 's/"/'"$sep/" -e 's/[0-9]{4}-[0-9]{2}-[0-9]{2}/'"$sep&$sep/" | sed '1d' | awk -F"$sep" "$tpl"
done

echo "</feed>"
