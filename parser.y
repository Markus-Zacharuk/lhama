%require "3.2"
%language "c++"
%define api.value.type variant
%define api.token.constructor

%{
  #include "Header.h"
  bool from_file = false;
  bool restart = true;
  std::unordered_map<std::string, std::any> assignments;

  auto operator<< (std::ostream& o, const Application& arg) -> std::ostream&;
  auto operator<< (std::ostream& o, const Abstraction& arg) -> std::ostream&;

  // Print std::any.
  auto operator<< (std::ostream& o, const std::any& arg) -> std::ostream& {
    if (auto str_ptr = std::any_cast<std::string>(&arg))
      o << *str_ptr;
    if (auto application_ptr = std::any_cast<Application>(&arg))
      o << *application_ptr;
    if (auto abstraction_ptr = std::any_cast<Abstraction>(&arg))
      o << *abstraction_ptr;
    return o;
  }


  auto operator<< (std::ostream& o, const Application& arg) -> std::ostream& {
    o << "(" << arg.abstraction << " " << arg.argument << ")";
    return o;
  }
  auto operator<< (std::ostream& o, const Abstraction& arg) -> std::ostream& {
    o << "L" << arg.variable << "." << arg.body;
    return o;
  }

  # define YY_DECL \
    yy::parser::symbol_type yylex ()
  // ... and declare it for the parser's sake.
  YY_DECL;
%}

//%glr-parser

%%

%token TOK_EOF;

Source : Assignment { YYACCEPT; }
       | Expression  {
	std::cout << $1; //<< "\n";
	beta_reduction_normal($1);
	std::cout << " => " << $1 << std::endl;
	YYACCEPT;
	}
	| TOK_EOF { if (from_file) { restart = false; } YYACCEPT; }
	;

Assignment : STR "=" Expression  {
	assignments[$1] = $3;
       }
       ;

%token
  LPAREN "("
  RPAREN ")"
  LAMBDA "L"
  DOT "."
  SEMICOLON ";"
  ASSIGNMENT "="
  REFERENCE "&"
  ;

%token <std::string> STR;

%nterm <Abstraction> Abstraction;
Abstraction : "L" STR "." Expression { $$ = Abstraction{ .variable = $2, .body = $4 };
//std::cout << "L" << $2 << "." << "?\n";
}
            ;

%nterm <Application> Application;
Application : "(" Expression Expression ")" { $$ = Application{ .abstraction = $2, .argument = $3 };
//std::cout << "(?.? ?)\n";
}

            ;

%nterm <std::any> Expression;
Expression  : Abstraction { $$ = std::any($1); } //std::cout << "L?.? -> Expr\n"; }
            | Application { $$ = std::any($1); } //std::cout << "(L?.? ?) -> Expr\n"; }
            | STR         { $$ = std::any($1); } //std::cout << $1 << " -> Expr\n"; }
            | "&" STR     {

            auto search = assignments.find($2);
            if (search != assignments.end()) {
            	$$ = std::any(search->second);
            } else {
            	std::cout << "Reference Error: can't find '" << $2 <<"'. Aborting evaluation\n";
            	YYACCEPT;
            }
            }
            ;


%%
namespace yy
{
  // Report an error to the user.
  auto parser::error (const std::string& msg) -> void
  {
    std::cerr << msg << ": " << yytext << '\n';
  }
}
unsigned int line = 0;

int main(int argc, char** argv) {

	if ( argc > 1 ) {
		yyin = fopen( argv[1], "r" );
		from_file = true;
	} else {
		yyin = stdin;
		printf("> ");
	}
	int line = 0;
	yy::parser parse;
	int counter = 0;
	while (restart) {
		parse();
	}
    /*
    if (from_file) {
    	fclose(yyin);
    	restart = false;
    	break;
    }
    */
	return 0;
}


