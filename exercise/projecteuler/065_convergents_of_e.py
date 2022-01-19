N = 100
n, d = 1, 0
for v in reversed([
        (2 if i == 1 else (2 * i // 3 if i % 3 == 0 else 1))
        for i in range(1, N + 1)]):
    p, q = n, d = v * n + d, n
    t = p % q
    while t:
        p, q = q, t
        t = p % q
    n //= q
    d //= q
print(sum(map(int, str(n))))
