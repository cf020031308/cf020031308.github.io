local M = 10 ^ 10


local function f(n)
    local r = 1
    for i = 1, n do
        r = (r * n) % M
    end
    return r
end


local s = 0
for n = 1, 1000 do
    s = (s + f(n)) % M
end
print(s)
