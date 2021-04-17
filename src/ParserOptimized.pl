% START SYMBOL
program(t_program(P)) --> command_list(P).

% BLOCK
block(t_block(CommandList)) --> ['{'], command_list(CommandList), ['}'].

% COMMAND LIST
command_list(t_command_list(Command, CommandList)) -->
    command(Command), command_list(CommandList).
command_list(t_command(Command)) --> command(Command).

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
if_command(t_if_command(IfTree)) --> if_part(IfTree).
if_command(t_if_command(IfTree, ElifTree, ElseTree)) -->
    if_part(IfTree),
    elif_part(ElifTree),
    else_part(ElseTree).
if_command(t_if_command(IfTree, ElseTree)) -->
    if_part(IfTree),
    else_part(ElseTree).

% IF, ELIF, ELSE - PARTS
if_part(t_if(Condition, Block)) -->
    [if], condition(Condition), block(Block).
elif_part(t_elif(Condition, Block)) -->
    [elif], condition(Condition), block(Block).
elif_part(t_elif(Condition, Block, ElifPart)) -->
    [elif], condition(Condition), block(Block),
    elif_part(ElifPart).
else_part(t_else(Block)) --> [else], block(Block).

%%%%%%%%%%%%%
% TERMINALS %
%%%%%%%%%%%%%

variable_type(t_variable_type(Head), [Head|T], T) :-
    member(Head, [int, float, bool, string]).

decrement_operator(t_decrement_operator) --> [--].
increment_operator(t_increment_operator) --> [++].

comparison_operator(t_comparison_operator(Head), [Head|T], T) :-
    member(Head, [<, >, <=, >=, ==, '!=']).

boolean_value(t_true) --> [true].
boolean_value(t_false) --> [false].

assignment_operator(t_assignment_operator) --> [=].
eof(t_eof) --> [;].

% BOOLEAN OPERATORS
and_operator(t_and_operator) --> [and].
not_operator(t_not_operator) --> [not].
or_operator(t_or_operator) --> [or].

%%%%%%%%%
% TESTS %
%%%%%%%%%

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
?- comparison_operator(t_comparison_operator(>=), [<=], []).

?- boolean_value(t_false, [false], []).
?- boolean_value(t_true, [true], []).

?- assignment_operator(t_assignment_operator, [=], []).

?- eof(t_eof, [;], []).

?- and_operator(t_and_operator, [and], []).
?- not_operator(t_not_operator, [not], []).
?- or_operator(t_or_operator, [or], []).
