% READS THE FILE LINE BY LINE AND RETURN AS A LIST
read_file(FileName, FileData) :-
    open(FileName, read, Stream),
    read_stream(Stream, FileData),
    close(Stream),
    print_list(FileData).

% PRINTS A LIST WITH NEW-LINE CHARACTER
print_list([]).
print_list([H|T]):-
    write(H), nl,
    print_list(T).

% READS A STREAM LINE BY LINE AND RETURN AS A LIST
read_stream(Stream, [CurrentLineCharacters | List]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_chars(CurrentLineCharacters, Codes),
    read_stream(Stream, List), !.
read_stream(Stream, []) :- at_end_of_stream(Stream).
