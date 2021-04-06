import sys
from sly import Lexer


class Lexer(Lexer):
    # Set of token names.   This is always required

    literals = {'{', '}', ',', '?', ';', ':', '[', ']', '(', ')', '.', '!'}
    tokens = {ID, EQUAL, LE, LT, GE, GT, ASSIGN, FLOAT, NUMBER, PLUS, MINUS, MULTIPLY,
              DIVIDE, MODULO, POW, DOUBLE_QUOTES, SINGLE_QUOTES , INCREMENT, DECREMENT}

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

    INCREMENT = r'\++'
    DECREMENT = r'\--'

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









# .* will match any character (including newlines if dotall is used). This is greedy: it matches as much as it can.
#
# (.*) will add that to a capture group.
#
# (.*?) the ? makes the .* non-greedy, matching as little as it can to make a match, and the parenthesis makes it a capture group as well.