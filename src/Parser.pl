% Parsing program and block 
program(t_program(X)) --> command_list(X), [.].
block(t_block(X)) --> ['{'], command_list(X), ['}'].  

% Parsing print command
print_command(t_print(X)) --> ['print'], ['('], expression(X), [')'], end_of_command. 

% Parsing while command
while_loop_command(t_while_loop(C, B)) --> ['while'], ['('], condition(C), [')'], block(B).

% Parsing for enhanced command
for_enhanced_command(t_for_enhanced(VN, RV1, RV2, B)) --> ['for'], variable_name(VN), ['in'], ['range'], ['('], range_value(RV1), [','], range_value(RV2), [')'], block(B).

% Parsing Range value
range_value(t_range(VN)) --> variable_name(VN).
range_value(t_range(I)) --> integer(I).

% Parsing Variable declaration command
variable_declaration_command(t_variable_declaration(VT, VN)) --> variable_type(VT), variable_name(VN), end_of_command.
variable_declaration_command(t_variable_declaration(VT, VN, AO, E)) --> variable_type(VT), variable_name(VN), assignment_operator(AO), expression(E), end_of_command.

% Parsing Assignment command
assignment_command(t_assignment_command(VN, AO, E)) --> variable_name(VN), assignment_operator(AO), expressoion(E), end_of_command. 
