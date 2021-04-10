
% expression, decrement_expression, increment_expression, condition

:- table expr/3, term/3.

expression(t_assign_multiple_expr(X, Y)) --> identifier(X), [:=], expression(Y).
expression(X) --> expr(X).

expr(t_add(X, Y)) --> expr(X), [+], term(Y).
expr(t_sub(X, Y)) --> expr(X), [-], term(Y).
expr(X) --> term(X).

term(t_multiply(X, Y)) --> term(X), [*], bracket(Y).
term(t_divide(X, Y)) --> term(X), [/], bracket(Y).
term(X) --> bracket(X).

bracket(t_bracket(X)) --> ['('], expression(X), [')'].

bracket(X) --> variable_name(X).
bracket(X) --> integer(X).

integer(digit(X)) --> [X], {number(X)}.

variable_name(var(X)) --> [X],{atom(X)}.

condition(t_cond(X, Y, Z)) --> variable_name(X), comparison_operators(Y), expression(Z).

decrement_expression(t_dec_expr(X, Y)) --> variable_name(X), decrement_operator(Y).
decrement_expression(t_dec_expr(X, Y)) --> decrement_operator(X), variable_name(Y).
increment_expression(t_inc_expr(X, Y)) --> variable_name(X), increment_operator(Y).
increment_expression(t_inc_expr(X, Y)) --> increment_operator(X), variable_name(Y).

% for_loop_command, variable_change_part

for_loop_command(t_for(X,Y,Z,W)) --> ['for'], ['('], assignment(X), [';'], condition(Y),  [';'], variable_change_statement(Z), [')'], block(W).

variable_change_statement(t_var_ch(X)) --> increment_expression(X)_.
variable_change_statement(t_var_ch(X)) --> decrement_expression(X).
variable_change_statement(t_var_ch(X, Y, Z)) --> variable_name(X), assignment_operator(Y), expression(Z).


