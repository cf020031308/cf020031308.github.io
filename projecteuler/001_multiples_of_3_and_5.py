def s(n):
    return n * (n + 1) / 2


def main(n):
    n = n - 1
    return 3 * s(n / 3) + 5 * s(n / 5) - 15 * s(n / 15)


print main(1000)
