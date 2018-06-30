local length = 1
local num = 1
local primes = {}
repeat
    length = length + 2
    for _ = 1, 4 do
        num = num + length - 1
        table.insert(primes, num)
        for p = 3, math.sqrt(num), 2 do
            if num % p == 0 then
                table.remove(primes)
                break
            end
        end
    end
    if #primes / (2 * length - 1) < 0.1 then
        print(length)
        os.exit()
    end
until false
