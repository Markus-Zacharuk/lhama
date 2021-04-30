#ifndef HEADER_H
#define HEADER_H

#include "Includes.h"

//#include "parser.tab.hpp"
//typedef Variable std::string;

struct Abstraction {
    std::string variable;
    std::any body;
};

struct Application {
    std::any abstraction;
    std::any argument;
};

auto operator<< (std::ostream& o, const std::any& arg) -> std::ostream&;
auto operator<< (std::ostream& o, const Application& arg) -> std::ostream&;
auto operator<< (std::ostream& o, const Abstraction& arg) -> std::ostream&;

void substitute(std::any &body, const std::string &variable, const std::any &substitute);
void beta_reduction_normal(std::any &expression);

//extern int yylex();
extern char* yytext;
extern unsigned int line;
extern FILE *yyin;
//YY_BUFFER_STATE yy_scan_buffer(char *base, yy_size_t size);
//extern int yy_scan_string(const char *);

std::any get_assigned_value(const std::string &name, bool &success);
extern std::unordered_map<std::string, std::any> assignments;
extern bool from_file;
extern bool restart;

#include "parser.tab.hpp"
#endif
