{-# LANGUAGE ForeignFunctionInterface #-}

module FfiExample where
#include <pcre.h>
import Foreign
import Foreign.C.Types

foreign import ccall "math.h sin"
  c_sin::CDouble -> CDouble

fastsin :: Double -> Double
fastsin = realToFrac . c_sin . realToFrac

main :: IO ()
main = putStr ("show" ++ ( show $ fastsin 40))
