:- module(read_file, [read_file/2]).

read_file(FileName, ConvertedData) :-
    open(FileName, read, Stream),
    read_stream(Stream, FileData),
    convert(FileData, ConvertedData),
    close(Stream).

% READING CURRENT LINE AND CONVERTING INTO CHARACTERS
read_stream(Stream, [CurrentLineCharacters | List]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_codes(CurrentLineCharacters, Codes),
    read_stream(Stream, List), !.

% END OF LINE
read_stream(Stream, []) :- at_end_of_stream(Stream).

% CONVERTS THE ATOMS TO NUMBERS IF ANY
convert([H|T], [N|R]) :- atom_number(H, N), convert(T, R).
convert([H|T], [H|R]) :- atom(H), convert(T, R).
convert([], []).