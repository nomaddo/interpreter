ML-like Interpreter Example
---------------------------

## requirement

- opam
- ocamlfind
- deriving.show
- menhir

## compile

- Install opam (see [installation document](https://opam.ocaml.org/doc/Install.html))
- Install dependencies (if neccesary)
  - `opam install ppx_deriving menhir`
- make ml

## run

This program prints the result of input expressions.

``` shell
$ ./ml --show-ast ./example/let
(Ast.Let ("x", (Ast.Add ((Ast.Const 1), (Ast.Const 2))),
   (Ast.Add ((Ast.Var "x"), (Ast.Var "x")))))
6
```

