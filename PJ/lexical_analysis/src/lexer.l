%{
#include <string>
#include <iostream>
#include <algorithm>
#include <iomanip>
#include <vector>
#include <map>
#include "lexer.h"
#include "parser.h"

#define SAVE_TOKEN  yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t)    (yylval.token = t)
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
SEMICOLON   )
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
{NEQ}       return TOKEN(OPERATOR);

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
BEGIN       return TOKEN(BEGIN);
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
{UNTERMINATED_STRING} return TOKEN(UNTERMINATED_STRING);
{UNTERMINATED_COMMENT} return TOKEN(UNTERMINATED_COMMENT);
{ID}        SAVE_TOKEN; return ID;
<<EOF>>     return TOKEN(T_EOF);
{INTEGER}   SAVE_TOKEN; return INTEGER;
{COMMENT}   ;
{REAL}      SAVE_TOKEN; return REAL;
{STRING}    SAVE_TOKEN; return STRING; // fixme: sanCheck
{UNKNOWN}   printf("Unknown token!\n"); yyterminate();
%%