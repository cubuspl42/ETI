isPrime :: Integer -> Bool
isPrime 1 = False
isPrime 2 = True
isPrime n = all (/= 0) (map (mod n) [2..n-1])

digitsOf :: Integer -> [Integer]
digitsOf 0 = [0]
digitsOf n
    | n >= 10   = (digitsOf (n `div` 10)) ++ [(n `mod` 10)]
    | otherwise = [(n `mod` 10)]

fromReversedDigits :: Integer -> [Integer] -> Integer
fromReversedDigits a [] = 0
fromReversedDigits a (i:j) = i * a + (fromReversedDigits (a * 10) j)

fromDigits :: [Integer] -> Integer
fromDigits d = fromReversedDigits 1 (reverse d)

rotateLeft :: [a] -> [a]
rotateLeft (h:t) = t ++ [h]

nRotationsOf :: [a] -> Integer -> [[a]]
nRotationsOf xs n
    | n == 1    = [xs]
    | otherwise = [xs] ++ (nRotationsOf (rotateLeft xs) (n-1))

allRotationsOf :: Integer -> [Integer]
allRotationsOf n =
    map fromDigits (nRotationsOf d (toInteger (length d)))
    where d = (digitsOf n)

isCircularPrime :: Integer -> Bool
isCircularPrime n = all isPrime (allRotationsOf n)

circularPrimes :: Integer -> [Integer]
circularPrimes n =
    filter isCircularPrime [1..n]

main =
    print (circularPrimes n)
    where n = 10000
