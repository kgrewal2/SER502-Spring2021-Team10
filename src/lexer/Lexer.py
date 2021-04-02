import sys
from sly import Lexer


class CalcLexer(Lexer):
    # Set of token names.   This is always required
    tokens = {ID, NUMBER, PLUS, MINUS, TIMES,
              DIVIDE, ASSIGN, LPAREN, RPAREN}

    # String containing ignored characters between tokens
    ignore = ' \t'

    # Regular expression rules for tokens
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
    NUMBER = r'\d+'
    PLUS = r'\+'
    MINUS = r'-'
    TIMES = r'\*'
    DIVIDE = r'/'
    ASSIGN = r'='
    LPAREN = r'\('
    RPAREN = r'\)'


def read_program():
    # Checking file extension
    file_extn = sys.argv[1][-4:]
    # print(file_extn)
    if file_extn == ".imp":
        # Handling file operations and file errors
        try:
            with open(sys.argv[1], "r") as input_file:
                program = input_file.read()
                print("program " + program)
        except FileNotFoundError:
            print("No such file in path:", sys.argv[1])
        return program

    else:
        print("Invalid file :", sys.argv[1])


if __name__ == '__main__':
    data = read_program()
    lexer = CalcLexer()
    for tok in lexer.tokenize(data):
        print(tok.value)