-- curl https://projecteuler.net/project/resources/p054_poker.txt | luajit 054_poker_hands.lua

VALUES = {T = 8, J = 9, Q = 10, K = 11, A = 12}
for i = 2, 9 do
    VALUES[tostring(i)] = i - 2
end

local function calc(cards)
    local rank = {}
    rank[6] = true
    local counts = {}
    for i = 1, 5 do
        rank[6] = rank[6] and cards[i][2] == cards[1][2]
        counts[cards[i][1]] = (counts[cards[i][1]] or 0) + 1
    end
    for v, c in pairs(counts) do
        if c == 4 then
            rank[4] = 5
        elseif c == 3 then
            rank[3] = 3
        elseif c == 2 then
            rank[2], rank[1] = rank[1], 1
        end
    end
    table.sort(cards, function(x, y)
        return (counts[x[1]] or 0) * 13 + VALUES[x[1]] > (counts[y[1]] or 0) * 13 + VALUES[y[1]]
    end)
    rank[5] = true
    for i = 1, 4 do
        if VALUES[cards[i][1]] ~= VALUES[cards[i + 1][1]] + 1 then
            rank[5] = false
            break
        end
    end
    rank[5] = rank[5] and 3.2 or 0
    rank[6] = rank[6] and 3.8 or 0
    local score = 0
    for i = 1, 6 do
        score = score + (rank[i] or 0)
    end
    for _, card in ipairs(cards) do
        score = score * 13 + VALUES[card[1]]
    end
    return score
end


local count = 0
for line in io.stdin:lines() do
    local cards = {{}, {}}
    for i = 1, 5 do
        local m = i * 3 - 2
        cards[1][i] = {line:sub(m, m), line:sub(m + 1, m + 1)}
        m = m + 15
        cards[2][i] = {line:sub(m, m), line:sub(m + 1, m + 1)}
    end
    if calc(cards[1]) > calc(cards[2]) then
        count = count + 1
    end
end
print(count)
