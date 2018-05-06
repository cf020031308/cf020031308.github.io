import math


LIMIT = 28123
found_primes = [2]
cache = {1: {}, 2: {2: 1}}


def f(n):
    global cache, found_primes
    if n not in cache:
        m = int(math.sqrt(n))
        for p in found_primes:
            if p > m:
                found_primes.append(n)
                cache[n] = {n: 1}
                break
            if n % p == 0:
                ret = f(n / p)
                ret[p] = ret.get(p, 0) + 1
                cache[n] = ret
                break
    return dict(cache[n])


abundant_numbers = [
    n for n in range(1, LIMIT + 1)
    if reduce(
        lambda s, (k, v): s * (k ** (v + 1) - 1) / (k - 1),
        f(n).iteritems(), 1) > 2 * n]
abundant_sums = filter(
    lambda n: n <= LIMIT,
    set(x + y for x in abundant_numbers for y in abundant_numbers))
non_abundant_sums = (1 + LIMIT) * LIMIT / 2 - sum(abundant_sums)


print non_abundant_sums
