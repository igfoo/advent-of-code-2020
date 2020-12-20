
import Control.Monad
import Data.Array
import Data.List
import qualified Data.Set as Set
import Numeric

main :: IO ()
main = do xs <- readFile "input"
          let ts = map parseTile $ filter (not . null) $ breaks null $ lines xs
              len = head [ i | i <- [1..], i * i == length ts ]
              es = sort $ concatMap edges ts
              us = unique es
              cs = [ t | t <- ts, length (intersect us (edges t)) == 2 ]
              c = head cs
              tlc = head [ c'
                         | c' <- tileOrientations c
                         , top c' `elemR` us
                         , left c' `elemR` us ]
              cell (x, y) = if x == 1 && y == 1 then tlc
                            else if y == 1 then the [ t
                                                    | t <- concatMap tileOrientations ts
                                                    , top t `elemR` us
                                                    , let l = arr ! (x - 1, y)
                                                    , fst t /= fst l
                                                    , left t == right l ]
                            else if x == 1 then the [ t
                                                    | t <- concatMap tileOrientations ts
                                                    , left t `elemR` us
                                                    , let u = arr ! (x, y - 1)
                                                    , fst t /= fst u
                                                    , top t == bottom u ]
                            else the [ t
                                     | t <- concatMap tileOrientations ts
                                     , left t == right (arr ! (x - 1, y))
                                     , top t == bottom (arr ! (x, y - 1)) ]
              arr = array ((1, 1), (len, len))
                          [ ((x, y), cell (x, y))
                          | x <- [1 .. len]
                          , y <- [1 .. len] ]
              arr' = fmap core arr
              rows :: [[[String]]]
              rows = [ [ arr' ! (x, y) | x <- [1 .. len] ]
                     | y <- [1 .. len] ]
              image = concat $ map (map concat . transpose) rows
              monsterStrings = ["                  # ",
                                "#    ##    ##    ###",
                                " #  #  #  #  #  #   "]
              len2 = length image
              imageSet = Set.fromList [ (x, y)
                                      | x <- [0 .. len2 - 1]
                                      , y <- [0 .. len2 - 1]
                                      , image !! y !! x == '#' ]
              monsters = [ mkMonster ms xoff yoff
                         | ms <- orientations monsterStrings
                         , xoff <- [0 .. len2]
                         , yoff <- [0 .. len2] ]
              mkMonster ms xoff yoff = Set.fromList [ (x + xoff, y + yoff)
                                                    | x <- [0 .. length (head ms) - 1]
                                                    , y <- [0 .. length ms - 1]
                                                    , ms !! y !! x == '#' ]
              isMonster m = (imageSet `Set.intersection` m) == m
              sightings = filter isMonster monsters
              hashes xs = length $ filter ('#' ==) $ concat xs
          print (hashes image - hashes monsterStrings * length sightings)

type Tile = (Integer, [String])

core :: Tile -> [String]
core (_, xs) = map (init . tail) $ init $ tail xs

the :: [a] -> a
the [x] = x
the [] = error "the none"
the _ = error "the many"

elemR :: String -> [String] -> Bool
x `elemR` ys = x `elem` ys || reverse x `elem` ys

top :: Tile -> String
top (_, (x : _)) = x

left :: Tile -> String
left (i, xs) = top (i, transpose xs)

right :: Tile -> String
right (i, xs) = left (i, map reverse xs)

bottom :: Tile -> String
bottom (i, xs) = top (i, reverse xs)

tileOrientations :: Tile -> [Tile]
tileOrientations (i, ls) = [ (i, ls') | ls' <- orientations ls ]

orientations :: [String] -> [[String]]
orientations xs = [ f1 $ f2 $ f3 xs
                  | f1 <- [id, reverse]
                  , f2 <- [id, map reverse]
                  , f3 <- [id, transpose] ]

edges :: Tile -> [String]
edges (_, ls) = [ e `min` reverse e | e <- map head [ls, reverse ls, transpose ls, reverse $ transpose ls] ]

parseTile :: [String] -> Tile
parseTile (x : xs) = case stripPrefix "Tile " x of
                     Just x' -> (read (init x'), xs)
    where borders ys = map top [ys, reverse ys, transpose ys, reverse $ transpose ys]
          top (y : _) = toBin y `min` toBin (reverse y)
          toBin y = case readInt 2 (`elem` "#.") (fromEnum . ('#' ==)) y of
                    [(i, "")] -> i

unique :: Eq a => [a] -> [a]
unique (x : y : xs')
 | x == y = unique $ dropWhile (x ==) xs'
unique (x : xs) = x : unique xs
unique [] = []

breaks :: (a -> Bool) -> [a] -> [[a]]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]

