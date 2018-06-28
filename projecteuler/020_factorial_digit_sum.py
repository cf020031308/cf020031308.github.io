def main(n):
    s = reduce(lambda x, y: x * y, range(1, n + 1), 1)
    return sum(map(int, str(s)))


assert main(10) == 27
print main(100)
