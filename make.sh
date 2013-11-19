#!/bin/bash
ocamllex scanner.mll
ocamlyacc parser.mly
ocamlc -c parser.mli
ocamlc -c scanner.ml
ocamlc -c parser.ml
#ocamlc -c compiler.ml
#ocamlc -c helloWorld.ml
#ocamlc -o llbc parser.cmo scanner.cmo compiler.cmo helloWorld.cmo