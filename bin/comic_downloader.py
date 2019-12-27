#!/usr/local/bin/python2
# coding: utf8
# E.g. `mkdir output && python2 $0 && zip bundle.cbz output/*`
#      Then upload it into boox.
import os
import re
import time
import json

import requests


path = os.path.expanduser('~/.accounts/comic.json')
host = 'http://p1.manhuapan.com/%s'
pattern = re.compile(r'20\d{2}/\d{2}/\d+\.jpg')
uris, i = set(), 0
with open(path) as file:
    progress = json.load(file)
for record in progress:
    record['name'] = record['name'].encode('utf8')
    for chapter in range(record['next'], record['next'] + 100):
        for page in range(0, 999):
            url = (
                'https://manhua.fzdm.com/%s/%s/index_%s.html'
                % (record['id'], chapter, page))
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
            record['next'] = chapter
            break

with open(path, 'w') as file:
    json.dump(progress, file, ensure_ascii=False, indent=4)
print('total: %s pages' % i)
