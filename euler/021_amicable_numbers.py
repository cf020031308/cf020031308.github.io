def d(n):
    return sum(i for i in range(1, n / 2 + 1) if n % i == 0)


assert d(220) == 284 and d(284) == 220


s = 0
ds = {}
for i in range(1, 10000):
    di = d(i)
    if ds.get(di) == i:
        s += i + di
    ds[i] = di
print s
