import math


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


def main(n):
    m = 1
    while 1:
        if m % 2:
            om = f(m)
            m += 1
            em = f(m / 2)
        else:
            em = f(m / 2)
            m += 1
            om = f(m)
        for k, v in em.iteritems():
            om[k] = om.get(k, 0) + v
        if reduce(lambda x, y: x * (y + 1), om.values(), 1) >= n:
            return (m - 1) * m / 2


assert main(5) == 28
print main(500)
