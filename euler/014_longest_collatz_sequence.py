cache = {}


def collatz_length(n):
    global cache
    if n not in cache:
        if n == 1:
            c = 1
        elif n % 2:
            c = 1 + collatz_length(3 * n + 1)
        else:
            c = 1 + collatz_length(n / 2)
        cache[n] = c
    return cache[n]


def main(n):
    return max(map(collatz_length, range(1, n + 1)))


print main(10 ** 6)
