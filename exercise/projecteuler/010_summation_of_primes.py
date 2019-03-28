import math


def main(n):
    l = range(n + 1)
    for i in l:
        if i < 2:
            continue
        for j in xrange(2 * i, n + 1, i):
            l[j] = 0
    return sum(l) - 1


assert main(10) == 17
print main(int(2e6))
