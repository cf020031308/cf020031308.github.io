local yield = coroutine.yield


local function permutation(t, n)
    n = n or #t
    if n == 0 then
        yield(t)
    else
        for i = 1, n do
            t[n], t[i] = t[i], t[n]
            permutation(t, n - 1)
            t[n], t[i] = t[i], t[n]
        end
    end
end


local function int(t, n, m)
    local r = 0
    for i = n, m do
        r = 10 * r + t[i]
    end
    return r
end


local set = {}
local ret = 0
for p in coroutine.wrap(function() permutation{1, 2, 3, 4, 5, 6, 7, 8, 9} end) do
    local pd = int(p, 6, 9)
    if set[pd] == nil
        and (p[1] * int(p, 2, 5) == pd or int(p, 1, 2) * int(p, 3, 5) == pd)
    then
        ret = ret + pd
        set[pd] = 1
    end
end

print(ret)
