module CountEntriesT (listDirectory, countEntries) where



import System.FilePath ((</>))
import Control.Monad (forM_, when, liftM)
import Control.Monad.Trans (liftIO)
import Control.Monad.Writer (WriterT, tell)
import Control.Applicative
import System.Directory (doesDirectoryExist, getDirectoryContents)


notDots :: String -> Bool
notDots = (&&) <$> (/=".") <*> (/="..")

listDirectory :: FilePath -> IO[String]
listDirectory = liftM (filter notDots) . getDirectoryContents


withContents :: String -> String -> WriterT [(FilePath, Int)] IO ()
withContents path name = do
  let newName = path </> name
  isDir <- liftIO . doesDirectoryExist $ newName
  when isDir $ countEntries newName

countEntries :: FilePath -> WriterT [(FilePath, Int)] IO ()
countEntries path = do
  contents <- liftIO . listDirectory $ path
  tell [(path, length contents)]
  forM_ contents (withContents path)
