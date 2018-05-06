local tostring = tostring
local concat = table.concat


local function permutation(t, n)
    if n == 0 then
        coroutine.yield(t)
    else
        for i = 1, n do
            t[i], t[n] = t[n], t[i]
            permutation(t, n - 1)
            t[i], t[n] = t[n], t[i]
        end
    end
end


local function f(t, i)
    return 100 * t[i] + 10 * t[i + 1] + t[i + 2]
end


local s = 0
for t in coroutine.wrap(function() permutation({0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, 10) end) do
    if t[0] ~= 0
        and t[4] % 2 == 0
        and (t[6] == 0 or t[6] == 5)
        and (t[3] + t[4] + t[5]) % 3 == 0
        and f(t, 5) % 7 == 0
        and f(t, 6) % 11 == 0
        and f(t, 7) % 13 == 0
        and f(t, 8) % 17 == 0
    then
        s = s + tostring(concat(t))
    end
end
print(s)
