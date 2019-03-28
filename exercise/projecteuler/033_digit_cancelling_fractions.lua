local pairs = pairs
local fs = {
    {[1]=1},
    {[2]=1},
    {[3]=1},
    {[2]=2},
    {[5]=1},
    {[2]=1, [3]=1},
    {[7]=1},
    {[2]=3},
    {[3]=2}
}
local f = {}


for c = 1, 9 do
    for x = 1, 9 do
        for y = x + 1, 9 do
            if ((10 * x + c) * y == (10 * c + y) * x
                or (10 * x + c) * y == (10 * y + c) * x
                or (10 * c + x) * y == (10 * c + y) * x
                or (10 * c + x) * y == (10 * y + c) * x)
            then
                for k, v in pairs(fs[y]) do
                    f[k] = (f[k] or 0) + v
                end
                for k, v in pairs(fs[x]) do
                    f[k] = (f[k] or 0) - v
                end
            end
        end
    end
end


local d = 1
for k, v in pairs(f) do
    if v > 0 then
        d = d * k ^ v
    end
end
print(d)
