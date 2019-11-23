%token WHILE FOR IF ELSE AT SEND_DATA GET_DATA READ_CONSOLE PRINT RETURN BOOL INT STRING FLOAT AND OR DEF BOOL_LIT_TRUE BOOL_LIT_FALSE FLOAT_LIT STRING_LIT URL UNSIGNED_INTEGER SIGNED_INTEGER SENSOR CONNECTION ACTUATOR TIMESTAMP VAR LP RP LB RB COMMA COMMENT ASSIGN_OP EQUAL NOT_EQUAL GREATER_EQUAL LESS_EQUAL GREATER_THAN LESS_THAN ADD SUBTRACT MULTIPLY DIVIDE 
%%
program: stmt_list { printf("Valid input\n"); return 0; };
stmt_list: empty | stmt_list stmt;
stmt: assign_stmt | declare_stmt | while_stmt | func_call | io_stmt | comment | if_stmt | for_stmt;
if_stmt: matched | unmatched;
matched: IF LP logic_expr RP LB stmt_list RB ELSE LB stmt_list RB;
unmatched: IF LP logic_expr RP LB stmt_list RB;
declare_stmt: connection_stmt | sensor_stmt | func_dec | actuator_stmt | type var_name | type assign_stmt;
connection_stmt: connection var_name LP url RP;
sensor_stmt: sensor var_name LP conn_param RP;
conn_param: var_name at LP port_name RP;
actuator_stmt: actuator var_name LP conn_param RP;
port_name: unsigned_integer | var_name;
url: var_name | URL;
io_stmt: input_stmt | output_stmt;
input_stmt: READ_CONSOLE LP var_name RP;
output_stmt: PRINT LP var_name RP | PRINT LP literal RP;
while_stmt: WHILE LP logic_expr RP LB stmt_list RB;
for_stmt: FOR LP type var_name assign_op literal COMMA logic_expr COMMA  assign_stmt RP LB stmt_list RB
func_dec:  def var_name LP var_list_i RP LB LP stmt_list RETURN var_name RP RB
            | def var_name LP var_list_i RP LB LP stmt_list RETURN literal RP RB
            | def var_name LP var_list_i RP LB LP stmt_list RETURN RP RB;
var_list_i: empty | nonemp_var_list_i;
nonemp_var_list_i: type var_name | connection var_name | actuator var_name | sensor var_name
                  | nonemp_var_list_i COMMA type var_name 
                  | nonemp_var_list_i COMMA sensor var_name 
                  | nonemp_var_list_i COMMA actuator var_name 
                  | nonemp_var_list_i COMMA connection var_name;
var_list_ii: empty | nonemp_var_list_ii;
nonemp_var_list_ii: var_name | literal | nonemp_var_list_ii COMMA var_name | nonemp_var_list_ii COMMA literal;
func_call: var_name send_data LP unsigned_integer RP | var_name send_data LP SIGNED_INTEGER RP|
           var_name get_data LP RP | var_name LP var_list_ii RP;
assign_stmt: var_name assign_op expression;
expression: expression add_op item | expression sub_op item | item;
item: item mult_op basic_item | item div_op basic_item | timestamp | basic_item;
basic_item: literal | var_name | func_call | LP expression RP;
timestamp: TIMESTAMP LP RP;
literal: STRING_LIT | unsigned_integer | SIGNED_INTEGER | BOOL_LIT_TRUE | BOOL_LIT_FALSE | FLOAT_LIT;
at: AT;
unsigned_integer: UNSIGNED_INTEGER;
send_data: SEND_DATA;
get_data: GET_DATA;
sensor: SENSOR LESS_THAN type GREATER_THAN;
connection: CONNECTION;
actuator: ACTUATOR;
var_name: VAR;
assign_op: ASSIGN_OP;
add_op: ADD;
def: DEF;
sub_op: SUBTRACT;
div_op: DIVIDE;
mult_op: MULTIPLY;
comment: COMMENT;
type: INT | BOOL | STRING | FLOAT;
empty: ;
logic_expr: expression logic_op expression;
logic_op: AND | OR | GREATER_THAN | LESS_THAN | GREATER_EQUAL | LESS_EQUAL | EQUAL | NOT_EQUAL;
%%
#include "lex.yy.c"
int yyerror(char* s){
  fprintf(stderr, "%s at line %d\n",s, yylineno);
  return 1;
}
int main(){
 return yyparse();
}