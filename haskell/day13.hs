import qualified Data.Map as Map
import Data.Text (pack, split, unpack)

result :: [[Int]] -> Int
result inputPairs = sum $ map product $ filter (\[a, b] -> a `mod` (b * 2 - 2) == 0) inputPairs

main = do
    inputRaw <- readFile "data-day13.txt"
    let inputPairs = map (\[a, b] -> [read a::Int, read b::Int]) $ map (\row -> map unpack $ split (==':') (pack row)) $ lines inputRaw
    print(result inputPairs)
    let minWait = (head $ head $ head $ dropWhile (\x -> result x > 0) $ iterate (map (\[a, b] -> [a + 1, b])) inputPairs) - (head $ head inputPairs)
    print minWait