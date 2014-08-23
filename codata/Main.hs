data Lit  =
  StrLit String
  | IntLit Int
  | Ident String
    deriving (Show, Eq)
data Expr
  = Index Expr Expr
  | Call Expr [Expr]
  | Unary String Expr
  | Binary Expr String Expr
  | Paren Expr
  | Literal Lit
    deriving (Show, Eq)

data Stmt
 = Break
   | Continue
   | Empty
   | IfElse Expr [Stmt] [Stmt]
   | Return (Maybe Expr)
   | While Expr [Stmt]
   | Expression Expr
     deriving (Show , Eq)


flatten :: Expr -> Expr
flatten (Literal i) = Literal i


applyExpr :: (Expr -> Expr) -> Expr -> Expr
-- base case: applyExpr is the identity function on constants
applyExpr f (Literal i) = Literal i

-- recursive cases: apply f to each subexpression
applyExpr f (Paren p) = Paren (f p)
applyExpr f (Index e i) = Index (f e) (f i)
applyExpr f (Call e args) = Call (f e) (map f args)
applyExpr f (Unary op arg) = Unary op (f arg)
applyExpr f (Binary l op r) = Binary (f l) op (f r)







main = putStrLn "hello world"
