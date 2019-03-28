local resume = coroutine.resume
local yield = coroutine.yield


local function pre()
    for x = 1, 9, 2 do
        yield({x})
        for y = 0, 9 do
            yield({x, y})
            for z = 0, 9 do
                yield({x, y, z})
            end
        end
    end
end


local function dec(pregen)
    while true do
        local ok, ds = resume(pregen)
        if not ds then
            return
        end
        local l, p, s = #ds, 0, 0
        for i = 1, l do
            p = 10 * p + ds[i]
            s = s + ds[i] * 10 ^ (i - 1)
        end
        yield(p * 10 ^ l + s)
        yield((p - ds[l]) * 10 ^ (l - 1) + s)
    end
end


local function is_pal2(n)
    local l, t, r = 0, {}, 0
    while n ~= 0 do
        r = n % 2
        n = (n - r) / 2
        l = l + 1
        t[l] = r
    end
    for i = 1, l / 2 do
        if t[i] ~= t[l + 1 - i] then
            return false
        end
    end
    return true
end


local ret = 0
for pal10 in coroutine.wrap(function() dec(coroutine.create(pre)) end) do
    if is_pal2(pal10) then
        ret = ret + pal10
    end
end
print(ret)
