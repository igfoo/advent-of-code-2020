
import Data.List
import Data.Maybe

main :: IO ()
main = do xs <- readFile "input"
          let [i, j] = map read $ lines xs
              y = findLoopSize j
          print (iterate (step i) 1 !! y)

findLoopSize :: Int -> Int
findLoopSize i = fromJust $ elemIndex i $ iterate (step 7) 1

step :: Int -> Int -> Int
step s i = (i * s) `mod` 20201227

