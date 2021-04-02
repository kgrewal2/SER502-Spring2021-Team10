import sys
from sly import Lexer


class CalcLexer(Lexer):
    # Set of token names.   This is always required
    tokens = {ID, EQUAL, LE, LT, GE, GT, ASSIGN, NUMBER, PLUS, MINUS, MULTIPLY,
              DIVIDE, MODULO, POW, LPAREN, RPAREN}

    # String containing ignored characters between tokens
    ignore = ' \t'
    ignore_newline = r'\n+'
    ignore_comment = r'\#(.*)'

    # Regular expression rules for tokens
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'

    EQUAL = r'=='
    LE = r'<='
    GE = r'>='

    LT = r'<'
    GT = r'>'
    ASSIGN = r'='

    NUMBER = r'\d+'
    PLUS = r'\+'
    MINUS = r'-'
    MULTIPLY = r'\*'
    DIVIDE = r'/'
    MODULO = r'%'
    POW = r'\^'

    LPAREN = r'\('
    RPAREN = r'\)'


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
