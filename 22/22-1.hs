
main :: IO ()
main = do xs <- readFile "input"
          let (p1, p2) = case break null $ lines xs of
                         (_ : ys, _ : _ : zs) -> (map read ys, map read zs)
          print $ play p1 p2

play :: [Integer] -> [Integer] -> Integer
play xs [] = sum $ zipWith (*) [1..] $ reverse xs
play [] ys = play ys []
play (x : xs) (y : ys)
 = if x > y then play (xs ++ [x, y]) ys
            else play xs (ys ++ [y, x])
 
