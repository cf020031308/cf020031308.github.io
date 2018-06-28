import math


def main(n):
    'works only when n is odd'
    m = int(math.sqrt(n))
    if m % 2 == 0:
        m -= 1
    for i in range(m, 2, -2):
        if n % i == 0:
            return max(main(i), main(n / i))
    return n


assert main(13195) == 29
print main(600851475143)
