local function fibs(n)
    local x, y = 1, 1
    return function()
        if y < n then
            x, y = y, x + y
            return y
        else
            return
        end
    end
end


local function main(n)
    local sum = 0
    for i in fibs(n) do
        if i % 2 == 0 then
            sum = sum + i
        end
    end
    return sum
end


print(main(4e6))
