# IMPRO
> Main Project Repository for SER502 (Emerging Languages and Programming Paradigms)

## Installation
### Installing Prolog
#### Arch Linux
```
$ pacman -S swi-prolog
```

#### MacOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


### Installing SLY
```
pip install sly
```

---

## Usage
### Evaluating TestProgram.imp
```
 python Lexer.py TestProgram.imp --evaluate
```

### Options
```
usage: Lexer.py [-h] [--evaluate] InputFileName

IMPRO Lexer - Converts the IMPRO source code into a list of tokens and save it as <InputFileName>.imptokens

positional arguments:
  InputFileName  Path to Input File that contains the IMPRO source code

optional arguments:
  -h, --help     show this help message and exit
  --evaluate     Evaluate the generated tokens
```

---

## Contributors
- Kamal Penmetcha
- Karandeep Singh Grewal
- Nikhil Hiremath
- Subramanian Arunachalam

## Acknowledgments
- Dr. Ajay Bansal
- Sakshi Jain

