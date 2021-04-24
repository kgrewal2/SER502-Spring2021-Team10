import os
import sys
import argparse
from sly import Lexer


class Constants:
    PRINT_GREEN_TEXT = '\033[92m'
    PRINT_NORMAL_TEXT = '\033[0m'
    TOKEN_FILE_EXTENSION = '.imptokens'
    PRINT_YELLOW_TEXT = '\033[93m'


# Reference: https://sly.readthedocs.io/en/latest/sly.html
class ImproLexer(Lexer):
    # SET OF TOKENS
    tokens = {ASSIGN, DECREMENT, DIVIDE, EQUAL, FLOAT, GE, GT, ID, INCREMENT, LE, LT, MINUS, MODULO,
              MULTIPLY, NOT_EQUAL, NUMBER, PLUS, POW, SINGLE_QUOTES, STRING}

    # LITERALS
    literals = {'{', '}', ',', '?', ';', ':', '[', ']', '(', ')', '.', '!'}

    # IGNORE
    ignore = ' \t'
    ignore_newline = r'\n+'
    # ignore_single_quote_in_string = r'\\"'
    ignore_comment = r'\#(.*)'

    # TOKENS
    EQUAL = r'=='
    DECREMENT = r'\--'
    ASSIGN = r'='
    INCREMENT = r'\++'
    DIVIDE = r'/'
    FLOAT = r'\d+\.\d+'
    GE = r'>='
    GT = r'>'
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
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
    STRING = r'\".*\"'


def parse_arguments():
    parser = argparse.ArgumentParser(
        description='IMPRO Lexer - Converts the IMPRO source code into a list of tokens and save it as '
                    '<InputFileName>' + Constants.TOKEN_FILE_EXTENSION)
    parser.add_argument('input', metavar='InputFileName', type=str,
                        nargs=1, help='Path to Input File that contains the IMPRO source code')
    parser.add_argument('--evaluate', action='store_true', help='Evaluate the generated tokens')
    return parser.parse_args()


def read_input_file(filename):
    data = None
    try:
        with open(filename, "r") as input_file:
            data = input_file.read()
    except FileNotFoundError:
        print("No such file in path:", sys.argv[1])
    print("Reading Source Code: " + Constants.PRINT_GREEN_TEXT + 'SUCCESSFUL' + Constants.PRINT_NORMAL_TEXT)
    return data


def write_tokens_to_file(tokens, filename):
    with open(filename, "w") as file:
        for token in tokens:
            file.write('{}\n'.format(token.value))
        print("Writing Tokens in " + filename + ": " + Constants.PRINT_GREEN_TEXT +
              'SUCCESSFUL' + Constants.PRINT_NORMAL_TEXT)


if __name__ == '__main__':
    print(Constants.PRINT_YELLOW_TEXT + "Starting Lexer" + Constants.PRINT_NORMAL_TEXT)
    parsed_args = parse_arguments()
    input_filename = parsed_args.input[0]
    output_filename = parsed_args.input[0][:-4:] + Constants.TOKEN_FILE_EXTENSION
    file_data = read_input_file(input_filename)

    lexer = ImproLexer()
    tokens = lexer.tokenize(file_data)
    write_tokens_to_file(tokens, output_filename)

    should_evaluate = parsed_args.evaluate
    if should_evaluate:
        os.system("swipl --quiet -t main main.pl")
