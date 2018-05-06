# names = ["MARY", "PATRICIA", "LINDA", "BARBARA", "ELIZABETH", ...]
names.sort()
print sum(
    i * (sum(ord(c) for c in name) - 64 * len(name))
    for i, name in enumerate(names, 1))
