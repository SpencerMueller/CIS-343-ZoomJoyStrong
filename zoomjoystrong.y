%{
	//headers
	#include <stdio.h>
	#include "zoomjoystrong.h"
	//error message declaration
	void yyerror(const char* msg);
	//yylex int
	int yylex();
	//command counter initialization
	int commandCount = 0;
	
%}

//parse error verbose
%define parse.error verbose
//starting the program
%start zoomjoystrong

//union of int char and float for tokens
%union {int i; char* str; float f; }

/*
*END token is the ending statement of the programs and exits gracefully (string)
*END_STATEMENT token is the ; token at the end of each statement (string)
*POINT is the point command to create a point (string)
*LINE is the line command to create a line (string)
*CIRCLE is the circle command to create a circle (string)
*RECTANGLE is the rectangle command to create a rectangle (string)
*SET_COLOR is the set_color command to set the RGB colors (string)
*INT is the integer which the user enters to select size (int)
*FLOAT is the float which the user enters to select size (float)
*SPACE TAB and FLOAT are all spacers within the commands (string)
*MATCH means the there is a match of not being a command (string)
*/

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT
%token SPACE
%token TAB
%token NEW
%token MATCH 

%type <str> END
%type <str> END_STATEMENT
%type <str> POINT
%type <str> LINE
%type <str> CIRCLE
%type <str> RECTANGLE
%type <str> SET_COLOR
%type <i> INT
%type <f> FLOAT
%type <str> SPACE
%type <str> TAB
%type <str> NEW
%type <str> MATCH

%%


//the start of the program list and END for when to exit
zoomjoystrong: statement_list END {exit(0);}
;

//a statement or a statement followed by a list of statements
statement_list: statement
	      | statement statement_list 
;

//a statement can be a line, point, circle, rectange, set_color or nocommand command
statement: linecommand END_STATEMENT
	 | pointcommand END_STATEMENT
	 | circlecommand END_STATEMENT
	 | rectanglecommand END_STATEMENT
	 | set_colorcommand END_STATEMENT
	 | notcommand
;

//linecommand will take in line, then ints and spacers and plot a line from point xy to point uv and check to see if negative
linecommand: LINE spacer INT spacer INT spacer INT spacer INT {printf("Plots a %s from x = %d, y = %d to u = %d, v = %d.\n", $1, $3, $5, $7, $9); commandCount++; if($3 < 0 | $5 < 0 | $7 < 0 | $9 < 0){yyerror("Cannot be a negative number when drawing!");} else{line($3, $5, $7, $9);}}
;

//pointcommand will take in a point, then ints and spacers and plot a line at xy and check to see if negative
pointcommand: POINT spacer INT spacer INT {printf("Plots a single %s at x = %d, y = %d.\n", $1, $3, $5); commandCount++; point($3, $5); if($3 < 0 | $5 < 0){yyerror("Cannot be a negative number when drawing!");} else{point($3, $5);}}
;

//circlecommand will take in a circle, then ints and spacers and plot a circle at xy of radius d and check to see if negative
circlecommand: CIRCLE spacer INT spacer INT spacer INT {printf("Plots a %s of radius %d around the center point at x = %d y = %d.\n", $1, $7, $3, $5); commandCount++; if($3 < 0 | $5 < 0 | $7 < 0){yyerror("Cannot be a negative number when drawing!");} else{circle($7, $3, $5);}}
;

//rectanglecommand will take in a rectangle, then ints and spacers to plot a rectangle of heigh h and width w at xy and check to see if negative
rectanglecommand: RECTANGLE spacer INT spacer INT spacer INT spacer INT{printf("Draws a %s of height h = %d and width w = %d, beginning at the top left edge x = %d, y = %d.\n", $1, $3, $5, $7, $9); commandCount++; if($3 < 0 | $5 < 0 | $7 < 0 | $9 < 0){yyerror("Cannot be a negative number when drawing!");} else{rectangle($3, $5, $7, $9);}}
;

//set_colorocmmand will take in a set_color, then ints and spacers to change the colors to the xyz tuple and check to see if negative as well as below 255
set_colorcommand: SET_COLOR spacer INT spacer INT spacer INT {printf("When called, %s changes the current drawing color to the %d %d %d tuple.\n", $1, $3, $5, $7); commandCount++; if($3 < 0 | $5 < 0 | $7 < 0){yyerror("Cannot be a negative number when drawing!");} else if($3 > 255 | $5 > 255 | $7 > 255){yyerror("RGB colors cannot excede 255 per red green or blue!");} else{set_color($3, $5, $7);}}
;

//notcommand is when there is a command followed by not a command or just not a command and will tell the user
notcommand: linecommand MATCH |
	    pointcommand MATCH |
	    circlecommand MATCH |
	    rectanglecommand MATCH |
	    set_colorcommand MATCH |
	    MATCH
	    //I was having trouble getting this to work for when I pressed enter and for multiple letters it would give this message, so I am keeping it out due to it not working
	    //{yyerror("User, this is not a command, please try again.");}
;

//spacer is a space, tab, or newline
spacer: SPACE |
      	TAB |
	NEW
;

%%

//main function
int main (int argc, char** argv){
	//sets up the drawing library
	setup();
	//=== for aesthetic
	printf("\n============================================\n");
	//parses tokens
	yyparse();
	// === and command count for aesthetic
	printf("\nYou gave %d command(s). \n============================================\n\n", commandCount);
	//return 0 when done
	return 0;
}

//yyerror, lets the  user know there is an error and gives the message of what is wrong with the language
void yyerror(const char* msg){
	//prints language invalidity to user
	fprintf(stderr, "ERROR! %s\n", msg);
}
