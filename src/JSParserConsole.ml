let file    = ref ""
let output_file = ref ""


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
      "-file", Arg.String(fun f -> file := f), "file to run";
      "-output", Arg.String(fun f -> output_file := f), "file to print output"
  	]
    (fun s -> Format.eprintf "WARNING: Ignored argument %s.@." s)
    usage_msg

let main () : unit = 
  arguments ();
  JSParserMain.init (); (*~path:"./lib"; *)
  let e_str = load_file !file in 
  (*Printf.printf "The input JS prog is the following:\n%s" e_str; *)
  let e_js =  JSParserMain.exp_from_string e_str in
  if(!output_file <> "") then (
    let out = open_out !output_file in
    output_string out (JSPrettyPrint.string_of_exp true e_js);  
    close_out out;              
  )
  (* Printf.printf "The PARSED JS prog is the following:\n%s\n" (JSPrettyPrint.string_of_exp true e_js) *)

let _ = main () 

