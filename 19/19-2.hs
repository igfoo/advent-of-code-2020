
import Data.Char
import Data.List
import qualified Data.Map as Map
import Text.Regex.PCRE

main :: IO ()
main = do xs <- readFile "input"
          case break null $ lines xs of
              (rules, "" : strings) -> print $ length $ filter (matches rules) strings

doit :: [String] -> String -> IO ()
doit rules str = do print str
                    print (matches rules str)

data State = DoingBoth Bool | DoingOne Bool

matches :: [String] -> String -> Bool
matches rules str = f (str, DoingBoth False)
    where pre = "^" ++ mkRegex 42 rules ++ "$"
          post = "^" ++ mkRegex 31 rules ++ "$"
          f ("", DoingOne True) = True
          f ("", _) = False
          f (xs0, DoingBoth started)
              = (started && f (xs0, DoingOne False))
             || any f [ (xs3, DoingBoth True)
                      | i <- [1 .. length xs0]
                      , let (xs1, xs2) = splitAt i xs0
                      , xs1 =~ pre
                      , j <- [1 .. length xs2]
                      , let (xs3, xs4) = splitAt j xs2
                      , xs4 =~ post ]
          f (xs0, DoingOne _)
              = any f [ (xs2, DoingOne True)
                      | i <- [1 .. length xs0]
                      , let (xs1, xs2) = splitAt i xs0
                      , xs1 =~ pre ]

mkRegex :: Int -> [String] -> String
mkRegex i strings = f i
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

