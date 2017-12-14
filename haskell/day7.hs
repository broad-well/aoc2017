import Data.Text (splitOn, pack, unpack)
import Data.List
import Data.Maybe (listToMaybe)

type InputRow = (String, Int, [String])

split :: String -> String -> [String]
split a b = map unpack $ splitOn (pack a) (pack b)

parseInputLine :: String -> InputRow
parseInputLine line = (name, (read envNum::Int), children)
    where toks
              | isSubsequenceOf " -> " line = split " -> " line
              | otherwise = [line]
          name:envNum:_ = split " " (toks !! 0)
          children
              | length toks == 1 = []
              | otherwise = split ", " (toks !! 1)

rowWithName :: String -> [InputRow] -> Maybe String
rowWithName xs inputs = case (find (\(x, _, _) x == xs) inputs) of
    Just n -> Just (fst' n)
    Nothing -> Nothing

weightAtop :: String -> [InputRow] -> Maybe Int
weightAtop xs inputs
    | row == Nothing = Nothing
    | thd row == [] = Just snd' row
    | otherwise = Just ((sum $ map (flip weightAtop $ inputs) $ thd row) + snd' row)
    where row = rowWithName xs

allSame :: Eq a => [a] -> Bool
allSame xs = all (== head xs) tail xs

isBalanced :: String -> [InputRow] -> Bool
isBalanced xs inputs
    | row == Nothing = True
    | otherwise = allSame $ map (flip weightAtop $ inputs) $ thd row
    where row = rowWithName xs

--                  all inputs  name of start input - unbalanced if available
findUnbalanced :: [InputRow] -> String -> Maybe InputRow
findUnbalanced inputs start = case rowWithName start inputs of
    Nothing -> Nothing
    Just (name, weight, children) -> listToMaybe $ filter (/= Nothing) map $ findUnbalanced inputs $ children

fst' (x, _, _) = x
snd' (_, x, _) = x
thd (_, _, x) = x

main = do
    inputLines <- readFile "data-day7.txt"
    let rows = map parseInputLine $ lines inputLines
    let children = concat $ map thd rows
    -- Part 1
    putStrLn $ show $ ((map (\(x,_,_) -> x) rows) \\ children) !! 0
