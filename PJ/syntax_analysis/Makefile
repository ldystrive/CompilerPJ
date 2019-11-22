GCC = @g++
LEX = @flex
YACC = @bison

CPPFLAGS = -std=c++11

default: parser

parser: main.cpp parser.o lexer.o tree.hpp parser.hpp
	$(GCC) $(CPPFLAGS) -o $@ main.cpp parser.o lexer.o tree.hpp parser.hpp 

parser.o: parser.cpp tree.hpp
	$(GCC) $(CPPFLAGS) -c $< -o $@

parser.cpp: parser.y tree.hpp
	$(YACC) -d -o $@ $<

parser.hpp: parser.cpp

lexer.cpp: lexer.l parser.hpp tree.hpp
	$(LEX) -o $@ $^

lexer.o: lexer.cpp parser.hpp tree.hpp
	$(GCC) -c $(CPPFLAGS) -o $@ $<
list: list.cpp
	$(GCC) $(CPPFLAGS) -o $@ $<

clean: 
	$(RM) parser.hpp *.o lexer.cpp parser.cpp parser list
