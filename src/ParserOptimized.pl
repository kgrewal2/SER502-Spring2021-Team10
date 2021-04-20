:- table expression_level_1/3, expression_level_2/3, expression_level_3/3.

% START SYMBOL
program(t_program(P)) -->
    command_list(P).

% BLOCK
block(t_block(CommandList)) -->
    ['{'],
    command_list(CommandList),
    ['}'].

% COMMAND LIST
command_list(t_command_list(Command, CommandList)) -->
    command(Command),
    command_list(CommandList).
command_list(t_command(Command)) -->
    command(Command).

% COMMAND
command(C) -->
    assignment_command(C) |
    for_enhanced_command(C) |
    for_loop_command(C) |
    if_command(C) |
    print_command(C) |
    variable_declaration_command(C) |
    while_loop_command(C).

% IF, ELIF, ELSE - COMMAND
if_command(t_if_command(IfTree)) -->
    if_part(IfTree).
if_command(t_if_command(IfTree, ElifTree, ElseTree)) -->
    if_part(IfTree),
    elif_part(ElifTree),
    else_part(ElseTree).
if_command(t_if_command(IfTree, ElseTree)) -->
    if_part(IfTree),
    else_part(ElseTree).

% IF, ELIF, ELSE - PARTS
if_part(t_if(Condition, Block)) -->
    [if],
    condition(Condition),
    block(Block).
elif_part(t_elif(Condition, Block)) -->
    [elif],
    condition(Condition),
    block(Block).
elif_part(t_elif(Condition, Block, ElifPart)) -->
    [elif],
    condition(Condition),
    block(Block),
    elif_part(ElifPart).
else_part(t_else(Block)) -->
    [else],
    block(Block).

print_command(t_print(Expression)) --> [print], ['('], expression(Expression), [')'], end_of_command(_).

variable_declaration_command(t_variable_declaration_command(Type, Name)) -->
    variable_type(Type),
    variable_name(Name),
    end_of_command(_).
variable_declaration_command(t_variable_declaration_command(Type, Name, Expression)) -->
    variable_type(Type),
    variable_name(Name),
    assignment_operator(_),
    expression(Expression),
    end_of_command(_).

assignment_command(Expression) -->
    assignment_expression(Expression),
    end_of_command(_).

for_loop_command(t_for_loop_command(Assignment, Condition, VariableChangePart, Block)) -->
    [for],
    ['('],
    assignment_expression(Assignment), [;],
    condition(Condition), [;],
    variable_change_part(VariableChangePart),
    [')'],
    block(Block).

variable_change_part(Expression) -->
    increment_expression(Expression) |
    decrement_expression(Expression).
variable_change_part(Expression) -->
    assignment_expression(Expression).

while_loop_command(t_while_command(Condition, Block)) -->
    [while],
    ['('],
    condition(Condition),
    [')'],
    block(Block).

for_enhanced_command(t_for_enhanced_command(Variable, Expression1, Expression2, Block)) -->
    [for],
    variable_name(Variable),
    [in],
    [range],
    ['('],
    expression(Expression1),
    [; ],
    expression(Expression2),
    [')'],
    block(Block).

range_value(Value) --> variable_name(Value) | integer_value(Value).

condition(t_condition(Expression1, Comparison_Operator, Expression2)) -->
    expression(Expression1),
    comparison_operator(Comparison_Operator),
    expression(Expression2).

% EXPRESSIONS (HIGHER THE LEVEL OF EXPRESSION, HIGHER THE PRECEDENCE OF OPERATOR)
expression(t_expression(Expression)) --> expression_level_1(Expression).

expression_level_1(t_add(X, Y)) --> expression_level_1(X), [+], expression_level_2(Y).
expression_level_1(t_sub(X, Y)) --> expression_level_1(X), [-], expression_level_2(Y).
expression_level_1(X) --> expression_level_2(X).

expression_level_2(t_multiply(X, Y)) --> expression_level_2(X), [*], expression_level_3(Y).
expression_level_2(t_divide(X, Y)) --> expression_level_2(X), [/], expression_level_3(Y).
expression_level_2(t_boolean_expression(X, Operator, Y)) --> expression(X), boolean_operator(Operator), expression(Y).
expression_level_2(X) --> expression_level_3(X).

expression_level_3(X) --> ['('], expression(X), [')'].
expression_level_3(X) -->
    ternary_expression(X) |
    variable_name(X) |
    value(X).

ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('],
    condition(Condition),
    ['?'],
    expression(TrueExpression),
    [':'],
    expression(FalseExpression),
    [')'].

assignment_expression(t_assignment_expression(Name, Expression)) -->
    variable_name(Name),
    assignment_operator(_),
    expression(Expression).

% NOT TESTED
value(Variable) -->
    integer_value(Variable) |
    float_value(Variable) |
    string_value(Variable) |
    boolean_value(Variable).

decrement_expression(t_post_decrement(Variable)) --> variable_name(Variable), [--].
decrement_expression(t_pre_decrement(Variable)) --> [--], variable_name(Variable).
increment_expression(t_post_increment(Variable)) --> variable_name(Variable), [++].
increment_expression(t_pre_increment(Variable)) --> [++], variable_name(Variable).

%%%%%%%%%%%%%
% TERMINALS %
%%%%%%%%%%%%%

% CHECKS IF THE VARIABLE NAME HAS ALLOWED CHARACTERS, AND VARIABLE NAME IS NOT A KEYWORDS
variable_name(t_variable_name(Variable), [Variable | Tail], Tail) :-
    atom(Variable), not_keyword(Variable).

not_keyword(Variable) :-
    not(member(Variable, [int, float, bool, string, true, false, for,
    if, elif, else, while, range, and, or, not, in, range, <, >, <=, >=, ==,
    '!=', ++, --, +, -, *, /])).

variable_type(t_variable_type(Head), [Head | T], T) :-
    member(Head, [int, float, bool, string]).

comparison_operator(t_comparison_operator(Head), [Head | T], T) :-
    member(Head, [<, >, <=, >=, ==, '!=']).

integer_value(t_integer(Variable), [Variable | Tail], Tail) :- integer(Variable).
float_value(t_float(Variable), [Variable | Tail], Tail) :- float(Variable).
string_value(t_string(Variable), [Variable | Tail], Tail) :- string(Variable).
boolean_value(t_boolean(Value), [Value | Tail], Tail) :- member(Value, [true, false]).

assignment_operator(t_assignment_operator) --> [=].
end_of_command(t_end_of_command) --> [;].

boolean_operator(t_boolean_operator(Operator), [Operator | Tail], Tail) :-
    member(Operator, [and, or, not]).

% HELPER PREDICATE FOR TESTING - IS EXPECTED TO PARSE EVERY GRAMMAR RULE
parse(T, L) :- assignment_command(T, L, []);assignment_expression(T, L, []);assignment_operator(T, L, []);block(T, L, []);command(T, L, []);command_list(T, L, []);condition(T, L, []);decrement_expression(T, L, []);elif_part(T, L, []);else_part(T, L, []);end_of_command(T, L, []);expression(T, L, []);expression_level_1(T, L, []);expression_level_2(T, L, []);expression_level_3(T, L, []);for_enhanced_command(T, L, []);for_loop_command(T, L, []);if_command(T, L, []);if_part(T, L, []);increment_expression(T, L, []);print_command(T, L, []);program(T, L, []); ternary_expression(T, L, []);value(T, L, []);variable_change_part(T, L, []);variable_declaration_command(T, L, []);while_loop_command(T, L, []);variable_name(T, L, []);variable_type(T, L, []);comparison_operator(T, L, []);integer_value(T, L, []);float_value(T, L, []);string_value(T, L, []);boolean_value(T, L, []);boolean_operator(T, L, []).


%%%%%%%%%%%
% TESTING %
%%%%%%%%%%%

% BOOLEAN OPERATOR
?- parse(t_boolean_operator(and) , [and]).
?- parse(t_boolean_operator(or) , [or]).
?- parse(t_boolean_operator(not) , [not]).

% END OF COMMAND
?- parse(t_end_of_command, [;]).

% ASSIGNMENT OPERATOR
?- parse(t_assignment_operator, [=]).

% VARIABLE VALUE
?- parse(t_boolean(true)             , [true]).
?- parse(t_boolean(false)             , [false]).
?- parse(t_string("This is a string with \" '' ") , ["This is a string with \" '' "]).
?- parse(t_float(12.3)              , [12.3]).
?- parse(t_integer(12)              , [12]).

% COMPARISON OPERATOR
?- parse(t_comparison_operator(<)  , [<]).
?- parse(t_comparison_operator(>)  , [>]).
?- parse(t_comparison_operator(>=)  , [>=]).
?- parse(t_comparison_operator(<=)  , [<=]).
?- parse(t_comparison_operator('!=') , ['!=']).

% VARIABLE TYPE
?- parse(t_variable_type(int)  , [int]).
?- parse(t_variable_type(float) , [float]).
?- parse(t_variable_type(bool)  , [bool]).
?- parse(t_variable_type(string) , [string]).

% VARIABLE NAME
?- parse(t_variable_name(variableName) , [variableName]).
?- parse(t_variable_name(variable_name) , [variable_name]).

% INCREMENT AND DECREMENT OPERATORS
?- parse(t_post_increment(t_variable_name(x)) , [x , ++]).
?- parse(t_pre_increment(t_variable_name(x)) , [++ , x]).
?- parse(t_post_decrement(t_variable_name(x)) , [x , --]).
?- parse(t_pre_decrement(t_variable_name(x)) , [-- , x]).

% ASSIGNMENT EXPRESSION
?- parse(t_assignment_expression(t_variable_name(x) , t_expression(t_string("String"))) , [x , = , "String"]).
?- parse(t_assignment_expression(t_variable_name(x) , t_expression(t_integer(12)))   , [x , = , 12]).
?- parse(t_assignment_expression(t_variable_name(x) , t_expression(t_float(12.3)))   , [x , = , 12.3]).
?- parse(t_assignment_expression(t_variable_name(x) , t_expression(t_boolean(true)))  , [x , = , true]).
?- parse(t_assignment_expression(t_variable_name(x) , t_expression(t_boolean(false)))  , [x , = , false]).

% TERNARY EXPRESSION
?- parse(t_expression(t_ternary_expression(t_condition(t_expression(t_variable_name(x)), t_comparison_operator((<)), t_expression(t_integer(3))), t_expression(t_add(t_integer(3), t_integer(2))), t_expression(t_sub(t_integer(2), t_integer(1))))), ['(', x, <, 3, '?', 3, +, 2, ':', 2, -, 1, ')']).
?- parse(t_ternary_expression(t_condition(t_expression(t_variable_name(x)), t_comparison_operator((<)), t_expression(t_integer(3))), t_expression(t_add(t_integer(3), t_integer(2))), t_expression(t_add(t_string("Yes"), t_string("No")))), ['(', x, <, 3, '?', 3, +, 2, ':', "Yes", +, "No", ')']).

% EXPRESSION - PENDING
?- parse(t_expression(t_sub(t_add(t_integer(1), t_multiply(t_integer(2), t_integer(3))), t_integer(4))), [1, +, 2, *, 3, -, 4]).
?- parse(t_expression(t_sub(t_add(t_integer(1), t_multiply(t_integer(2), t_integer(3))), t_multiply(t_integer(4), t_expression(t_divide(t_divide(t_integer(3), t_integer(2)), t_integer(10)))))), [1, +, 2, *, 3, -, 4, *, '(', 3, /, 2, /, 10, ')']).
?- parse(t_expression(t_sub(t_add(t_integer(1), t_multiply(t_ternary_expression(t_condition(t_expression(t_variable_name(x)), t_comparison_operator((>)), t_expression(t_integer(2))), t_expression(t_string("Hello")), t_expression(t_string("Bye"))), t_integer(3))), t_multiply(t_integer(4), t_expression(t_divide(t_divide(t_integer(3), t_integer(2)), t_integer(10)))))), [1, +, '(', x, >, 2, '?', "Hello", ':', "Bye", ')', *, 3, -, 4, *, '(', 3, /, 2, /, 10, ')']).

% CONDITION
?- parse(t_condition(t_expression(t_add(t_integer(3), t_integer(2))), t_comparison_operator((>)), t_expression(t_sub(t_integer(5), t_integer(2)))), [3, +, 2, >, 5, -, 2]).
?- parse(t_condition(t_expression(t_variable_name(x)), t_comparison_operator((>)), t_expression(t_integer(2))), [x, > , 2]).

% PRINT COMMAND
?- parse(t_print(t_expression(t_add(t_integer(2), t_integer(3)))), [ print, '(', 2, +, 3, ')', ';']).
?- parse(t_print(t_expression(t_string("Hello World"))), [ print, '(', "Hello World",')', ';']).

% VARIABLE DECLARATION COMMAND
?- parse(t_variable_declaration_command(t_variable_type(int), t_variable_name(x), t_expression(t_integer(3))), [int, x, =, 3, ';']).
?- parse(t_variable_declaration_command(t_variable_type(int), t_variable_name(x)), [int, x,';']).

% VARIABLE ASSIGNMENT EXPRESSION
?- parse(t_assignment_expression(t_variable_name(x), t_expression(t_add(t_integer(12), t_integer(12)))), [ x, =, 12, +, 12]).
?- parse(t_assignment_expression(t_variable_name(x), t_expression(t_add(t_integer(12), t_integer(12)))), [ x, =, 12, +, 12, ;]).

% PRINT COMMAND
?- parse(t_print(t_expression(t_add(t_integer(2), t_integer(1)))), [print, '(', 2, +, 1, ')', ;]).

% FOR ENHANCED COMMAND
?- parse( t_for_enhanced_command(t_variable_name(i), t_expression(t_add(t_integer(2), t_integer(2))), t_expression(t_integer(3)), t_block(t_command_list(t_print(t_expression(t_add(t_integer(2), t_integer(1)))), t_command(t_assignment_expression(t_variable_name(x), t_expression(t_add(t_integer(2), t_integer(3)))))))), [for, i, in, range, '(', 2, +, 2, ;, 3, ')', '{', print, '(', 2, +, 1, ')', ;, x, =, 2, +, 3, ;, '}']).

% WHILE COMMAND
?- parse( t_while_command(t_condition(t_expression(t_variable_name(x)), t_comparison_operator((>)), t_expression(t_integer(20))), t_block(t_command_list(t_print(t_expression(t_add(t_integer(2), t_integer(1)))), t_command(t_assignment_expression(t_variable_name(x), t_expression(t_add(t_integer(2), t_integer(3)))))))), [while, '(', x, >, 20, ')', '{', print, '(', 2, +, 1, ')', ;, x, =, 2, +, 3, ;, '}']).

% FOR COMMAND
?- parse( t_for_loop_command(t_assignment_expression(t_variable_name(i), t_expression(t_integer(0))), t_condition(t_expression(t_variable_name(i)), t_comparison_operator((<)), t_expression(t_add(t_integer(3), t_integer(1)))), t_post_increment(t_variable_name(i)), t_block(t_command_list(t_print(t_expression(t_add(t_integer(2), t_integer(1)))), t_command(t_assignment_expression(t_variable_name(x), t_expression(t_add(t_integer(2), t_integer(3)))))))), [for, '(', i, =, 0, ;, i, <, 3, +, 1, ;, i, ++, ')', '{', print, '(', 2, +, 1, ')', ;, x, =, 2, +, 3, ;, '}']).




