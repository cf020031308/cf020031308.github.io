def f(n):
    return reduce(int.__mul__, range(1, n + 1), 1)


def main(l, n):
    n -= 1
    ret = []
    while l:
        f = reduce(int.__mul__, range(1, len(l)), 1)
        ret.append(l.pop(n / f))
        n %= f
    return ''.join(ret)


assert ([main(map(str, range(3)), i) for i in range(1, 7)]
        == ['012', '021', '102', '120', '201', '210'])
print main(map(str, range(10)), 1000000)
