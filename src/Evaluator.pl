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
