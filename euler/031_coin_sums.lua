local function exchange(sum, coins)
    local n = #coins
    if n == 1 then
        return 1
    end

    local next_coins = {}
    for i = 1, n - 1 do
        next_coins[i] = coins[i]
    end
    local largest = coins[n]

    local ways = 0
    for i = 0, sum / largest do
        ways = ways + exchange(sum - i * largest, next_coins)
    end

    return ways
end


print(exchange(200, {1, 2, 5, 10, 20, 50, 100, 200}))
