def main(n):
    return (n * (n + 1) / 2) ** 2 - n * (n + 1) * (2 * n + 1) / 6


assert main(10) == 2640
print main(100)
