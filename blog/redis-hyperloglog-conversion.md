# Redis Hyperloglog Conversion

In `redis` if several (or simply one) `hyperloglog` datas are merged into one, the result will be displayed in dense representation which costs 12k in memory, whereas the sparse representation costs only 200 Byte on average in my DB.

Here is a `Lua` script to **convert hyperloglog data represented as dense into sparse representation**.

On my MacBook Pro with 2.4 GHz Intel Core i5, it works at a speed of 182/s.

```lua
local function hll_dense2sparse(key)
    local exec = redis.call
    local sub = string.sub
    local byte = string.byte
    local char = string.char
    local insert = table.insert
    local concat = table.concat
    local floor = math.floor
    local magic = "HYLL"

    local dense = exec("GET", key)
    if sub(dense, 1, 4) ~= magic then
        -- not a hll
        return -1
    end
    if byte(dense, 5) == 1 then
        -- already sparse
        return 0
    end
    if #dense ~= 12304 then
        -- 12304 = 16 + 16384 * 6 / 8 is the length of a dense hll
        return -1
    end

    local sparse = {magic, char(1), sub(dense, 6, 16)}
    local c, v, _v = 1, nil, nil
    for i = 0, 16384 do
        local offset = i * 6 % 8
        local j = (i * 6 - offset) / 8 + 17
        local x, y = byte(dense, j, j + 1)
        if x then
            _v = (floor(x / 2 ^ offset) + (y or 0) * 2 ^ (8 - offset)) % 64
        else
            _v = nil
        end

        if _v and _v > 32 then
            -- cannot translate to sparse representation
            return -2
        end
        if _v == v then
            c = c + 1
        else
            if v == 0 then
                while c >= 16384 do
                    insert(sparse, char(127) .. char(255))
                    c = c - 16384
                end
                if c > 64 then
                    c = c - 1
                    insert(sparse, char(64 + floor(c / 256)) .. char(c % 256))
                elseif c > 0 then
                    insert(sparse, char(c - 1))
                end
            elseif v then
                v = v - 1
                while c >= 4 do
                    insert(sparse, char(128 + v * 4 + 3))
                    c = c - 4
                end
                if c > 0 then
                    insert(sparse, char(128 + v * 4 + c - 1))
                end
            end
            c, v = 1, _v
        end
    end

    exec("SET", key, concat(sparse))
    return 1
end
```
