local insert = table.insert
local remove = table.remove
local concat = table.concat
local yield = coroutine.yield
local tonumber = tonumber


local function combination(t, m, n, r)
    n = n or #t
    r = r or {}

    if m == 0 then
        yield(r)
    elseif m == n then
        for i = 1, n do
            insert(r, t[i])
        end
        yield(r)
        for i = 1, n do
            remove(r)
        end
    else
        combination(t, m, n - 1, r)
        insert(r, t[n])
        combination(t, m - 1, n - 1, r)
        remove(r)
    end
end


local function permutation(t, m, n)
    n = n or #t
    if n == 0 then
        yield(t)
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


local function is_pandigital(n)
    local t, s, l = {[0]=1}, 0, #n
    for i, v in ipairs(n) do
        t[v], s = 1, s + v
    end
    for i = 2, 9 do
        local b = 0
        for j = l, 1, -1 do
            local d = i * n[j] + b
            b = d % 10
            if t[b] then
                return
            end
            t[b] = 1
            s = s + b
            b = (d - b) / 10
        end
        if b > 0 then
            if t[b] then
                return
            else
                t[b] = 1
                s = s + b
            end
        end
        if s == 45 then
            local n = tonumber(concat(n, ""))
            local r = {}
            for j = 1, i do
                r[j] = j * n
            end
            return tonumber(concat(r, ""))
        end
    end
end


local max = 0
for n in coroutine.wrap(
        function()
            local t = {1, 2, 3, 4, 5, 6, 7, 8, 9}
            for i = 1, 4 do
                permutation(t, i)
            end
        end) do
    local m = is_pandigital(n)
    if m and m > max then
        max = m
    end
end
print(max)
