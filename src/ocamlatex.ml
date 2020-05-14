let version = "Beta" ;;
let defaultTitle = "Title" ;;
let title = String.concat defaultTitle ["\\title{"; "}"];;
let defaultAuthor = "Pierre-Elisee Flory" ;;
let author = String.concat defaultAuthor ["\\author{"; "}"];;

let startDoc() =
  print_string "\\documentclass[11pt, a4paper]{article}

\\usepackage[french,english]{babel}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}

\\usepackage{csquotes}
\\usepackage{listings}
\\usepackage{xcolor}

\\definecolor{codegreen}{rgb}{0,0.6,0}
\\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\\definecolor{codepurple}{rgb}{0.58,0,0.82}
\\definecolor{backcolour}{rgb}{0.95,0.95,0.92}

\\lstdefinestyle{mystyle}{
    backgroundcolor=\\color{backcolour},   
    commentstyle=\\color{codegreen},
    keywordstyle=\\color{magenta},
    numberstyle=\\tiny\\color{codegray},
    stringstyle=\\color{codepurple},
    basicstyle=\\ttfamily\\footnotesize,
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,                 
    numbers=left,                    
    numbersep=5pt,                  
    showspaces=false,                
    showstringspaces=false,
    showtabs=false,                  
    tabsize=2
}

\\lstset{style=mystyle}
\\usepackage{hyperref}
\\usepackage{XCharter}
\\usepackage{graphicx}
\\usepackage{geometry}
\\geometry{
  top=2cm,
  bottom=2cm,
  left=2.2cm,
  right=2.2cm,
  includehead,
}
\\setlength{\\parindent}{15pt}
\\usepackage{setspace}
\\linespread{1.5}";
  print_newline(); 
  print_string title;
  print_newline(); 
  print_string author;
  print_newline(); 
  print_string "\\date{\\small \\today}";
  print_newline(); 
  flush stdout
;;

let usage () =
  let _ =
    Printf.eprintf
      "Usage: %s [file]\n\tRead a PCF program from file (default is stdin)\n%!"
    Sys.argv.(0) in
  exit 1
;;

let main() =
  let input_channel =
    match Array.length Sys.argv with
    | 1 -> stdin
    | 2 -> (
        match Sys.argv.(1) with
        | "-" -> stdin
        | name ->
            (try open_in name with
            |_ -> Printf.eprintf "Opening %s failed\n%!" name; exit 1)
       )
    | n -> usage () in
  (* let _ = Printf.printf "        Welcome to OCamLaTEX, version %s\n%!" version in *)
  let lexbuf = Lexing.from_channel input_channel in
  let _ = startDoc() in
  while true do
    try
      (* let _ = Printf.printf  "> %!" in *)
      let parsedString = Parser.main Lexer.token lexbuf in
      (* let _ = Printf.printf "Translation: " in *)
        print_string parsedString; flush stdout;
    with Lexer.Eof -> print_string "\\end{document}"; print_newline(); exit 0
  done
;;

if !Sys.interactive then () else main () ;;
