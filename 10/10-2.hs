
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

main = do xs <- readFile "input"
          print $ f (0 : map read (lines xs))

f :: [Integer] -> Integer
f is = let maxi = maximum is
           numberFrom = Map.fromList [ (i, v)
                                     | i <- [0 .. maxi + 3]
                                     , let v = if i == maxi
                                               then 1
                                               else if i `elem` is
                                               then fromJust (Map.lookup (i + 1) numberFrom)
                                                  + fromJust (Map.lookup (i + 2) numberFrom)
                                                  + fromJust (Map.lookup (i + 3) numberFrom)
                                               else 0 ]
       in fromJust $ Map.lookup 0 numberFrom

