type t =
  | Const of int
  | Var   of string
  | Add   of t * t
  | Sub   of t * t
  | Mul   of t * t
  | Div   of t * t
  | Let   of string * t * t
  | Seq   of t * t
  | Print of t
  | If    of t * t * t
  | While of t * t
[@@deriving show]
