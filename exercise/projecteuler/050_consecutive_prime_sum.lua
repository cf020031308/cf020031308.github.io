local sqrt = math.sqrt
local insert = table.insert
local primes = {}
local composites = {}
local limit = 1000000
for i = 2, limit do
    if not composites[i] then
        insert(primes, i)
        for j = 2, limit / i do
            composites[i * j] = true
        end
    end
end


local function is_prime(n)
    if n > limit then
        local m = sqrt(n)
        for i, p in ipairs(primes) do
            if p > m then
                return true
            elseif n % p == 0 then
                return false
            end
        end
        assert(false, "overflow")
    else
        return not composites[n]
    end
end


local l, i, max, sum = #primes, 1, 0, 0
while i <= l - max + 1 do
    local s, m, ms = 0, 0, 0
    for j = i, l do
        s = s + primes[j]
        if s > limit then
            break
        elseif is_prime(s) then
            m, ms = j - i + 1, s
        end
    end
    if m > max then
        max, sum = m, ms
    end
    i = i + 1
end

print(sum)
