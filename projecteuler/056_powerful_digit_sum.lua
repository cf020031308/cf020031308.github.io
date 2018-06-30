local function add(x, y)
    for i = #x, 1, -1 do
        x[i] = x[i] + y
        if x[i] > 9 then
            y = (x[i] - x[i] % 10) / 10
            x[i] = x[i] % 10
        else
            return
        end
    end
    while y > 0 do
        table.insert(x, 1, y % 10)
        y = (y - y % 10) / 10
    end
end
local x = {2, 3, 5}
add(x, 9999) 
x = table.concat(x)
assert(x == "10234", x)


local function multi(x, y)
    local s = {0}
    local r = 0
    for i = #x, 1, -1 do
        x[i] = x[i] * y + r
        r = (x[i] - x[i] % 10) / 10
        x[i] = x[i] % 10
        add(s, x[i])
    end
    while r > 0 do
        table.insert(x, 1, r % 10)
        add(s, r % 10)
        r = (r - r % 10) / 10
    end
    return s
end
local x = {1, 7, 2, 8}
local y = multi(x, 3211)
x = table.concat(x)
y = table.concat(y)
assert(x == "5548608", x)
assert(y == "36", y)


local function gt(x, y)
    if #x > #y then
        return true
    elseif #x < #y then
        return false
    end
    for i = 1, #x do
        if x[i] > y[i] then
            return true
        elseif x[i] < y[i] then
            return false
        end
    end
    return false
end


local max = {}
for a = 1, 99 do
    if a % 10 ~= 0 then
        local n = {1}
        for _ = 1, 99 do
            s = multi(n, a)
            if gt(s, max) then
                for i = 1, #s do
                    max[i] = s[i]
                end
            end
        end
    end
end
print(table.concat(max))
