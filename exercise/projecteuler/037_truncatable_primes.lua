local ipairs = ipairs
local sqrt = math.sqrt
local yield = coroutine.yield
local ds = {1, 2, 3, 5, 7, 9}
local ys = {[2]=1, [3]=1, [5]=1, [7]=1}
local gs = {[1]=1, [3]=1, [7]=1, [9]=1}


local function is_prime(n)
    for i = 3, sqrt(n), 2 do
        if n % i == 0 then
            return false
        end
    end
    return true
end


local function gen(n, m)
    local y, z = 10 ^ m, m + 1
    for _, i in ipairs(ds) do
        local x = i * y + n
        if is_prime(x) then
            if ys[i] then
                yield(x, z)
            end
            if gs[i] then
                gen(x, z)
            end
        end
    end
end


local function is_prime_from_left(n, m)
    for i = 1, m - 2 do
        n = (n - n % 10) / 10
        if not is_prime(n) then
            return false
        end
    end
    return true
end


local ret = 0
for tp, l in coroutine.wrap(function() gen(3, 1); gen(7, 1); end) do
    if is_prime_from_left(tp, l) then
        ret = ret + tp
    end
end
print(ret)
