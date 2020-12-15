
import Data.Bits
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Word
import Numeric

type State = (Map Word64 Word64, Word64{-0, and-}, Word64{-1, or-})

main :: IO ()
main = do xs <- readFile "input"
          let (m, _, _) = foldl' f (Map.empty, 0, 0) $ lines xs
          print $ sum $ Map.elems m

fromReads :: [(a, String)] -> a
fromReads [(x, "")] = x
fromReads _ = error "Impossible fromReads"

f :: State -> String -> State
f (m, zero, one) s0
 | Just mask <- stripPrefix "mask = " s0
    = (m,
       fromReads $ readInt 2 (`elem` "X01") (\c -> if c == '0' then 0 else 1) mask,
       fromReads $ readInt 2 (`elem` "X01") (\c -> if c == '1' then 1 else 0) mask)
 | Just s1 <- stripPrefix "mem[" s0,
   [(addr, s2)] <- reads s1,
   Just s3 <- stripPrefix "] = " s2,
   [(val, "")] <- reads s3
    = (Map.insert addr ((val .&. zero) .|. one) m, zero, one)
 | otherwise = error "Bad line"

