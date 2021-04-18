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

print_command(t_print(Expression)) --> ['print'], expression(Expression), end_of_command(_).

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


condition(t_condition(Expression1, Comparison_Operator, Expression2)) -->
    expression(Expression1),
    comparison_operator(Comparison_Operator),
    expression(Expression2).

% EXPRESSIONS (HIGHER THE LEVEL OF EXPRESSION, HIGHER THE PRECEDENCE OF OPERATOR)
expression(Expression) --> expression_level_1(Expression).

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
    [')'],
    expression(TrueExpression),
    [':'],
    expression(FalseExpression).

assignment_expression(t_assignment_expression(Name, Value)) -->
    variable_name(Name),
    assignment_operator(_),
    value(Value).

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
    if, elif, else, while, range, and, or, not])).

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
parse(T, L) :- assignment_command(T, L, []);assignment_expression(T, L, []);assignment_operator(T, L, []);block(T, L, []);command(T, L, []);command_list(T, L, []);condition(T, L, []);decrement_expression(T, L, []);elif_part(T, L, []);else_part(T, L, []);end_of_command(T, L, []);expression(T, L, []);expression_level_1(T, L, []);expression_level_2(T, L, []);expression_level_3(T, L, []);for_enhanced_command(T, L, []);for_loop_command(T, L, []);if_command(T, L, []);if_part(T, L, []);increment_expression(T, L, []);print_command(T, L, []);program(T, L, []);range_value(T, L, []);ternary_expression(T, L, []);value(T, L, []);variable_change_part(T, L, []);variable_declaration_command(T, L, []);while_loop_command(T, L, []);variable_name(T, L, []);variable_type(T, L, []);comparison_operator(T, L, []);integer_value(T, L, []);float_value(T, L, []);string_value(T, L, []);boolean_value(T, L, []);boolean_operator(T, L, []).

%%%%%%%%%%%
% TESTING %
%%%%%%%%%%%

?- T = t_boolean_operator(and), L = [and], parse(T, L).
