%{
    #include <cstdio>
    #include <iostream>
    #include <string>
    #include <unordered_map>

    #include "funcTab.h"
    #include "quadruples.h"


    #define YYERROR_VERBOSE 1
    using namespace std;
//     #include "lex.yy.c"
    extern int yylineno;
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;

    SymTab *currScope;
    SymTab global;

    FuncTab functions;

    void yyerror(const char *s);
//     int yywrap();
%}

%union{
    char* id;
    int value;
    int dir;

//     FunctionEntry funcScope;
}

%token PROGRAM VAR CLASS INHERIT MAIN
%token INT FLOAT STRING CHAR
%token FUN VOID RETURN
%token IF ELIF ELSE
%token WHILE FOR
%token READ WRITE
%token  CTE_INT CTE_FLT
%token CTE_CHR CTE_STR
%token <id>ID
%token DOT COMMA CLN SMCLN
%token ADD SUB MULT DIV
%token G_ET L_ET EQ NEQ GT LT ASGN
%token LP RP LCB RCB LSB RSB
%token OR AND
// %token WS

%left ADD SUB MULT DIV
%right G_ET L_ET EQ NEQ GT LT ASGN
//
// %type<dir> VAR_CTE

%%
PROGRAMA: PROGRAM ID SMCLN {
    global = SymTab("global", "global var table");
    currScope = &global;
    functions = FuncTab($2);
} DEC_CLASES DEC_ATRIBUTOS DEC_METODOS DEC_MAIN;

DEC_CLASES: CLASE DEC_CLASES
| ;

CLASE: CLASS ID CLASE_HEREDA {cout << "encontrada clase " << $2 << "\n";} LCB DEC_ATRIBUTOS DEC_METODOS RCB;

CLASE_HEREDA: INHERIT ID
| ;

DEC_ATRIBUTOS: VARIABLES DEC_ATRIBUTOS
| ;

DEC_MAIN: MAIN {
    functions.addFuncTable("main", 'v', "main");

    SymTab tempScope = functions.getFunction("main").getVarTab();
    currScope = &tempScope;
}
LP RP LCB ESTATUTOS RCB;

VARIABLES: VAR TIPO_SIMPLE ID VAR_ARR VAR_MULTIPLE SMCLN {
    currScope->add($3, "var", "dfs", "global", yylineno);
}
| VAR ID ID VAR_ARR VAR_MULTIPLE SMCLN;

VAR_ARR: LSB CTE_INT RSB VAR_MAT
| ;

VAR_MAT: LSB CTE_INT RSB
| ;

VAR_MULTIPLE: COMMA ID VAR_ARR VAR_MULTIPLE
| ;

TIPO_SIMPLE: INT
|FLOAT
|STRING
|CHAR;

DEC_METODOS: FUNCION DEC_METODOS
| ;

FUNCION: FUN TIPO_SIMPLE ID LP PARAMETROS RP LCB DEC_ATRIBUTOS ESTATUTOS RCB
| FUN VOID ID LP PARAMETROS RP LCB DEC_ATRIBUTOS ESTATUTOS RCB;

PARAMETROS: TIPO_SIMPLE ID PARAMETROS_MULTIPLE
| ;

PARAMETROS_MULTIPLE: COMMA PARAMETROS
| ;

ESTATUTOS: ESTATUTO ESTATUTOS
| ;

ESTATUTO: VARIABLES
| ASIGNA SMCLN
| LLAMADA SMCLN
| LEE SMCLN
| ESCRIBE SMCLN
| CONDICIONAL
| CICLO_WH
| CICLO_FOR
| RT SMCLN;

RT: RETURN EXP;

ASIGNA: VARIABLE ASGN EXP;

LLAMADA: FUNC_ID LP PONER_PARAM RP;

FUNC_ID: ID
| ID DOT ID;

PONER_PARAM: EXP {cout<<"parametro 1 encontrado " ;} LLAMADA_MULTIPLE
| ;

LLAMADA_MULTIPLE: COMMA EXP LLAMADA_MULTIPLE
| ;

LEE: READ LP VARIABLE RP;

ESCRIBE: WRITE LP EXP ESCRIBE_MULTIPLE RP
| WRITE LP CTE_STR ESCRIBE_MULTIPLE RP;

ESCRIBE_MULTIPLE: COMMA EXP ESCRIBE_MULTIPLE
| COMMA CTE_STR ESCRIBE_MULTIPLE
| ;

CONDICIONAL: IF LP EXP RP LCB ESTATUTOS RCB COND_ELIF COND_ELSE;

COND_ELIF: ELIF LP EXP RP LCB ESTATUTOS RCB COND_ELIF
| ;

COND_ELSE: ELSE LCB ESTATUTOS RCB
| ;

CICLO_WH: WHILE LP EXP RP LCB ESTATUTOS RCB ;

CICLO_FOR: FOR LP INIT SMCLN EXP SMCLN STEP RP LCB ESTATUTOS RCB ;

INIT: VARIABLE ASGN EXP
| VARIABLE ;

STEP: VARIABLE ASGN EXP;

VARIABLE: ID VARIABLE_COMP;

VARIABLE_COMP: LSB EXP RSB VARIABLE_MAT
| DOT ID
| ;

VARIABLE_MAT: LSB EXP RSB
| ;
// PROGRAMA: PROG ID SMCLN VARS BLOQUE
// | PROG ID SMCLN BLOQUE;
//
// VARS: VAR ID VARS2 CLN TIPO SMCLN VARS3 ;
// VARS2: COMMA ID VARS2
// | ;
// VARS3: ID VARS2 CLN TIPO SMCLN VARS3
// | ;
//
// BLOQUE: LCB ESTATUTO BLOQUE2 RCB;
// BLOQUE2: ESTATUTO BLOQUE2
// | ;
//
// TIPO : INT | FLOAT;
//
// ESTATUTO: ASIGNACION
// | CONDICION
// | ESCRITURA;
//
// ASIGNACION: ID ASGN EXPRESION SMCLN;
//
// CONDICION: IF LP EXPRESION RP BLOQUE CONDICION2 SMCLN;
// CONDICION2: ELSE BLOQUE
// | ;
//
// ESCRITURA: PRINT LP EXPRESION ESCRITURA2 RP SMCLN
// | PRINT LP STRING_CONST ESCRITURA2 RP SMCLN;
// ESCRITURA2: EXPRESION ESCRITURA2
// | STRING_CONST ESCRITURA2
// | ;

COMPARATOR: G_ET
|L_ET
|EQ
|NEQ
|GT
|LT;

ARIT_SUM_RES: ADD
| SUB;

ARIT_MULT_DIV: MULT
| DIV;

EXP: EXP_AND EXP_1;
EXP_1: OR EXP
| ;

EXP_AND: EXP_OPREL EXP_AND_1;
EXP_AND_1: AND EXP_AND
| ;

EXP_OPREL: EXP_ARIT EXP_OPREL_1;
EXP_OPREL_1: COMPARATOR EXP_OPREL
| ;

EXP_ARIT: TERMINO EXP_ARIT_1;
EXP_ARIT_1: ARIT_SUM_RES TERMINO //EXP_ARIT_1
| ;

TERMINO: FACTOR TERMINO_1;
TERMINO_1: ARIT_MULT_DIV FACTOR //TERMINO_1
| ;

FACTOR: LP EXP RP
| SIGNO VAR_CTE
| SIGNO VARIABLE
| SIGNO LLAMADA;

VAR_CTE: CTE_INT | CTE_FLT | CTE_CHR;

SIGNO: SUB
| ;
%%

int main(int, char** c){
//     cout << c[1] << endl;
    FILE *myfile = fopen(c[1], "r");
    if(!myfile){
        cout << "Can't open file" << endl;
        return -1;
    }

//     global.getTable();

    yyin = myfile;
    yyparse();

//     std::unordered_map<std::string, Entry> table = global.getTable();
//     for(auto& it: table){
//         cout << it.second.getID() << '\n';
//     }

    std::unordered_map<std::string, Entry> tableFunctions = functions.getFunction("main").getVarTab().getTable();

    for(auto& it: tableFunctions){
        cout << it.second.getID() << '\n';
    }
    return 0;
}

void yyerror(const char *s){
    cout << "parsing error: " << s << " on line: " << yylineno << endl;

    exit(-1);
}

void createQuad(std::string command, std::string op1, std::string op2, std::string res){
    cout << command << " " << op1 << " " << op2 << " " << res << '\n';
}
