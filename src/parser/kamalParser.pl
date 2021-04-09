% PARSER

program(t_program(X)) --> block(X), [.].

block(t_block(X)) --> ['{'], command_list(X), ['}'].  



