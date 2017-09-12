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
