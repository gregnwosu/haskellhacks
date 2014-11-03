{-# LANGUAGE DeriveFunctor #-}

module CoData where
import           Control.Arrow
-- import System.Environment
import           Control.DeepSeq
import           Control.Parallel.Strategies
-- import Data.Maybe


data Lit  =
  StrLit String
  | IntLit Int
  | Ident String
    deriving (Show, Eq)
data Expr a
  = Index a a
  | Call a [a]
  | Unary String a
  | Binary a String a
  | Paren a
  | Literal Lit
    deriving (Show, Eq, Functor)


data Term f = In (f (Term f))

out :: Term f -> f (Term f)
out (In t) = t



fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

topDown, bottomUp :: Functor a => (Term a -> Term a) -> Term a -> Term a
bottomUp fn =
  out                    -- 1) unpack
  >>> fmap (bottomUp fn) -- 2) recurse
  >>> In                 -- 3) repack
  >>> fn                 -- 4) apply

topDown f  =
  In                    -- 1) pack
  <<< fmap (topDown f)  -- 2) recurse
  <<< out               -- 3) unpack
  <<< f                 -- 4) apply

flattenTerm :: Term Expr -> Term Expr
flattenTerm (In (Paren e)) = e  -- remove all Parens
flattenTerm other = other       -- do nothing otherwise

flatten :: Term Expr -> Term Expr
flatten = bottomUp flattenTerm

applyExpr :: (a -> b) -> Expr a -> Expr b
-- base case: applyExpr is the identity function on constants
applyExpr f (Literal i) = Literal i

-- recursive cases: apply f to each subexpression
applyExpr f (Paren p) = Paren (f p)
applyExpr f (Index e i) = Index (f e) (f i)
applyExpr f (Call e args) = Call (f e) (map f args)
applyExpr f (Unary op arg) = Unary op (f arg)
applyExpr f (Binary l op r) = Binary (f l) op (f r)







main = putStrLn "hello world"
