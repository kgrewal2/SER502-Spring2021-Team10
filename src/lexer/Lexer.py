import sys
from sly import Lexer


class CalcLexer(Lexer):
    # Set of token names.   This is always required

    literals = {'{', '}', ',', '?', ';', ':', '[', ']', '(', ')'}
    tokens = {ID, EQUAL, LE, LT, GE, GT, ASSIGN, FLOAT, NUMBER, PLUS, MINUS, MULTIPLY,
              DIVIDE, MODULO, POW, DOUBLE_QUOTES, SINGLE_QUOTES }

    # String containing ignored characters between tokens
    ignore = ' \t'
    ignore_newline = r'\n+'

    #(.*) match all the groups
    ignore_comment = r'\#(.*)'

    # Regular expression rules for tokens
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'

    EQUAL = r'=='
    LE = r'<='
    GE = r'>='

    LT = r'<'
    GT = r'>'
    ASSIGN = r'='

    FLOAT = r'\d+\.\d+'
    NUMBER = r'\d+'
    PLUS = r'\+'
    MINUS = r'-'
    MULTIPLY = r'\*'
    DIVIDE = r'/'
    MODULO = r'%'
    POW = r'\^'

    DOUBLE_QUOTES = r'\"'
    SINGLE_QUOTES = r'\''


def read_program():
    # Checking the file extension
    file_extn = sys.argv[1][-4:]
    if file_extn == ".imp":
        # Handling file operations and file errors
        try:
            with open(sys.argv[1], "r") as input_file:
                program = input_file.read()
                print("program: " + program)
        except FileNotFoundError:
            print("No such file in path:", sys.argv[1])
        return program

    else:
        print("Invalid file :", sys.argv[1])


if __name__ == '__main__':
    data = read_program()
    lexer = CalcLexer()
    output_file = "tokens.txt"
    with open(output_file, "w") as f:
        for token in lexer.tokenize(data):
            f.write('{}\n'.format(token.value))


#venv\Scripts\python.exe Lexer.py Input.imp

# .* will match any character (including newlines if dotall is used). This is greedy: it matches as much as it can.
#
# (.*) will add that to a capture group.
#
# (.*?) the ? makes the .* non-greedy, matching as little as it can to make a match, and the parenthesis makes it a capture group as well.