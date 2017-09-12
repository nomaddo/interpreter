open Ast

module Env = Map.Make (struct type t = string let compare = compare end)

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

let show_ast = ref false

let spec = [("--show-ast", Arg.Unit (fun () -> show_ast := true), "show ast")]

let usage = ""

let main anonymous =
  let inc = open_in anonymous in
  let lexbuf = Lexing.from_channel inc in
  let ast = Parser.main Lexer.token lexbuf in
  begin if !show_ast then Printf.printf "%s\n" (Ast.show ast) end;
  Format.printf "%d\n" @@ run Env.empty ast

let _ =
  Arg.parse spec main usage
