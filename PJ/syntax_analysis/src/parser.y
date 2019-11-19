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