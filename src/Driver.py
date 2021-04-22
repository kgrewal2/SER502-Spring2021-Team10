import sys
import argparse
from sly import Lexer


class Lexer(Lexer):
    # SET OF TOKENS
    tokens = {ASSIGN, DECREMENT, DIVIDE, DOUBLE_QUOTES, EQUAL, FLOAT, GE, GT, ID, INCREMENT, LE, LT, MINUS, MODULO,
              MULTIPLY, NOT_EQUAL, NUMBER, PLUS, POW, SINGLE_QUOTES, STRING}

    # LITERALS
    literals = {'{', '}', ',', '?', ';', ':', '[', ']', '(', ')', '.', '!'}

    # IGNORE
    ignore = ' \t'
    ignore_newline = r'\n+'
    # ignore_single_quote_in_string = r'\\"'
    ignore_comment = r'\#(.*)'

    # TOKENS
    ASSIGN = r'='
    DECREMENT = r'\--'
    DIVIDE = r'/'
    DOUBLE_QUOTES = r'\"'
    EQUAL = r'=='
    FLOAT = r'\d+\.\d+'
    GE = r'>='
    GT = r'>'
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
    INCREMENT = r'\++'
    LE = r'<='
    LT = r'<'
    MINUS = r'-'
    MODULO = r'%'
    MULTIPLY = r'\*'
    NOT_EQUAL = r'!='
    NUMBER = r'\d+'
    PLUS = r'\+'
    POW = r'\^'
    SINGLE_QUOTES = r'\''
    STRING = r'".*"'


def parse_arguments():
    parser = argparse.ArgumentParser(description='IMPRO Lexer - Stores the IMPRO source code into a list of tokens as <filename>.impt')
    parser.add_argument('input', metavar='InputFile', type=str,
                        nargs=1, help='Input File that contains the IMPRO source code')
    return parser.parse_args()


def read_input_file(filename):
    data = None
    try:
        with open(filename, "r") as input_file:
            data = input_file.read()
    except FileNotFoundError:
        print("No such file in path:", sys.argv[1])
    return data


def write_tokens_to_file(tokens, filename):
    with open(filename, "w") as file:
        for token in tokens:
            file.write('{}\n'.format(token.value))


if __name__ == '__main__':
    parsed_args = parse_arguments()
    input_filename = parsed_args.input[0]
    output_filename = parsed_args.input[0]+'tokens'
    file_data = read_input_file(input_filename)

    lexer = Lexer()
    print(file_data)
    tokens = lexer.tokenize(file_data)
    write_tokens_to_file(tokens, output_filename)
