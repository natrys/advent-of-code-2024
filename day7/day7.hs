import Data.Char (isDigit)

data Op = Add | Mul | Cat

eval :: Op -> Int -> Int -> Int
eval Add = (+)
eval Mul = (*)
eval Cat = \a b -> a * 10 ^ floor (logBase 10 (fromIntegral b) + 1) + b

solve :: Int -> Int -> [Int] -> [Op] -> Bool
solve target acc [] _ = target == acc
solve target acc (x : xs) ops
  | acc > target = False
  | otherwise = any (\op -> solve target (eval op acc x) xs ops) ops

getNumbers :: String -> [Int]
getNumbers line = [read (takeWhile isDigit num) :: Int | num <- words line]

main :: IO ()
main = do
  inputs <- fmap getNumbers . lines <$> getContents
  let f ops = sum [target | (target : x : xs) <- inputs, solve target x xs ops]
   in do
        putStrLn $ "Part1: " <> (show $ f [Add, Mul])
        putStrLn $ "Part2: " <> (show $ f [Add, Mul, Cat])
