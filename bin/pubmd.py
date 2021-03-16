#!/usr/local/bin/python3
# USAGE: $1 folder/readme.md | pbcopy
# Then paste to https://www.mdnice.com/

import os
import sys
import re
from urllib.parse import urljoin


fn = sys.argv[1]
if os.path.isdir(fn):
    fn += '/readme.md'
url = os.path.realpath(fn).replace(
    '/Users/Roy/Workplace/roy.log', 'https://cf020031308.github.io', 1)
base = os.path.dirname(url) + '/'
if url.lower().endswith('/readme.md'):
    url = base
elif url.endswith('.md'):
    url = url[-3:] + '.html'
with open(fn) as file:
    content = file.read()
content = content.replace('\\\\', '\\')
for uri in set(re.findall(r']\((.*?)\)', content)):
    if uri.startswith(('http:', 'https:')):
        continue
    if uri.endswith('.md'):
        uri = uri[-3:] + '.html'
    content = content.replace('](%s)' % uri, '](%s)' % urljoin(base, uri))
output = content.split('\n', 1)
output.insert(1, '\n原文地址：[%s](%s)\n' % (url, url))
print('\n'.join(output))
