#!/bin/sh -

AUTH="$HOME/.accounts/my_discuz"
COOKIE="/tmp/my_cookie"
UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0'

host=$(sed -n '1p' "${AUTH}")
auth=$(sed -n '2p' "${AUTH}")


function http() {
    curl 2>&- -b "${COOKIE}" -c "${COOKIE}" -H"User-Agent: ${UA}" $@
}


function login() {
    url="http://${host}/logging.php?action=login"
    formhash=$(http -H"Referrer: ${url}" "${url}" | xmllint --html --xpath "//form[@name='login']/input[@name='formhash']/@value" - 2>&- | sed 's/.*"\(.*\)"/\1/')
    http -H"Referrer: ${url}" -d "formhash=${formhash}&referer=index.php&loginfield=username&${auth}&questionid=0&answer=&cookietime=315360000&loginmode=&styleid=&loginsubmit=%CC%E1+%26%23160%3B+%BD%BB" "${url}&" > /dev/null
}


function index() {
    http "http://${host}/forumdisplay.php?fid=41&filter=0&orderby=dateline&page=1"\
        | xmllint --html --xpath '//table[@class="row"]//td[@class="f_title"]/a/@href' 2>&- -\
        | sed -e 's/ href="/\
/g' -e 's/"//g'\
        | grep "viewthread.php"\
        | sort\
        | uniq
}


function parse() {
    http "http://${host}/$1"\
        | xmllint --html --xpath '//table[@class="t_msg"][1]//tr[2]/td//text() | //table[@class="t_msg"][1]//tr[2]/td//img/@src' 2>&- -\
        | iconv -f gbk -t UTF-8\
        | sed 's/\(src=".*"\)/<img \1>/g'\
        | grep -v 'src="/'
}


if [ ! -e "${COOKIE}" ]; then
    login "${host}"
fi
utctime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat <<FEED
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title> MyDiscuz </title>
  <id> my_discuz:41 </id>
  <update> ${utctime} </update>

FEED
for uri in $(index)
do parse ${uri} | python -c '
import sys
import hashlib

lines = [line.strip() for line in sys.stdin.read().splitlines() if line.strip()]
if not lines:
    exit()
title = lines[0]
_id = hashlib.md5(title).hexdigest()
content = "<br>".join(lines[1:])
print("""  <entry>
    <title> %s </title>
    <id> %s </id>
    <content type="html"><![CDATA[%s]]></content>
    <author><name> MyDiscuz </name></author>
  </entry>""" % (title, _id, content))
'
done

echo '</feed>'
