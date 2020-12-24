
import Data.List
import Data.Set (Set)
import qualified Data.Set as Set

data Dir = E | SE | SW | W | NW | NE

main :: IO ()
main = do xs <- readFile "input"
          let s0 = Set.fromList $ filterOdd $ sort $ map (pos . parse) $ lines xs
          print $ Set.size (iterate step s0 !! 100)

parse :: String -> [Dir]
parse [] = []
parse ('e'       : xs) = E : parse xs
parse ('s' : 'e' : xs) = SE : parse xs
parse ('s' : 'w' : xs) = SW : parse xs
parse ('w'       : xs) = W : parse xs
parse ('n' : 'w' : xs) = NW : parse xs
parse ('n' : 'e' : xs) = NE : parse xs

pos :: [Dir] -> (Int, Int)
pos = foldl' neighbour (0, 0)

neighbour :: (Int, Int) -> Dir -> (Int, Int)
neighbour (x, y) d = case d of
                     E  -> (x + 2, y)
                     SE -> (x + 1, y - 1)
                     SW -> (x - 1, y - 1)
                     W  -> (x - 2, y)
                     NW -> (x - 1, y + 1)
                     NE -> (x + 1, y + 1)

neighbours :: (Int, Int) -> [(Int, Int)]
neighbours p = map (neighbour p) [E, SE, SW, W, NW, NE]

filterOdd  :: [(Int, Int)] -> [(Int, Int)]
filterOdd (x : y : xs) | x == y = filterOdd xs
filterOdd (x : xs) = x : filterOdd xs
filterOdd [] = []

step :: Set (Int, Int) -> Set (Int, Int)
step s = Set.fromList [ p
                      | x <- expandedDounds fst
                      , y <- expandedDounds snd
                      , let p = (x, y)
                            n = Set.size (Set.fromList (neighbours p) `Set.intersection` s)
                      , n == 2 || ((p `Set.member` s) && n == 1) ]
    where expandedDounds f = let s' = Set.map f s in [minimum s' - 1 .. maximum s' + 1]

