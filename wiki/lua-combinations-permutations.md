# Combinations and Permutations in Lua With Coroutine

```lua
local function combination(t, m, n, r)
    n = n or #t
    r = r or {}

    if m == 0 then
        coroutine.yield(r)
    elseif m == n then
        for i = 1, n do
            table.insert(r, t[i])
        end
        coroutine.yield(r)
        for i = 1, n do
            table.remove(r)
        end
    else
        combination(t, m, n - 1, r)
        table.insert(r, t[n])
        combination(t, m - 1, n - 1, r)
        table.remove(r)
    end
end


local function permutation(t, m, n)
    n = n or #t
    if n == 0 then
        coroutine.yield(t)
    elseif m and n > m then
        for c in coroutine.wrap(function() combination(t, m, n) end) do
            permutation(c, m, m)
        end
    else
        for i = 1, n do
            t[n], t[i] = t[i], t[n]
            permutation(t, m, n - 1)
            t[n], t[i] = t[i], t[n]
        end
    end
end


for p in coroutine.wrap(function() permutation({1, 2, 3, 4}, 2) end) do
    print(table.concat(p, ", "))
end
```
