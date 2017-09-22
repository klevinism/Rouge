// Define a grammar called Hello
grammar GYOO;
program   : 'begin' block+ 'end';

block
	: statement+
	;

statement 
	: assign
	| print 
	| if_statement
	| while_statement
	| for_statement
	| switch_statement
	| OTHER {System.err.println("unknown text: " + $OTHER.text);}
	;

assign    
	: 'let' ID 'be'? expression? 
	;
	
print     
	: print_exp atom? 
	;
	
print_exp
	: PRINT
	| PRINTLN
	;
	 
if_statement
	: 'if' condition_block (ELSE IF condition_block)* (ELSE stat_block)?
	;
	
while_statement
	: 'while' OPAR? expression*  CPAR? 'do' stat_block 
	;
	
for_statement
	: 'for' OPAR? assign SCOL expression SCOL stat_block CPAR? 'do' stat_block 
	;
	
switch_statement
	: 'switch' expression* 'do' OBRACE switch_expression+ CBRACE
	;
	 	
switch_expression
	:	'case' expression ':' stat_block
	|	'default' ':' statement
	;
	
condition_block
 	: expression stat_block
 	;
 	
stat_block
 	: OBRACE (block | expression) CBRACE
 	| statement
 	;
 	 	
expression
 	: NOT expression                             	 	#notExpr
	| expression op=(MULT | DIV | MOD) expression       	#multiplicationExpr
 	| expression op=(PLUS | MINUS) expression           	#additiveExpr
 	| expression op=(LTEQ | GTEQ | LT | GT) expression  	#relationalExpr
 	| expression op=(EQ | NEQ) expression               	#equalityExpr
 	| expression AND expression                         #andExpr
 	| expression OR expression                          #orExpr
 	| atom                                 				#atomExpr 	
  	;


atom
 	: OPAR expression CPAR  #parExpr
 	| (NUMBER | FLOAT)  	#numberAtom
 	| (TRUE | FALSE) 		#booleanAtom
 	| ID             		#idAtom
 	| STRING         		#stringAtom
 	| NULL           		#nullAtom
	;

IMPORT : 'import';
INCLUDE : 'include';
OR : 'or';
AND : 'and';
EQ : 'is'; 				//'=='
NEQ : 'is not'; 		//'!='
GT : 'greater'; 		//'>'
LT : 'lower';			//'<'
GTEQ : 'is greater';	//'>=' 
LTEQ : 'is lower';		//'<='
SCOL : ';';

PLUS : '+';
MINUS : '-';
MULT : '*';
DIV : '/';
MOD : '%';
POW : '^';
NOT : 'not';
PRINT : 'print';
PRINTLN : 'println';


ASSIGN : '=';
OPAR : '(';
CPAR : ')';
OBRACE : '{';
CBRACE : '}';

TRUE : 'true';
FALSE : 'false';
NULL : 'null';
IF : 'if';
ELSE : 'else';

WS : (' ' | '\t' | '\r' | '\n') + -> skip;
ID     : [a-z]+;
NUMBER : [0-9]+ ;
FLOAT
 : [0-9]+ '.' [0-9]* 
 | '.' [0-9]+
 ;

STRING
 : '"' (~["\r\n] | '""')* '"'
 ;
 
COMMENT
    :   '/*' .*? '*/' -> channel(HIDDEN)
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> channel(HIDDEN)
    ;
OTHER
 : . 
 ;
