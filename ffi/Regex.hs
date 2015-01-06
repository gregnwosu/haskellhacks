{-# LINE 1 "Regex.hsc" #-}
{-# LANGUAGE CPP, ForeignFunctionInterface, EmptyDataDecls #-}
{-# LINE 2 "Regex.hsc" #-}
module Regex where

import Foreign
import Foreign.C.Types


{-# LINE 8 "Regex.hsc" #-}
data PCRE
newtype PCREOption = PCREOption {unPCREOption:: CInt}
                     deriving (Eq, Show)

foreign import  ccall unsafe "pcre.h pcre_compile"
  c_pcre_compile :: CString -> PCREOption -> Ptr CString -> Ptr CInt -> Ptr Word8 -> IO (Ptr PCRE)

{-
caseless :: PCREOption
caseless = PCREOption #const PCRE_CASELESS

dollar_endonly :: PCREOption
dollar_endonly =  PCREOption #const PCRE_DOLLAR_ENDONLY

dotall :: PCREOption
dotall = PCREOption #const PCRE_DOTALL
-}

caseless  :: PCREOption
caseless  = PCREOption 1
dollar_endonly  :: PCREOption
dollar_endonly  = PCREOption 32
dotall  :: PCREOption
dotall  = PCREOption 4

{-# LINE 30 "Regex.hsc" #-}

combineOptions :: [PCREOption] -> PCREOption
combineOptions = PCREOption . foldr . ((.|.) . unPCREOption) 0

data Regex = Regex !(ForeignPtr PCRE) !(ByteString)
             deriving (Eq, Ord, Show)
