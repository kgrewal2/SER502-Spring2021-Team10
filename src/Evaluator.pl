% EVALUATOR

% Evaluating block
eval_block(t_block(CommandList), Env, NEnv) :-
	eval_command_list(CommandList, Env, NEnv).


% Evaluating command
eval_command(t_assignment_expression(C), Env, NEnv) :- eval_assignment_command(C, Env, NEnv).
eval_command(t_for_enhanced_command(C), Env, NEnv) :- eval_for_enhanced_command(C, Env, NEnv).
eval_command(t_for_loop_command(C), Env, NEnv) :- eval_for_loop_command(C, Env, NEnv).
eval_command(t_if_command(C), Env, NEnv) :- eval_if_command(C, Env, NEnv).
eval_command(t_print(C), Env, NEnv) :- eval_print_command(C, Env, NEnv).
eval_command(t_variable_declaration_command(C), Env, NEnv) :- eval_variable_declaration_command(C, Env, NEnv).
eval_command(t_while_command(C), Env, NEnv) :- eval_while_loop_command(C, Env, NEnv).


% Evaluating variable_type
eval_variable_type(t_variable_type(int), Env, NEnv).
eval_variable_type(t_variable_type(float), Env, NEnv).
eval_variable_type(t_variable_type(bool), Env, NEnv).
eval_variable_type(t_variable_type(string), Env, NEnv).


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

% Evaluating IF, ELIF, ELSE - PARTS
eval_if_part(t_if(Condition, Block), Env, NEnv) :- 
     [if], 
     ['('], 
     eval_condition(Condition, Env, Env1), 
     [')'], 
     eval_block(Block, Env1, NEnv).

eval_elif_part(t_elif(Condition, Block), Env, NEnv) :- 
     [elif], 
     ['('], 
     eval_condition(Condition, Env, Env1), 
     [')'], 
     eval_block(Block, Env1, NEnv).

eval_elif_part(t_elif(Condition, Block, ElifPart), Env, NEnv) :- 
     [elif], 
     ['('], 
     eval_condition(Condition, Env, Env1), 
     [')'], 
     eval_block(Block, Env1, Env2), 
     eval_elif_part(ElifPart, Env2, NEnv).

eval_else_part(t_else(Block), Env, NEnv) :- 
     [else], 
     eval_block(Block, Env, NEnv).
    

% Environment lookup
lookup(Id, [(Id, Val) | _], Val).
lookup(Id, [_|T], Val) :- lookup(Id, T, Val).

% Environment update
update(Id, Val, [], [(Id,Val)]).
update(Id, Val, [(Id,_)|T], [(Id,Val)|T]).
update(Id, Val, [H|T], [H| Env]):- H \= (Id, _), update(Id, Val, T, Env).

% Evaluating program
eval_program(t_program(_P)) :- eval_command_list(_CL, [], _).

% Evaluating command list
eval_command_list(t_command_list(C, CL), Env, EnvRes):- 
	eval_command(C,Env,Env1), eval_command_list(CL,Env1,EnvRes).
eval_command_list(t_command(C), Env, EnvRes):-
	eval_command(C, Env, EnvRes).
	
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

% Addition Expression
eval_expression(t_add(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1+Val2.

eval_expression(t_add(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1+Val2.
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
% Division
eval_expression(t_divide(X,Y), Env, Val, Env):-
      lookup(X,Env, Val1),
      lookup(Y,Env, Val2),
      Val is Val1/Val2.



	
%%%%%%%%%%%	
% TESTING %
%%%%%%%%%%%

% ENVIRONMENT LOOKUP AND UPDATE
?- lookup(x, [(x,3), (y,5)], _X).
?- lookup(y, [(z,3), (y,5)], _X).
?- update(x, 4, [], _Res).
?- update(x, 5, [(x,4), (y,6)], _Res).
?- update(y, 5, [(x,4), (y,6)], _Res).
?- eval_expression(t_post_decrement(a),[(a,3), (y,5)],2,[(a,2), (y,5)]).
?- eval_expression(t_pre_decrement(a),[(a,3), (y,5)],2,[(a,2), (y,5)]).
?- eval_expression(t_post_increment(a),[(a,3), (y,5)],4,[(a,4), (y,5)]).
?- eval_expression(t_pre_increment(a),[(a,3), (y,5)],4,[(a,4), (y,5)]).
?- eval_expression(t_add(a,y),[(a,3), (y,5)],8,[(a,3), (y,5)]).
?- eval_expression(t_sub(a,y),[(a,3), (y,5)],-2,[(a,3), (y,5)]).
?- eval_expression(t_multiply(a,y),[(a,3), (y,5)],15,[(a,3), (y,5)]).
?- eval_expression(t_divide(a,y),[(a,10), (y,5)],2,[(a,10), (y,5)]).
?- eval_expression(t_divide(a,y),[(a,1), (y,2)],0.5,[(a,1), (y,2)]).
?- eval_expression(t_divide(a,y),[(a,0), (y,2)],0,[(a,0), (y,2)]).
