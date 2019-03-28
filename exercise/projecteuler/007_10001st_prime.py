import math


found_primes = [2, 3]


def is_prime(n):
    m = int(math.sqrt(n))
    for p in found_primes:
        if p > m:
            break
        if n % p == 0:
            return
    return True


def main(n):
    l = len(found_primes)
    p = found_primes[-1]
    while 1:
        p += 2
        if is_prime(p):
            found_primes.append(p)
            l += 1
            if l > n:
                break
    return found_primes[n - 1]


assert main(6) == 13
print main(10001)
