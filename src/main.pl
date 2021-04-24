:- use_module(token_reader).
:- use_module(parser).

main :-
    ansi_format([bold,fg(yellow)], 'Starting Parser', []), nl,
    read_file("TestProgram.imptokens", FileData),
    program(ParseTree, FileData, []),
    write("Generating Parse Tree: "), successful_flag, nl,
    write(ParseTree), nl,
    ansi_format([bold,fg(yellow)], 'Starting Evaluation', []), nl.


successful_flag :- ansi_format([bold,fg(green)], 'SUCCESSFUL', []).