local insert = table.insert
local n = 5
local ret = 0

local tbl = {}
for i = 0, 9 do
    tbl[i] = i ^ 5
end

local w = 3
while true do
    if 10 ^ (w - 1) > tbl[9] * w then
        break
    end
    local limit = 10 ^ w
    for pre = 10 ^ (w - 3), 10 ^ (w - 2) - 1 do
        local p, r, s, t = pre, 0, 0, 0
        while p ~= 0 do
            r = p % 10
            p, s, t = (p - r) / 10, s - r, t + tbl[r]
        end
        r = s % 10
        t = t + tbl[r]
        if t < limit then
            local iff = 100 * pre + 10 * r - t
            for d = 0, 9 do
                local diff = d + iff
                if diff == tbl[d] then
                    ret = ret + diff + t
                end
            end
        end
    end
    w = w + 1
end

print(ret)
