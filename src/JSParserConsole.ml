let file    = ref ""


(* Load file from string *)
let load_file f : string =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  Bytes.to_string s

let arguments () =
  let usage_msg="Usage: -file <path>" in
  Arg.parse
    [
  	  (* file containing the program to parse *)
  	  "-file", Arg.String(fun f -> file := f), "file to run"
  	]
    (fun s -> Format.eprintf "WARNING: Ignored argument %s.@." s)
    usage_msg


(*let count_functions (e : JSParserSyntax.exp) : int = 
  let f_state (expr : JSParserSyntax.exp) (count : int) : int = 
    match expr.exp_stx with 
      | Function _
      | FunctionExp _ -> 
          Printf.printf "cur fun exp state %d:\n%s\n" count (JSPrettyPrint.string_of_exp true expr);  
          count + 1 
      | _ -> count in 
  let f_ac (e : JSParserSyntax.exp) (new_count : int) (count : int) (sub_counts : int list) : int = 
    List.fold_left (+) new_count sub_counts in 
    JSParserSyntax.js_fold f_ac f_state 0 e 
             
let add_bananas (e : JSParserSyntax.exp) : JSParserSyntax.exp = 
  let f_m (e : JSParserSyntax.exp) : JSParserSyntax.exp = 
     match e.exp_stx with 
      | Function (str, name, args, fb, async) -> 
          let banana_exp = JSParserSyntax.mk_exp (JSParserSyntax.String "banana") 0 [] in 
          let block = JSParserSyntax.mk_exp (JSParserSyntax.Block [banana_exp; fb]) 0 [] in 
          { e with exp_stx = Function (str, name, args, block, async)} 

      | FunctionExp (str, name, args, fb, async) ->
          let banana_exp = JSParserSyntax.mk_exp (JSParserSyntax.String "banana") 0 [] in 
          let block = JSParserSyntax.mk_exp (JSParserSyntax.Block [banana_exp; fb]) 0 [] in 
          { e with exp_stx = FunctionExp (str, name, args, block, async)} 

      | _ -> e in 
  JSParserSyntax.js_map f_m e *)

let main () : unit = 
  arguments ();
  JSParserMain.init (); (*~path:"./lib"; *)
  let e_str = load_file !file in 
  (*Printf.printf "The input JS prog is the following:\n%s" e_str; *)
  let e_js =  JSParserMain.exp_from_string e_str in
  Printf.printf "The PARSED JS prog is the following:\n%s\n" (JSPrettyPrint.string_of_exp true e_js)

let _ = main () 

