/*
24. int eval(char *s);
    A simple stack-based expression evaluator. The input string contains expression in Reverse Polish
    Notation with four possible arithmetic operators (+, -, *, /) and integer decimal numbers. The routine
    should return integer result of expression. Assume that all input numbers fit in 32 bits, handle
    arithmetic overflow and underflow by saturating the result to MAXINT or MININT as appropriate.
*/

#include <stdio.h>
extern int eval(char *s);

int main(int argc, char *argv[])
{
    printf("Expression to be evaluated: %s\n", argv[1]);
    printf("Result: %d\n\n", eval(argv[1]));
}