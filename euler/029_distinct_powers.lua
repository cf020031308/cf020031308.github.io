local pairs = pairs
local ipairs = ipairs
local sqrt = math.sqrt
local int = math.floor
local insert = table.insert

local found_primes = {2}
local cache = {{}, {2, 1}}


local function f(n)
    if not cache[n] then
        local m = int(sqrt(n))
        for _, p in ipairs(found_primes) do
            if p > m then
                insert(found_primes, n)
                cache[n] = {n, 1}
                break
            elseif n % p == 0 then
                local r
                local s = f(n / p)
                if s[1] == p then
                    r = {}
                    for i, v in ipairs(s) do
                        r[i] = v
                    end
                    r[2] = r[2] + 1
                else
                    r = {p, 1}
                    for _, v in ipairs(s) do
                        insert(r, v)
                    end
                end
                cache[n] = r
                break
            end
        end
    end
    return cache[n]
end


local function main(maxa, maxb)
    local format = string.format
    local set = {}
    local len = 0
    for a = 2, maxa do
        local r = f(a)
        local l = #r
        for b = 2, maxb do
            local k = ""
            for i = 1, l, 2 do
                k = k .. r[i] .. "-" .. r[i + 1] * b .. " "
            end
            if not set[k] then
                set[k] = 1
                len = len + 1
            end
        end
    end
    return len
end


assert(main(5, 5) == 15)
print(main(100, 100))
