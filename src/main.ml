open DataStructure
open Lexer

let () =
  let argvLength = Array.length Sys.argv in 
  let filename = Sys.argv.(argvLength-1) in 
  let lexbuf = Lexing.from_channel (open_in filename) in 
  try
    let ds = Parser.main (Lexer.tokenize filename) lexbuf in 
    print_ds ds
  with
    |Lexing_Error(s) -> Printf.fprintf stderr "%s\n" s
    |Parser.Error ->  Printf.fprintf stderr "Syntax error!" 
    |exn -> Printf.fprintf stderr "%s\n" (Printexc.to_string exn)