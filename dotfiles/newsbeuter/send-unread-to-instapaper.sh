#!/bin/sh -

sqlite3 ~/.newsbeuter/cache.db 'SELECT rss_feed.title, rss_item.url, rss_item.title FROM rss_item JOIN rss_feed ON rss_item.feedurl = rss_feed.rssurl WHERE rss_item.unread = "1" ORDER BY rss_item.feedurl;' | python -c '
import sys
from itertools import groupby

for title, items in groupby(
        [
            line.split("|", 2)
            for line in sys.stdin.read().splitlines()
            if line
        ], lambda x: x.pop(0)):
    print("</ul><h2> %s </h2><ul>" % title)
    for url, subtitle in items:
        print("<li><a href=\"%s\"> %s </a></li>" % (url, subtitle))
'

# TODO: send to instapaper via mail
