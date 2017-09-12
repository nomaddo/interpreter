open Ast

(* 環境の定義
 * 変数を定義した時に、どの変数がどの値だったのか覚えておく
 * immutableなデータ構造にする
*)
module Env = Map.Make (struct type t = string let compare = compare end)

(* インタプリタの本体
 * この関数自体が評価結果のintを返し、再帰的に計算する
*)
let rec run env = function
  | Const i -> i
  | Var   s ->
    begin try Env.find s env with
      Not_found ->
        Printf.printf "変数 %s が未定義です\n" s;
        exit 1
    end
  | Add (x, y) -> run env x + run env y
  | Sub (x, y) -> run env x - run env y
  | Mul (x, y) -> run env x * run env y
  | Div (x, y) -> run env x / run env y
  | Let (s, x, y) ->
    let i = run env x in
    let new_env = Env.add s i env in
    run new_env y
  | Seq (x, y) -> ignore (run env x); run env y
  | Print x ->
    let i = run env x in
    Format.printf "%d\n" i; 0
  | If (cond, x, y) ->
    if run env cond > 0 then run env x else run env y
  | While _ -> failwith "while"

(* オプションの定義 *)
let show_ast = ref false
let spec = [("--show-ast", Arg.Unit (fun () -> show_ast := true), "show ast")]

let usage = "./ml [--show-ast] file"

let main anonymous =
  let inc = open_in anonymous in
  let lexbuf = Lexing.from_channel inc in
  let ast = Parser.main Lexer.token lexbuf in
  begin if !show_ast then Printf.printf "%s\n" (Ast.show ast) end;
  ignore (run Env.empty ast)

let _ =
  Arg.parse spec main usage
