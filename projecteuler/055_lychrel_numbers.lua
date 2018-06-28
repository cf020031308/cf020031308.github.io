local reverse = setmetatable(
    {},
    { __index = function(t, k)
        local m = 0
        local n = k
        while n > 0 do
            local r = n % 10
            n = (n - r ) / 10
            m = m * 10 + r
        end
        t[k] = m
        t[m] = k
        return m
    end }
)

local palindromes = {}


local count = 0
for n = 1, 10000 do
    local m = n
    for i = 1, 50 do
        if palindromes[m] then
            count = count + 1
            break
        end
        m = m + reverse[m]
        if m == reverse[m] then
            count = count + 1
            while n ~= m do
                palindromes[n] = 1
                n = n + reverse[n]
            end
            break
        end
    end
end
print(10000 - count)
