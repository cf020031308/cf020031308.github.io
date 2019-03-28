local insert = table.insert
local pairs = pairs
local tostring = tostring
local limit = 1000000
local primes = {}
local composites = {}
for i = 2, limit do
    if not composites[i] then
        insert(primes, i)
        for j = 2, limit / i do
            composites[i * j] = 1
        end
    end
end


local function is_cp(p, l)
    local b = 10 ^ l
    for i = 1, l do
        local r = p % 10
        p = r * b + (p - r) / 10
        if composites[p] then
            return false
        end
    end
    return true
end


local c = 0
for _, p in pairs(primes) do
    local s = tostring(p)
    if not s:find("0") and is_cp(p, #s - 1) then
        c = c + 1
    end
end

print(c)
