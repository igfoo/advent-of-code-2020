
import Data.Map (Map)
import qualified Data.Map as Map

main :: IO ()
main = do xs <- readFile "input"
          let is = map read $ breaks (',' ==) xs
              initialMap = Map.fromList $ zip (init is) [1..]
              js = is ++ doit initialMap (length is) (last is)
          print (js !! (2020 - 1))

doit :: Map Int Int -> Int -> Int -> [(Int)]
doit m lastIndex lastValue = let this = case Map.lookup lastValue m of
                                        Nothing -> 0
                                        Just i -> lastIndex - i
                             in this : doit (Map.insert lastValue lastIndex m) (lastIndex + 1) this

breaks :: (Char -> Bool) -> String -> [String]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]


