n = 1000
for c in range(n / 3 + 1, (n + 1) / 2):
    c2 = c * c
    for a in range(1, c):
        b = 1000 - a - c
        if a * a + b * b == c2:
            print a, b, c, a * b * c
            exit()
