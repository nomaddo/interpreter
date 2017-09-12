(* トークンの定義
 * 構文木を作るために、文字列を入力として受け取り、
 * それをトークンに区切っていく
 * parserがトークンの列から木構造を再構築する
 *
 * このファイルではどうやって文字列からトークンを切り出すのか定義している
 * 詳細はマニュアルを読む
 * http://ocaml.jp/archive/ocaml-manual-3.06-ja/manual026.html
*)

{
open Parser

let mkhash l =
  let h = Hashtbl.create (List.length l) in
  List.iter (fun (s, k) -> Hashtbl.add h s k) l; h

let keyword_table =
  mkhash [
    "if",     IF;
    "then",   THEN;
    "else",   ELSE;
    "while",  WHILE;
    "do",     DO;
    "done",   DONE;
    "let",    LET;
    "in",     IN;
  ]
}

let num = ['0' - '9']
let num_head = ['1' '2' '3' '4' '5' '6' '7' '8' '9']

let char = ['A'-'Z' 'a'-'z']

rule token = parse
| [' ' '\t' '\n']             { token lexbuf }
| '('                         { LPAREN       }
| ')'                         { RPAREN       }
| '+'                         { PLUS         }
| '-'                         { MINUS        }
| '*'                         { MUL          }
| '/'                         { DIV          }
| '='                         { EQ           }
| ';'                         { SEMI         }
| num_head num *  as str      { CONST str    }
| char + as str {
  try
    Hashtbl.find keyword_table str
  with Not_found -> IDENT str }
| eof                         { EOF }
