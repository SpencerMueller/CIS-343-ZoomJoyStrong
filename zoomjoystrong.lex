%{
	//Definitions, including the stdlib library and our zoomjoystrong h tab
	#include <stdlib.h>
	#include "zoomjoystrong.tab.h"
%}

%option noyywrap

%%

END					{yylval.str = strdup(yytext); return END; }
;					{return END_STATEMENT; }
line 					{yylval.str = strdup(yytext); return LINE; }
point 					{yylval.str = strdup(yytext); return POINT; }
circle 					{yylval.str = strdup(yytext); return CIRCLE; }
rectangle				{yylval.str = strdup(yytext); return RECTANGLE; }
set_color				{yylval.str = strdup(yytext); return SET_COLOR; }
[ ] 					{return SPACE; }
[\t]					{return TAB; }
[\s]					{return NEW; }	
[0-9]+|[-][0-9]		                {yylval.i = atoi(yytext); return INT; }
[0-9]+[\.][0-9]+|[-][0-9]+[\.][0-9]+	{yylval.f = strtof(yytext, NULL); return FLOAT; }	
(^line|^point|^circle|^rectangle|^set_color|^END|^;|[^ ]|[^\t]|[^\n]|[^\s+]|[^\^]|[^\$]|^[0-9]+){1}	{yylval.str = strdup(yytext); return MATCH; }

%%
