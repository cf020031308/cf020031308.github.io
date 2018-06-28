def main(n):
    n = 2 ** n
    return sum(map(int, str(n)))


assert main(15) == 26
print main(1000)
