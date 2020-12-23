import Data.Char

main :: IO ()
main = do xs <- readFile "input"
          let cups = map (\c -> read [c]) $ filter (not . isSpace) xs
          case break (1 ==) (iterate action cups !! 100) of
              (ys, _ : zs) -> putStrLn $ concatMap show (zs ++ ys)

action :: [Int] -> [Int]
action (x : x1 : x2 : x3 : xs)
 = let y = case filter (< x) xs of
           [] -> maximum xs
           xs' -> maximum xs'
   in case break (y ==) (x : xs) of
      (ys, z : zs) ->
          case break (x ==) (ys ++ [z, x1, x2, x3] ++ zs) of
          (pre, old : post) -> post ++ pre ++ [old]

