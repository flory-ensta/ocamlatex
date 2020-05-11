%token HLINE
%token LBRA RBRA LPAR RPAR
%token <string> STRING
%token <string> DESCR ALT URL
%token <string> TITLE SUBTITLE SUBTITLE2 SUBTITLE3
%token <string> AUTHOR
%token <string> DATE
%token <string> BOLD ITALIC CODE BLOCKCODE
%token <string> QUOTE LIST
%token EOL

%start main
%type <string> main
%%

main:
    expr EOL  { $1 }
  | EOL expr  { $2 }
  | EOL EOL expr{ $3 }

expr:
    STRING    { $1 };
  | TITLE     { String.concat "Title: " [""; $1] };
  | SUBTITLE     { String.concat "Sub-title: " [""; $1] };
  | SUBTITLE2     { String.concat "Sub-title 2 : " [""; $1] };
  | SUBTITLE3     { String.concat "Sub-title 3 : " [""; $1] };
  | AUTHOR     { String.concat "The author is: " [""; $1] };
  | DATE     { String.concat "The date is: " [""; $1] };
  | BOLD     { String.concat "This text should be rendered as bold: " [""; $1] };
  | ITALIC     { String.concat "This text should be rendered as italic: " [""; $1] };
  | DESCR URL     { String.concat " : " [$1; $2] };
  | ALT URL     { String.concat " -> " [$1; $2] };
  | QUOTE     { String.concat " : " ["Quote text"; $1] };
  | CODE     { String.concat " : " ["Code line"; $1] };
  | LIST     { String.concat " : " ["This is a list item"; $1] };
  | BLOCKCODE     { String.concat " : " ["This is a block of code"; $1] };
  | HLINE    { "I'm a horizontal line" }

  