{-# LANGUAGE ForeignFunctionInterface #-}

module FfiExample where
import Regex
#include <pcre.h>
import Foreign
import Foreign.C.Types
import Foreign.C.String
import System.IO.Unsafe
import qualified Data.ByteString.Char8 as B

foreign import ccall "math.h sin"
  c_sin::CDouble -> CDouble

compile :: B.ByteString -> [PCREOption] -> Either String Regex
compile str flags = unsafePerformIO $
                    B.useAsCString str $ \pattern -> do
                      alloca $ \errptr -> do
                        alloca $ \erroroffset -> do
                          pcre_ptr <- c_pcre_compile pattern (combineOptions flags) errptr erroroffset nullPtr
                          if pcre_ptr == nullPtr
                             then do
                               err <- peekCString =<< peek errptr
                               return (Left err)
                             else do
                               reg <- newForeignPtr finalizerFree pcre_ptr
                               return (Right (Regex reg str))

fastsin :: Double -> Double
fastsin = realToFrac . c_sin . realToFrac





main :: IO ()
main = putStr ("show" ++ ( show $ fastsin 40))
