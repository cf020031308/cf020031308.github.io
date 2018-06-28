local function main(n)
    local x, s = 1, 1
    for i = 3, n, 2 do
        x, s = x + 4 * (i - 1), s + 4 * x + 10 * (i - 1)
    end
    return s
end


assert(main(5) == 101)
print(main(1001))
