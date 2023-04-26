{
	open Parser
  exception Lexing_Error of string;;

  let string_of_position p =
    let line_number = p.Lexing.pos_lnum in
    let column = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1 in
    Printf.sprintf "(%d, %d)" line_number column
  ;;

}

let digit 	= ['0'-'9']
let integer = digit+ 
let bool 		= ("true"|"false")
let string  = "\"" [^ '"']* "\""
let id 			= ['a'-'z' 'A'-'Z']['a'-'z' '0'-'9']*
let white   = [' ' '\t']

rule tokenize file = parse
	| integer as inum		{ INT(int_of_string inum)}
	| bool as b					{ BOOL (bool_of_string b) }
	| string as s				{ STRING (String.sub s 1 ((String.length s)-2)) }
  | id as word        { ID word }
  | '{'               { BEGINSECTION }
  | '}'               { ENDSECTION }
  | ';'               { SEMICOLON }
  | '.'               { DOT }
  | '='               { EQ }
  | '$'               { VAR }
  | "#import<" ( [^ '\n' '>']* as filename) '>'
                      { 
                        let lb = Lexing.from_channel (open_in filename) in
                        let p = Parser.main (tokenize filename) lb in
                        IMPORT p
                      }
  | '\n'              { Lexing.new_line lexbuf; tokenize file lexbuf }
  | "//" [^ '\n']*    (* eat up one-line comments *)
  | white             (* eat up whitespace *)
											{ tokenize file lexbuf }
  | eof               { EOF }
	| _ 			          { raise (Lexing_Error("Unexpected character "^(Lexing.lexeme lexbuf)^
                        " at "^file^": "^(string_of_position (Lexing.lexeme_start_p lexbuf)))) 
                      }
