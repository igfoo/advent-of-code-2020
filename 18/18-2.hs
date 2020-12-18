
import Data.Char

main :: IO ()
main = do xs <- readFile "input"
          print $ sum $ map (eval . parse) $ lines xs

data Expr = Num Integer | Sum Expr Expr | Mul Expr Expr | Paren Expr

parse :: String -> Expr
parse s = case f $ filter (' ' /=) $ reverse s of
          (e, "") -> twiddle e
    where f (x : xs)
           | isDigit x = g (Num (fromIntegral (ord x - ord '0'))) xs
           | x == ')' = case f xs of
                        (e, '(' : ys) -> g (Paren e) ys
          g lhs ('+' : xs) = case f xs of
                             (rhs, ys) -> (Sum lhs rhs, ys)
          g lhs ('*' : xs) = case f xs of
                             (rhs, ys) -> (Mul lhs rhs, ys)
          g lhs xs = (lhs, xs)

twiddle :: Expr -> Expr
twiddle (Sum x y) = case twiddle x of
                    Mul a b -> Mul (twiddle a) (twiddle (Sum b y))
                    x' ->
                        case twiddle y of
                        Mul a b -> Mul (twiddle (Sum x a)) (twiddle b)
                        y' -> Sum x' y'
twiddle (Mul x y) = Mul (twiddle x) (twiddle y)
twiddle (Paren e) = Paren (twiddle e)
twiddle (Num i) = Num i

eval :: Expr -> Integer
eval (Num i) = i
eval (Sum x y) = eval x + eval y
eval (Mul x y) = eval x * eval y
eval (Paren e) = eval e

