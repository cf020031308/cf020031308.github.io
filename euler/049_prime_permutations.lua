local pairs = pairs
local ipairs = ipairs
local insert = table.insert
local primes = {}
local composites = {}
for i = 2, 9999 do
    if not composites[i] then
        insert(primes, i)
        for j = 2, 9999 / i do
            composites[i * j] = true
        end
    end
end


local function f(n)
    local a, b, c, d = n, n % 1000, n % 100, n % 10
    a, b, c = (a - b) / 1000, (b - c) / 100, (c - d) / 10
    if b > a then a, b = b, a end
    if c > b then b, c = c, b end
    if d > c then c, d = d, c end
    if b > a then a, b = b, a end
    if c > b then b, c = c, b end
    if b > a then a, b = b, a end
    return a * 1000 + b * 100 + c * 10 + d
end


local perms = {}
local groups = {}
for _, p in ipairs(primes) do
    if p > 1000 then
        local g = f(p)
        perms[p] = g
        if groups[g] then
            insert(groups[g], p)
        else
            groups[g] = {p}
        end
    end
end


for g, ps in pairs(groups) do
    for m = 2, #ps - 1 do
        for l = 1, m - 1 do
            if perms[2 * ps[m] - ps[l]] == g then
                print(ps[l] .. ps[m] .. 2 * ps[m] - ps[l])
            end
        end
    end
end
