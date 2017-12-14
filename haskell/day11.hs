import Data.Maybe (isJust, fromJust)
import qualified Data.Map as Map
import qualified Data.Text as Text

-- Hex grid support
type Coordinate = (Int, Int)

directions = ["n", "nw", "sw", "s", "se", "ne"]

go :: Coordinate -> String -> Coordinate
go (x, y) direction = case direction of
    "n" -> (x, y - 1)
    "nw" -> (x - 1, y)
    "sw" -> (x - 1, y + 1)
    "s" -> (x, y + 1)
    "se" -> (x + 1, y)
    "ne" -> (x + 1, y - 1)
    where xIsEven = x `mod` 2 == 0

move :: Coordinate -> [String] -> Coordinate
move origin steps = foldl go origin steps

nextPositions :: Coordinate -> [Coordinate]
nextPositions origin = map (go origin) directions

-- I implemented BFS in functional all for nothing!
bfs :: ([Coordinate], Map.Map Coordinate Coordinate) -> ([Coordinate], Map.Map Coordinate Coordinate)
bfs ([], xs) = ([], xs)
bfs (current:rest, visited) = (rest ++ nexts, Map.union visited newVisitedPairs)
    where nexts = filter ((flip Map.notMember) visited) $ nextPositions current
          newVisitedPairs = Map.fromList $ map (\x -> (x, current)) nexts

traceback :: Coordinate -> Map.Map Coordinate Coordinate -> [Coordinate]
traceback (0, 0) _ = []
traceback coord visited = coord:traceback (fromJust $ Map.lookup coord visited) visited

distance :: Coordinate -> Coordinate -> Int
distance (ax, ay) (bx, by) = (abs(ax - bx) + abs(ax + ay - bx - by) + abs(ay - by)) `div` 2

main = do
    inputRaw <- readFile "data-day11.txt"
    let input = map Text.unpack $ Text.split (==',') (Text.pack inputRaw)
    let pos = move (0, 0) input
    putStrLn ("Going to " ++ (show pos))
    putStrLn ("Part 1: " ++ (show $ distance (0, 0) pos))
    putStrLn (show $ maximum $ map ((distance (0, 0)) . (move (0, 0)) . ((flip take) input)) [1..(length input - 1)])