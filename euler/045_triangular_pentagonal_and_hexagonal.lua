local function main(start)
    local sqrt = math.sqrt
    for n, h in function(s, n)
                    n = n + 1
                    return n, n * (2 * n - 1)
                end, nil, start do
        if sqrt(8 * h + 1) % 2 == 1 and sqrt(24 * h + 1) % 6 == 5 then
            return h
        end
    end
end


assert(main(1) == 40755)
print(main(143))
