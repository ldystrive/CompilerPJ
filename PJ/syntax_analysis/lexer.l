%{
#include <string>
#include <iostream>
#include <algorithm>
#include <iomanip>
#include <vector>
#include <map>
#include "tree.hpp"
#include "parser.hpp"
#define ptos(x,y) \
    " at ("+(std::to_string(x))+","+(std::to_string(y))+")"
#define print_location ptos(yylloc.first_line,yylloc.first_column)
#define TOKEN(t)    (yylval.node = new Node(#t,std::string(yytext, yyleng),yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column-1),t)
#define TOKEN_ERROR(x) (yylval.node = new Node("ERROR",std::string(x)+print_location,yylloc.first_line,yylloc.first_column,yylloc.last_line,yylloc.last_column-1),ERROR)
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line; \
    yylloc.first_column = yylloc.last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            yylloc.last_line++; \
            yylloc.last_column = 1; \
        } \
        else { \
            yylloc.last_column++; \
        } \
    }
%}
%option     nounput
%option     noyywrap
%option     nodefault



DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
COMMENT     \(\*(([^*])|(\**[^*)]))*\**\*\)
UNTERMINATED_COMMENT    \(\*(([^*])|(\**[^*)]))*\**$
UNTERMINATED_STRING     \"[^\"\n]*(\n|$)
WS          [ \t]+
NEWLINE     \n
UNKNOWN     .|\n
LETTER      [a-zA-Z]
STRING      \"[^\"\n]*\"
ID          {LETTER}({LETTER}|{DIGIT})*

ASSIGN      :=
PLUS        \+
MINUS       -
STAR        \*
SLASH       \/
LT          <
LE          <=
GT          >
GE          >=
EQ          =
NEQ         <>

COLON       :
SEMICOLON   ;
COMMA       ,
DOT         \.
LPAREN      \(
RPAREN      \)
LBRACKET    \[
RBRACKET    \]
LBRACE      \{
RBRACE      \}
LABRACKET   \[<
RABRACKET   >\]
BACKSLASH   \\


%%

{ASSIGN}    return TOKEN(ASSIGN);
{PLUS}      return TOKEN(PLUS);
{MINUS}     return TOKEN(MINUS);
{STAR}      return TOKEN(STAR);
{SLASH}     return TOKEN(SLASH);
{LT}        return TOKEN(LT);
{LE}        return TOKEN(LE);
{GT}        return TOKEN(GT);
{GE}        return TOKEN(GE);
{EQ}        return TOKEN(EQ);
{NEQ}       return TOKEN(NEQ);

{COLON}     return TOKEN(COLON);
{SEMICOLON} return TOKEN(SEMICOLON);
{COMMA}     return TOKEN(COMMA);
{DOT}       return TOKEN(DOT);
{LPAREN}    return TOKEN(LPAREN);
{RPAREN}    return TOKEN(RPAREN);
{LBRACKET}  return TOKEN(LBRACKET);
{RBRACKET}  return TOKEN(RBRACKET);
{LBRACE}    return TOKEN(LBRACE);
{RBRACE}    return TOKEN(RBRACE);
{LABRACKET} return TOKEN(LABRACKET);
{RABRACKET} return TOKEN(RABRACKET);
{BACKSLASH} return TOKEN(BACKSLASH);

AND         return TOKEN(AND);
ARRAY       return TOKEN(ARRAY);
BEGIN       return TOKEN(BBEGIN);
BY          return TOKEN(BY);
DIV         return TOKEN(DIV);
DO          return TOKEN(DO);
ELSE        return TOKEN(ELSE);
ELSIF       return TOKEN(ELSIF);
END         return TOKEN(END);
EXIT        return TOKEN(EXIT);
FOR         return TOKEN(FOR);
IF          return TOKEN(IF);
IN          return TOKEN(IN);
IS          return TOKEN(IS);
LOOP        return TOKEN(LOOP);
MOD         return TOKEN(MOD);
NOT         return TOKEN(NOT);
OF          return TOKEN(OF);
OR          return TOKEN(OR);
OUT         return TOKEN(OUT);
PROCEDURE   return TOKEN(PROCEDURE);
PROGRAM     return TOKEN(PROGRAM);
READ        return TOKEN(READ);
RECORD      return TOKEN(RECORD);
RETURN      return TOKEN(RETURN);
THEN        return TOKEN(THEN);
TO          return TOKEN(TO);
TYPE        return TOKEN(TYPE);
VAR         return TOKEN(VAR);
WHILE       return TOKEN(WHILE);
WRITE       return TOKEN(WRITE);


{WS}        ; // skip blanks and tabs
{NEWLINE}   ;
{UNTERMINATED_STRING}  return TOKEN(UNTERMINATED_STRING);
{UNTERMINATED_COMMENT}  return TOKEN(UNTERMINATED_COMMENT);
{ID}        if(yyleng > 255){return TOKEN_ERROR("Error: Identifier length out of range.");}else{return TOKEN(ID);}
<<EOF>>     yyterminate();
{INTEGER}   if(yyleng > 10 || (yyleng == 10 && string(yytext,yyleng) > "2147483647")){return TOKEN_ERROR("Error: Integer out of range.");}else{return TOKEN(INTEGER);}
{COMMENT}   cout<<"COMMENT: "<<(std::string(yytext, yyleng))<<"at ( "<<yylloc.first_line<<", "<<yylloc.first_column<<", "<<yylloc.last_line<<", "<<yylloc.last_column<<")"<<endl;//todo: collection of comment
{REAL}      return TOKEN(REAL);
{STRING}    if(string(yytext,yyleng).find_first_of("\t\n") != std::string::npos) {return TOKEN_ERROR("Error: String contains tabs or newlines.");}else if(yyleng > 257){return TOKEN_ERROR("Error: String length out of range.");} else{  return TOKEN(STRING);}
{UNKNOWN}   printf("Unknown token!\n"); yyterminate();
%%