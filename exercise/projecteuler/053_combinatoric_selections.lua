local facs = setmetatable(
    {[0] = 1},
    {
        __index=function(t, k)
            t[k] = t[k - 1] * k
            return t[k]
        end
    }
)
local combs = function(n, r)
    return facs[n] / facs[r] / facs[n - r]
end
local count = 0
for n = 1, 100 do
    for r = 1, n / 2 do
        if facs[n] / facs[r] / facs[n - r] > 1000000 then
            count = count + n + 1 - 2 * r
            break
        end
    end
end
print(count)
