import Data.List
import Data.Map hiding (map)

data Zdanie =
    Z Char | N Zdanie | K Zdanie Zdanie | A Zdanie Zdanie | C Zdanie Zdanie

drukuj :: Zdanie -> String
drukuj (Z p) = [p]
drukuj (N p) = "~" ++ drukuj p
drukuj (K p q) = "(" ++ drukuj p ++ " & " ++ drukuj q ++ ")"
drukuj (A p q) = "(" ++ drukuj p ++ " | " ++ drukuj q ++ ")"
drukuj (C p q) = "(" ++ drukuj p ++ " => " ++ drukuj q ++ ")"

zmienne :: Zdanie -> [Char]
zmienne (Z p) = [p]
zmienne (N p) = zmienne p
zmienne (K p q) = (zmienne p) ++ (zmienne q)
zmienne (A p q) = (zmienne p) ++ (zmienne q)
zmienne (C p q) = (zmienne p) ++ (zmienne q)

wypisz_zmienne :: Zdanie -> [Char]
wypisz_zmienne z = map head (group (sort (zmienne z)))

sprawdz :: Zdanie -> (Map Char Bool) -> Bool
sprawdz (Z p) wartosci =
    case Data.Map.lookup p wartosci of
        Just value -> value
        Nothing    -> False
sprawdz (N p) wartosci = not (sprawdz p wartosci)
sprawdz (K p q) wartosci = (sprawdz p wartosci) && (sprawdz q wartosci)
sprawdz (A p q) wartosci = (sprawdz p wartosci) || (sprawdz q wartosci)
sprawdz (C p q) wartosci = (not (sprawdz p wartosci)) || (sprawdz q wartosci)

sprawdz_kombinacje :: Zdanie -> [Char] -> [(Char, Bool)] -> Bool
sprawdz_kombinacje z [] pv = sprawdz z (fromList pv)
sprawdz_kombinacje z (p:t) pv =
    (sprawdz_kombinacje z t (pv ++ [(p, True)])) &&
    (sprawdz_kombinacje z t (pv ++ [(p, False)]))  

jest_tautologia :: Zdanie -> Bool
jest_tautologia z = sprawdz_kombinacje z (wypisz_zmienne z) []

main = do
    print (drukuj z)
    print (wypisz_zmienne z)
    print (sprawdz z m)
    print "Tautologie:"
    print (drukuj t1)
    print (jest_tautologia t1)
    print (drukuj t2)
    print (jest_tautologia t2)
    print (drukuj t3)
    print (jest_tautologia t3)
    print (drukuj t4)
    print (jest_tautologia t4)
    print "Nie-tautologie:"
    print (drukuj t5)
    print (jest_tautologia t5)
    print (drukuj t6)
    print (jest_tautologia t6)
    print (drukuj t7)
    print (jest_tautologia t7)
    print (drukuj t8)
    print (jest_tautologia t8)
    where   z = (C (N (Z 'p')) (A (K (Z 'p') (Z 'q')) (Z 'r')))
            m = fromList [('p', False), ('q', True), ('r', False)]
            t1 = (C (Z 'p') (A (Z 'p') (Z 'q')))
            t2 = (A (Z 'p') (N (Z 'p')))
            t3 = (C (Z 'p') (Z 'p'))
            t4 = (C (K (C (Z 'p') (Z 'q')) (C (Z 'r') (Z 's'))) (C (A (Z 'p') (Z 'r')) (A (Z 'q') (Z 's'))))
            t5 = (A (Z 'p') (A (Z 'q') (Z 'p')))
            t6 = (K (Z 'p') (N (Z 'p')))
            t7 = (C (Z 'p') (Z 'q'))
            t8 = (C (A (C (Z 'p') (Z 'r')) (C (Z 'r') (Z 's'))) (C (K (Z 'p') (Z 'r')) (A (Z 'q') (Z 's'))))




