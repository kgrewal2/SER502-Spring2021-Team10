%%%%%%%%%%%%%%%%%
% NON-TERMINALS %
%%%%%%%%%%%%%%%%%

program --> command_list.

block --> ['{'], command_list, ['}'].

command_list --> command, command_list.
command_list --> command_without_block, command_list.
command_list --> command.
command_list --> command_without_block.

command_without_block --> print_command.
command_without_block --> assignment_command.

command --> for_loop_command.
command --> while_loop_command.
command --> for_enhanced_command.
command --> if_command.
command --> if_elif_else_command.
command --> if_else_command.

if_command --> if_statement.
if_elif_else_command --> if_statement, elif_statement, else_statement.
if_else_command --> if_statement, else_statement.

if_statement --> ['if'], ['('], condition, [')'], block.
else_statement --> ['else'], ['('], condition, [')'], block.
elif_statement --> ['elif'], ['('], condition, [')'], block.
elif_statement --> ['elif'], ['('], condition, [')'], block, elif_command.

while_loop_command --> ['while'], ['('], condition, [')'], block.

for_enhanced_command --> ['for'], variable_name, ['in'], ['range'], ['('], range_value, [','], range_value, [')'], block.

range_value --> variable_name | integer.

for_loop_command --> ['for'], ['('], assignment, [';'], condition,  [';'], variable_change_statement, [')'], block.

condition --> variable_name, comparison_operators, expression.

variable_change_statement --> increment_expression.
variable_change_statement --> decrement_expression.
variable_change_statement --> variable_name, assignment_operator, expression.

decrement_expression --> variable_name, decrement_operator.
decrement_expression --> decrement_operator, variable_name.
increment_expression --> variable_name, increment_operator.
increment_expression --> increment_operator, variable_name.

print_command --> ['print'], ['('], expression, [')'], end_of_command.

expression --> value, operator, expression.
expression --> ['('], expression, [')'], operator, expression.
expression --> value.
expression --> ternary_expression.

ternary_expression --> ['('], condition, [')'], ['?'], expression, [':'], expression.

value --> float | integer | boolean_value | string_value | variable_name.

boolean_operators --> and | or | not.

operators --> ['+'] | ['-'] | ['*'] | ['/'] | boolean_operators.

assignment_command --> assignment, end_of_command.
assignment --> variable_name, assignment_operator, expression.

variable_declaration_command --> variable_type, variable_name, end_of_command.
variable_declaration_command --> variable_type, variable_name, assignment_operator, expression, end_of_command.

variable_name --> lower_case, variable_name.
variable_name --> variable_name, upper_case.
variable_name --> variable_name, upper_case, variable_name.
variable_name --> variable_name, underscore, variable_name.
variable_name --> lower_case.

string_value --> single_quote, character_phrase, single_quote.
string_value --> double_quote, character_phrase, double_quote.

character_phrase --> character, character_phrase.
character_phrase --> character.

character --> lower_case | upper_case | digit | symbol.

float --> integer, ['.'], integer.
float --> integer.

integer --> digit, integer.
integer --> digit.

%%%%%%%%%%%%%
% TERMINALS %
%%%%%%%%%%%%%
variable_type --> ['int'] | ['float'] | ['bool'] | ['string'].

decrement_operator --> ['--'].
increment_operator --> ['++'].

comparison_operators --> ['<'], ['>'], ['<='], ['>='], ['=='], ['!='].

single_quote --> ['\''].
double_quote --> ['\"'].

lower_case --> ['a'] | ['b'] | ['c'] | ['d'] | ['e'] | ['f'] | ['g'] | ['h'] | ['i'] | ['j'] | ['k'] | ['l'] | ['m'] | ['n'] | ['o'] | ['p'] | ['q'] | ['r'] | ['s'] | ['t'] | ['u'] | ['v'] | ['w'] | ['x'] | ['y'] | ['z'].

upper_case --> ['A'] | ['B'] | ['C'] | ['D'] | ['E'] | ['F'] | ['G'] | ['H'] | ['I'] | ['J'] | ['K'] | ['L'] | ['M'] | ['N'] | ['O'] | ['P'] | ['Q'] | ['R'] | ['S'] | ['T'] | ['U'] | ['V'] | ['W'] | ['X'] | ['Y'] | ['Z'].

symbol --> [' '] | ['!'] | ['\"'] | ['#'] | ['$'] | ['%'] | ['&'] | ['\''] | ['('] | [')'] | ['*'] | ['+'] | [','] | ['-'] | ['.'] | ['/'] | [':'] | [';'] | ['<'] | ['='] | ['>'] | ['?'] | ['@'] | ['['] | ['\\'] | [']'] | ['^'] | ['_'] | ['`'] | ['{'] | ['|'] | ['}'] | ['~'].

digit --> ['0'] | ['1'] | ['2'] | ['3'] | ['4'] | ['5'] | ['6'] | ['7'] | ['8'] | ['9'].

boolean_value --> ['true'].
boolean_value --> ['false'].

assignment_operator --> [‘=’].
end_of_command --> [‘;’].

and_operator --> ['and'].
or_operator --> ['or'].
not_operator --> ['not'].
