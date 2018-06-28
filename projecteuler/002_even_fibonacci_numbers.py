def fib(n):
    x, y = 1, 1
    while y < n:
        x, y = y, x + y
        yield y


def main(n):
    return sum(i for i in fib(n) if i % 2 == 0)


print main(4e6)
