local N = 5
local n = 100
local c = n^3
local ret = {}
while true do
    local x = c
    local t = {}
    while x > 0 do
        local r = x % 10
        table.insert(t, r)
        x = (x - r) / 10
    end
    table.sort(t)
    local k = table.concat(t, "")
    if ret[k] then
        table.insert(ret[k], {n, c})
        if #ret[k] == N then
            for i = 1, N do
                print(ret[k][i][1], ret[k][i][2])
            end
            os.exit()
        end
    else
        ret[k] = {{n, c}}
    end
    c = c + 3 * n * (n + 1) + 1
    n = n + 1
end
