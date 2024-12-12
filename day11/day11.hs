import Control.Monad.State
import Data.Map qualified as Map

numOfDigits :: Int -> Int
numOfDigits val = floor $ logBase 10 (fromIntegral val) + 1

splitNum :: Int -> Int -> (Int, Int)
splitNum val at = (val `div` (10 ^ at), val `mod` (10 ^ at))

type Memo = Map.Map (Int, Int) Int

solve :: Int -> Int -> State Memo Int
solve 0 _ = return 1
solve gen 0 = solve (pred gen) 1
solve gen val = do
  memo <- get
  case Map.lookup (gen, val) memo of
    Just result -> return result
    Nothing -> do
      result <-
        if (numOfDigits val) `mod` 2 == 0
          then do
            let at = (numOfDigits val) `div` 2
                (a, b) = splitNum val at
            ra <- solve (pred gen) a
            rb <- solve (pred gen) b
            return (ra + rb)
          else do
            solve (pred gen) (val * 2024)
      modify (Map.insert (gen, val) result)
      return result

main :: IO ()
main = do
  input <- fmap (fmap read . words) getLine
  let (part1, part2) =
        evalState
          ( do
              p1 <- mapM (solve 25) input
              p2 <- mapM (solve 75) input
              return (sum p1, sum p2)
          )
          Map.empty
    in do
      putStrLn $ "Part1: " <> (show part1)
      putStrLn $ "Part2: " <> (show part2)
