{-# LANGUAGE RankNTypes #-}

-- from http://unbui.lt/#!/post/haskell-another-lens-tutorial

import Control.Applicative
import Control.Monad.Identity

data Person = Person {
  name    :: String,
  age     :: Int,
  address :: Address
} deriving Show


data Address = Address {
  house  :: String,
  street :: String,
  city   :: String
} deriving Show

type Lens thing prop = Functor f => (prop -> f prop) -> thing -> f thing

betterAddressLens :: Lens Person Address
betterAddressLens fn person = fmap (\newAddy -> person {address = newAddy}) $ fn (address person)

betterCityLens :: Lens Address String
betterCityLens fn addr = fmap (\newCity -> addr {city = newCity}) $ fn (city person)

betterNameLens :: Lens Person String
betterNameLens fn person = fmap (\newName -> person {name = newName}) $ fn (name person)

view :: Lens thing prop -> thing -> prop
view ln thing = getConst $ ln (\p -> Const p) thing

-- a lens takes a function and a thing to return a updated thing
update :: Lens thing prop -> (prop -> prop) -> thing -> thing
update ln fn thing = runIdentity $ ln (\p -> Identity (fn p)) thing

set :: Lens thing prop -> prop -> thing -> thing
set ln newValue thing = update ln (\_ -> newValue) thing

data Lens' thing prop = Lens'{
view'::thing -> prop,
update' :: (prop -> prop) -> thing -> thing
}


addressLens:: Lens' Person Address
addressLens= Lens' address (\fn thing -> thing {address = fn (address thing)} )
cityLens:: Lens' Address String
cityLens= Lens' city (\fn thing -> thing {city = fn (city thing)} )

personToCityLens :: Lens' Person String
personToCityLens = Lens' ((view' cityLens).(view' addressLens)) ((update' addressLens). (update' cityLens))

viewCity :: Person -> String
viewCity = (view' cityLens) . (view' addressLens)

updateCity :: (String -> String) ->  Person -> Person
updateCity = (update' addressLens) . (update' cityLens)


greg = Person { name= "greg", age=38, address = Address {house= "3a", street= "Milo Road", city= "London"}}




main::IO ()
main = putStrLn (show (greg {address = (address greg) {house= "4a"}}))
