import os
import sys
from module_Lexer.Lexer import Lexer


def read_file():
    # Checking the file extension
    file_extn = sys.argv[1][-4:]
    if file_extn == ".imp":
        # Handling file operations and file errors
        try:
            with open(sys.argv[1], "r") as input_file:
                data = input_file.read()
                #print("program: " + data)
        except FileNotFoundError:
            print("No such file in path:", sys.argv[1])
        return data

    else:
        #TODO Implement for other file types in future
        print("Invalid file :", sys.argv[1])


if __name__ == '__main__':
    data = read_file()
    tokens = Lexer()
    tokens_file_path = os.path.join("module_Lexer", "tokens.txt")
    with open(tokens_file_path, "w") as f:
        for token in tokens.tokenize(data):
            f.write('{}\n'.format(token.value))


#venv\Scripts\python.exe Lexer.py Input.imp
#venv\Scripts\python.exe Driver.py Input.imp
