-- curl https://projecteuler.net/project/resources/p059_cipher.txt | luajit 059_xor_decryption.lua

local xor = require("bit").bxor
local insert = table.insert
local printables = {}  -- without backquote: 96
for _, ord in ipairs({9, 10, 11, 12, 13, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126}) do
    printables[ord] = true
end
local text = {}
local keys = {}
local tbls = {}
for i = 1, 3 do
    insert(keys, {})
    for lower = 97, 122 do
        keys[i][lower] = true
    end
    insert(tbls, {})
end


local c = 1
for n in io.stdin:read("*a"):gmatch("%d+") do
    n = tonumber(n)
    insert(text, n)
    tbls[c][n] = true
    c = c % #tbls + 1
end
for i, tbl in ipairs(tbls) do
    for k, _ in pairs(keys[i]) do
        local has_space = false
        for n, _ in pairs(tbl) do
            local x = xor(n, k)
            if not printables[x] then
                keys[i][k] = nil
                break
            end
            if x == 32 then
                has_space = true
            end
        end
        if not has_space then
            keys[i][k] = nil
        end
    end
    for k, _ in pairs(keys[i]) do
        keys[i] = k
        break
    end
end

local s = 0
c = 1
for i = 1, #text do
    local n = xor(text[i], keys[c])
    s = s + n
    text[i] = string.char(n)
    c = c % 3 + 1
end
print(table.concat(text))
print(s)
