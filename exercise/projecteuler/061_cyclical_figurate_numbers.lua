-- 1. generate all 4-digit numbers
-- 2. index all 4-digit numbers with their prefices
-- 3. search a 6-sized chain that covers six groups

local N = 6
local bit = require("bit")
local count1 = function(m)
    local c = 0
    while m > 0 do
        c = c + (m % 2)
        m = bit.rshift(m, 1)
    end
    return c
end

local figs = {}
for i = 1, N do
    local m = bit.lshift(1, i - 1)
    figs[i] = {}
    local p = 1
    local n = 1
    while p < 10000 do
        if p > 999 and (p % 100) > 9 then
            -- TRY ignore this situation where one number belongs to multiple groups
            -- Suceed! No need to consider this situation then.
            -- figs[p] = bit.bor(figs[p] or 0, m)
            figs[p] = m
        end
        p = p + i * n + 1
        n = n + 1
    end
end

local index = {}
for n, _ in pairs(figs) do
    local p = (n - (n % 100)) / 100
    if index[p] then
        table.insert(index[p], n)
    else
        index[p] = {n}
    end
end

function iter(outs, mask)
    local l = #outs
    local n = outs[l]
    local p = n % 100
    if l == N then
        if (outs[1] - (outs[1] % 100)) / 100 == p then
            local s = 0
            for i = 1, N do
                print(outs[i], figs[outs[i]])
                s = s + outs[i]
            end
            print(s)
            os.exit()
        end
        return
    end
    if not index[p] then
        return
    end
    for _, n2 in ipairs(index[p]) do
        local m = bit.bor(mask, figs[n2])
        if l + 1 <= count1(m) then
            table.insert(outs, n2)
            iter(outs, m)
            table.remove(outs)
        end
    end
end

for n, m in pairs(figs) do
    iter({n}, m)
end
