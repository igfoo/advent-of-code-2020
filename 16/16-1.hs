
import Data.Char

main :: IO ()
main = do xs <- readFile "input"
          let [descrs, "your ticket:" : mine, "nearby tickets:" : nearby] = breaks null $ lines xs
              checks = map mk_check descrs
              nearVals = map read $ concatMap (breaks (',' == )) nearby
          print $ sum [ i | i <- nearVals, not $ any ($ i) checks ]

mk_check :: String -> Int -> Bool
mk_check xs i = case break (':' ==) xs of
                (_, ':':' ':ys) ->
                    case breaks (not . isDigit) ys of
                    [from1,to1,"","","",from2,to2] ->
                        (read from1 <= i && read to1 >= i) ||
                        (read from2 <= i && read to2 >= i)

breaks :: (a -> Bool) -> [a] -> [[a]]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]


