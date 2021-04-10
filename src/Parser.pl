ternary_expression(t_ternary_expression(Condition, TrueExpression, FalseExpression)) -->
    ['('], condition(Condition),  [')'], ['?'], expression(TrueExpression), [':'], expression(FalseExpression).

operator --> boolean_operator.
operator --> [+] | [-] | [*] | [/].

boolean_operator --> and_operator | or_operator | not_operator.

and_operator --> [and].
or_operator  --> [or].
not_operator --> [not].
