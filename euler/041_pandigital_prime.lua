local function permutation(t, n)
    if n == 0 then
        local m = 0
        for _, v in ipairs(t) do
            m = 10 * m + v
        end
        coroutine.yield(m)
    else
        for i = 1, n do
            t[n], t[i] = t[i], t[n]
            permutation(t, n - 1)
            t[n], t[i] = t[i], t[n]
        end
    end
end


local function is_prime(n)
    for i = 3, math.sqrt(n), 2 do
        if n % i == 0 then
            return false
        end
    end
    return true
end


local function pp(n)
    local max = 0
    for m in coroutine.wrap(
            function()
                local t = {}
                for i = 1, n do
                    t[i] = i
                end
                permutation(t, n - 1)
                t[1], t[n] = t[n], t[1]
                permutation(t, n - 1)
                t[3], t[n] = t[n], t[3]
                permutation(t, n - 1)
                t[7], t[n] = t[n], t[7]
                permutation(t, n - 1)
            end) do
        if m > max and is_prime(m) then
            max = m
        end
    end
    return max
end


for n = 9, 1, -1 do
    local ppn = pp(n)
    if ppn > 0 then
        print(ppn)
        break
    end
end
