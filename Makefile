LIB= -package ppx_deriving.show

OCAMLC=ocamlfind ocamlc ${LIB}
OCAMLDEP=ocamlfind ocamldep
OCAMLYACC=menhir
OCAMLLEX=ocamllex

FILES=ast.cmo parser.cmi parser.cmo lexer.cmo main.cmo
OBJS=$(filter %.cmo, ${FILES})

OPT=-g -bin-annot

ml: $(OBJS)
	$(OCAMLC) ${OPT} ${LIB} -linkpkg -o $@ ${OBJS}

parser.ml: parser.mly
	$(OCAMLYACC) $<

lexer.ml: lexer.mll
	$(OCAMLLEX) $<

%.cmi: %.mli
	$(OCAMLC) ${OPT} $< -c -o $@
%.cmo: %.ml
	$(OCAMLC) ${OPT} $< -c -o $@

depend:
	$(OCAMLDEP) `find -name "*.ml" -or -name "*.mli"` > .depend

clean:
	rm -rf `find -name "*.cm??"` ml parser.ml parser.mli lexer.ml lexer.mli parser.automaton parser.conflicts

include .depend
