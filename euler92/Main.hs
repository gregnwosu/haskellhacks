
import           Control.Monad.State
import           Data.Char
import           Data.Function
import qualified Data.IntMap         as M
import           Data.List
import           Data.Ma

digits :: Int -> [Int]
digits =  map (digitToInt) . show

step :: Int -> Int
step = sum . map (^2) . digits


terminate' :: Int -> Int
terminate' 89 = 89
terminate' 1  = 1
terminate' x  =  terminate' (step x)

terminate :: Int -> State (M.IntMap Int) Int
terminate 89 = return 89
terminate 1  = return 1
terminate n =
  do
    m <- get
    if M.member n m
    then
      return (m M.! n)
    else
      do
        t <- terminate (step n)
        modify (M.insert n t)
        return t


-- haskells fixed point combinator


howmany :: Int
howmany =  length $ filter (==89) $ evalState (mapM (terminate) [1..10000000]) M.empty


sierpinsky :: Integral a => a -> String
sierpinsky 0 = "L"
sierpinsky n =  concat $ intercalate ["\n"] ([next] : (transpose [ss,spc,ss]))
                where next = sierpinsky (n-1)
                      ss = lines next
                      spc = f ss
                      f  = fmap ((`replicate` ' ')  . ((2^n) -) . length)
main :: IO ()
main = putStrLn $ sierpinsky 4
  --main = putStrLn $ show (Data.Function.fix terminate')
