%token HLINE MAKETITLE
%token <string> STRING
%token <string list> LANG_CODE
%token <string> DESCR ALT URL
%token <string> TITLE SUBTITLE SUBTITLE2 SUBTITLE3
%token <string> AUTHOR DATE
%token <string> BOLD ITALIC CODE BLOCKCODE
%token <string> QUOTE LIST
%token EOL

%start main
%type <string> main
%%

main:
  expr { $1 }
  | EOL EOL expr { String.concat "\n" [""; $3] }
  | EOL EOL list_expr { String.concat "\n" ["\\begin{itemize}"; $3] }
  | EOL expr { String.concat $2["\\end{itemize}\n"; "\n" ] }
  | EOL list_expr EOL { $2 }
  | list_expr EOL { $1 }
  | EOL EOL EOL { "\n" }

expr:
    STRING    { String.concat $1 [""; "\n"] };
  | TITLE     { String.concat $1 ["\\title{"; "}"] };
  | AUTHOR     { String.concat $1["\\author{"; "}"] };
  | DATE     { String.concat $1 ["\\date{\\small "; "}"] };
  | SUBTITLE     { String.concat $1 ["\\section{"; "}\n"] };
  | SUBTITLE2     { String.concat $1 ["\\subsection{"; "}\n"] };
  | SUBTITLE3     { String.concat $1 ["\\subsubsection{"; "}\n"] };
  | BOLD     { String.concat $1 ["\\textbf{"; "}\n"] };
  | ITALIC     { String.concat $1 ["\\textit{"; "}\n"] };
  | DESCR URL     { String.concat $1 [String.concat $2 ["\\href{"; "}{"]; "}\n"] };
  | ALT URL     { String.concat $1 [String.concat $2 ["\\begin{figure}[h]\n\\centering\n\\includegraphics[width=8cm,height=10cm,keepaspectratio]{"; "}\n\\caption{"]; "}\n\\end{figure}\n"] };
  | QUOTE     { String.concat $1 ["\\begin{displayquote}\n"; "\n\\end{displayquote}\n"] };
  | CODE     { String.concat $1 ["\\begin{lstlisting}\n"; "\n\\end{lstlisting}\n"] };
  | BLOCKCODE     { String.concat $1 ["\\begin{lstlisting}"; "\\end{lstlisting}\n"] };
  | LANG_CODE     { String.concat (List.nth $1 1) [String.concat (List.nth $1 0) ["\\begin{lstlisting}[language="; "]"]; "\\end{lstlisting}\n"] };
  | HLINE    { "\\noindent\\rule{\\textwidth}{1pt}\n" }
  | MAKETITLE    { "\\begin{document}\n\\maketitle\n\\newpage\n" }

list_expr:
    LIST     { String.concat " " ["\\item"; $1] };