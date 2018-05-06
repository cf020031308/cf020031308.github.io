def largest_prime_factor(x, y):
    if y > x:
        x, y = y, x
    while x % y:
        x, y = y, x % y
    return y


def smallest_multiple(x, y):
    return x * y / largest_prime_factor(x, y)


def main(n):
    return reduce(smallest_multiple, range(1, n + 1), 1)


assert main(10) == 2520
print main(20)
