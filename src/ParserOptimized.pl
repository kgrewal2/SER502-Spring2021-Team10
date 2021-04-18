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
    if_elif_else_command(C) |
    if_else_command(C) |
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

while_loop_command(t_while_command(Condition, Block)) -->
    ['while'],
    ['('],
    condition(Condition),
    [')'],
    block(Block).

for_enhanced_command(t_for_enhanced_command(Variable, RangeValue1, RangeValue2, Block)) -->
    ['for'],
    variable_name(Variable),
    ['('],
    range_value(RangeValue1),
    [, ],
    range_value(RangeValue2),
    [')'],
    block(Block).

range_value(Value) --> variable_name(Value) | integer_value(Value).

for_loop_command(t_for_loop_command(Assignment, Condition, VariableChangePart, Block)) -->
    [for],
    ['('],
    assignment_command(Assignment), [;],
    condition(Condition), [;],
    variable_change_part(VariableChangePart),
    [')'],
    block(Block).

variable_change_part(Expression) -->
    increment_expression(Expression) |
    decrement_expression(Expression).
variable_change_part(Expression) -->
    assignment_expression(Expression).

condition(t_condition(Expression1, Comparison_Operator, Expression2)) -->
    expression(Expression1),
    comparison_operator(Comparison_Operator),
    expression(Expression2).

decrement_expression(t_post_decrement(Variable)) --> variableName(Variable), [--].
decrement_expression(t_pre_decrement(Variable)) --> [--], variableName(Variable).
increment_expression(t_post_increment(Variable)) --> variableName(Variable), [++].
increment_expression(t_pre_increment(Variable)) --> [++], variableName(Variable).

print_command(t_print(Expression)) --> ['print'], expression(Expression), end_of_command(_).

% Higher the level of expression, higher the precedence of expression
expression_level_1(t_add(X, Y)) --> expression_level_1(X), [+], expression_level_2(Y).
expression_level_1(t_sub(X, Y)) --> expression_level_1(X), [-], expression_level_2(Y).
expression_level_1(X) --> expression_level_2(X).

expression_level_2(t_multiply(X, Y)) --> expression_level_2(X), [*], expression_level_3(Y).
expression_level_2(t_divide(X, Y)) --> expression_level_2(X), [/], expression_level_3(Y).
expression_level_2(X) --> expression_level_3(X).

expression_level_3(t_high_precedence(X)) --> ['('], expression(X), [')'].

expression_level_3(X) --> variable_name(X).
expression_level_3(X) --> value(X).

ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('],
    condition(Condition),
    [')'],
    expression(TrueExpression),
    [':'],
    expression(FalseExpression).

value(t_integer(Variable), [Variable | Tail], Tail) :- integer(Variable).
value(t_float(Variable), [Variable | Tail], Tail) :- float(Variable).
value(t_string(Variable), [Variable | Tail], Tail) :- string(Variable).
value(t_boolean(Variable)) --> boolean_value(Variable).

operator(t_operator(Operator), [Operator | Tail], Tail) :-
    member(Operator, [+, -, *, /]).
operator(t_operator(Boolean)) --> boolean_operator(Boolean).

boolean_operator(Boolean) -->
    and_operator(Boolean) |
    or_operator(Boolean) |
    not_operator(Boolean).

assignment_expression(t_assignment_expression(Name, Value)) -->
    variable_name(Name),
    assignment_operator(_),
    value(Value).

assignment_command(Expression) -->
    assignment_expression(Expression),
    end_of_command(_).

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

variable_name(t_variable_name(Variable), [Variable | Tail], Tail) :-
    atom(Variable).


%%%%%%%%%%%%%
% TERMINALS %
%%%%%%%%%%%%%

variable_type(t_variable_type(Head), [Head | T], T) :-
    member(Head, [int, float, bool, string]).

decrement_operator(t_decrement_operator) --> [--].
increment_operator(t_increment_operator) --> [++].

comparison_operator(t_comparison_operator(Head), [Head | T], T) :-
    member(Head, [<, >, <=, >=, ==, '!=']).

boolean_value(t_true) --> [true].
boolean_value(t_false) --> [false].

assignment_operator(t_assignment_operator) --> [=].
end_of_command(t_end_of_command) --> [;].

% BOOLEAN OPERATORS
and_operator(t_and_operator) --> [and].
not_operator(t_not_operator) --> [not].
or_operator(t_or_operator) --> [or].

%%%%%%%%%
% TESTS %
%%%%%%%%%

?- operator(t_operator(+), [+], []).
?- operator(t_operator(-), [-], []).
?- operator(t_operator(*), [*], []).
?- operator(t_operator(/), [/], []).
?- operator(t_operator(t_and_operator), [and], []).
?- operator(t_operator(t_not_operator), [not], []).
?- operator(t_operator(t_or_operator), [or], []).

?- variable_name(t_variable_name(variableName), [variableName], []).
?- variable_name(t_variable_name(variable_name), [variable_name], []).

?- value(t_integer(12), [12], []).
?- value(t_float(12.2), [12.2], []).
?- value(t_float(12.0), [12.0], []).
?- value(t_string("Hello"), ["Hello"], []).
?- value(t_string("Hello''\""), ["Hello''\""], []).
?- value(t_boolean(t_true), [true], []).

?- variable_type(t_variable_type(int), [int], []).
?- variable_type(t_variable_type(float), [float], []).
?- variable_type(t_variable_type(bool), [bool], []).
?- variable_type(t_variable_type(string), [string], []).

?- decrement_operator(t_decrement_operator, [--], []).
?- increment_operator(t_increment_operator, [++], []).

?- comparison_operator(t_comparison_operator('!='), ['!='], []).
?- comparison_operator(t_comparison_operator(<), [<], []).
?- comparison_operator(t_comparison_operator(<=), [<=], []).
?- comparison_operator(t_comparison_operator(==), [==], []).
?- comparison_operator(t_comparison_operator(>), [>], []).
?- comparison_operator(t_comparison_operator(>=), [>=], []).

?- boolean_value(t_false, [false], []).
?- boolean_value(t_true, [true], []).

?- assignment_operator(t_assignment_operator, [=], []).

?- end_of_command(t_end_of_command, [;], []).

?- and_operator(t_and_operator, [and], []).
?- not_operator(t_not_operator, [not], []).
?- or_operator(t_or_operator, [or], []).
