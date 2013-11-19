%{ open Ast %}

%token LPAREN RPAREN LBRACE RBRACE LBRACK 
%token RBRACK SEMI COLON COMMA QUOTE PLUS MINUS 
%token TIMES DIVIDE PERCENT
%token TIE COMMENT FUNC MAIN

%token ASSIGN OR AND EQ NEQ LT LEQ GT GEQ NOT
%token IF ELSE FOR WHILE RETURN
%token INT DBL PITCH SOUND VOID EOF

%token TRUE FALSE

%token <int> INT_LIT

%token <float> DBL_LIT
%token <string> S_LIT
%token <string> P_LIT
%token <string> ID

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
%left AND OR
%left LT GT LEQ GEQ EQ NEQ
%left PLUS MINUS
%left TIMES DIVIDE PERCENT

%type <Ast.program> program
%start program

%%
expr:
    INT_LIT                             { Int($1) }
    | DBL_LIT                           { Dbl($1) }
    | ID                                { Id($1) }
    | LPAREN MINUS expr RPAREN          { Neg($3) } 
    | NOT LPAREN expr RPAREN            { Not($3) }  
    | expr PLUS expr                    { Binop($1, Add, $3) }
    | expr MINUS expr                   { Binop($1, Sub, $3) }
    | expr TIMES expr                   { Binop($1, Mult, $3) }
    | expr DIVIDE expr                  { Binop($1, Div, $3) }
    | expr PERCENT expr                 { Binop($1, Mod , $3) }
    | expr LT expr                      { Binop($1, Lt  , $3) }
    | expr GT expr                      { Binop($1, Gt  , $3) }
    | expr LEQ expr                     { Binop($1, Leq , $3) }
    | expr GEQ expr                     { Binop($1, Geq , $3) }
    | expr EQ expr                      { Binop($1, Eq  , $3) }
    | expr AND expr                     { Binop($1, And , $3) }
    | expr OR expr                      { Binop($1, Or  , $3) }
    | ID ASSIGN expr                    { Assign($1, $3)      }
   /* | LPAREN expr RPAREN                { Expr($2)            } */
    | ID LPAREN actuals_opt RPAREN      { Call($1, $3)        }
    | ID LBRACK expr RBRACK             { Array($1, $3)       }


 program: 
    /* nothing */        { [] }
    /*| program vdecl { ($2 :: fst $1), snd $1 }*/
    | program fdecl { $2 :: $1 }


fdecl:
     typeConst ID LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
                    { { 
                        rtype = $1;
                        fname = $2;
                        formals = $4;
                        locals = List.rev $7; 
                        body = List.rev $8 } }
                        
                        /*
                        body = List.rev $8 } } */
/*reduced 4 rules?*/

formals_opt:
                            { [] }
    | formal_list           { List.rev $1 } 

formal_list:
    formal_decl                         { [$1] }
    | formal_list COMMA formal_decl     { $3 :: $1 }

formal_decl: typeConst ID { { formtype = $1; formname = $2 } }

 
typeConst:
    INT                     { Integer }
    | DBL                   { Double }
    | VOID                  { Void }
    | PITCH                 { Pitch }
    | SOUND                 { Sound }

stmt_list:
    { [] }
    | stmt_list stmt          { $2 :: $1 }


stmt:
    expr SEMI                                       { Expr($1) } 
/* 
    | RETURN expr SEMI                              { Return($2) }
    | LBRACE stmt_list RBRACE                       { Block(List.rev $2) }
    | IF LPAREN expr RPAREN stmt %prec NOELSE       { If($3, $5, Block([])) }
    | IF LPAREN expr RPAREN stmt ELSE stmt          { If($3, $5, $7) }
    | WHILE LPAREN expr RPAREN stmt                 { While($3, $5) }

*/

 
vdecl: typeConst ID SEMI { { varname = $2; vartype = $1 } }

vdecl_list:
         { [] }
  | vdecl_list vdecl { $2 :: $1 }

actuals_opt: 
       { [] }
    | actuals_list  {List.rev $1}
    

actuals_list:
    expr                        { [$1] }
    | actuals_list COMMA expr   { $3 :: $1 } 