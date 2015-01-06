
import           Text.XML.HXT.Core

main = do
  html <- readFile "test.html"
  let doc = readString [withParseHTML yes, withWarnings no] html
  links <- runX $ doc //> hasName "a" >>> getAttrValue "href"
  mapM_ putStrLn links

