:- module(eval_program, [eval_program/2]).
%%%%%%%%%%%%%%
% Evaluation %
%%%%%%%%%%%%%%

eval_program(t_program(P), NewEnv) :- eval_command_list(P, [], NewEnv).

eval_command_list(t_command_list(Command, CommandList), Env, NewEnv) :-
    eval_command(Command, Env, E1),
    eval_command_list(CommandList, E1, NewEnv).
eval_command_list(t_command(Command), Env, NewEnv) :-
    eval_command(Command, Env, NewEnv).

eval_block(t_block(CommandList), Env, NewEnv) :- eval_command_list(CommandList, Env, NewEnv).

eval_command(t_assignment_expression(t_variable_name(Name), Expression), Env, NewEnv) :-
    eval_expression(Expression, Env, R1),
    update(Name, R1, Env, NewEnv).
eval_command(t_variable_declaration_command(Type, t_variable_name(Name), Expression), Env, NewEnv) :-
    eval_variable_type(Type, Env, R1),
    eval_expression(Expression, Env, R2),
    update(R1, Name, R2, Env, NewEnv).

eval_command(t_variable_declaration_command(Type, t_variable_name(Name)), Env, NewEnv) :- eval_variable_type(Type, Env, R1), R1 = int,  update(R1, Name, 0, Env, NewEnv).
eval_command(t_variable_declaration_command(Type, t_variable_name(Name)), Env, NewEnv) :- eval_variable_type(Type, Env, R1), R1 = float,  update(R1, Name, 0.0, Env, NewEnv).
eval_command(t_variable_declaration_command(Type, t_variable_name(Name)), Env, NewEnv) :- eval_variable_type(Type, Env, R1), R1 = string,  update(R1, Name, "", Env, NewEnv).
eval_command(t_variable_declaration_command(Type, t_variable_name(Name)), Env, NewEnv) :- eval_variable_type(Type, Env, R1), R1 = bool,  update(R1, Name, false, Env, NewEnv).

eval_command(t_print_expression(Expression), Env, Env) :- eval_expression(Expression, Env, Result), write(Result), nl.
eval_command(t_print_string(String), Env, Env) :- write(String), nl.

eval_command(t_for_loop_command(Assignment, Condition, Variable_Change, Block), Env, NewEnv) :-
    eval_command(Assignment, Env, E1),
    eval_for_command(Condition, Variable_Change, Block, E1, NewEnv).

eval_command(t_while_command(C, B), Env, NewEnv) :-
    eval_condition(C, Env, true),
    eval_block(B, Env, E1),
    eval_command(t_while_command(C, B), E1, NewEnv).
eval_command(t_while_command(C, _), Env, _) :-
    eval_condition(C, Env, false).

eval_command(t_for_enhanced_command(Variable, Expression1, Expression2, Block), Env, NewEnv) :-
    eval_command(t_assignment_expression(Variable, Expression1), Env, E1),
    eval_condition(t_condition(Expression1, t_comparison_operator(>), Expression2), E1, false),
    eval_for_command(t_condition(Variable, t_comparison_operator(=<), Expression2), t_pre_increment(Variable), Block, E1, NewEnv).

eval_command(t_for_enhanced_command(Variable, Expression1, Expression2, Block), Env, NewEnv) :-
    eval_command(t_assignment_expression(Variable, Expression1), Env, E1),
    eval_condition(t_condition(Expression1, t_comparison_operator(<), Expression2), E1, false),
    eval_for_command(t_condition(Variable, t_comparison_operator(>=), Expression2), t_pre_decrement(Variable), Block, E1, NewEnv).

eval_command(t_if_command(IfTree), Env, NewEnv) :- eval_if_part(IfTree, Env, NewEnv, _).
eval_command(t_if_command(IfTree, _, _), Env, NewEnv) :-
    eval_if_part(IfTree, Env, NewEnv, true).
eval_command(t_if_command(IfTree, ElifTree, _), Env, NewEnv) :-
    eval_if_part(IfTree, Env, _, false),
    eval_elif_part(ElifTree, Env, NewEnv, true).
eval_command(t_if_command(IfTree, ElifTree, ElseTree), Env, NewEnv) :-
    eval_if_part(IfTree, Env, _, false),
    eval_elif_part(ElifTree, Env, _, false),
    eval_else_part(ElseTree, Env, NewEnv, true).
eval_command(t_if_command(IfTree, _), Env, NewEnv) :-
    eval_if_part(IfTree, Env, NewEnv, true).
eval_command(t_if_command(IfTree, ElseTree), Env, NewEnv) :-
    eval_if_part(IfTree, Env, _, false),
    eval_else_part(ElseTree, Env, NewEnv, true).

eval_for_command(Condition, _, _, Env, Env) :-
    eval_condition(Condition, Env, false).

eval_for_command(Condition, t_pre_increment(Variable), Block, Env, NewEnv) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, E1),
    eval_expression(t_increment(Variable), E1, E2),
    eval_for_command(Condition, t_pre_increment(Variable), Block, E2, NewEnv).

eval_for_command(Condition, t_pre_decrement(Variable), Block, Env, NewEnv) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, E1),
    eval_expression(t_decrement(Variable), E1, E2),
    eval_for_command(Condition, t_pre_decrement(Variable), Block, E2, NewEnv).

eval_for_command(Condition, t_post_decrement(Variable), Block, Env, NewEnv) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, E1),
    eval_expression(t_decrement(Variable), E1, E2),
    eval_for_command(Condition, t_post_decrement(Variable), Block, E2, NewEnv).

eval_for_command(Condition, t_post_increment(Variable), Block, Env, NewEnv) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, E1),
    eval_expression(t_increment(Variable), E1, E2),
    eval_for_command(Condition, t_post_increment(Variable), Block, E2, NewEnv).

eval_if_part(t_if(Condition, Block), Env, NewEnv, true) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, NewEnv).
eval_if_part(t_if(Condition, _), Env, Env, false) :-
    eval_condition(Condition, Env, false).

eval_elif_part(t_elif(Condition, Block), Env, NewEnv, true) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, NewEnv).
eval_elif_part(t_elif(Condition, Block, _), Env, NewEnv, true) :-
    eval_condition(Condition, Env, true),
    eval_block(Block, Env, NewEnv).
eval_elif_part(t_elif(Condition, _, ElifPart), Env, NewEnv, R) :-
    eval_condition(Condition, Env, false),
    eval_elif_part(ElifPart, Env, NewEnv, R).
eval_elif_part(t_elif(Condition, _, _), Env, Env, false) :-
    eval_condition(Condition, Env, false).

eval_else_part(t_else(Block), Env, NewEnv, true) :-
    eval_block(Block, Env, NewEnv).

eval_condition(t_condition(Expression1, Operator, Expression2), Env, Result) :-
    eval_expression(Expression1, Env, R1),
    eval_expression(Expression2, Env, R2),
    eval_comparison(R1, Operator, R2, Result).

eval_comparison(V1, t_comparison_operator(>), V2, true)  :- V1 > V2.
eval_comparison(V1, t_comparison_operator(>), V2, false)  :- V1 =< V2.
eval_comparison(V1, t_comparison_operator(<), V2, true)  :- V1 < V2.
eval_comparison(V1, t_comparison_operator(<), V2, false)  :- V1 >= V2.
eval_comparison(V1, t_comparison_operator(>=), V2, true)  :- V1 >= V2.
eval_comparison(V1, t_comparison_operator(>=), V2, false) :- V1 < V2.
eval_comparison(V1, t_comparison_operator(=<), V2, true)  :- V1 =< V2.
eval_comparison(V1, t_comparison_operator(=<), V2, false) :- V1 > V2.
eval_comparison(V1, t_comparison_operator(==), V2, true)  :- V1 =:= V2.
eval_comparison(V1, t_comparison_operator(==), V2, false) :- V1 =\= V2.
eval_comparison(V1, t_comparison_operator('!='), V2, true)  :- V1 =\= V2.
eval_comparison(V1, t_comparison_operator('!='), V2, false) :- V1 =:= V2.

eval_expression(t_expression(X), Env, Result) :- eval_expression(X, Env, Result).
eval_expression(t_add(X, Y), Env, Result) :- eval_expression(X, Env, R1), eval_expression(Y, Env, R2), Result is R1+R2.
eval_expression(t_sub(X, Y), Env, Result) :- eval_expression(X, Env, R1), eval_expression(Y, Env, R2), Result is R1-R2.
eval_expression(t_multiply(X, Y), Env, Result) :- eval_expression(X, Env, R1), eval_expression(Y, Env, R2), Result is R1*R2.
eval_expression(t_divide(X, Y), Env, Result) :- eval_expression(X, Env, R1), eval_expression(Y, Env, R2), Result is R1/R2.
eval_expression(t_boolean(Variable), _, Variable).
eval_expression(t_integer(Variable), _, Variable).
eval_expression(t_float(Variable) , _, Variable).
eval_expression(t_string(Variable) , _, Variable).
eval_expression(t_variable_name(Name), Env, Value) :- lookup(Name, Value, Env).
eval_expression(t_variable_name(Name), Env, Name) :- not(lookup(Name, _, Env)), string(Name).
eval_expression(t_increment(t_variable_name(VariableName)), Env, NewEnv) :- lookup(VariableName, Result, Env), NewValue is Result+1, update(VariableName, NewValue, Env, NewEnv).
eval_expression(t_decrement(t_variable_name(VariableName)), Env, NewEnv) :- lookup(VariableName, Result, Env), NewValue is Result-1, update(VariableName, NewValue, Env, NewEnv).
eval_expression(t_increment(Variable), Env, NewEnv) :- lookup(Variable, Result, Env), NewValue is Result+1, update(Variable, NewValue, Env, NewEnv).
eval_expression(t_decrement(Variable), Env, NewEnv) :- lookup(Variable, Result, Env), NewValue is Result-1, update(Variable, NewValue, Env, NewEnv).

eval_expression(t_ternary_expression(Condition, TrueExpression, _), Env, Result) :-
    eval_condition(Condition, Env, true),
    eval_expression(TrueExpression, Env, Result).

eval_expression(t_ternary_expression(Condition, _, FalseExpression), Env, Result) :-
    eval_condition(Condition, Env, false),
    eval_expression(FalseExpression, Env, Result).

eval_expression(t_boolean_expression(X, t_boolean_operator(Operator), Y), Env, Result) :-
    eval_expression(X, Env, R1),
    eval_expression(Y, Env, R2),
    eval_boolean(R1,  Operator, R2, Result).

eval_boolean(true , and, true  , true).
eval_boolean(true , and, false , false).
eval_boolean(false , and, true  , false).
eval_boolean(false , and, false , false).
eval_boolean(true , or , true  , true).
eval_boolean(true , or , false , true).
eval_boolean(false , or , true  , true).
eval_boolean(false , or , false , false).

eval_variable_type(t_variable_type(Type), _, Type).

%%%%%%%%%%%%%%%
% Environment %
%%%%%%%%%%%%%%%

% lookup(Name, Value, Env)
lookup(Name, Value, [(_, Name, Value) | _]).
lookup(Name, Value, [_Head | Tail]) :- lookup(Name, Value, Tail).

% update(Name, Value, Env, NewEnv)
update(Name, _, [], []) :- error_undeclared(Name).
update(Name, Value, [Head | Tail], [Head | NewEnv]) :- Head \= (_, Name, _), update(Name, Value, Tail, NewEnv).
update(Name, Value, [(int , Name, _) | Env], [ (int , Name, Value) | Env]) :- integer(Value).
update(Name, Value, [(float , Name, _) | Env], [ (float , Name, Value) | Env]) :- float(Value).
update(Name, Value, [(bool , Name, _) | Env], [ (bool , Name, Value) | Env]) :- member(Value, [true, false]).
update(Name, Value, [(string, Name, _) | Env], [ (string, Name, Value) | Env]) :- string(Value).

% update - errors for type mismatch
update(Name, Value, [(int , Name, _) | _], _)  :- not(integer(Value)),     error_type_conversion(Name, int).
update(Name, Value, [(float, Name, _) | _], _)  :- not(float(Value)),     error_type_conversion(Name, float).
update(Name, Value, [(bool , Name, _) | _], _)  :- not(member(Value, [true, false])), error_type_conversion(Name, bool).
update(Name, Value, [(string, Name, _) | _], _) :- not(string(Value)) ,     error_type_conversion(Name, string).

% update(Type, Name, Value, Env, NewEnv)
update(Type, Name, Value, [], [(Type, Name, Value)]).
update(Type, Name, Value, [Head | Tail], [Head | NewEnv]) :- Head \= (_, Name, _), update(Type, Name, Value, Tail, NewEnv).
update(_, Name, _, [(_, Name, _) | _], _NewEnv) :- error_redefinition(Name).

%%%%%%%%%
% ERROR %
%%%%%%%%%
error(String, List) :-
    ansi_format([bold, fg(red)], String, List), halt.
error_redefinition(Name) :-
    error('Error: Redefinition of ~w', [Name]).
error_type_conversion(Name, Type) :-
    error('Error: IMPRO doesn\'t support type conversion. (Variable \'~w\' is not of type \'~w\')', [Name, Type]).
error_undeclared(Name) :- error('Error: ~w Undeclared', [Name]).

%%%%%%%%%%%
% TESTING %
%%%%%%%%%%%

?- update(x, 5, [(int, x, 6)], [(int, x, 5)]).
?- update(x, 5, [(int, x, 2), (float, y, 3.4)], [(int, x, 5), (float, y, 3.4)]).

?- update(int, x, 5, [], [(int, x, 5)]).
?- update(int, x, 5, [(int, y, 6)], [(int, y, 6), (int, x, 5)]).

?- eval_expression(t_add(t_integer(3), t_integer(5)), [], 8).
?- eval_expression(t_sub(t_integer(3), t_integer(5)), [], -2).
?- eval_expression(t_multiply(t_integer(3), t_integer(5)), [], 15).
?- eval_expression(t_divide(t_integer(3), t_integer(6)), [], 0.5).

?- not(eval_expression(t_variable_name(x), [], _)).
?- eval_expression(t_variable_name("String"), [], "String").

?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(>),  t_integer(4)), [(int, x, 6)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(<),  t_integer(4)), [(int, x, 2)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(>=), t_integer(4)), [(int, x, 6)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(>=), t_integer(4)), [(int, x, 4)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(=<), t_integer(4)), [(int, x, 2)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(=<), t_integer(4)), [(int, x, 4)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator(==), t_integer(4)), [(int, x, 4)], true).
?- eval_condition(t_condition(t_variable_name(x), t_comparison_operator('!='), t_integer(4)), [(int, x, 2)], true).
