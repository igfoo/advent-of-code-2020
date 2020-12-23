import Data.Char
import Data.Map (Map, (!))
import qualified Data.Map as Map

type State = (Int, Map Int Int)

main :: IO ()
main = do xs <- readFile "input"
          let cups = map (\c -> read [c]) $ filter (not . isSpace) xs
              allCups = cups ++ [maximum cups + 1 .. 1000000]
              initState = (head allCups, Map.fromList $ zip allCups (tail allCups ++ [head allCups]))
              (_, finalM) = iterate action initState !! 10000000
              x1 = finalM ! 1
              x2 = finalM ! x1
          print (fromIntegral x1 * fromIntegral x2)

action :: State -> State
action (x, m)
 = let x1 = m ! x
       x2 = m ! x1
       x3 = m ! x2
       x4 = m ! x3
       y = head $ filter (`notElem` [x1, x2, x3]) $ tail $ iterate prev x
   in (x4, Map.insert y x1 (Map.insert x3 (m ! y) (Map.insert x x4 m)))

prev :: Int -> Int
prev 1 = 1000000
prev x = x - 1
