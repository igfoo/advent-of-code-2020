
import Data.Char

main :: IO ()
main = do xs <- readFile "input"
          print $ sum $ map (eval . parse) $ lines xs

data Expr = Num Integer | Sum Expr Expr | Mul Expr Expr

parse :: String -> Expr
parse s = case f $ filter (' ' /=) $ reverse s of
          (e, "") -> e
    where f (x : xs)
           | isDigit x = g (Num (fromIntegral (ord x - ord '0'))) xs
           | x == ')' = case f xs of
                        (e, '(' : ys) -> g e ys
          g lhs ('+' : xs) = case f xs of
                             (rhs, ys) -> (Sum lhs rhs, ys)
          g lhs ('*' : xs) = case f xs of
                             (rhs, ys) -> (Mul lhs rhs, ys)
          g lhs xs = (lhs, xs)

eval :: Expr -> Integer
eval (Num i) = i
eval (Sum x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

