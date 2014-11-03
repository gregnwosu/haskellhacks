
import           Control.Concurrent.ParallelIO
import           Control.Monad
import           Control.Monad.Maybe
import           Control.Monad.Trans
import qualified Data.ByteString.Char8         as B
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           Network.HTTP
import           Network.URI
import           System.Environment
import           Text.XML.HXT.Core


openUrl :: String -> MaybeT IO String
openUrl url = case parseURI url of
  Nothing -> fail ""
  Just u -> liftIO (getResponseBody =<< simpleHTTP (mkRequest GET u))


css :: ArrowXml a => String -> a XmlTree XmlTree
css tag  = multi (hasName tag)

get :: String -> IO (IOSArrow XmlTree (NTree XNode))
get url = do
  content <- runMaybeT $ openUrl url
  return $ readString [withParseHTML yes, withWarnings no] (fromMaybe "" content)
