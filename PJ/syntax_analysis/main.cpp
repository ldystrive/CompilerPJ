#include <iostream>
#include <cstring>
#include <string>
#include <cstdio>
#include <iomanip>

#include "tree.hpp"
#include "parser.hpp"

extern int yylex();
extern FILE* yyin;
extern char* yytext;
extern int yyleng;
extern int yyparse();
extern Node* root;
using namespace std;

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            cerr << "Cannot open file." << endl;
            return 1;
        } else {
            yyin = file;
        }
    } else {
        yyin = stdin;
    }
    yyparse();
    Node* tmp;
    tmp=root->show();
    delete root;
    tmp->print("");
    return 0;
}
