%{
  open DataStructure

  let rec resolve_refs l : t =
    List.map (
      fun (section, vars) -> (
        section, (
        List.map (
          fun (ide, value) -> (ide, 
            match value with
            | Ref(s, v) -> get_var l s v section
            | other -> other)
          ) vars
        )
      )
    ) l

  and get_var l section var curr = 
  let res = match section with
    | Some s -> (lookup l s |> lookup) var
    | _ ->      (lookup l curr |> lookup) var
  in match res with
    | Ref (s, v) -> get_var l s v curr
    | other -> other
  ;;

  let rec check_dup = function
    | [] -> false
    | x::xs -> if (List.exists (fun y -> y = x) xs) then true else check_dup xs
  ;;
    
  let contain_duplicates list = 
    let (sections, vars) = List.split list in 
    let duplicate_sections = check_dup sections in 
    let duplicate_vars = 
      List.exists check_dup (vars |> List.map (List.map fst) ) in 
    duplicate_sections || duplicate_vars
  ;;

%}

(** Tokens definition *)
%token <int> INT
%token <bool> BOOL 
%token <string> STRING
%token <string> ID
%token <DataStructure.t> IMPORT
%token BEGINSECTION "{" ENDSECTION "}" 
%token SEMICOLON ";" DOT "." EQ "=" VAR "$"
%token EOF

%start <DataStructure.t> main

%%

main:
| i = list(IMPORT) l = list(sectdecl) EOF 
    { 
      let list = (List.concat i |> List.append) l in 
      if contain_duplicates list then failwith("Duplicate identifiers are not allowed!")
      else resolve_refs list
    }

sectdecl:
| sectname = ID "{" vars = list(vardecl) "}"
    { (sectname, vars) }

vardecl:
| id = ID "=" v = value ";"
    { (id, v) }

value:
| i = INT
    { Int i }

| b = BOOL
    { Bool b }

| s = STRING
    { String s }

| "$" id = ID
    { Ref (None, id) }

| "$" sect = ID "." id = ID
    { Ref (Some sect, id) }