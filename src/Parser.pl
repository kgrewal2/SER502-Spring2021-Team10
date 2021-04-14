
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

bracket(X) --> variable_name(X).
bracket(X) --> integer(X).

integer(digit(X)) --> [X], {number(X)}.

variable_name(var(X)) --> [X],{atom(X)}.

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

decrement_operator(--) --> [--].
increment_operator(++) --> [++].

comparison_operators(<) --> [<].
comparison_operators(>) --> [>].
comparison_operators(<=) --> [<=].
comparison_operators(>=) --> [>=].
comparison_operators(==) --> [==].
comparison_operators(!=) --> [!=].

single_quote(\') --> [\'].
double_quote(\") --> [\"].

boolean_value(true) --> [true].
boolean_value(false) --> [false].

assignment_operator(=) --> [=].
end_of_command(;) --> [;].

and_operator(and) --> [and].
or_operator(or) --> [or].
not_operator(not) --> [not].

%TEST CASES

?-variable_type(t_type(int), [int, end], [end]).
?-variable_type(t_type(float), [float, end], [end]).
?-variable_type(t_type(bool), [bool, end], [end]).
?-variable_type(t_type(string), [string, end], [end]).

?-decrement_operator((--), [--, end], [end]).
?-increment-operator((++), [++, end], [end]).

?-comparison_operators((<), [<, end], [end]).
?-comparison_operators((>), [>, end], [end]).
?-comparison_operators((<=), [<=, end], [end]).
?-comparison_operators((>=), [>=, end], [end]).
?-comparison_operators((==), [==, end], [end]).
?-comparison_operators((!=), [!=, end], [end]).

?-single_quote((\'), [\', end], [end]).
?-double_quote((\"), [\", end], [end]).

?-boolean_value((true), [true, end], [end]).
?-boolean_value((false), [false, end], [end]).

?-assignment_operator((=), [=, end], [end]).
?-end_of_command((;), [;, end], [end]).

?-and_operator((and), [and, end], [end]).
?-or_operator((or), [or, end], [end]).
?-not_operator((not), [not, end], [end]).

