
import Data.List
import Data.Set (Set)
import qualified Data.Set as Set

main :: IO ()
main = do xs <- readFile "input"
          let foods = map parse $ lines xs
              allergens = Set.toList $ Set.fromList $ concatMap snd foods
              allergenPossibilities = map (mkPossibility foods) allergens
              allPossibles = foldl1' Set.union $ map snd allergenPossibilities
              impossible = Set.fromList (concatMap fst foods) `Set.difference` allPossibles
          print $ length $ filter (`elem` impossible) $ concatMap fst foods

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

