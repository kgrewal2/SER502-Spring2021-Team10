% READS THE FILE
read_file(FileName) :-
    open(FileName, read, Stream),
    read_stream(Stream, FileData),
    close(Stream),
    write(FileData),  nl.

% READING CURRENT LINE AND CONVERTING INTO CHARACTERS
read_stream(Stream, [CurrentLineCharacters | List]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_chars(CurrentLineCharacters, Codes),
    read_stream(Stream, List), !.

% END OF LINE
read_stream(Stream, []) :- at_end_of_stream(Stream).
