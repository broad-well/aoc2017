import Data.Char (digitToInt)

-- (aggregate sum, previous digit)
accumul :: (Int, Char) -> Char -> (Int, Char)
accumul (aggreg, previous) current
    | previous == current = (aggreg + digitToInt previous, current)
    | otherwise = (aggreg, current)

part1 = do
    input <- getLine
    putStrLn $ show $ fst $ foldl accumul (0, 'N') $ input ++ (head input):[]

-- Input -> (Index, Element) -> Addend
calc :: String -> (Int, Char) -> Int
calc input (index, element)
    | corres == element = digitToInt element
    | otherwise = 0
    where len = length input
          corres = (drop index $ cycle input) !! (len `div` 2)
          
part2 = do
    input <- getLine
    putStrLn $ show $ sum $ map (calc input) $ zip [0..] input