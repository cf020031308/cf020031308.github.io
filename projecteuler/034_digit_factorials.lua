local fs = {[0]=1}
local f = 1
for i = 1, 9 do
    f = f * i
    fs[i] = f
end

local m = 1
while fs[9] * m > 10 ^ m - 1 do
    m = m + 1
end
m = fs[9] * m / 10


local function df(n, s)
    if n == s then
        coroutine.yield(n)
    end
    if n < m then
        for i = 0, 9 do
            df(10 * n + i, s + fs[i])
        end
    end
end


local s = -1 - 2
for n in coroutine.wrap(function() for n = 1, 9 do df(n, fs[n]) end end) do
    s = s + n
end
print(s)
