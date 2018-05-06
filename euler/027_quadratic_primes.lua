-- f(n) = n ** 2 + a * n + b
-- f(0) is prime => b is prime
-- f(b) is composite => the longest sequance of n is shorter than b-length
-- f(1) and f(2) are prime => a is odd
-- if a < 0; f(int(-a / 2)) = b - int(a * a / 4) > 0 => a > -sqrt(4 * b)


local function prime_filter(limit)
    local insert = table.insert
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
    return primes
end


local function is_prime(n, primes)
    local limit = math.floor(math.sqrt(n))
    for _, p in ipairs(primes) do
        if p > limit then
            return true
        elseif n % p == 0 then
            return false
        end
    end
    assert(false, "primes out of range")
end


local function quadratic(a, b)
    return function(n)
        return n * (n + a) + b
    end
end


local function main(maxa, maxb)
    local int = math.floor
    local sqrt = math.sqrt
    local primes = prime_filter(maxb)
    local len = 0
    local ret = 0
    for i = #primes, 1, -1 do
        local b = primes[i]
        if b <= len then
            break
        end
        for a = -int(sqrt(b)) * 2 - 1, maxa, 2 do
            local f = quadratic(a, b)
            local l = 1
            for n = 1, b - 1 do
                if not is_prime(f(n), primes) then
                    break
                end
                l = l + 1
            end
            if l > len then
                len = l
                ret = a * b
            end
        end
    end
    return ret
end


print(main(999, 999))
