%{
#include<iostream>
#include "lexer.c"
#include "tree.h"
using namespace std;

void Node* root;
void yyerror(const char *msg) {
    cout << msg << endl;
}
%}

%locations

%union {
    int token;
    string string;
    Node * node;
    //todo:e.g. NStat NExpr (the number of argument is different)
}

%token <string> INTEGER REAL

%token <token> ASSIGN PLUS MINUS STAR SLASH BACKSLASH
%token <token> LT LE GT GE EQ NEQ COLON SEMICOLON COMMA DOT
%token <token> LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token <token> LABRACKET RABRACKET AND ARRAY BBEGIN BY DIV
%token <token> FOR IF IN IS LOOP MOD NOT OF OR OUT THEN TO 
%token <token> PROCEDURE PROGRAM READ RECORD RETURN T_EOF
%token <token> TYPE VAR WHILE WRITE DO ELSE ELSIF END EXIT 

%token <string> UNTERMINATED_STRING UNTERMINATED_COMMENT ID INTEGER COMMENT REAL STRING
%token <string> ERROR

%type <node> program body declaration var-decl

