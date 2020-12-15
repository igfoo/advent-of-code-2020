
import Data.Bits
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Word
import Numeric

type Masks = [(Word64, Word64)]
type State = (Map Word64 Word64, Masks)

mkMasks :: String -> Masks
mkMasks = foldl f [(0, 0)]
    where f ms '0' = [((and `shiftL` 1) .|. 1,       or `shiftL` 1)            | (and, or) <- ms]
          f ms '1' = [ (and `shiftL` 1,             (or `shiftL` 1) .|. 1)     | (and, or) <- ms]
          f ms 'X' = [ (and `shiftL` 1,             (or `shiftL` 1) .|. orBit) | (and, or) <- ms, orBit <- [0, 1]]

addresses :: Masks -> Word64 -> [Word64]
addresses ms w = [ (w .&. and) .|. or | (and, or) <- ms ]

main :: IO ()
main = do xs <- readFile "input"
          let (m, _) = foldl' doStep (Map.empty, []) $ lines xs
          print $ sum $ Map.elems m

doStep :: State -> String -> State
doStep (m, masks) s0
 | Just mask <- stripPrefix "mask = " s0
    = (m, mkMasks mask)
 | Just s1 <- stripPrefix "mem[" s0,
   [(addr, s2)] <- reads s1,
   Just s3 <- stripPrefix "] = " s2,
   [(val, "")] <- reads s3
    = let f addr' m' = Map.insert addr' val m'
      in (foldr f m (addresses masks addr), masks)
 | otherwise = error "Bad line"

