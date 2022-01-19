-- This following programme is not able to get the correct answer
-- due to precision of float numbers
-- local N = 10000
-- local n_odd = 0
-- for n = 2, N do
--     local _, x = math.modf(math.sqrt(n))
--     local odd = false
--     local map = {}
--     local s = string.format("%.4f", x)
--     while x > 0 and not map[s] do
--         map[s] = true
--         x = (1 % x) / x
--         s = string.format("%.4f", x)
--         odd = not odd
--     end
--     n_odd = n_odd + (odd and 1 or 0)
-- end
-- print(n_odd)


function tri_dec(a, b, c)
    if a % 2 == 0 and b % 2 == 0 and c % 2 == 0 then
        return tri_dec(a / 2, b / 2, c / 2)
    end
    local m = math.min(a, b, c)
    if m > 1 then
        if a % m == 0 and b % m == 0 and c % m == 0 then
            return tri_dec(a / m, b / m, c / m)
        end
        for k = 3, math.sqrt(m), 2 do
            if a % k == 0 and b % k == 0 and c % k == 0 then
                return tri_dec(a / k, b / k, c / k)
            end
        end
    end
    return a, b, c
end


local sqrt_dec = function(n, a, b, c)
    -- decompose x = (a * sqrt(n) - b) / c
    -- return s and next (a, b, c)
    -- where s is an integer, 0 < t < 1 and x = 1 / (s + t)
    local x = math.sqrt(n)
    local d = a * a * n - b * b
    local s = math.floor((a * x + b) * c / d)
    return tri_dec(a * c, s * d - b * c, d)
end


local N = 10000
local n_odd = 0
for n = 2, N do
    local b = math.floor(math.sqrt(n))
    if b ^ 2 ~= n then
        local odd = false
        local map = {}
        local a = 1
        local c = 1
        local p = string.format("%d,%d,%d", a, b, c)
        repeat
            map[p] = true
            a, b, c = sqrt_dec(n, a, b, c)
            p = string.format("%d,%d,%d", a, b, c)
            odd = not odd
        until map[p]
        n_odd = n_odd + (odd and 1 or 0)
    end
end
print(n_odd)
