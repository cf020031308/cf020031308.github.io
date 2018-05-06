def f():
    x, y = 1, 1
    while 1:
        x, y = y, x + y
        yield y


def main(n):
    for i, fi in enumerate(f(), 3):
        if len(str(fi)) < n:
            continue
        return i


assert main(3) == 12
print main(1000)
