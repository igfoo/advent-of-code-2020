
import Data.List
import Data.Set (Set)
import qualified Data.Set as Set

main :: IO ()
main = do xs <- readFile "input"
          let (p1, p2) = case break null $ lines xs of
                         (_ : ys, _ : _ : zs) -> (map read ys, map read zs)
          print $ snd $ play Set.empty p1 p2

play :: Set ([Integer], [Integer]) -> [Integer] -> [Integer] -> (Bool, Integer)
play seen xs ys
 | (xs, ys) `Set.member` seen = score False xs ys
play _ xs [] = score False xs []
play _ [] ys = score True  [] ys
play seen xs@(x : xs') ys@(y : ys')
 = let winner = if x > genericLength xs' || y > genericLength ys'
                then y > x
                else fst $ play Set.empty (genericTake x xs') (genericTake y ys')
   in if winner then play seen' xs' (ys' ++ [y, x])
                else play seen' (xs' ++ [x, y]) ys'
    where seen' = (xs, ys) `Set.insert` seen

score :: Bool -> [Integer] -> [Integer] -> (Bool, Integer)
score player xs ys = (player, sum $ zipWith (*) [1..] $ reverse ys)
    where zs = if player then ys else xs

