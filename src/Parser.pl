ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('], condition(Condition),  [')'], ['?'], expression(TrueExpression), [':'], expression(FalseExpression).

operator --> boolean_operator.
operator --> [+] | [-] | [*] | [/].

boolean_operator(B) --> and_operator(B) | or_operator(B) | not_operator(B).

and_operator(bool_and) --> [and].
or_operator(bool_or)  --> [or].
not_operator(bool_not) --> [not].

% TEST CODE
?- boolean_operator(bool_and, [and, end], [end]).
?- boolean_operator(bool_or, [or, end], [end]).
?- boolean_operator(bool_not, [not, end], [end]).

?- and_operator(bool_and, [and, end], [end]).
?- or_operator(bool_or, [or, end], [end]).
?- not_operator(bool_not, [not, end], [end]).
