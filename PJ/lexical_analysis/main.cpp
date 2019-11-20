#include <iostream>
#include <cstring>
#include <string>
#include <cstdio>
#include <iomanip>
#include "lexAnalyzer.h"
#include "lexer.h"
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

    return 0;
}
