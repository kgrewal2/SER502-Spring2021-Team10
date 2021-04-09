% PARSER

% Parsing program and block 
program(t_program(X)) --> block(X), [.].
block(t_block(X)) --> ['{'], command_list(X), ['}'].  

% Parsing print command
print_command(t_print(X)) --> ['print'], ['('], expression(X), [')'], end_of_command. 



