{-# LANGUAGE CPP, ForeignFunctionInterface, EmptyDataDecls #-}

module Regex where

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import qualified Data.ByteString.Char8 as B
foreign import  ccall unsafe "pcre.h pcre_compile"
   c_pcre_compile  :: CString -> PCREOption -> Ptr CString -> Ptr CInt  -> Ptr Word8 -> IO (Ptr PCRE)

newtype PCREOption = PCREOption { unPCREOption :: CInt} deriving (Eq, Show)

#include <pcre.h>

data PCRE

c_pcre_compile :: CString -> PCREOption -> Ptr CString -> Ptr CInt -> Ptr Word8 -> IO (Ptr PCRE)

{-
caseless :: PCREOption
caseless = PCREOption #const PCRE_CASELESS

dollar_endonly :: PCREOption
dollar_endonly =  PCREOption #const PCRE_DOLLAR_ENDONLY

dotall :: PCREOption
dotall = PCREOption #const PCRE_DOTALL
-}

#{enum PCREOption, PCREOption,
  caseless = PCRE_CASELESS,
  dollar_endonly = PCRE_DOLLAR_ENDONLY,
  dotall = PCRE_DOTALL}

combineOptions :: [PCREOption] -> PCREOption
combineOptions = PCREOption . foldr  ((.|.) . unPCREOption) 0

data Regex = Regex !(ForeignPtr PCRE) !(B.ByteString)
             deriving (Eq, Ord, Show)
