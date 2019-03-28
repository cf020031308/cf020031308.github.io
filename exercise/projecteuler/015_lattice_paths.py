def main(m, n):
    # C(m + n, m)
    def mul(x, y):
        return x * y
    s = reduce(mul, range(n + 1, m + n + 1), 1)
    t = reduce(mul, range(1, m + 1), 1)
    return s / t


assert main(2, 2) == 6
print main(20, 20)
