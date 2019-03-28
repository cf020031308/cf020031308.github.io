local function sum(n)
    n = math.floor(n)
    return n * (n + 1) / 2
end


local function main(n)
    n = n - 1
    return 3 * sum(n / 3) + 5 * sum(n / 5) - 15 * sum(n / 15)
end


print(main(1000))
