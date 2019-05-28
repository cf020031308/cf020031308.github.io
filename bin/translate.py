#!/usr/local/bin/python

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


def space(s, code='utf8'):
    # space between Chinese and English
    s = list(s.decode(code))
    for i in range(len(s) - 1, 0, -1):
        if (
                (is_zh(s[i]) and is_en(s[i - 1]))
                or (is_en(s[i]) and is_zh(s[i - 1]))):
            s.insert(i, u' ')
    s = u''.join(s).encode(code)

    # Numbers and Units
    s = re.sub(
        r'(?<=\d)(bps|kbps|mbps|gbps|b|kb|mb|gb|tb|pb|g|kg|t|h|m|s)\b',
        r' \1',
        s,
        flags=re.I)

    return s


# https://github.com/soimort/translate-shell
status, zh = commands.getstatusoutput(
    'trans :zh -no-auto file://%s' % os.path.realpath(sys.argv[1]))
assert status == 0, zh
zh = space(zh)

path = os.path.realpath(sys.argv[1])
with open(path) as file:
    en = file.read()

with open(path, 'w') as file:
    file.write(
        '\n'.join(
            this if this == that else (this + '\n' + that)
            for this, that in zip(en.splitlines(), zh.splitlines())))
