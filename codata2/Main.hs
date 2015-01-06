{-# LANGUAGE DeriveFunctor #-}

import           Control.Arrow

data Lit
  = StrLit String
    | IntLit Int
    | Ident String
      deriving (Show, Eq)


data Expr a =
  Index a a
  | Call a [a]
  | Unary String a
  | Binary a String a
  | Paren a
  | Literal Lit
 deriving (Show, Eq, Functor)





data Term f = In ( f (Term f))

out :: Term f -> f (Term f)
out  (In t) = t





bottomUp :: Functor a => (Term a -> Term a) -> Term a -> Term a
bottomUp fn =
  out
  >>> fmap (bottomUp fn)
  >>> In
  >>> fn


topDown :: Functor a => (Term a -> Term a ) -> Term a -> Term a
topDown fn = In <<< fmap (topDown fn) <<< out <<< fn


flattenTerm :: Term Expr -> Term Expr
flattenTerm (In (Paren e)) = e
flatternTerm other = other


flatten :: Term Expr -> Term Expr
flatten = bottomUp flattenTerm


