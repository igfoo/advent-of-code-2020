
import Data.Maybe
import Data.Set (Set)
import qualified Data.Set as Set

main :: IO ()
main = do xs <- readFile "input"
          let s = Set.fromList $ map fst $ filter (('#' ==) . snd) $ concat $ zipWith (\x ys -> map (\(y, c) -> ((x, y, 0, 0), c)) ys) [0..] $ map (zip [0..]) $ lines xs
          print $ Set.size (iterate step s !! 6)

step :: Set (Int, Int, Int, Int) -> Set (Int, Int, Int, Int)
step s = Set.fromList [ c
                      | w <- [wmin - 1 .. wmax + 1],
                        x <- [xmin - 1 .. xmax + 1],
                        y <- [ymin - 1 .. ymax + 1],
                        z <- [zmin - 1 .. zmax + 1],
                        let c = (w, x, y, z)
                            i = Set.fromList (neighbours c) `Set.intersection` s,
                        (((c `Set.member` s) && (Set.size i == 2)) || (Set.size i == 3)) ]
    where wmin = fromJust $ Set.lookupMin $ Set.map getW s
          wmax = fromJust $ Set.lookupMax $ Set.map getW s
          xmin = fromJust $ Set.lookupMin $ Set.map getX s
          xmax = fromJust $ Set.lookupMax $ Set.map getX s
          ymin = fromJust $ Set.lookupMin $ Set.map getY s
          ymax = fromJust $ Set.lookupMax $ Set.map getY s
          zmin = fromJust $ Set.lookupMin $ Set.map getZ s
          zmax = fromJust $ Set.lookupMax $ Set.map getZ s

getW :: (Int, Int, Int, Int) -> Int
getW (w, _, _, _) = w

getX :: (Int, Int, Int, Int) -> Int
getX (_, x, _, _) = x

getY :: (Int, Int, Int, Int) -> Int
getY (_, _, y, _) = y

getZ :: (Int, Int, Int, Int) -> Int
getZ (_, _, _, z) = z

neighbours :: (Int, Int, Int, Int) -> [(Int, Int, Int, Int)]
neighbours (w, x, y, z) = [ (w', x', y', z')
                          | w' <- [w - 1, w, w + 1],
                            x' <- [x - 1, x, x + 1],
                            y' <- [y - 1, y, y + 1],
                            z' <- [z - 1, z, z + 1],
                            w /= w' || x /= x' || y /= y' || z /= z' ]


