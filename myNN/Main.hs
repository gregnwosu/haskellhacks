import           Numeric.LinearAlgebra

-- same as matrix, all inputs and outputs are column vectors
type ColumnVector a = Matrix a



-- the first field asF is the activatikon founction whnich takes a Double (double precision, real floating point value) as input and returns a Double. The second field asF', is the first derivative. It also takes a Double and returns a Double.
-- Accessing the field, desc, is a String value containing a description of the function. Accessing the fields of a value of type ActivationSpec , if the name of the record is s then its activation Function is asF s , and its first derivative is asF' s




-- hyperbolic tangent activation spec
tanhAS = ActivationSpec {
 asF = tanh,
 asF' = tanh',
 desc = "tanh"
  }

data ActivationSpec = ActivationSpec {
  asF  :: Double -> Double,
  asF' :: Double -> Double,
  desc :: String
}


tanh' x = 1 - (tanh x) ^2

identityAS = ActivationSpec {
asF = id,
asF' = const 1,
desc = "identity" }

-- To define a layer in the neural network we use a record structure
-- containing the weights and the activation specification, The weights are store in a nxm matrix where  nn is the number of inputs and m is the number of neurons. The number of outputs from the layer is equal equal to the number of neurons

-- so this layer contains m neurons
-- each neuron has m inputs , hence a nxm matrix
data Layer = Layer {
  lW  :: Matrix Double,
  lAS :: ActivationSpec
}

-- the matrix lW has type Matrix Double . This is a matrix whose element values are double precision floats. This type and the associated operations are provided by the hmatrix  package . The activation specification lAS uses the type ActivationSpec definied earlier. Again we use the support for first-class functions to crate a value of type Layer we parss a record containing function values into the layer constructor.

-- making the network
-- the network consists of layers and a learning rate

data BackpropNet = BackpropNet{
  layers       :: [Layer],
  learningRate :: Double
}

-- tthe number of outputs from one layer must matcht the number of inputs to the next layer.
-- We ensure this by requiring the user to call a special function to constuct the network

--First we address the problem of how to verify that the dimensions of a consecutive pair of network layers is compatible. The following function will report if an error from a mismatch is detected.

checkDimensions:: Matrix Double -> Matrix Double -> Matrix Double
checkDimensions w1 w2 =
  if rows w1 == cols w2
     then w2
  else error "Inconsistent dimensions in weight matrix"


-- applying scan1 checkDimensions to a list of weight matrices gives the list of matrices if the weight matrices are consistent.

-- the expression
-- map buildLayer checkedWeights will return a new list , where
-- each element is the result of applying the function buildLayer to the correspongind element in the weight matrix. The definition of buildLayer is simple, it merely invokes the constructor for the type Layer, defined earlier



-- we can no define the net constructor


buildBackpropNet ::
  Double -> [Matrix Double] -> ActivationSpec -> BackpropNet
buildBackpropNet lr ws s = BackpropNet { layers=ls, learningRate=lr}
  where
    checkedWeights = scanl1 checkDimensions ws
    ls = map buildLayer checkedWeights
    buildLayer w = Layer {lW=w, lAS=s}
-- [[./images/image16725rc0.jpg]]
-- M-x set-input-method tex
-- xᵢ is the ith component of the input pattern
-- zₗᵢ is thout output of the ith neuron in layer l
-- yᵢ is the ith component of the output pattern

-- The activation function for neuron k in layer l is
-- a₀ₖ = xₖ
-- aₗₖ = Σᴺᵗ⁼¹ⱼ₌₁ wₗₖzₗ₋₁ⱼ for: l > 0
-- where
-- Nₜ₋₁ is the number of neurons in layer l-1
-- wₗₖⱼ is the weight applied to neuron k in layer l to the input recieved from neuron j in layer l -1 (Recall theat the sensor layer, layer 0, simply passes along it inputs withouts change)
-- nj[l-1] -> nk(w)[l]
-- we can express the activation for layer l using a matrix equation
-- aₗ = x for l = 0
-- aₗ =Wₗx for l > 0
-- The output from the neuron is
-- zₗₖ = f (aₗₖ)
-- where f(a) is the activation function. For convenience, we define the function mapMatrix which applies a function to each element of a matrix or column vector, this is like haskells map function. we can calculate the layers output using the haskell expression mapmatrix.

-- we keep intermediate calculations because they will be required during the back-propagation pass. We will keep all of the neccesary information in the following record. Note that anything between the symbol -- and then end of a line is a comment and is ignored by the compiler.

data PropagatedLayer = PropagatedLayer {
  -- The input to this layer
  pIn :: ColumnVector Double,
  -- The output from this layer
  pOut :: ColumnVector Double,
  -- The value of the first derivative of the activation function for this layer
  pF'a :: ColumnVector Double,
  -- The weights for this layer
  pW :: Matrix Double
  -- The activation specification for this layer
  pAS :: ActivationSpec
} | PropagatedSensorLayer { 
  -- The output from this layer
  pOut :: ColumnVector Double
}

-- this structure has two variants . For  the sensor layer (PropagatedSensorLayer), the only information we need is the output, which is identical to the input. For all other layers (PropagatedLayer), we need the full set of values . we can now define a function to propgate through a layer

propagate :: PropagatedLayer => Layer -> PropagatedLayer
propagate layerJ layerK = PropagatedLayer{
   pIn = x,
   pOut = y,
   pF'a = f'a,
   pW = w,
   pAS = lAS layerK
  }
where x = pOut layerJ
      w = lW layerK
      a = w <> x
      f = asF (lAS layerK)
      y = P.mapMatrix f a
      f' = asF' (lAS layerK)
      f'a = P.mapMatrix f' a

-- The operator <> performs matrix multiplication; it is defined in the hmatrix package



main:: IO ()
main = putStrLn "haskell placeholder"



