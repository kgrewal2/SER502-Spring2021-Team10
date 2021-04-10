ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('], condition(Condition),  [')'], ['?'], expression(TrueExpression), [':'], expression(FalseExpression).

operator(BooleanOperator) --> boolean_operator(BooleanOperator).
operator(operator(Operator), [Operator|Tail], Tail) :- member(Operator, [+, -, *, /]).

boolean_operator(BooleanOperator) -->
    and_operator(BooleanOperator) | or_operator(BooleanOperator) | not_operator(BooleanOperator).

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

?- operator(operator(+), [+, end], [end]).
?- operator(operator(-), [-, end], [end]).
?- operator(operator(*), [*, end], [end]).
?- operator(operator(/), [/, end], [end]).
