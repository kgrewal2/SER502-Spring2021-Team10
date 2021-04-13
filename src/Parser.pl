
% If, If-Else, If-Elif-Else
if_command(t_if_command(IfCondtion,IfBlock)) --> if_part(IfCondtion,IfBlock).
if_elif_else_command(t_if_elif_else_command(IfCondtion,IfBlock, ElifCondtion, ElifBlock, ElseBlock)) --> if_part(IfCondtion, IfBlock), elif_part(ElifCondtion, ElifBlock), else_part(ElseBlock).
if_else_command(t_if_else(IfCondtion,IfBlock,ElseBlock)) --> if_part(IfCondtion,IfBlock), else_part(ElseBlock).
if_part(t_if(IfCondtion,IfBlock)) --> [if], ['('], condition(IfCondtion), [')'], block(IfBlock).
else_part(t_else(ElseBlock)) --> [else], block(ElseBlock);
elif_part(t_elif(ElifCondtion,ElifBlock)) --> [elif], ['('], condition(ElifCondtion), [')'], block(ElifBlock).
elif_part(t_elif(ElifCondtion,ElifBlock,ElifCondtion2)) --> [elif], ['('], condition(ElifCondtion), [')'], block(ElifBlock), elif_part(ElifCondtion2).

ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('], condition(Condition),  [')'], ['?'], expression(TrueExpression), [':'], expression(FalseExpression).

value(t_float_value(Value)) --> float_value(Value).
value(t_integer_value(Value)) --> integer_value(Value).
value(t_boolean_value(Value)) --> boolean_value(Value).
value(t_string_value(Value)) --> string_value(Value).

boolean_operator(BooleanOperator) -->
    and_operator(BooleanOperator) | or_operator(BooleanOperator) | not_operator(BooleanOperator).

and_operator(t_bool_and) --> [and].

or_operator(t_bool_or) --> [or].

not_operator(t_bool_not) --> [not].

operator(BooleanOperator) --> boolean_operator(BooleanOperator).
operator(t_operator(Operator), [Operator | Tail], Tail) :- member(Operator, [+, -, *, /]).

variable_name(t_variable_name(VariableName), [VariableName | Tail], Tail) :-
    atom(VariableName).

float_value(Value, [Value | Tail], Tail) :- float(Value).

integer_value(Value, [Value | Tail], Tail) :- integer(Value).

string_value(Value, [Value | Tail], Tail) :- string(Value).

boolean_value(True) --> [True].
boolean_value(False) --> [False].

% TEST CODE

?- value(t_float_value(1.23), [1.23, 2], [2]).
?- value(t_integer_value(1), [1, 2.2], [2.2]).
?- value(t_boolean_value(True), [True, 2], [2]).
?- value(t_string_value("Hello''"), ["Hello''", 2], [2]).
?- value(t_string_value("Hello"), ["Hello", 2], [2]).
?- value(t_string_value("Hello\""), ["Hello\"", 2], [2]).

?- boolean_operator(t_bool_and, [and, end], [end]).
?- boolean_operator(t_bool_or, [or, end], [end]).
?- boolean_operator(t_bool_not, [not, end], [end]).

?- and_operator(t_bool_and, [and, end], [end]).

?- or_operator(t_bool_or, [or, end], [end]).

?- not_operator(t_bool_not, [not, end], [end]).

?- operator(t_operator(+), [+, end], [end]).
?- operator(t_operator(-), [-, end], [end]).
?- operator(t_operator(*), [*, end], [end]).
?- operator(t_operator(/), [/, end], [end]).

?- variable_name(t_variable_name(variable_name), [variable_name, end], [end]). % Variable name can contain lower case, upper case and underscores
?- variable_name(t_variable_name(variableName), [variableName, end], [end]).
?- variable_name(t_variable_name(variable), [variable, end], [end]).
?- not(variable_name(t_variable_name(Variable_name), [Variable_name, end], [end])). % Variable name should not start with capital letter
?- not(variable_name(t_variable_name(_variable_name), [_variable_name, end], [end])). % Variable name should not start with underscore

?- float_value(12.3, [12.3], []).

?- integer_value(12, [12], []).

?- string_value("Hello''", ["Hello''", 12], [12]).
?- string_value("Hello", ["Hello", 12], [12]).
?- string_value("Hello \"", ["Hello \"", 12], [12]).

?- boolean_value(True, [True, False], [False]).
?- boolean_value(False, [False, True], [True]).
