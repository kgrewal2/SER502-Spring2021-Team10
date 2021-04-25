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



% Substraction Expression
eval_expression(t_sub(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1),
    eval_expression(Y, Env1, Val2, NewEnv),
    Val is Val1 - Val2.
 

% Multiplication Expression
eval_expression(t_mult(X,Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1),
    eval_expression(Y, Env1, Val2, NewEnv), 
    number(Val1), number(Val2),
    Val is Val1 * Val2.

% Division
eval_expression(t_divide(X,Y), Env, Val, NewEnv):-
	eval_expression(X, Env, Val1, Env1), 
    eval_expression(Y, Env1, Val2, NewEnv),
    number(Val1), number(Val2),
    Val is Val1 / Val2.



eval_expression(t_boolean_expression(X, Operator, Y), Env, Val, NewEnv):-
    eval_expression(X, Env, Val1, Env1), 
    eval_expression(Y, Env1, Val2, NewEnv),
    eval_boolean_operator(Operator,Operator1),
    eval_operator(Val1,Val2,Operator1,Val).

eval_expression(t_boolean_expression(X, Operator), Env, Val, NewEnv):-
     eval_expression(X, Env, Val1, NewEnv),
     eval_boolean_operator(Operator,Operator1),
     eval_operator(Val1,Operator1,Val).

eval_operator(true,true,and,true).
eval_operator(true,false,and,false).
eval_operator(false,true,and,false).
eval_operator(false,false,and,false).
eval_operator(true,true,or,true).
eval_operator(true,false,or,true).
eval_operator(false,true,or,true).
eval_operator(false,false,or,false).
eval_operator(false,not,true).
eval_operator(true,not,false).


% Evaluating ternary expression      
eval_ternary_expression(t_ternary_expression(Condition, TrueExpression, _FalseExpression), Env, NEnv, Val) :-
    eval_condition(Condition, Env, Env1, Val1),
    booleanValue(Val1, true),
    eval_expression(TrueExpression, Env1, NEnv, Val).

eval_ternary_expression(t_ternary_expression(Condition, _TrueExpression, FalseExpression), Env, NEnv, Val) :- 
    eval_condition(Condition, Env, Env1, Val1),
    booleanValue(Val1, false),
    eval_expression(FalseExpression, Env1, NEnv, Val).
	
% Assignment operator
eval_assignment_operator(t_assignment_operator, =).


% Assignment expression
eval_assignment_expression(t_assignment_expression(t_variable_name(Name), t_expression(Expression)), Env, NewEnv):-
	eval_expression(Expression, Env, Val1, Env2),
	update(Name, Val1, Env2, NewEnv).


	
% End of command
eval_end_of_command(t_end_of_command, ;).

% Evaluating variable type
eval_variable_type(t_variable_type(int), I):- integer(I).  
eval_variable_type(t_variable_type(float), F):- float(F).  
eval_variable_type(t_variable_type(string), S):- string(S).  
eval_variable_type(t_variable_type(bool), C, true):- C is true.
eval_variable_type(t_variable_type(bool), C, false):- C is false.


eval_boolean_operator(t_boolean_operator(X),X).
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


%  Substraction TestCases for Int's
?- eval_expression(t_sub(t_integer(2), t_integer(2)),[(a,3), (y,5)],0, [(a,3), (y,5)]).
?- eval_expression(t_sub(t_variable_name(a),t_variable_name(y)),[(a,3), (y,5)],-2,[(a,3), (y,5)]).
?- eval_expression(t_sub(t_integer(2),t_variable_name(y)),[(a,3), (y,5)],-3,[(a,3), (y,5)]).
?- eval_expression(t_sub(t_variable_name(y),t_integer(2)),[(a,3), (y,5)],3,[(a,3), (y,5)]).
% The below cases should fail with error message
%?- eval_expression(t_sub(t_string("hi"),t_integer(2)),[(a,3), (y,5)],Ans,[(a,3), (y,5)]).
%?- eval_expression(t_sub(t_integer(2),t_string("hi")),[(a,3), (y,5)],Ans, [(a,3), (y,5)]).
%?- eval_expression(t_sub(t_string("hello"),t_string("world")),[(a,3.0), (y,5.0)],Ans, [(a,3.0), (y,5.0)]).	

%  Substraction TestCases for Float's
?- eval_expression(t_sub(t_float(2), t_float(2)),[(a,3.0), (y,5.0)],0, [(a,3.0), (y,5.0)]).
?- eval_expression(t_sub(t_variable_name(a),t_variable_name(y)),[(a,3.0), (y,5.0)],-2.0,[(a,3.0), (y,5.0)]).
?- eval_expression(t_sub(t_float(2),t_variable_name(y)),[(a,3.0), (y,5.0)],-3.0,[(a,3.0), (y,5.0)]).
?- eval_expression(t_sub(t_variable_name(y),t_float(2)),[(a,3.0), (y,5.0)],3.0,[(a,3.0), (y,5.0)]).
% The below cases should fail with error message
%?- eval_expression(t_sub(t_string("hi"),t_float(2)),[(a,3.0), (y,5.0)],Ans,[(a,3.0), (y,5.0)]).
%?- eval_expression(t_sub(t_float(2),t_string("hi")),[(a,3.0), (y,5.0)],Ans, [(a,3.0), (y,5.0)]).
%?- eval_expression(t_sub(t_string("hello"),t_string("world")),[(a,3.0), (y,5.0)],Ans, [(a,3.0), (y,5.0)]).

?- eval_expression(t_mult(t_integer(2), t_integer(2)),[(a,3), (y,5)],4, [(a,3), (y,5)]).
?- eval_expression(t_mult(t_variable_name(a),t_variable_name(y)),[(a,10), (y,5)],50,[(a,10), (y,5)]).
?- eval_expression(t_mult(t_integer(15),t_variable_name(y)),[(a,3), (y,5)],75,[(a,3), (y,5)]).
?- eval_expression(t_mult(t_variable_name(y),t_integer(2)),[(a,3), (y,5)],10,[(a,3), (y,5)]).
?- eval_expression(t_mult(t_float(2), t_float(2)),[(a,3.0), (y,5.0)],4, [(a,3.0), (y,5.0)]).
?- eval_expression(t_mult(t_variable_name(a),t_variable_name(y)),[(a,6.0), (y,2.0)],12.0,[(a,6.0), (y,2.0)]).
?- eval_expression(t_mult(t_float(10),t_variable_name(y)),[(a,3.0), (y,5.0)],50.0,[(a,3.0), (y,5.0)]).
?- eval_expression(t_mult(t_variable_name(y),t_float(2)),[(a,3.0), (y,5.0)],10.0,[(a,3.0), (y,5.0)]).

?- eval_expression(t_divide(t_integer(2), t_integer(2)),[(a,3), (y,5)],1, [(a,3), (y,5)]).
?- eval_expression(t_divide(t_variable_name(a),t_variable_name(y)),[(a,10), (y,5)],2,[(a,10), (y,5)]).
?- eval_expression(t_divide(t_integer(15),t_variable_name(y)),[(a,3), (y,5)],3,[(a,3), (y,5)]).
?- eval_expression(t_divide(t_variable_name(y),t_integer(2)),[(a,3), (y,5)],2.5,[(a,3), (y,5)]).
?- eval_expression(t_divide(t_float(2), t_float(2)),[(a,3.0), (y,5.0)],1, [(a,3.0), (y,5.0)]).
?- eval_expression(t_divide(t_variable_name(a),t_variable_name(y)),[(a,6.0), (y,2.0)],3.0,[(a,6.0), (y,2.0)]).
?- eval_expression(t_divide(t_float(10),t_variable_name(y)),[(a,3.0), (y,5.0)],2.0,[(a,3.0), (y,5.0)]).
?- eval_expression(t_divide(t_variable_name(y),t_float(2)),[(a,3.0), (y,5.0)],2.5,[(a,3.0), (y,5.0)]).

?- eval_assignment_expression(t_assignment_expression(t_variable_name(x) , t_expression(t_integer(12))),[(a,3), (y,5)],[(a,3), (y,5), (x,12)]).
?- eval_assignment_expression(t_assignment_expression(t_variable_name(z) , t_expression(t_variable_name(a))),[(a,3), (y,5)],[(a,3), (y,5), (z,3)]).
?- eval_assignment_expression(t_assignment_expression(t_variable_name(z) , t_expression(t_mult(t_integer(2), t_integer(2)))),[(a,3), (y,5)], [(a,3), (y,5), (z,4)]).


% TESTING ASSIGNMENT OPERATOR
?- eval_assignment_operator(t_assignment_operator, =).

% TESTING END OF COMMAND
?- eval_end_of_command(t_end_of_command, ;).

% TESTING VARIABLE TYPE
?- eval_variable_type(t_variable_type(float), 5.5). 
?- eval_variable_type(t_variable_type(int), 5). 
?- eval_variable_type(t_variable_type(string), "String testing"). 
?- eval_variable_type(t_variable_type(string), "String testing 'K' "). 
?- eval_variable_type(t_variable_type(bool), C, false). 
?- eval_variable_type(t_variable_type(bool), C, true). 

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


?- eval_expression(t_boolean_expression(t_boolean(false),t_boolean_operator(and),t_boolean(false)),[(a,3), (y,5)],false, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(true), t_boolean_operator(and), t_boolean(false)),[(a,3), (y,5)],false, [(a,3), (y,5)].
?- eval_expression(t_boolean_expression(t_boolean(false),t_boolean_operator(and),t_boolean(true)),[(a,3), (y,5)],false, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(true), t_boolean_operator(and), t_boolean(true)),[(a,3), (y,5)],true, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(false),t_boolean_operator(or),t_boolean(false)),[(a,3), (y,5)],false, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(true), t_boolean_operator(or),t_boolean(false)),[(a,3), (y,5)],true, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(false),t_boolean_operator(or),t_boolean(true)),[(a,3), (y,5)],true, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(true), t_boolean_operator(or),t_boolean(true)),[(a,3), (y,5)],true, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(false),t_boolean_operator(not)),[(a,3), (y,5)],true, [(a,3), (y,5)]).
?- eval_expression(t_boolean_expression(t_boolean(true),t_boolean_operator(not)),[(a,3), (y,5)],false, [(a,3), (y,5)]).
