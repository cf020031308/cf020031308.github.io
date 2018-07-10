#!/usr/local/bin/python

print('\n'.join(
    this if this == that else (this + '\n' + that)
    for this, that in zip(*(
        iter(open(path).read().splitlines())
        for path in __import__('sys').argv[1:3]))))
