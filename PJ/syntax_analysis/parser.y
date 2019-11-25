%{

#include "tree.hpp"
#include "parser.hpp"
#include<iostream>
using namespace std;

Node* root;
extern int yylex();
void yyerror(const char *msg) {
    cout<<msg<<" at ("<<yylloc.first_line<<","<<yylloc.first_column<<")"<<endl;
}
%}

%code requires{
#include "tree.hpp"
}

%locations

%union {
    Node *node;
}

%token <node> INTEGER REAL ID STRING

%token <node> ASSIGN PLUS MINUS STAR SLASH BACKSLASH
%token <node> LT LE GT GE EQ NEQ COLON SEMICOLON COMMA DOT
%token <node> LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token <node> LABRACKET RABRACKET AND ARRAY BBEGIN BY DIV
%token <node> FOR IF IN IS LOOP MOD NOT OF OR OUT THEN TO 
%token <node> PROCEDURE PROGRAM READ RECORD RETURN
%token <node> TYPE VAR WHILE WRITE DO ELSE ELSIF END EXIT 
%token <node> UNTERMINATED_STRING UNTERMINATED_COMMENT ERROR
%type <node> program body declaration var-decl type-decl
%type <node> procedure-decl typename type component formal-params
%type <node> fp-section statement write-params write-expr 
%type <node> expression lvalue actual-params record-inits
%type <node> array-inits array-init number unary-op binary-op

%type <node> declaration-list statement-list var-decl-list
%type <node> type-decl-list procedure-decl-list
%type <node> ID-non-null-list ID-trail component-non-null-list
%type <node> fp-section-non-null-list fp-section-trail
%type <node> lvalue-non-null-list lvalue-trail ELSIF-list
%type <node> write-expr-non-null-list write-expr-trail
%type <node> ASS-non-null-list ASS-trail
%type <node> array-init-non-null-list array-init-trail
%type <node>  expression-non-null-list expression-trail

%%
program:
    PROGRAM IS body SEMICOLON {$$ = new Node("program",4,$1,$2,$3,$4);root=$$;}
    ;
body:
    declaration-list BBEGIN statement-list END {$$ = new Node("body",4,$1,$2,$3,$4);}
    ;
declaration-list:
    %empty {$$ = new Node("declaration-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | declaration declaration-list {$$ = new Node("declaration-list",2,$1,$2->invisible());}
    ;
statement-list:
    %empty {$$ = new Node("statement-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | statement statement-list {$$ = new Node("statement-list",2,$1,$2->invisible());}
    ;
declaration:
    VAR var-decl-list {$$ = new Node("declaration",2,$1,$2);}
    | TYPE type-decl-list {$$ = new Node("declaration",2,$1,$2);}
    | PROCEDURE procedure-decl-list {$$ = new Node("declaration",2,$1,$2);}
    ;
var-decl-list:
    %empty {$$ = new Node("var-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | var-decl var-decl-list {$$ = new Node("var-decl-list",2,$1,$2->invisible());}
    ;
type-decl-list:
    %empty {$$ = new Node("type-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | type-decl type-decl-list {$$ = new Node("type-decl-list",2,$1,$2->invisible());}
    ;
procedure-decl-list:
    %empty {$$ = new Node("procedure-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | procedure-decl procedure-decl-list {$$ = new Node("procedure-decl-list",2,$1,$2->invisible());}
    ;
var-decl:
    ID-non-null-list COLON typename ASSIGN expression SEMICOLON {$$ = new Node("var-decl",6,$1,$2,$3,$4,$5,$6);}
    | ID-non-null-list ASSIGN expression SEMICOLON {$$ = new Node("var-decl",4,$1,$2,$3,$4);} 
    ;
ID-non-null-list:
    ID ID-trail {$$ = new Node("ID-non-null-list",2,$1,$2->invisible());}
    ;
ID-trail:
    %empty {$$ = new Node("ID-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA ID ID-trail {$$ = new Node("ID-trail",3,$1,$2,$3->invisible());}
    ;
type-decl:
    ID IS type SEMICOLON {$$ = new Node("type-decl",4,$1,$2,$3,$4);}
    ;
procedure-decl:
    ID formal-params COLON typename IS body SEMICOLON {$$=new Node("procedure-decl",7,$1,$2,$3,$4,$5,$6,$7);}
    | ID formal-params IS body SEMICOLON {$$ = new Node("procedure-decl",5,$1,$2,$3,$4,$5);}
    ;
typename:
    ID {$$ = new Node("typename",1,$1);}
    ;
type:
    ARRAY OF typename {$$ = new Node("type",3,$1,$2,$3);}
    | RECORD component-non-null-list END {$$ = new Node("type",3,$1,$2,$3);}
    ;
component-non-null-list:
    component {$$ = new Node("component-non-null-list",1,$1);}
    | component component-non-null-list {$$ = new Node("component-non-null-list",2,$1,$2->invisible());}
    ;
component:
    ID COLON typename SEMICOLON {$$ = new Node("component",4,$1,$2,$3,$4);}
    ;
formal-params:
    LPAREN fp-section-non-null-list RPAREN {$$ = new Node("formal-params",3,$1,$2,$3);}
    | LPAREN RPAREN {$$ = new Node("formal-params",2,$1,$2);}
    ;
fp-section-non-null-list:
    fp-section fp-section-trail {$$ = new Node("fp-section-non-null-list",2,$1,$2->invisible());}
    ;
fp-section-trail:
    %empty {$$ = new Node("fp-section-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | SEMICOLON fp-section fp-section-trail {$$ = new Node("fp-section-trail",3,$1,$2,$3->invisible());}
    ;
fp-section:
    ID-non-null-list COLON typename {$$ = new Node("fp-section",3,$1,$2,$3);}
    ;
statement:
    lvalue ASSIGN expression SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);}
    | ID actual-params SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);}
    | READ LPAREN lvalue-non-null-list RPAREN SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);}
    | WRITE write-params SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);}
    | IF expression THEN statement-list ELSIF-list ELSE statement-list END SEMICOLON {$$ = new Node("statement",9,$1,$2,$3,$4,$5,$6,$7,$8,$9);}
    | IF expression THEN statement-list ELSIF-list END SEMICOLON {$$ = new Node("statement",7,$1,$2,$3,$4,$5,$6,$7);}
    | WHILE expression DO statement-list END SEMICOLON {$$ = new Node("statement",6,$1,$2,$3,$4,$5,$6);}
    | LOOP statement-list END SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);}
    | FOR ID ASSIGN expression TO expression BY expression DO statement-list END SEMICOLON {$$ = new Node("statement",12,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);}
    | FOR ID ASSIGN expression TO expression DO statement-list END SEMICOLON {$$ = new Node("statement",10,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10);}
    | EXIT SEMICOLON {$$ = new Node("statement",2,$1,$2);}
    | RETURN expression SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);}
    | RETURN SEMICOLON {$$ = new Node("statement",2,$1,$2);}
    ;
lvalue-non-null-list:
    lvalue lvalue-trail {$$ = new Node("lvalue-non-null-list",2,$1,$2->invisible());}
    ;
lvalue-trail:
    %empty {$$ = new Node("lvalue-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA lvalue lvalue-trail {$$ = new Node("lvalue-trail",3,$1,$2,$3->invisible());}
    ;
ELSIF-list:
    %empty {$$ = new Node("ELSIF-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | ELSIF expression THEN statement-list ELSIF-list {$$ = new Node("ELSIF-list",5,$1,$2,$3,$4,$5->invisible());}
    ;
write-params:
    LPAREN write-expr-non-null-list RPAREN {$$ = new Node("write-params",3,$1,$2,$3);}
    | LPAREN RPAREN {$$ = new Node("write-params",2,$1,$2);}
    ;
write-expr-non-null-list:
    write-expr write-expr-trail {$$ = new Node("write-expr-non-null-list",2,$1,$2->invisible());}
    ;
write-expr-trail:
    %empty {$$ = new Node("write-expr-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA write-expr write-expr-trail {$$ = new Node("write-expr-trail",3,$1,$2,$3->invisible());}
    ;
write-expr:
    STRING {$$ = new Node("write-expr",1,$1);}
    | expression {$$ = new Node("write-expr",1,$1);}
    ;
expression:
    number {$$ = new Node("expression",1,$1);}
    | lvalue {$$ = new Node("expression",1,$1);}
    | LPAREN expression RPAREN {$$ = new Node("expression",3,$1,$2,$3);}
    | unary-op expression {$$ = new Node("expression",2,$1,$2);}
    | expression binary-op expression {$$ = new Node("expression",3,$1,$2,$3);}
    | ID actual-params {$$ = new Node("expression",2,$1,$2);}
    | ID record-inits {$$ = new Node("expression",2,$1,$2);}
    | ID array-inits {$$ = new Node("expression",2,$1,$2);}
    ;
lvalue:
    ID {$$ = new Node("lvalue",1,$1);}
    | lvalue LBRACKET expression RBRACKET {$$ = new Node("lvalue",4,$1,$2,$3,$4);}
    | lvalue DOT ID {$$ = new Node("lvalue",3,$1,$2,$3);}
    ;
actual-params:
    LPAREN expression-non-null-list RPAREN {$$ = new Node("actual-params",3,$1,$2,$3);}
    | LPAREN RPAREN {$$ = new Node("actual-params",2,$1,$2);}
    ;
expression-non-null-list:
    expression expression-trail {$$ = new Node("expression-non-null-list",2,$1,$2->invisible());}
    ;
expression-trail:
    %empty {$$ = new Node("expression-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA expression expression-trail {$$ = new Node("expression-trail",3,$1,$2,$3->invisible());}
    ;

record-inits:
    LBRACE ASS-non-null-list RBRACE {$$ = new Node("record-inits",3,$1,$2,$3);}
    ;
ASS-non-null-list:
    ID ASSIGN expression ASS-trail {$$ = new Node("ASS-non-null-list",4,$1,$2,$3,$4->invisible());}
    ;
ASS-trail:
    %empty {$$ = new Node("ASS-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA ID ASSIGN expression ASS-trail {$$ = new Node("ASS-trail",5,$1,$2,$3,$4,$5->invisible());}
    ;
array-inits:
    LABRACKET array-init-non-null-list RABRACKET {$$ = new Node("array-inits",3,$1,$2,$3);}
    ;
array-init-non-null-list:
    array-init array-init-trail {$$ = new Node("array-init-non-null-list",2,$1,$2->invisible());}
    ;
array-init-trail:
    %empty {$$ = new Node("array-init-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);}
    | COMMA array-init array-init-trail {$$ = new Node("array-init-trail",3,$1,$2,$3->invisible());}
    ;
array-init:
    expression OF expression {$$ = new Node("array-init",3,$1,$2,$3);}
    | expression {$$ = new Node("array-init",1,$1);}
    ;
number:
    INTEGER {$$ = new Node("number",1,$1);}
    | REAL {$$ = new Node("number",1,$1);}
    ;
unary-op:
    PLUS {$$ = new Node("unary-op",1,$1);}
    | MINUS {$$ = new Node("unary-op",1,$1);}
    | NOT  {$$ = new Node("unary-op",1,$1);}
    ;
binary-op:
    PLUS {$$ = new Node("binary-op",1,$1);}
    | MINUS {$$ = new Node("binary-op",1,$1);}
    | STAR {$$ = new Node("binary-op",1,$1);}
    | SLASH {$$ = new Node("binary-op",1,$1);}
    | DIV {$$ = new Node("binary-op",1,$1);}
    | MOD {$$ = new Node("binary-op",1,$1);}
    | OR {$$ = new Node("binary-op",1,$1);}
    | AND {$$ = new Node("binary-op",1,$1);}
    | GT {$$ = new Node("binary-op",1,$1);}
    | LT {$$ = new Node("binary-op",1,$1);}
    | EQ {$$ = new Node("binary-op",1,$1);}
    | GE {$$ = new Node("binary-op",1,$1);}
    | LE {$$ = new Node("binary-op",1,$1);}
    | NEQ {$$ = new Node("binary-op",1,$1);}
    ;
    
%%