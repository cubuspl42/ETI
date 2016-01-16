f n a b c =
    if (a + b + c == n) && (a*a + b*b == c*c) then [[a, b, c]]
    else []
g n a b = concat (map (f n a b) [1..n])
h n a   = concat (map (g n a) [1..n])
i n     = concat (map (h n) [1..n])

main =
    print (head (i n))
    where n = 12