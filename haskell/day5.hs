-- input too many lines, in file data-day5.txt --
isPart2 = True

increment :: [Int] -> Int -> [Int]
increment xs x = bef ++ [update curr] ++ aft
    where (bef, curr:aft) = splitAt x xs
          update n
            | n >= 3 && isPart2 = n - 1
            | otherwise = n + 1

--         input    index  new input, new index
jmpFrom :: ([Int], Int) -> ([Int],    Int)
jmpFrom (xs, x) = (increment xs x, x + (xs !! x))

main = do
    rawInput <- readFile "data-day5.txt"
    let input = map read $ lines rawInput
    putStrLn $ show $ length $ takeWhile (\(_, y) -> y >= 0 && y < length input) $ iterate jmpFrom (input, 0)