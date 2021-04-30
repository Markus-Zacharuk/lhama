lhama: lex.yy.cpp parser.tab.cpp
	   clang++ lex.yy.cpp parser.tab.cpp Functions.cpp -lpthread -std=c++20 -O3 -o lhama

parser.tab.cpp: parser.y
	   bison -d --verbose --graph parser.y -o parser.tab.cpp

lex.yy.cpp: lexer.l
	   flex lexer.l
	   cp lex.yy.c lex.yy.cpp
	   rm lex.yy.c

graph: parser.tab.cpp
	   xdot parser.dot

conflicts:
	   cat parser.output

clean:
	   rm -rf lex.yy.c lex.yy.cpp lex.yy.cc parser.tab.cpp parser.tab.c parser.tab.cc parser.tab.h parser.tab.hh parser.output parser.dot
