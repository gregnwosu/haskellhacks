import           Data.Char

import           Control.Applicative
import           System.IO
import           Test.QuickCheck



instance Arbitrary Char where
  arbitrary = choose ('\32','\128')


-- coarbitrary c = variant (ord c `rem` 4)


main :: IO ()
main = putStrLn "Hi this will become my quick check project"





average :: [Double] -> Double
average = (/) <$> (sum. (map abs)) <*> (fromIntegral.length)


quickCheck1 :: IO ()
quickCheck1 = quickCheck $ \x -> average x >= 0


quickCheck2 :: IO ()
quickCheck2 = quickCheck $ \x -> length x > 1 ==> average x >= 0

getList :: IO (String)
getList = find 5 where
  find 0 = return []
  find n = do
    hSetBuffering stdin NoBuffering
    ch <- getChar
    if ch `elem` ['a'..'e'] then do
      t1 <- find (n-1)
      return (ch: t1)
    else
      find n
-- getList = fmap take5 getContents

-- take5 :: [Char] -> [Char]
-- take5 = take 5. filter (`elem` ['a'..'e'])




onKeyPress :: Handle -> IO a -> IO a
onKeyPress hnd x = hReady hnd >>= f
                   where f True = x >>= return
                         f _ = onKeyPress hnd x



