local tonumber = tonumber
local tostring = tostring
local ipairs = ipairs
local remove = table.remove
local sub = string.sub

local t = {1, 10, 100, 1000, 10000, 100000, 1000000}
local r, s, w, l, max = {}, 0, 1, #t, t[#t]

while s < max do
    local diff = w * 9 * 10 ^ (w - 1)
    s = s + diff
    for i = 1, l do
        if r[i] == nil and s >= t[i] then
            local n = t[i] - s + diff - 1
            local m = n % w
            r[i] = tonumber(sub(tostring(10 ^ (w - 1) + (n - m) / w), m + 1, m + 1))
        end
    end
    w = w + 1
end

local s = 1
for i = 1, l do
    s = s * r[i]
end
print(s)
