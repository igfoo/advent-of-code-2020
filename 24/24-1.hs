
import Data.List

data Dir = E | SE | SW | W | NW | NE

main :: IO ()
main = do xs <- readFile "input"
          print $ numOdd $ sort $ map (pos . parse) $ lines xs

parse :: String -> [Dir]
parse [] = []
parse ('e'       : xs) = E : parse xs
parse ('s' : 'e' : xs) = SE : parse xs
parse ('s' : 'w' : xs) = SW : parse xs
parse ('w'       : xs) = W : parse xs
parse ('n' : 'w' : xs) = NW : parse xs
parse ('n' : 'e' : xs) = NE : parse xs

pos :: [Dir] -> (Int, Int)
pos = foldl' f (0, 0)
    where f (x, y) d = case d of
                       E  -> (x + 2, y)
                       SE -> (x + 1, y - 1)
                       SW -> (x - 1, y - 1)
                       W  -> (x - 2, y)
                       NW -> (x - 1, y + 1)
                       NE -> (x + 1, y + 1)

numOdd  :: [(Int, Int)] -> Int
numOdd (x : y : xs) | x == y = numOdd xs
numOdd (x : xs) = 1 + numOdd xs
numOdd [] = 0

