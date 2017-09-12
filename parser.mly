/* パーサーの定義
 * lexerが文字列をトークンの列に区切ってくれるので
 * 木構造を作りなおすルールを定義する
 *
 * 詳細はマニュアルを読む
 * http://ocaml.jp/archive/ocaml-manual-3.06-ja/manual026.html
 */

%{
  open Ast
%}

%token LET IN WHILE DO DONE IF THEN ELSE

%token <string> IDENT
%token <string> CONST

%token SEMI
%token PLUS MINUS MUL DIV

%token EQ
%token EOF

%token LPAREN RPAREN

%left SEMI
%left PLUS MINUS /* 結合の強さは個々に並んでいる順番に依存 */
%left MUL DIV

%type  <Ast.t> main
%start main

%%

main:
| expr EOF { $1 }

expr:
| IF expr THEN expr ELSE expr { If ($2, $4, $6) }
| LET ident EQ expr IN expr   { Let ($2, $4, $6) }
| expr SEMI expr              { Seq ($1, $3) }
| WHILE expr DO expr DONE     { While ($2, $4)}
| expr PLUS  expr             { Add ($1, $3) }
| expr MINUS expr             { Sub ($1, $3) }
| expr MUL   expr             { Mul ($1, $3) }
| expr DIV   expr             { Div ($1, $3) }
| const                       { Const $1 }
| IDENT                       { Var $1 }

| LPAREN expr RPAREN { $2 }

const:
| CONST           { int_of_string $1 }

ident:
| IDENT           { $1 }
