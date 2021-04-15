program(t_program(X)) --> command_list(X).
block(t_block(X)) --> ['{'], command_list(X), ['}'].

print_command(t_print_command(X)) --> ['print'], ['('], expression(X), [')'], end_of_command.

while_loop_command(t_while_command(C, B)) --> ['while'], ['('], condition(C), [')'], block(B).

for_enhanced_command(t_enhanced_for_command(VN, RV1, RV2, B)) -->
    ['for'], variable_name(VN), ['in'], ['range'], ['('], range_value(RV1), [','], range_value(RV2), [')'], block(B).

range_value(t_range_value(VN)) --> variable_name(VN).
range_value(t_range_value(I)) --> integer(I).

variable_declaration_command(t_variable_declaration_command(VT, VN)) --> variable_type(VT), variable_name(VN), end_of_command.
variable_declaration_command(t_variable_declaration_command(VT, VN, AO, E)) -->
    variable_type(VT), variable_name(VN), assignment_operator(AO), expression(E), end_of_command.

assignment_command(t_assignment_command(VN, AO, E)) --> variable_name(VN), assignment_operator(AO), expression(E), end_of_command.

% expression, decrement_expression, increment_expression, condition

:- table expr/3, term/3.

expression(t_assignment_expr(X)) --> assignment_expression(X).
expression(X) --> expr(X).

expr(t_add(X, Y)) --> expr(X), [+], term(Y).
expr(t_sub(X, Y)) --> expr(X), [-], term(Y).
expr(X) --> term(X).

term(t_multiply(X, Y)) --> term(X), [*], high_precedence_expression(Y).
term(t_divide(X, Y)) --> term(X), [/], high_precedence_expression(Y).
term(X) --> high_precedence_expression(X).

high_precedence_expression(t_high_precedence(X)) --> ['('], expression(X), [')'].

high_precedence_expression(X) --> variable_name(X).
high_precedence_expression(X) --> integer(X).

integer(digit(X)) --> [X], {number(X)}.

condition(t_cond(X, Y, Z)) --> expression(X), comparison_operators(Y), expression(Z).

decrement_expression(t_dec_expr(X, Y)) --> variable_name(X), decrement_operator(Y).
decrement_expression(t_dec_expr(X, Y)) --> decrement_operator(X), variable_name(Y).
increment_expression(t_inc_expr(X, Y)) --> variable_name(X), increment_operator(Y).
increment_expression(t_inc_expr(X, Y)) --> increment_operator(X), variable_name(Y).

% terminals

variable_type(t_type(int)) --> [int].
variable_type(t_type(float)) --> [float].
variable_type(t_type(bool)) --> [bool].
variable_type(t_type(string)) --> [string].

decrement_operator(t_decrement) --> [--].
increment_operator(t_increment) --> [++].

comparison_operators(t_lt) --> [<].
comparison_operators(t_gt) --> [>].
comparison_operators(t_le) --> [<=].
comparison_operators(t_ge) --> [>=].
comparison_operators(t_equal) --> [==].
comparison_operators(t_not_equal) --> ['!='].

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

boolean_value(true) --> [true].
boolean_value(false) --> [false].

assignment_operator(=) --> [=].
end_of_command(;) --> [;].

%TEST CASES

?-variable_type(t_type(int), [int, end], [end]).
?-variable_type(t_type(float), [float, end], [end]).
?-variable_type(t_type(bool), [bool, end], [end]).
?-variable_type(t_type(string), [string, end], [end]).

?-decrement_operator(t_decrement, [--, end], [end]).
?-increment_operator(t_increment, [++, end], [end]).

?-comparison_operators(t_lt ,  [<  ,  end] ,  [end]).
?-comparison_operators(t_gt ,  [>  ,  end] ,  [end]).
?-comparison_operators(t_le ,  [<= ,  end] ,  [end]).
?-comparison_operators(t_ge ,  [>= ,  end] ,  [end]).
?-comparison_operators(t_equal,  [== ,  end] ,  [end]).
?-comparison_operators(t_not_equal,  ['!=' ,  end] ,  [end]).

?-boolean_value((true), [true, end], [end]).
?-boolean_value((false), [false, end], [end]).

?-assignment_operator((=), [=, end], [end]).
?-end_of_command((;), [;, end], [end]).

% TEST CODE

?- value(t_float_value(1.23), [1.23, 2], [2]).
?- value(t_integer_value(1), [1, 2.2], [2.2]).
?- value(t_boolean_value(true), [true, 2], [2]).
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

?- boolean_value(true, [true, false], [false]).
?- boolean_value(false, [false, true], [true]).


