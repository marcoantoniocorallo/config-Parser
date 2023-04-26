type var = string;;

type 'v env = (string * 'v) list;;

let rec lookup env x =
  match env with
  | []        -> failwith ("Section or variable "^x^" not found")
  | (y, v)::r -> if x=y then v else lookup r x
;;

let remove env x = 
  let rec rm acc = function
    | []        -> failwith ("Section or variable "^x^" not found")
    | (y, v)::r -> if x=y then (List.rev acc)@r else rm ((y,v)::acc) r
  in rm [] env
;;

let rm_section env s = remove env s;;
let rm_binding env s v = 
  List.map (
    fun (sect, vars) -> if s=sect then (sect, remove vars v) else (sect,vars)
  ) env

type value = 
  | Int of int 
  | String of string 
  | Bool of bool 
  | Ref of var option * var;; (* ref of a var in a section: Ref(s,v) *)

type section = value env;;

type t = section env;;

(* a serialized data-structure is ready to be parsed again! *)
let rec print_ds l = 
  List.iter (
    fun (section, vars) -> 
      print_endline (section^"{");
      List.iter (
        fun (var, value) -> 
          print_endline ("\t"^var^" = "^(string_of_value value)^" ;")
      ) vars;
      print_endline ("}");
  ) l
and string_of_value = function
  | Int i -> string_of_int i 
  | Bool b -> string_of_bool b 
  | String s -> "\""^s ^"\""
  | Ref (s,v) -> if Option.is_some s then ("$"^(Option.get s)^"."^v) else v
;;