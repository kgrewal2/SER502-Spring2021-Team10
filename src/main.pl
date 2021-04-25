:- use_module(token_reader).
:- use_module(parser).
:- use_module(evaluator_optimized).

main(Filename) :- nl,
    ansi_format([bold,fg(yellow)], 'Starting Parser', []), nl,
    read_file(Filename, FileData),
    program(ParseTree, FileData, []),
    write("Generating Parse Tree: "), successful_flag, nl,
    write(ParseTree), nl,
    ansi_format([bold,fg(yellow)], 'Starting Evaluation', []), nl,
    eval_program(ParseTree, NewEnv),
    ansi_format([bold,fg(yellow)], 'Environment after Evaluation', []), nl,
    write(NewEnv), nl,
    halt.

successful_flag :- ansi_format([bold,fg(green)], 'SUCCESSFUL', []).
