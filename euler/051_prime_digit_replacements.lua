--[[
By replacing the 1st digit of the 2-digit number *3, it turns out that six of the nine possible values: 13, 23, 43, 53, 73, and 83, are all prime.

By replacing the 3rd and 4th digits of 56**3 with the same digit, this 5-digit number is the first example having seven primes among the ten generated numbers, yielding the family: 56003, 56113, 56333, 56443, 56663, 56773, and 56993. Consequently 56003, being the first member of this family, is the smallest prime with this property.

Find the smallest prime which, by replacing part of the number (not necessarily adjacent digits) with the same digit, is part of an eight prime value family.
--]]
local function main(length, family)
    local max = 10 ^ (length + 1)
    local composites = {}
    for n = 3, max, 2 do
        if not composites[n] then
            local digits = {}
            local k = 10
            for _ = 2, length do
                if n < k then
                    break
                end
                local d = ((n - n % k) / k) % 10 + 1
                digits[d] = (digits[d] or 0) + k
                k = k * 10
            end
            for i = 1, 11 - family do
                local inc = digits[i]
                if inc then
                    local count = 12 - family - i
                    for j = 1, 10 - i do
                        if composites[n + inc * j] then
                            count = count - 1
                            if count == 0 then
                                break
                            end
                        end
                        if j == 10 - i then
                            for m = 0, 9 do
                                print(n + inc * m, composites[n + inc * m])
                            end
                            return n
                        end
                    end
                end
            end
            for i = 3, max / n, 2 do
                composites[n * i] = 1
            end
        end
        composites[n] = nil
    end
end
print(main(5, 7))
print(main(7, 8))
