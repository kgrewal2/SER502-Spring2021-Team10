%%%%%%%%%%%%%%%
% Environment %
%%%%%%%%%%%%%%%

% lookup(Name, Value, Env, NewEnv)
lookup(Name, Value, [(_, Name, Value) | _]).
lookup(Name, Value, [_Head | Tail]) :- lookup(Name, Value, Tail).

% update(Name, Value, Env, NewEnv)
update(Name, _, [], []) :- error_undeclared(Name).
update(Name, Value, [Head | Tail], [Head | NewEnv]) :- Head \= (_, Name, _), update(Name, Value, Tail, NewEnv).
update(Name, Value, [(int   , Name, _) | Env], [ (int   , Name, Value)| Env]) :- integer(Value).
update(Name, Value, [(float , Name, _) | Env], [ (float , Name, Value)| Env]) :- float(Value).
update(Name, Value, [(bool  , Name, _) | Env], [ (bool  , Name, Value)| Env]) :- member(Value, [true, false]).
update(Name, Value, [(string, Name, _) | Env], [ (string, Name, Value)| Env]) :- string(Value).

% update - errors for type mismatch
update(Name, Value, [(int  , Name, _) | _], _)  :- not(integer(Value)),               error_type_conversion(Name, int).
update(Name, Value, [(float, Name, _) | _], _)  :- not(float(Value)),                 error_type_conversion(Name, float).
update(Name, Value, [(bool , Name, _) | _], _)  :- not(member(Value, [true, false])), error_type_conversion(Name, bool).
update(Name, Value, [(string, Name, _) | _], _) :- not(string(Value)) ,               error_type_conversion(Name, string).

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
