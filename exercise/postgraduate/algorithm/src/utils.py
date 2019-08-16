def dist(x, y, p=2):
    return ((x - y) ** p).sum(axis=1) ** (1.0 / p)
