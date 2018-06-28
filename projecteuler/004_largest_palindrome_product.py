import math


def pal(n):
    ps = map(str, range(10 ** n - 1, 10 ** (n - 1) - 1, -1))
    for p in ps:
        yield int(p + ''.join(reversed(p)))
    for p in ps:
        yield int(p[:-1] + ''.join(reversed(p)))


def main(n):
    for p in pal(n):
        m = 10 ** (n - 1)
        for x in range(
                max(int(math.ceil(float(p) / (10 * m - 1))), m),
                int(math.sqrt(p)) + 1):
            if p % x == 0:
                return p, x, p / x


assert main(2) == (9009, 91, 99)
print main(3)
