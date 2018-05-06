local pairs = pairs
local sqrt = math.sqrt

local primes = {2}
local l = #primes
local factors = setmetatable({{n=0}, {[2]=1, n=1}}, {__index=function(t, n)
    local m = sqrt(n)
    for i = 1, l do
        local p = primes[i]
        if p > m then
            l = l + 1
            primes[l] = n
            t[n] = {[n]=1, n=1}
            return t[n]
        elseif n % p == 0 then
            local ret = {}
            for k, v in pairs(t[n / p]) do
                ret[k] = v
            end
            if ret[p] then
                ret[p] = ret[p] + 1
            else
                ret[p] = 1
                ret.n = ret.n + 1
            end
            t[n] = ret
            return ret
        end
    end
end})


local function main(m)
    local n, combo = #factors, 0
    repeat
        n = n + 1
        if factors[n].n == m then
            combo = combo + 1
        else
            combo = 0
        end
    until combo == m
    return n - m + 1
end


assert(main(2) == 14)
assert(main(3) == 644)
print(main(4))
