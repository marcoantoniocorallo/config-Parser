TARGET=src/main

default: $(TARGET).native

$TARGET: default

native: $(TARGET).native

%.native:
	ocamlbuild -use-menhir -menhir "menhir --explain --infer" -use-ocamlfind $@
	mv main.native parser

clean:
	ocamlbuild -clean

.PHONY: clean default
