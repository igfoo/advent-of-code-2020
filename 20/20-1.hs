
import Control.Monad
import Data.List
import Numeric

main :: IO ()
main = do xs <- readFile "input"
          let ts = map parseTile $ filter (not . null) $ breaks null $ lines xs
              us = unique $ sort $ concatMap snd ts
              cs = [ t | t <- ts, length (intersect us (snd t)) == 2 ]
          when (length cs /= 4) $ error "Too many corners"
          print $ product $ map fst cs

type Tile = (Integer, [Integer])

parseTile :: [String] -> Tile
parseTile (x : xs) = case stripPrefix "Tile " x of
                     Just x' -> (read (init x'), borders xs)
    where borders ys = map top [ys, reverse ys, transpose ys, reverse $ transpose ys]
          top (y : _) = toBin y `min` toBin (reverse y)
          toBin y = case readInt 2 (`elem` "#.") (fromEnum . ('#' ==)) y of
                    [(i, "")] -> i

unique :: [Integer] -> [Integer]
unique (x : y : xs')
 | x == y = unique $ dropWhile (x ==) xs'
unique (x : xs) = x : unique xs
unique [] = []

breaks :: (a -> Bool) -> [a] -> [[a]]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]

