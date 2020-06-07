#!/usr/local/bin/python2
# coding: utf8

# This script will looking for the saved progress in `~/.accounts/comic.json`
# and start from it. Here is an example:
# [
#   { "next": 175, "site": "fzdm", "id": 132, "name": "一拳超人" },
#   { "last": 0, "site": "pufei", "id": 419, "name": "一人之下" },
# ]
# To download: `mkdir output && python2 $0`
# To upload into Boox/Kindle: `zip bundle.cbz output/*`
# To upload to Android for DuoKan:
#     python2 -c "import glob;
#     print('\n'.join(
#         '![%s](%s)' % (fp, fp)
#         for fp in sorted(glob.glob('output/*.jpg'))))
#     " | pandoc -o bundle.epub

import os
import re
import time
import json
import base64
import string

import requests


def http(url):
    resp = requests.get(url, verify=False)
    print('[%s] %s' % (resp.status_code, url))
    while resp.status_code >= 500:
        if resp.content.strip() == '404':
            return
        time.sleep(10)
        resp = requests.get(url, verify=False)
        print('[%s] %s' % (resp.status_code, url))
    if resp.status_code == 404 or resp.content.strip() == '404':
        return ''
    return resp.content


def fzdm(record,
         host='https://manhua.fzdm.com',
         static='http://p1.manhuapan.com'):
    for chapter in range(record['next'], record['next'] + 999):
        for page in range(0, 999):
            content = http(
                '%s/%s/%s/index_%s.html' % (host, record['id'], chapter, page))
            if not content:
                break
            for uri in re.findall(r'20\d{2}/\d{2}/\d+\.jpg', content):
                yield static + '/' + uri
        record['next'] = chapter
        if page < 2:
            break


def pufei(record,
          host='http://www.pufei8.com',
          static='http://res.img.fffmanhua.com'):
    dir = '/manhua/%(id)d' % record
    cids = sorted(map(int, set(
        re.findall(r'href="%s/(\d+)\.html"' % dir, http(host + dir)))))
    for cid in cids:
        if cid <= record['last']:
            continue
        packed = base64.b64decode(re.findall(
            r'packed="(.*?)"', http('%s%s/%d.html' % (host, dir, cid)))[0])
        print(packed)
        kwds = [
            ts for ts in re.findall(r"'([0-9a-zA-Z|\\]+)'", packed)
            if 'photosr' in ts
        ][0].strip('\\').split('|')
        formats = re.findall(r'[a-z]\[.\]="(.*?)";', packed)
        mp = string.digits + string.ascii_letters
        for fmt in formats:
            yield static + '/' + re.sub(
                r'[0-9a-zA-Z]+',
                lambda m: kwds[reduce(
                    lambda i, c: i * len(mp) + mp.index(c), m.group(),
                    0)] or m.group(),
                fmt)
        record['last'] = cid


if __name__ == '__main__':
    output = 'output'
    assert os.path.isdir(output), 'mkdir output/ first'

    path = os.path.expanduser('~/.accounts/comic.json')
    with open(path) as file:
        progress = json.load(file)

    urls = set()
    for record in progress:
        record['name'] = record['name'].encode('utf8')
        for url in {'fzdm': fzdm, 'pufei': pufei}[record['site']](record):
            if url in urls:
                continue
            urls.add(url)
            img = http(url)
            if not img:
                continue
            name = '%s/%s.jpg' % (output, str(len(urls)).rjust(6, '0'))
            with open(name, 'w') as file:
                file.write(img)

    with open(path, 'w') as file:
        json.dump(progress, file, ensure_ascii=False, indent=4)
    print('total: %s pages' % len(urls))
