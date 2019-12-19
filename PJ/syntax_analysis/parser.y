%{

#include "tree.hpp"
#include "parser.hpp"
#include<iostream>
using namespace std;

Node* root;
Node* now;
extern int yylex();
void yyerror(const char *msg) {
    cout<<msg<<" at ("<<yylloc.first_line<<","<<yylloc.first_column<<")"<<endl;
    cout << "last node:" << endl;
    Node* tmp;
    tmp=now->show();
    delete now;
    tmp->print("");
    exit(0);
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
    PROGRAM IS body SEMICOLON {$$ = new Node("program",4,$1,$2,$3,$4);root=$$;now=$$;}
    ;
body:
    declaration-list BBEGIN statement-list END {$$ = new Node("body",4,$1,$2,$3,$4);now=$$;}
    ;
declaration-list:
    %empty {$$ = new Node("declaration-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | declaration declaration-list {$$ = new Node("declaration-list",2,$1,$2->invisible());now=$$;}
    ;
statement-list:
    %empty {$$ = new Node("statement-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | statement statement-list {$$ = new Node("statement-list",2,$1,$2->invisible());now=$$;}
    ;
declaration:
    VAR var-decl-list {$$ = new Node("declaration",2,$1,$2);now=$$;}
    | TYPE type-decl-list {$$ = new Node("declaration",2,$1,$2);now=$$;}
    | PROCEDURE procedure-decl-list {$$ = new Node("declaration",2,$1,$2);now=$$;}
    ;
var-decl-list:
    %empty {$$ = new Node("var-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | var-decl var-decl-list {$$ = new Node("var-decl-list",2,$1,$2->invisible());now=$$;}
    ;
type-decl-list:
    %empty {$$ = new Node("type-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | type-decl type-decl-list {$$ = new Node("type-decl-list",2,$1,$2->invisible());now=$$;}
    ;
procedure-decl-list:
    %empty {$$ = new Node("procedure-decl-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | procedure-decl procedure-decl-list {$$ = new Node("procedure-decl-list",2,$1,$2->invisible());now=$$;}
    ;
var-decl:
    ID-non-null-list COLON typename ASSIGN expression SEMICOLON {$$ = new Node("var-decl",6,$1,$2,$3,$4,$5,$6);now=$$;}
    | ID-non-null-list ASSIGN expression SEMICOLON {$$ = new Node("var-decl",4,$1,$2,$3,$4);now=$$;} 
    ;
ID-non-null-list:
    ID ID-trail {$$ = new Node("ID-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
ID-trail:
    %empty {$$ = new Node("ID-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | COMMA ID ID-trail {$$ = new Node("ID-trail",3,$1,$2,$3->invisible());now=$$;}
    ;
type-decl:
    ID IS type SEMICOLON {$$ = new Node("type-decl",4,$1,$2,$3,$4);now=$$;}
    ;
procedure-decl:
    ID formal-params COLON typename IS body SEMICOLON {$$=new Node("procedure-decl",7,$1,$2,$3,$4,$5,$6,$7);now=$$;}
    | ID formal-params IS body SEMICOLON {$$ = new Node("procedure-decl",5,$1,$2,$3,$4,$5);now=$$;}
    ;
typename:
    ID {$$ = new Node("typename",1,$1);now=$$;}
    ;
type:
    ARRAY OF typename {$$ = new Node("type",3,$1,$2,$3);now=$$;}
    | RECORD component-non-null-list END {$$ = new Node("type",3,$1,$2,$3);now=$$;}
    ;
component-non-null-list:
    component {$$ = new Node("component-non-null-list",1,$1);now=$$;}
    | component component-non-null-list {$$ = new Node("component-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
component:
    ID COLON typename SEMICOLON {$$ = new Node("component",4,$1,$2,$3,$4);now=$$;}
    ;
formal-params:
    LPAREN fp-section-non-null-list RPAREN {$$ = new Node("formal-params",3,$1,$2,$3);now=$$;}
    | LPAREN RPAREN {$$ = new Node("formal-params",2,$1,$2);now=$$;}
    ;
fp-section-non-null-list:
    fp-section fp-section-trail {$$ = new Node("fp-section-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
fp-section-trail:
    %empty {$$ = new Node("fp-section-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | SEMICOLON fp-section fp-section-trail {$$ = new Node("fp-section-trail",3,$1,$2,$3->invisible());now=$$;}
    ;
fp-section:
    ID-non-null-list COLON typename {$$ = new Node("fp-section",3,$1,$2,$3);now=$$;}
    ;
statement:
    lvalue ASSIGN expression SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);now=$$;}
    | ID actual-params SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);now=$$;}
    | READ LPAREN lvalue-non-null-list RPAREN SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);now=$$;}
    | WRITE write-params SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);now=$$;}
    | IF expression THEN statement-list ELSIF-list ELSE statement-list END SEMICOLON {$$ = new Node("statement",9,$1,$2,$3,$4,$5,$6,$7,$8,$9);now=$$;}
    | IF expression THEN statement-list ELSIF-list END SEMICOLON {$$ = new Node("statement",7,$1,$2,$3,$4,$5,$6,$7);now=$$;}
    | WHILE expression DO statement-list END SEMICOLON {$$ = new Node("statement",6,$1,$2,$3,$4,$5,$6);now=$$;}
    | LOOP statement-list END SEMICOLON {$$ = new Node("statement",4,$1,$2,$3,$4);now=$$;}
    | FOR ID ASSIGN expression TO expression BY expression DO statement-list END SEMICOLON {$$ = new Node("statement",12,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);now=$$;}
    | FOR ID ASSIGN expression TO expression DO statement-list END SEMICOLON {$$ = new Node("statement",10,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10);now=$$;}
    | EXIT SEMICOLON {$$ = new Node("statement",2,$1,$2);now=$$;}
    | RETURN expression SEMICOLON {$$ = new Node("statement",3,$1,$2,$3);now=$$;}
    | RETURN SEMICOLON {$$ = new Node("statement",2,$1,$2);now=$$;}
    ;
lvalue-non-null-list:
    lvalue lvalue-trail {$$ = new Node("lvalue-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
lvalue-trail:
    %empty {$$ = new Node("lvalue-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | COMMA lvalue lvalue-trail {$$ = new Node("lvalue-trail",3,$1,$2,$3->invisible());now=$$;}
    ;
ELSIF-list:
    %empty {$$ = new Node("ELSIF-list","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | ELSIF expression THEN statement-list ELSIF-list {$$ = new Node("ELSIF-list",5,$1,$2,$3,$4,$5->invisible());now=$$;}
    ;
write-params:
    LPAREN write-expr-non-null-list RPAREN {$$ = new Node("write-params",3,$1,$2,$3);now=$$;}
    | LPAREN RPAREN {$$ = new Node("write-params",2,$1,$2);now=$$;}
    ;
write-expr-non-null-list:
    write-expr write-expr-trail {$$ = new Node("write-expr-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
write-expr-trail:
    %empty {$$ = new Node("write-expr-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | COMMA write-expr write-expr-trail {$$ = new Node("write-expr-trail",3,$1,$2,$3->invisible());now=$$;}
    ;
write-expr:
    STRING {$$ = new Node("write-expr",1,$1);now=$$;}
    | expression {$$ = new Node("write-expr",1,$1);now=$$;}
    ;
expression:
    number {$$ = new Node("expression",1,$1);now=$$;}
    | lvalue {$$ = new Node("expression",1,$1);now=$$;}
    | LPAREN expression RPAREN {$$ = new Node("expression",3,$1,$2,$3);now=$$;}
    | unary-op expression {$$ = new Node("expression",2,$1,$2);now=$$;}
    | expression binary-op expression {$$ = new Node("expression",3,$1,$2,$3);now=$$;}
    | ID actual-params {$$ = new Node("expression",2,$1,$2);now=$$;}
    | ID record-inits {$$ = new Node("expression",2,$1,$2);now=$$;}
    | ID array-inits {$$ = new Node("expression",2,$1,$2);now=$$;}
    ;
lvalue:
    ID {$$ = new Node("lvalue",1,$1);now=$$;}
    | lvalue LBRACKET expression RBRACKET {$$ = new Node("lvalue",4,$1,$2,$3,$4);now=$$;}
    | lvalue DOT ID {$$ = new Node("lvalue",3,$1,$2,$3);now=$$;}
    ;
actual-params:
    LPAREN expression-non-null-list RPAREN {$$ = new Node("actual-params",3,$1,$2,$3);now=$$;}
    | LPAREN RPAREN {$$ = new Node("actual-params",2,$1,$2);now=$$;}
    ;
expression-non-null-list:
    expression expression-trail {$$ = new Node("expression-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
expression-trail:
    %empty {$$ = new Node("expression-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | COMMA expression expression-trail {$$ = new Node("expression-trail",3,$1,$2,$3->invisible());now=$$;}
    ;

record-inits:
    LBRACE ASS-non-null-list RBRACE {$$ = new Node("record-inits",3,$1,$2,$3);now=$$;}
    ;
ASS-non-null-list:
    ID ASSIGN expression ASS-trail {$$ = new Node("ASS-non-null-list",4,$1,$2,$3,$4->invisible());now=$$;}
    ;
ASS-trail:
    %empty {$$ = new Node("ASS-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | SEMICOLON ID ASSIGN expression ASS-trail {$$ = new Node("ASS-trail",5,$1,$2,$3,$4,$5->invisible());now=$$;}
    ;
array-inits:
    LABRACKET array-init-non-null-list RABRACKET {$$ = new Node("array-inits",3,$1,$2,$3);now=$$;}
    ;
array-init-non-null-list:
    array-init array-init-trail {$$ = new Node("array-init-non-null-list",2,$1,$2->invisible());now=$$;}
    ;
array-init-trail:
    %empty {$$ = new Node("array-init-trail","",yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column);now=$$;}
    | COMMA array-init array-init-trail {$$ = new Node("array-init-trail",3,$1,$2,$3->invisible());now=$$;}
    ;
array-init:
    expression OF expression {$$ = new Node("array-init",3,$1,$2,$3);now=$$;}
    | expression {$$ = new Node("array-init",1,$1);now=$$;}
    ;
number:
    INTEGER {$$ = new Node("number",1,$1);now=$$;}
    | REAL {$$ = new Node("number",1,$1);now=$$;}
    ;
unary-op:
    PLUS {$$ = new Node("unary-op",1,$1);now=$$;}
    | MINUS {$$ = new Node("unary-op",1,$1);now=$$;}
    | NOT  {$$ = new Node("unary-op",1,$1);now=$$;}
    ;
binary-op:
    PLUS {$$ = new Node("binary-op",1,$1);now=$$;}
    | MINUS {$$ = new Node("binary-op",1,$1);now=$$;}
    | STAR {$$ = new Node("binary-op",1,$1);now=$$;}
    | SLASH {$$ = new Node("binary-op",1,$1);now=$$;}
    | DIV {$$ = new Node("binary-op",1,$1);now=$$;}
    | MOD {$$ = new Node("binary-op",1,$1);now=$$;}
    | OR {$$ = new Node("binary-op",1,$1);now=$$;}
    | AND {$$ = new Node("binary-op",1,$1);now=$$;}
    | GT {$$ = new Node("binary-op",1,$1);now=$$;}
    | LT {$$ = new Node("binary-op",1,$1);now=$$;}
    | EQ {$$ = new Node("binary-op",1,$1);now=$$;}
    | GE {$$ = new Node("binary-op",1,$1);now=$$;}
    | LE {$$ = new Node("binary-op",1,$1);now=$$;}
    | NEQ {$$ = new Node("binary-op",1,$1);now=$$;}
    ;
    
%%