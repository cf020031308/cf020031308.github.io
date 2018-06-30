local function add(x, y)
    for i = 1, #y do
        x[i] = (x[i] or 0) + y[i]
        if x[i] > 9 then
            x[i + 1] = (x[i + 1] or 0) + 1
            x[i] = x[i] - 10
        end
    end
    for i = #y, #x do
        if x[i] < 10 then
            return x
        end
        x[i + 1] = (x[i + 1] or 0) + 1
        x[i] = x[i] - 10
    end
end


local count = 0
local num, den= {1}, {1}
for i = 1, 1000 do
    den, num = add(num, den), add(den, num)
    if #num > #den then
        count = count + 1
    end
end
print(count)
