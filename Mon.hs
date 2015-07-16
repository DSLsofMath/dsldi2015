data MonSyn var  =  Z | V var | Plus (MonSyn var) (MonSyn var)

type MonAlg a    =  (a, a -> a -> a)

type Dict var a  =  var -> a -- partial!

eval :: MonSyn var -> MonAlg a -> Dict var a -> a
eval e (z, plus) dict  = eval' e
  where
    eval' Z             =  z
    eval' (Plus x1 x2)  =  (eval' x1) `plus` (eval' x2)
    eval' (V x)         =  dict x
