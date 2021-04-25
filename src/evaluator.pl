% EVALUATOR

% Environment lookup
lookup(Id, [(Id, Val) | _], Val).
lookup(Id, [_|T], Val) :- lookup(Id, T, Val).

% Environment update
update(Id, Val, [], [(Id,Val)]).
update(Id, Val, [(Id,_)|T], [(Id,Val)|T]).
update(Id, Val, [H|T], [H| Env]):- H \= (Id, _), update(Id, Val, T, Env).

% Evaluating program
eval_program(t_program(_P)) :- eval_command_list(_CL, [], _).

% Evaluating block
eval_block(t_block(CommandList), Env, NEnv) :-
	eval_command_list(CommandList, Env, NEnv).

% Evaluating command list
eval_command_list(t_command_list(C, CL), Env, EnvRes):- 
	eval_command(C,Env,Env1), eval_command_list(CL,Env1,EnvRes).
eval_command_list(t_command(C), Env, EnvRes):-
	eval_command(C, Env, EnvRes).

% Evaluating command
eval_command(t_assignment_expression(C), Env, NEnv) :- eval_assignment_command(C, Env, NEnv).
eval_command(t_for_enhanced_command(C), Env, NEnv) :- eval_for_enhanced_command(C, Env, NEnv).
eval_command(t_for_loop_command(C), Env, NEnv) :- eval_for_loop_command(C, Env, NEnv).
eval_command(t_if_command(C), Env, NEnv) :- eval_if_command(C, Env, NEnv).
eval_command(t_print(C), Env, NEnv) :- eval_print_command(C, Env, NEnv).
eval_command(t_variable_declaration_command(C), Env, NEnv) :- eval_variable_declaration_command(C, Env, NEnv).
eval_command(t_while_command(C), Env, NEnv) :- eval_while_loop_command(C, Env, NEnv).


% Evaluating comparison operator
eval_comparison_operator(t_comparison_operator(>), V1, V2, true):- V1 > V2.
eval_comparison_operator(t_comparison_operator(>), V1, V2, false):- V1 =< V2.

eval_comparison_operator(t_comparison_operator(<), V1, V2, true):- V1 < V2.
eval_comparison_operator(t_comparison_operator(<), V1, V2, false):- V1 >= V2.

eval_comparison_operator(t_comparison_operator(<=), V1, V2, true):- V1 =< V2.
eval_comparison_operator(t_comparison_operator(<=), V1, V2, false):- V1 > V2.
                
eval_comparison_operator(t_comparison_operator(>=), V1, V2, true):- V1 >= V2.
eval_comparison_operator(t_comparison_operator(>=), V1, V2, false):- V1 < V2.

eval_comparison_operator(t_comparison_operator(==), V1, V2, true):- V1 =:= V2.
eval_comparison_operator(t_comparison_operator(==), V1, V2, false):- V1 =\= V2.

eval_comparison_operator(t_comparison_operator('!='), V1, V2, true):- V1 =\= V2.
eval_comparison_operator(t_comparison_operator('!='), V1, V2, false):- V1 =:= V2.

% Evaluating IF, ELIF, ELSE- COMMAND
eval_if_command(t_if_command(IfTree), Env, NEnv) :-
    eval_if_part(IfTree, Env, NEnv).

eval_if_command(t_if_command(IfTree, ElifTree, ElseTree), Env, NEnv) :-
    eval_if_part(IfTree, Env, Env1),
    eval_elif_part(ElifTree, Env1, Env2),
    eval_else_part(ElseTree, Env2, NEnv).

eval_if_command(t_if_command(IfTree, ElseTree), Env, NEnv) :-
    eval_if_part(IfTree, Env, Env1),
    eval_else_part(ElseTree, Env1, NEnv).

% Evaluating IF, ELIF, ELSE - PARTS
eval_if_part(t_if(Condition, Block), Env, NEnv) :- 
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, true),
     eval_block(Block, Env1, Env2),
     eval_if_part(t_if(Condition, Block), Env2, NEnv).
eval_if_part(t_if(Condition, Block), Env, NEnv) :- 
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, false).

eval_elif_part(t_elif(Condition, Block), Env, NEnv) :-  
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, true), 
     eval_block(Block, Env1, Env2),
     eval_elif_part(t_elif(Condition, Block), Env2, NEnv).
eval_elif_part(t_elif(Condition, Block), Env, NEnv) :-  
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, false).

eval_elif_part(t_elif(Condition, Block, ElifPart), Env, NEnv) :-  
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, true),
     eval_block(Block, Env1, Env2), 
     eval_elif_part(ElifPart, Env2, Env3),
     eval_elif_part(t_elif(Condition, Block, ElifPart), Env3, NEnv).
eval_elif_part(t_elif(Condition, Block, ElifPart), Env, NEnv) :-  
     eval_condition(Condition, Env, Env1, Val),
     booleanValue(Val, false).
     
eval_else_part(t_else(Block), Env, NEnv) :- 
     eval_block(Block, Env, NEnv).

	
% Evaluating while loop command
eval_while_loop_command(t_while_command(C,B), Env, EnvRes) :- 
	eval_condition(C,Env,Env1,Val), 
	booleanValue(Val, true),
	eval_block(B,Env1,Env2),
	eval_while_loop_command(t_while_command(C,B), Env2, EnvRes).
eval_while_loop_command(t_while_command(C, _), Env, EnvRes) :-
	eval_condition(C,Env,EnvRes,Val),
	booleanValue(Val, false).
	
% Evaluating boolean values
booleanValue(false, false).
booleanValue(Val, true) :- Val \= false.	
	
% Evaluating print command
eval_print_command(t_print(Expression), Env, EnvRes) :-
	eval_expression(Expression, Env, EnvRes, NewEnv), write(EnvRes).

% Decrement Expression
eval_expression(t_post_decrement(a),Env, Val, NewEnv):-
    lookup(X,Env, Val1),
    Val is Val1-1,
    update(X,Val, Env, NewEnv).

eval_expression(t_pre_decrement(a),Env, Val, NewEnv):-
    lookup(X,Env, Val1),
    Val is Val1-1,
    update(X,Val, Env, NewEnv).

% Increment Expression
eval_expression(t_post_increment(a),Env, Val, NewEnv):-
    lookup(X,Env, Val1),
    Val is Val1+1,
    update(X,Val, Env, NewEnv).

eval_expression(t_pre_increment(a),Env, Val, NewEnv):-
    lookup(X,Env, Val1),
    Val is Val1+1,
    update(X,Val, Env, NewEnv).


% Addtion Expression
eval_expression(t_add(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1), 
    eval_expression(Y, Env1, Val2, NewEnv), 
    string(Val1), \+ string(Val2),
    string_concat(Val1, Val2, Val).

eval_expression(t_add(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1), 
    eval_expression(Y, Env1, Val2, NewEnv), 
    \+ string(Val1), string(Val2),
    string_concat(Val1, Val2, Val).

eval_expression(t_add(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1), eval_expression(Y, Env1, Val2, NewEnv), 
    \+string(Val1), \+string(Val2),
    Val is Val1 + Val2.

eval_expression(t_add(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1), eval_expression(Y, Env1, Val2, NewEnv), 
    \+ number(Val1), \+ number(Val2), 
    string_concat(Val1, Val2, Val).

% Subtraction Expression
eval_expression(t_sub(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1-Val2.
	  
% Multiplication Expression
eval_expression(t_multiply(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1*Val2.
	  
% Division Expression
eval_expression(t_divide(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1/Val2.

% Evaluating ternary expression      
eval_ternary_expression(t_ternary_expression(Condition, TrueExpression, _FalseExpression), Env, NEnv, Val) :-
    eval_condition(Condition, Env, Env1, Val1),
    booleanValue(Val1, true),
    eval_expression(TrueExpression, Env1, NEnv, Val).

eval_ternary_expression(t_ternary_expression(Condition, _TrueExpression, FalseExpression), Env, NEnv, Val) :- 
    eval_condition(Condition, Env, Env1, Val1),
    booleanValue(Val1, false),
    eval_expression(FalseExpression, Env1, NEnv, Val).
	
% Assignment expression x=5
eval_assignment_expression(t_assignment_expression(Name, Expression), Env, Val, NewEnv):-
	eval_variable_name(Name),
	lookup(),
	eval_assignment_operator(_),
	eval_expression(Expression),
	
% Assignment operator
eval_assignment_operator(t_assignment_operator, =).
	
% End of command
eval_end_of_command(t_end_of_command, ;).


eval_expression(t_boolean(I), Env, I, Env).
eval_expression(t_integer(X), Env, X, Env).
eval_expression(t_float(X), Env, X, Env).
eval_expression(t_string(X), Env, X, Env).
eval_expression(t_variable_name(I), Env, Val, Env):- lookup(I, Env, Val).

%%%%%%%%%%%	
% TESTING %
%%%%%%%%%%%

% ENVIRONMENT LOOKUP AND UPDATE
?- lookup(x, [(x,3), (y,5)], _X).
?- lookup(y, [(z,3), (y,5)], _X).
?- update(x, 4, [], _Res).
?- update(x, 5, [(x,4), (y,6)], _Res).
?- update(y, 5, [(x,4), (y,6)], _Res).

% TESTING EXPRESSION
?- eval_expression(t_post_decrement(a),[(a,3), (y,5)],2,[(a,2), (y,5)]).
?- eval_expression(t_pre_decrement(a),[(a,3), (y,5)],2,[(a,2), (y,5)]).
?- eval_expression(t_post_increment(a),[(a,3), (y,5)],4,[(a,4), (y,5)]).
?- eval_expression(t_pre_increment(a),[(a,3), (y,5)],4,[(a,4), (y,5)]).

?- eval_expression(t_add(t_string("hi"),t_integer(2)),[(a,3), (y,5)],"hi2", [(a,3), (y,5)]).
?- eval_expression(t_add(t_integer(2),t_string("hi")),[(a,3), (y,5)],"2hi", [(a,3), (y,5)]).
?- eval_expression(t_add(t_string("hello"),t_string("world")),[(a,3), (y,5)],"helloworld", [(a,3), (y,5)]).
?- eval_expression(t_add(t_integer(2),t_integer(3)),[(a,3), (y,5)],5, [(a,3), (y,5)]).
?- eval_expression(t_add(t_variable_name(a),t_variable_name(y)),[(a,3), (y,5)],8,[(a,3), (y,5)]).
?- eval_expression(t_add(t_integer(2),t_variable_name(y)),[(a,3), (y,5)],7,[(a,3), (y,5)]).
?- eval_expression(t_add(t_variable_name(y),t_integer(2)),[(a,3), (y,5)],7,[(a,3), (y,5)]).

?- eval_expression(t_sub(a,y),[(a,3), (y,5)],-2,[(a,3), (y,5)]).
?- eval_expression(t_multiply(a,y),[(a,3), (y,5)],15,[(a,3), (y,5)]).
?- eval_expression(t_divide(a,y),[(a,10), (y,5)],2,[(a,10), (y,5)]).
?- eval_expression(t_divide(a,y),[(a,1), (y,2)],0.5,[(a,1), (y,2)]).
?- eval_expression(t_divide(a,y),[(a,0), (y,2)],0,[(a,0), (y,2)]).

% TESTING ASSIGNMENT OPERATOR
?- eval_assignment_operator(t_assignment_operator, =).

% TESTING END OF COMMAND
?- eval_end_of_command(t_end_of_command, ;).

% TESTING COMPARISON OPERATOR
?- eval_comparison_operator(t_comparison_operator(>), 7, 5, R).
?- eval_comparison_operator(t_comparison_operator(>), 5, 7, R). 

?- eval_comparison_operator(t_comparison_operator(<), 5, 7, R).
?- eval_comparison_operator(t_comparison_operator(<), 7, 5, R).

?- eval_comparison_operator(t_comparison_operator(<=), 6, 8, R).
?- eval_comparison_operator(t_comparison_operator(<=), 8, 6, R). 

?- eval_comparison_operator(t_comparison_operator(>=), 9, 5, R).
?- eval_comparison_operator(t_comparison_operator(>=), 10, 12, R).

?- eval_comparison_operator(t_comparison_operator(==), 4, 4, R).
?- eval_comparison_operator(t_comparison_operator(==), 5, 4, R).

?- eval_comparison_operator(t_comparison_operator('!='), 5, 4, R).
?- eval_comparison_operator(t_comparison_operator('!='), 4, 4, R).

