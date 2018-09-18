local function largest_prime_factor(n)
    -- works only when n is odd
    local m = math.floor(math.sqrt(n))
    if m % 2 == 0 then
        m = m - 1
    end
    for i = m, 2, -2 do
        if n % i == 0 then
            return math.max(largest_prime_factor(i), largest_prime_factor(n / i))
        end
    end
    return n
end


assert(largest_prime_factor(13195) == 29)
print(largest_prime_factor(600851475143))
