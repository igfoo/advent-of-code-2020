
import Data.List
import Data.Maybe
import Data.Set (Set)
import qualified Data.Set as Set

main :: IO ()
main = do xs <- readFile "input"
          let foods = map parse $ lines xs
              allergens = Set.toList $ Set.fromList $ concatMap snd foods
              allergenPossibilities = map (mkPossibility foods) allergens
              allPossibles = foldl1' Set.union $ map snd allergenPossibilities
              impossible = Set.fromList (concatMap fst foods) `Set.difference` allPossibles
              actuals = mkActuals allergenPossibilities
          print $ intercalate "," $ map snd $ sort actuals

mkActuals :: [(String, Set String)] -> [(String, String)]
mkActuals [] = []
mkActuals xs = case break ((== 1) . Set.size . snd) xs of
               (ys, (allergen, possibles) : zs) ->
                   let actual = fromJust $ Set.lookupMin possibles
                       rest = [ (a, actual `Set.delete` ps)
                              | (a, ps) <- ys ++ zs ]
                   in (allergen, actual) : mkActuals rest

mkPossibility :: [([String], [String])] -> String -> (String, Set String)
mkPossibility foods allergen = (allergen, candidates)
    where candidates = foldl1' Set.intersection [ Set.fromList ings
                                                | (ings, allergens) <- foods
                                                , allergen `elem` allergens ]

parse :: String -> ([String], [String])
parse xs = case break ('(' ==) xs of
           (ys, zs) ->
               case stripPrefix "(contains " (init zs) of
               Just zs' ->
                   (words ys, words $ filter (',' /=) zs')

