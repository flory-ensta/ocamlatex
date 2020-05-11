{ 
  open Parser
  exception Eof
  exception Invalid_lexeme


(* Gestion des textes encadrés *)

  let initial_string_buffer = Bytes.create 256;;
  let string_buff = ref initial_string_buffer;;
  let string_index = ref 0;;

  let reset_string_buffer () =
    string_buff := initial_string_buffer;
    string_index := 0;;

  let store_string_char c =
    if !string_index >= Bytes.length (!string_buff) then begin
      let new_buff = Bytes.create (Bytes.length (!string_buff) * 2) in
      Bytes.blit (!string_buff) 0 new_buff 0 (Bytes.length (!string_buff));
      string_buff := new_buff
    end;
    Bytes.unsafe_set (!string_buff) (!string_index) c;
    incr string_index;;

  let get_stored_string () =
    let s = Bytes.to_string (Bytes.sub (!string_buff) 0 (!string_index)) in
    string_buff := initial_string_buffer;
    s;;

  let char_for_backslash c = match c with
    | 'n' -> '\010'
    | 'r' -> '\013'
    | 'b' -> '\008'
    | 't' -> '\009'
    | c   -> c

  let char_for_decimal_code lexbuf i =
    let c = 100 * (Char.code(Lexing.lexeme_char lexbuf i) - 48) +
             10 * (Char.code(Lexing.lexeme_char lexbuf (i+1)) - 48) +
                  (Char.code(Lexing.lexeme_char lexbuf (i+2)) - 48) in
    if (c < 0 || c > 255)
    then raise (Failure ("Illegal_escape: " ^ (Lexing.lexeme lexbuf)))
    else Char.chr c;;

(* Fin de la gestion des textes encadrés *)

}

let newline = ('\010' | '\013' | "\013\010")

let digits = ['0'-'9']+
let character = ['A'-'Z' 'a'-'z' ' ']
let text = ['A'-'Z' 'a'-'z' '0'-'9' ' ' ':' ',' '.' '/']+
let code = ['A'-'Z' 'a'-'z' '0'-'9' ' ' ':' ',' '.' '/' '&' '~' '"' '(' ')' '-' '|' '*' '=' '/' '-' '+' ';' '<' '>' '$' '!']+
let link = ['A'-'Z' 'a'-'z' '0'-'9' ':' '.' '/']+
let words = ['A'-'Z' 'a'-'z' ' ']+
let name = ['A'-'Z' 'a'-'z' ' ' '-']+
let datetype = ['A'-'Z' 'a'-'z' ' ' '0'-'9' ',' '/']+

let title = "# "
let subTitle = "## "
let subTitle2 = "### "
let subTitle3 = "#### "
let author = "author:"
let date = "date:"


rule token = parse 
    [' ' '\t']     { token lexbuf }
  | [ '\n' ]  { EOL }
  | '['   { LBRA }
  |  '>' { quote lexbuf }
  |  title { title lexbuf }
  |  subTitle { subTitle lexbuf } 
  |  subTitle2 { subTitle2 lexbuf } 
  |  subTitle3 { subTitle3 lexbuf } 
  |  author { author lexbuf } 
  |  date { date lexbuf } 
  |  '*' (text as txt )'*' { ITALIC(txt) }
  |  "* " (text as txt ) { LIST(txt) }
  |  "**" (text as txt )"**" { BOLD(txt) }
  |  '`' (code as txt )'`' { CODE(txt) }
  |  '[' (text as descr ) ']' { DESCR(descr) }
  |  "![" (text as descr ) ']' { ALT(descr) }
  |  '(' (link as url ) ')' { URL(url) }
  |  "```" { reset_string_buffer();
            in_string lexbuf;
            BLOCKCODE (get_stored_string()) } 
  | "---" { HLINE }
  | eof   { raise Eof }
  | _   { token lexbuf }

and title = parse
    text as txt { TITLE(txt)}

and subTitle = parse
    text as txt { SUBTITLE(txt)}

and subTitle2 = parse
    text as txt { SUBTITLE2(txt)}

and subTitle3 = parse
    text as txt { SUBTITLE3(txt)}

and author = parse
    name as n { AUTHOR(n)}

and date = parse
    datetype as d { DATE(d)}

and quote = parse
    text as txt { QUOTE(txt)}


and in_string = parse
  "```"
    { () }
  | '\\' ['\\' '\'' '"' 'n' 't' 'b' 'r' ' ']
      { store_string_char(char_for_backslash(Lexing.lexeme_char lexbuf 1));
        in_string lexbuf }
  | '\\' ['0'-'9'] ['0'-'9'] ['0'-'9']
      { store_string_char(char_for_decimal_code lexbuf 1);
        in_string lexbuf }
  | '\\' _ as chars
      { skip_to_eol lexbuf; raise (Failure("Illegal escape: " ^ chars)) }
  | newline as s
      { for i = 0 to String.length s - 1 do
          store_string_char s.[i];
        done;
        in_string lexbuf
      }
  | eof
      { raise Invalid_lexeme }
  | _ as c
      { store_string_char c; in_string lexbuf }

and skip_to_eol = parse
    newline { () }
  | _       { skip_to_eol lexbuf }