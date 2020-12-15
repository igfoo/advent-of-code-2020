
main :: IO ()
main = do xs <- readFile "input"
          print $ solve (lines xs !! 1)

solve :: String -> Integer
solve xs = fst $ foldl1 merge_bus $ busses xs

busses :: String -> [(Integer, Integer)]
busses xs = [ (offset, time) | (o, t) <- zip [0..] $ breaks (',' ==) xs, t /= "x", let time = read t, let offset = o `mod` time ]

breaks :: (Char -> Bool) -> String -> [String]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]

merge_bus :: (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer)
merge_bus (ox, tx) (oy, ty) = head [ (o, lcm tx ty)
                                   | i <- [ 1 .. ty ]
                                   , let o = tx * i + ox
                                   , ((o + ty - 1) `div` ty) * ty - o == oy ]



