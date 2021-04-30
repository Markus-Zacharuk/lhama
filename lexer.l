%{
#include "Header.h"
#include "parser.tab.hpp"

// https://en.cppreference.com/w/cpp/language/escape
// Code of this function based on https://stackoverflow.com/questions/5612182/convert-string-with-explicit-escape-sequence-into-relative-character
std::string unescape(const std::string &str) {
  std::string result;
  std::string::const_iterator it = str.begin();
  while (it != str.end()) {
    char c = *it++;
    if (c == '\\' && it != str.end()) {
      switch (*it++) {
        case '\'':
          c = '\'';
          break;
        case '\"':
          c = '\"';
          break;
        case '\?':
          c = '\?';
          break;
        case '\\':
          c = '\\';
          break;
        case 'a':
          c = '\a';
          break;
        case 'b':
          c = '\b';
          break;
        case 'f':
          c = '\f';
          break;
        case 'n':
          c = '\n';
          break;
        case 'r':
          c = '\r';
          break;
        case 't':
          c = '\t';
          break;
        case 'v':
          c = '\v';
          break;
        default:
          // invalid escape sequence
          continue;
      }
    }
    result += c;
  }
  return result;
}

// Tell Flex the lexer's prototype ...
# define YY_DECL \
  yy::parser::symbol_type yylex ()
// ... and declare it for the parser's sake.
YY_DECL;
%}

%option noyywrap

%%



\(                          { return yy::parser::make_LPAREN(); }
\)                          { return yy::parser::make_RPAREN(); }
\.                          { return yy::parser::make_DOT(); }
L                           { return yy::parser::make_LAMBDA(); }
;                           { return yy::parser::make_SEMICOLON(); }
=                           { return yy::parser::make_ASSIGNMENT(); }
&                           { return yy::parser::make_REFERENCE(); }
[ \t\v\f]                             { ;                                                                                               }
\n                          { if (!from_file) { std::cout << "> "; } ++line; }
[^ \t\v\f\n\(\)\.;L=&]+     { return yy::parser::make_STR( std::string(yytext) ); }
<<EOF>>                     { return yy::parser::make_TOK_EOF(); }
%%
