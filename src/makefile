# Compilateurs
OCC = ocamlc
OCL = ocamllex
OCY = ocamlyacc

all: ocamlatex

lexer.ml: lexer.mll
	$(OCL) lexer.mll

parser.ml: parser.mly
	$(OCY) parser.mly

parser.mli: parser.ml

parser.cmi: parser.mli
	$(OCC) -c parser.mli

parser.cmo: parser.cmi

lexer.cmi: lexer.ml parser.cmo
	$(OCC) -c lexer.ml

lexer.cmo: lexer.cmi

parser.cmo: parser.ml
	$(OCC) -c parser.ml

ocamlatex.cmi: ocamlatex.ml
	$(OCC) -c ocamlatex.ml

ocamlatex.cmo: ocamlatex.cmi

ocamlatex: lexer.cmo parser.cmo ocamlatex.cmo
	$(OCC) -o ocamlatex lexer.cmo parser.cmo ocamlatex.cmo

clean:
	rm -f lexer.ml lexer.cmi lexer.cmo lexer.cmi ocamlatex ocamlatex.cmi ocamlatex.cmo parser.cmi parser.cmo parser.ml parser.mli