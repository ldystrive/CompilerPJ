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
    Node * node;
}

%token <node> INTEGER REAL ID STRING

%token <node> ASSIGN PLUS MINUS STAR SLASH BACKSLASH
%token <node> LT LE GT GE EQ NEQ COLON SEMICOLON COMMA DOT
%token <node> LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token <node> LABRACKET RABRACKET AND ARRAY BBEGIN BY DIV
%token <node> FOR IF IN IS LOOP MOD NOT OF OR OUT THEN TO 
%token <node> PROCEDURE PROGRAM READ RECORD RETURN T_EOF
%token <node> TYPE VAR WHILE WRITE DO ELSE ELSIF END EXIT 

%token <node> UNTERMINATED_STRING UNTERMINATED_COMMENT ERROR

%type <node> program body declaration var-decl type-decl
%type <node> procedure-decl typename type component formal-params
%type <node> fp-section statement write-params write-expr 
%type <node> expression lvalue actual-params record-inits
%type <node>  array-inits array-init number unary-op binary-op

%%
program:
    PROGRAM IS body SEMICOLON {$$ = new Node(4,$1,$2,$3,$4);}
    ;
body:
    declaration BBEGIN statement END {$$ = new Node}
%%

    /* S = { A } */
    /* S = AA */
    /* AA = | A AA */

    /* S = [ A ] */
    /* S = AA */
    /* AA = | A */

    /* S = ( A ) */
    /* S = AA */
    /* AA = A */

    /* todo: remember to make AA invisible */
    /* todo: name S A_list or optional (without confirmation) */