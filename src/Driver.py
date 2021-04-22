# import os
# import sys
# from module_Lexer.Lexer import Lexer


# def read_file():
#    # Checking the file extension
#    file_extn = sys.argv[1][-4:]
#    if file_extn == ".imp":
#        # Handling file operations and file errors
#        try:
#            with open(sys.argv[1], "r") as input_file:
#                data = input_file.read()
#                #print("program: " + data)
#        except FileNotFoundError:
#            print("No such file in path:", sys.argv[1])
#        return data

#    else:
#        #TODO Implement for other file types in future
#        print("Invalid file :", sys.argv[1])


import argparse
# if __name__ == '__main__':
#    data = read_file()
#    tokens = Lexer()
#    tokens_file_path = os.path.join("module_Lexer", "tokens.txt")
#    with open(tokens_file_path, "w") as f:
#        for token in tokens.tokenize(data):
#            f.write('{}\n'.format(token.value))
import sys


def parse_arguments():
    parser = argparse.ArgumentParser(description='IMPRO Lexer - Stores the IMPRO source code into a list of tokens')
    parser.add_argument('input', metavar='InputFile', type=str,
                        nargs=1, help='Input File that contains the IMPRO source code')
    parser.add_argument('--output', metavar='filename', type=str,
                        nargs=1, help='Output File to store the generated list of tokens (Default: InputFile.tokens)')
    return parser.parse_args()


def read_input_file(filename):
    try:
        with open(filename, "r") as input_file:
            data = input_file.read()
            print("program: " + data)
    except FileNotFoundError:
        print("No such file in path:", sys.argv[1])


if __name__ == '__main__':
    args = parse_arguments()
    read_input_file(args.input[0])
    print(args.output[0])

