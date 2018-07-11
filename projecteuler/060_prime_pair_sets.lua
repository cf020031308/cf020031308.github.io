local push = table.insert
local pop = table.remove

local g_primes = {2}
local g_tree = {[2] = {}}
local g_length = 4

local is_prime = function(n)
    if g_tree[n] then
        return true
    end
    local max = math.sqrt(n)
    for _, p in ipairs(g_primes) do
        if p > max then
            g_tree[n] = {}
            return true
        elseif n % p == 0 then
            return false
        end
    end
    for p = g_primes[#g_primes] + 2, max, 2 do
        if n % p == 0 then
            return false
        end
    end
    g_tree[n] = {}
    return true
end

local function chain(tree, n, route)
    route = route or {}
    if next(tree) == nil then
        if #route + 1 >= g_length then
            lst = string.format("[%s, %d]", table.concat(route, ", "), n)
            for _, p in ipairs(route) do
                n = n + p
            end
            print(string.format(
                "minimal sets with length %d: %s, sum: %s", #route + 1, lst, n))
            if g_length == 4 then
                assert(lst == "[3, 7, 109, 673]", lst)
                g_length = #route + 2
            else
                os.exit()
            end
        end
    else
        for _, p in ipairs(g_primes) do
            local t = tree[p]
            if t and is_prime(tonumber(p .. n)) and is_prime(tonumber(n .. p)) then
                push(route, p)
                chain(t, n, route)
                pop(route)
            end
        end
    end
    tree[n] = {}
end

local n = 3
while true do
    if is_prime(n) then
        chain(g_tree, n)
        push(g_primes, n)
    end
    n = n + 2
end
