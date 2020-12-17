
import Data.Char
import Data.List
import Data.Maybe

main :: IO ()
main = do xs <- readFile "input"
          let [descrs, ["your ticket:", mine], "nearby tickets:" : nearby] = breaks null $ lines xs
              myVals = map read $ breaks (',' == ) mine
              checks = map mk_check descrs
              checkAll v = or $ map ($ v) checks
              tickets = map (map read . breaks (',' == )) nearby
              validTickets = filter (all checkAll) tickets
              validFields = transpose validTickets
              candidates = zip [0..] $ map (findCandidates validFields) checks
              solution = solve candidates
          print $ product [ myVals !! column
                          | (fieldId, fieldName) <- zip [0..] descrs
                          , "departure " `isPrefixOf` fieldName
                          , let column = fromJust $ lookup fieldId solution ]

findCandidates :: [[Int]] -> (Int -> Bool) -> [Int]
findCandidates validFields check
    = [ i
      | (i, vals) <- zip [0..] validFields,
        all (check $) vals ]

solve :: [(Int, [Int])] -> [(Int, Int)]
solve [] = []
solve xs = case break ((1 ==) . length . snd) xs of
           (ys, (i, [c]) : zs) ->
               let xs' = [ (a, filter (c /=) bs)
                         | (a, bs) <- ys ++ zs ]
               in (i, c) : solve xs'

mk_check :: String -> Int -> Bool
mk_check xs i = case break (':' ==) xs of
                (_, ':':' ':ys) ->
                    case breaks (not . isDigit) ys of
                    [from1,to1,"","","",from2,to2] ->
                        (read from1 <= i && read to1 >= i) ||
                        (read from2 <= i && read to2 >= i)

breaks :: (a -> Bool) -> [a] -> [[a]]
breaks f xs = case break f xs of
              (ys, _ : zs) -> ys : breaks f zs
              _ -> [xs]

