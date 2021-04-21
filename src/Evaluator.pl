% Environment lookup
lookup(Id, [(Id, Val) | _], Val).
lookup(Id, [_|T], Val) :- lookup(Id, T, Val).

% Evaluating program
eval_program(t_program(P)) :- eval_command_list(CL, [], _).

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
	eval_expression(Expression, Env, EnvRes).