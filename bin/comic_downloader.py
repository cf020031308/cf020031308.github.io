#!/usr/local/bin/python2
# coding: utf8
# 2: 海贼王，看完 949
# 39: 进击的巨人，看完 119
# 132: 一拳超人，看完 155
# E.g. Download One Piece from chapter 600 to 700: `python2 $0 2 600 700`
#      Then `zip bundle.zip output/*` and you can upload it into kindle.
import re
import sys
import time

import requests


_, cartoon, chapter0, chapter1 = sys.argv
host = 'http://p1.manhuapan.com/%s'
pattern = re.compile(r'20\d{2}/\d{2}/\d+\.jpg')
uris, i = set(), 0
for chapter in range(int(chapter0), int(chapter1)):
    for page in range(0, 999):
        url = (
            'https://manhua.fzdm.com/%s/%s/index_%s.html'
            % (cartoon, chapter, page))
        resp = requests.get(url, verify=False)
        print(resp.status_code, url)
        while resp.status_code >= 500:
            if resp.content.strip() == '404':
                break
            time.sleep(10)
            resp = requests.get(url, verify=False)
        if resp.status_code == 404 or resp.content.strip() == '404':
            break

        for uri in pattern.findall(resp.content):
            if uri in uris:
                continue
            uris.add(uri)
            # CREATE output FOLDER MANNUALLY
            name = 'output/%s.jpg' % str(i).rjust(6, '0')
            resp = requests.get(host % uri, verify=False)
            if resp.status_code == 200 and resp.content:
                with open(name, 'w') as file:
                    file.write(resp.content)
            else:
                print(resp.status_code, resp.content)
            i += 1
    if page < 2:
        break
