/* parser.y */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void yyerror(const char *msg);
int yylex();
extern int yylineno;
#define YYDEBUG 1
int yydebug = 1;

char *fieldName;
char *fieldType;
char *textareaValue;
char validationScript[8192] = "";

char *capitalize(const char *str) {
    char *cap = strdup(str);
    if (cap && strlen(cap) > 0) {
        cap[0] = toupper(cap[0]);
    }
    return cap;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s at line %d\n", msg, yylineno);
}
%}

%union {
    char *str;
    int num;
}

%token FORM META SECTION FIELD VALIDATE IF ERROR
%token REQUIRED MIN MAX DEFAULT PATTERN ROWS COLS ACCEPT
%token COLON SEMICOLON EQUAL LBRACE RBRACE
%token LBRACK RBRACK COMMA
%token LT GT EQ
%token <str> ID STRING BOOL
%token <num> NUMBER

%type <str> attr attr_block attr_list string_list string_items condition

%%

program:
    FORM ID LBRACE form_body validate_block RBRACE {
        printf("<div style='margin-top: 20px;'>\n");
        printf("<button type=\"submit\">Submit</button>\n</div>\n</form>\n");
        if (strlen(validationScript) > 0) {
            printf("<script>\n");
            printf("document.forms['MyForm'].addEventListener('submit', function(e) {\n");
            printf("%s", validationScript);
            printf("});\n</script>\n");
        }
    }
;

form_body:
    meta_list section_list
;

meta_list:
    /* empty */
    | meta_list META ID EQUAL STRING SEMICOLON {
        printf("<!-- Meta: %s = %s -->\n", $3, $5);
        free($3); free($5);
    }
;

section_list:
    /* empty */
    | section_list SECTION ID LBRACE field_list RBRACE {
        free($3);
    }
;

field_list:
    /* empty */
    | field_list field
;

field:
    FIELD ID COLON ID attr_block SEMICOLON {
        fieldName = $2;
        fieldType = $4;
        char *label = capitalize($2);
        printf("<div style='margin-bottom: 12px;'>");

        if (strcmp($4, "checkbox") == 0) {
            int isChecked = strstr($5, "checked") != NULL;
            printf("<label><input type=\"checkbox\" name=\"%s\"%s> %s</label>", $2, isChecked ? " checked" : "", label);
        } else if (strcmp($4, "textarea") == 0) {
            printf("<label>%s:<br><textarea name=\"%s\" %s>%s</textarea></label>", 
                   label, $2, $5, textareaValue ? textareaValue : "");
            if (textareaValue) { free(textareaValue); textareaValue = NULL; }
        } else {
            printf("<label>%s:<br><input type=\"%s\" name=\"%s\" %s></label>", label, $4, $2, $5);
        }

        printf("</div>\n");
        free($2); free($4); free($5); free(label);
    }
    | FIELD ID COLON ID string_list attr_block SEMICOLON {
        fieldName = $2;
        fieldType = $4;
        char *label = capitalize($2);
        printf("<div style='margin-bottom: 12px;'>");

        if (strcmp($4, "radio") == 0) {
            printf("<label>%s:</label><br>%s", label, $5);
        } else if (strcmp($4, "dropdown") == 0) {
            printf("<label>%s:<br><select name=\"%s\" %s>%s</select></label>", label, $2, $6, $5);
        }

        printf("</div>\n");
        free($2); free($4); free($5); free($6); free(label);
    }
;

validate_block:
    /* empty */
    | VALIDATE LBRACE validations RBRACE
;

validations:
    /* empty */
    | validations IF condition LBRACE ERROR STRING SEMICOLON RBRACE {
        char buf[512];
        sprintf(buf, "if ((%s)) { e.preventDefault(); alert(\"%s\"); }\n", $3, $6);
        strcat(validationScript, buf);
        free($3); free($6);
    }
;

condition:
    ID LT NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) < %d", $1, $3);
        $$ = strdup(buf);
        free($1);
    }
    | ID GT NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) > %d", $1, $3);
        $$ = strdup(buf);
        free($1);
    }
    | ID EQ NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) == %d", $1, $3);
        $$ = strdup(buf);
        free($1);
    }
;

attr_block:
    /* empty */ { $$ = strdup(""); }
    | attr_list  { $$ = $1; }
;

attr_list:
    attr { $$ = $1; }
    | attr_list attr {
        $$ = malloc(strlen($1) + strlen($2) + 2);
        sprintf($$, "%s %s", $1, $2);
        free($1); free($2);
    }
;

attr:
    REQUIRED { $$ = strdup("required"); }
    | MIN EQUAL NUMBER { char buf[32]; sprintf(buf, "min=\"%d\"", $3); $$ = strdup(buf); }
    | MAX EQUAL NUMBER { char buf[32]; sprintf(buf, "max=\"%d\"", $3); $$ = strdup(buf); }
    | MIN EQUAL STRING { char buf[64]; sprintf(buf, "min=\"%s\"", $3); $$ = strdup(buf); free($3); }
    | MAX EQUAL STRING { char buf[64]; sprintf(buf, "max=\"%s\"", $3); $$ = strdup(buf); free($3); }
    | DEFAULT EQUAL STRING {
        if (fieldType && strcmp(fieldType, "textarea") == 0) {
            textareaValue = strdup($3); $$ = strdup("");
        } else {
            char buf[256]; sprintf(buf, "value=\"%s\"", $3); $$ = strdup(buf);
        }
        free($3);
    }
    | DEFAULT EQUAL BOOL { $$ = strdup(strcmp($3, "true") == 0 ? "checked" : ""); free($3); }
    | PATTERN EQUAL STRING { char buf[256]; sprintf(buf, "pattern=\"%s\"", $3); $$ = strdup(buf); free($3); }
    | ROWS EQUAL NUMBER { char buf[32]; sprintf(buf, "rows=\"%d\"", $3); $$ = strdup(buf); }
    | COLS EQUAL NUMBER { char buf[32]; sprintf(buf, "cols=\"%d\"", $3); $$ = strdup(buf); }
    | ACCEPT EQUAL STRING { char buf[256]; sprintf(buf, "accept=\"%s\"", $3); $$ = strdup(buf); free($3); }
    | ID EQUAL NUMBER { char buf[64]; sprintf(buf, "%s=\"%d\"", $1, $3); $$ = strdup(buf); free($1); }
    | ID EQUAL STRING { char buf[256]; sprintf(buf, "%s=\"%s\"", $1, $3); $$ = strdup(buf); free($1); free($3); }
;

string_list:
    LBRACK string_items RBRACK { $$ = $2; }
;

string_items:
    STRING {
        char buf[256];
        if (fieldType && strcmp(fieldType, "radio") == 0)
            sprintf(buf, "<input type=\"radio\" name=\"%s\" value=\"%s\"> %s<br>\n", fieldName, $1, $1);
        else
            sprintf(buf, "<option value=\"%s\">%s</option>\n", $1, $1);
        $$ = strdup(buf);
        free($1);
    }
    | string_items COMMA STRING {
        char *combined = malloc(strlen($1) + 256);
        if (fieldType && strcmp(fieldType, "radio") == 0)
            sprintf(combined, "%s<input type=\"radio\" name=\"%s\" value=\"%s\"> %s<br>\n", $1, fieldName, $3, $3);
        else
            sprintf(combined, "%s<option value=\"%s\">%s</option>\n", $1, $3, $3);
        free($1); free($3);
        $$ = combined;
    }
;

%%

int main() {
    printf("<style>"
        "body { background:rgb(135, 179, 233); font-family: 'Helvetica Neue', sans-serif; padding: 20px; }"
        ".form-container {"
        "  background: white; max-width: 640px; margin: 0 auto; padding: 40px;"
        "  border-radius: 12px; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);"
        "}"
        ".form-container label { font-weight: 600; display: block; margin-bottom: 8px; color: #2c3e50; }"
        ".form-container input[type], .form-container textarea, .form-container select {"
        "  width: 100%%; padding: 12px 16px; margin-bottom: 20px; border: 1px solid #dfe6e9; border-radius: 8px;"
        "  font-size: 15px; background: #f9f9f9;"
        "}"
        ".form-container input[type='checkbox'], .form-container input[type='radio'] {"
        "  margin-right: 8px;"
        "}"
        ".form-container button { background:rgb(173, 41, 185); border: none; padding: 12px 24px;"
        "  color: white; font-size: 16px; border-radius: 8px; cursor: pointer; }"
        ".form-container button:hover { background:rgb(54, 9, 63); }"
        "</style>");
    printf("<form name=\"MyForm\" class=\"form-container\">\n");
    return yyparse();
}
