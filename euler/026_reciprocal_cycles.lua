local function rc(n)
    local set = {[0]=-1}
    local len = 0
    local remain = 1
    repeat
        set[remain] = len
        remain = remain * 10
        while remain < n do
            remain = remain * 10
            len = len + 1
        end
        local s = remain % n
        remain, s = s, (remain - s) / n
        len = len + 1
    until set[remain]
    if remain ~= 0 then
        return len - set[remain]
    end
end


local function main(n)
    local max = 0
    local idx = 1
    for i = 2, n do
        local len = rc(i)
        if len and len > max then
            max = len
            idx = i
        end
    end
    return idx
end

assert(main(10) == 7)
print(main(1000))
