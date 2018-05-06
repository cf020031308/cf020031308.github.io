local sqrt = math.sqrt
local n2p = setmetatable({}, {__index=function(t, n)
    t[n] = n * (3 * n - 1) / 2
    return t[n]
end})


local function is_p(x)
    return sqrt(24 * x + 1) % 6 == 5
end


local function main()
    local n = 1
    while true do
        local m, np = n + 1, n2p[n]
        repeat
            local mp = n2p[m]
            local sp = np + mp
            if is_p(sp) then
                if is_p(sp + mp) then
                    return np
                elseif is_p(sp + np) then
                    return mp
                end
            end
            m = m + 1
        until sp < n2p[m]
        n = n + 1
    end
end


print(main())
