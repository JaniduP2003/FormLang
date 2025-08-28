/* lexer.l */
%{
#include "parser.tab.h"
#include <string.h>
%}

%option yylineno

%%
form            { return FORM; }
meta            { return META; }
section         { return SECTION; }
field           { return FIELD; }
validate        { return VALIDATE; }
if              { return IF; }



error           { return ERROR; }
required        { return REQUIRED; }
min             { return MIN; }
max             { return MAX; }
default         { return DEFAULT; }
pattern         { return PATTERN; }
rows            { return ROWS; }
cols            { return COLS; }
accept          { return ACCEPT; }

":"             { return COLON; }
";"             { return SEMICOLON; }
"="             { return EQUAL; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LBRACK; }
"]"             { return RBRACK; }
","             { return COMMA; }
"<"             { return LT; }
">"             { return GT; }
"=="            { return EQ; }

text            { yylval.str = strdup(yytext); return ID; }
password        { yylval.str = strdup(yytext); return ID; }
number          { yylval.str = strdup(yytext); return ID; }
email           { yylval.str = strdup(yytext); return ID; }
radio           { yylval.str = strdup(yytext); return ID; }
date            { yylval.str = strdup(yytext); return ID; }
textarea        { yylval.str = strdup(yytext); return ID; }
dropdown        { yylval.str = strdup(yytext); return ID; }
file            { yylval.str = strdup(yytext); return ID; }
checkbox        { yylval.str = strdup(yytext); return ID; }

true|false      { yylval.str = strdup(yytext); return BOOL; }



[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }

\"[^\"]*\"      {
                  yylval.str = strdup(yytext + 1);
                  yylval.str[strlen(yylval.str) - 1] = '\0';
                  return STRING;
               }

[a-zA-Z_][a-zA-Z0-9_]* {
                  yylval.str = strdup(yytext);
                  return ID;
               }

[ \t\r]+        ; // Ignore whitespace
\n              { yylineno++; }
.               { return *yytext; }
%%

int yywrap() { return 1; }
