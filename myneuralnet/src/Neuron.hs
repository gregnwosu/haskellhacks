module Neuron where


type ColumnVector a = Matrix a

data ActivationSpec = ActivationSpec{
 asF :: Double -> Double,
 asF' :: Double -> Double,
 desc :: String
}

idendtityAs = Ac
