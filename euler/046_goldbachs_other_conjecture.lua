local function main()
    local sqrt = math.sqrt

    local primes = {3, 5, 7}
    local l = #primes
    local squares = {1, [4]=2}

    local function f(c)
        for i = 1, l do
            if squares[(c - primes[i]) / 2] then
                return
            end
        end
        return true
    end

    local c = 9
    while true do
        local root = sqrt(c)
        if root % 1 == 0 then
            squares[c] = root
            squares[(root + 1) ^ 2] = root + 1
        else
            for i = 1, l do
                local p = primes[i]
                if p > root then
                    l = l + 1
                    primes[l] = c
                    break
                elseif c % p == 0 then
                    if f(c) then
                        return c
                    end
                    break
                end
            end
        end
        c = c + 2
    end
end

print(main())
