local function tri(p)
    local s = 0
    for z = math.ceil(p / 3), p / 2 do
        local step, zz, r = 2 - z % 2, z * z, p - z
        for x = step, r / 2, step do
            if x * x + (r - x) ^ 2 == zz then
                s = s + 1
            end
        end
    end
    return s
end


local max, mp = 0, 0
for p = 12, 1000 do
    local m = tri(p)
    if m > max then
        max = m
        mp = p
    end
end
print(mp)
