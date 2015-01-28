module CountEntries (listDirectory, countEntriesTrad) where

import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import Control.Monad (forM, liftM)
import Control.Applicative

notDots :: String -> Bool
notDots = (&&) <$> (/=".") <*> (/="..")

listDirectory :: FilePath -> IO[String]
listDirectory = liftM (filter notDots) . getDirectoryContents


withContents :: String -> String -> IO [(FilePath, Int)]
withContents path name =
  do
    let newName = path </> name
    isDir <- doesDirectoryExist newName
    if isDir
      then countEntriesTrad newName
      else return []

countEntriesTrad :: FilePath -> IO [(FilePath, Int)]
countEntriesTrad path = do
  contents <- listDirectory path
  rest <- forM contents (withContents path)
  return $ (path, length contents) : concat rest
