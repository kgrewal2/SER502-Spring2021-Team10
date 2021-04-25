# IMPRO
> Main Project Repository for SER502 (Emerging Languages and Programming Paradigms)

## Installation
### Installing Prolog
#### Arch Linux
```
$ pacman -S swi-prolog
```
#### MacOS (Requires Homebrew)
```
homebrew install swi-prolog
```

### Installing SLY
`pip install sly` or `python3 -m pip install sly`

---

## Usage
### Evaluating TestProgram.imp using Lexer.py
`--evaluate` option is used to generate the tokens and evaluate them at the same time.
```
 python Lexer.py TestProgram.imp --evaluate
```

### Options for Lexer.py
```
usage: Lexer.py [-h] [--evaluate] InputFileName

IMPRO Lexer - Converts the IMPRO source code into a list of tokens and save it as <InputFileName>.imptokens

positional arguments:
  InputFileName  Path to Input File that contains the IMPRO source code

optional arguments:
  -h, --help     show this help message and exit
  --evaluate     Evaluate the generated tokens
```
If the user doesn't use the `--evaluate` flag, the tokens are saved in the file.

### Evaluating the tokens file
- Load the `main.pl` file
- Type `main('inputfile.imptokens'` where inputfile is the name of the source code.

---

## Contributors
- Kamal Penmetcha
- Karandeep Singh Grewal
- Nikhil Hiremath
- Subramanian Arunachalam

## Acknowledgments
- Dr. Ajay Bansal
- Sakshi Jain

