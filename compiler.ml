open Ast

module NameMap = Map.Make(struct
  type t = string
  let compare x y = Pervasives.compare x y
end)


let run funcs = 
let vars = [""] in
	let func_decls = List.fold_left
		(fun funcs fdecl -> print_endline(fdecl.fname); NameMap.add fdecl.fname fdecl funcs)
		NameMap.empty funcs
	in

(* Invoke a function and return an updated global symbol table *)
  	let rec call fdecl actuals globals =

		let rec eval = function
			Int(x) -> Int(x)
			| Call("print", [e]) ->
			let v = eval e in 
				let rec print = function
					Int(x) -> string_of_int x
				in 
					print_endline( print v ); Int(0)
		in

		let rec exec = function
      		Expr(e) -> eval e
		in

	let locals =
      try List.fold_left2
	  (fun locals formal actual -> NameMap.add formal actual locals)
	  NameMap.empty fdecl.formals actuals
      with Invalid_argument(_) ->
	raise (Failure ("wrong number of arguments passed to " ^ fdecl.fname))
    in

	let locals = List.fold_left
	(fun locals local -> NameMap.add local 0 locals) locals fdecl.locals
    in
    snd (List.fold_left exec (locals, globals) fdecl.body);
    (* Execute each statement in sequence, return updated global symbol table *)
in let globals = List.fold_left
	(fun globals vdecl -> NameMap.add vdecl 0 globals) NameMap.empty vars
in
call (NameMap.find "brain" func_decls) [] globals
		(* let lexbuf = Lexing.from_channel stdin in  *)
		(* let program = Parser.program Scanner.token lexbuf in *)
		(* let result = run program 7 in  *)
		(* result *)