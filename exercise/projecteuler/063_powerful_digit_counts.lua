-- Because: n > log10(x^n) >= n - 1
-- So for left: x = 1, ..., 9
-- And for right: n <= 1 / (1 - log10(x))

local s = 0
for x = 1, 9 do
    s = s + math.floor(1 / (1 - math.log10(x)))
end
print(s)
