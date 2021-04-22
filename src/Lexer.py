import sys
from sly import Lexer


class Lexer(Lexer):
    # SET OF TOKENS
    tokens = {ASSIGN, DECREMENT, DIVIDE, DOUBLE_QUOTES, EQUAL, FLOAT, GE, GT, ID, INCREMENT, LE, LT, MINUS, MODULO, MULTIPLY, NOT_EQUAL, NUMBER, PLUS, POW, SINGLE_QUOTES, STRING}

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
