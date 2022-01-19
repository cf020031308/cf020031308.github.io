#!/usr/local/bin/python
# coding: utf8

import re
import os
import sys
import string
import commands


ens = set(string.letters + string.digits)


def is_zh(uni_ch):
    return u'\u4e00' <= uni_ch <= u'\u9fa5'


def is_en(uni_ch):
    return uni_ch in ens


def handleSpace(s, code='utf8'):
    # space between Chinese and English
    s = list(s.decode(code))
    for i in range(len(s) - 1, 0, -1):
        if (
                (is_zh(s[i]) and is_en(s[i - 1]))
                or (is_en(s[i]) and is_zh(s[i - 1]))):
            s.insert(i, u' ')
    s = u''.join(s).encode(code)

    # space between Numbers and Units
    s = re.sub(
        r'(?<=\d)(bps|kbps|mbps|gbps|b|kb|mb|gb|tb|pb|g|kg|t|h|m|s)\b',
        r' \1',
        s,
        flags=re.I)

    return s


path = os.path.realpath(sys.argv[1])
with open(path) as file:
    en = file.read()

# https://github.com/soimort/translate-shell
status, zh = commands.getstatusoutput(
    'trans :zh -no-auto file://%s -u "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36"' % path)
assert status == 0, zh
zh = handleSpace(zh)

with open(path, 'w') as file:
    file.write(
        '\n'.join(
            this if (this == that or not that.strip()) else (this + '\n' + that)
            for this, that in zip(en.splitlines(), zh.splitlines())))
