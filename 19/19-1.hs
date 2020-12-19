
import Data.Char
import qualified Data.Map as Map
import Text.Regex.PCRE

main :: IO ()
main = do xs <- readFile "input"
          case break null $ lines xs of
              (rules, "" : strings) -> print $ length $ filter (=~ (mkRegex rules)) strings

mkRegex :: [String] -> String
mkRegex strings = "^" ++ f 0 ++ "$"
    where m = Map.fromList [ (i, rhs)
                           | x <- strings
                           , let (i, rhs) = case break (':' ==) x of
                                            (iStr, ':' : ' ' : y) -> (read iStr, y) ]
          f i = case Map.lookup i m of
                Just ['"', c, '"'] -> [c]
                Just xs -> case break ('|' ==) xs of
                           (ys, '|' : zs) -> "(" ++ g ys ++ "|" ++ g zs ++ ")"
                           _ -> g xs
          g xs = concatMap f $ map read $ words xs

