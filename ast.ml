(* 構文木の定義
 * この言語はすべてが式であり、１つの型で表す
 * パースされた結果は木になり、それを型tで表す
*)

(* 式の定義 *)
type t =
  | Const of int                (* 定数 *)
  | Var   of string             (* 変数 *)
  | Add   of t * t              (* 四則演算 *)
  | Sub   of t * t
  | Mul   of t * t
  | Div   of t * t
  | Let   of string * t * t     (* let 変数 = 式 in 式 *)
  | Seq   of t * t              (* 式; 式 *)
  | Print of t                  (* print 式 *)
  | If    of t * t * t          (* if 式 then 式 else 式 *)
  | While of t * t              (* while 式 do 式 done *)
[@@deriving show]
