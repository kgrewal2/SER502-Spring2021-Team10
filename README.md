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
> Requires `swipl` in the command line. Doesn't work with `swipl.exe` or swipl application.
```
 python Lexer.py TestProgram.imp --evaluate
```

If the user doesn't use the `--evaluate` flag, the tokens are saved in the `xxx.imptokens` file.

### Evaluating the tokens file
> Use this if you are using `swipl.exe` or swipl application
- Load the `main.pl` file
- Type `main('xxx.imptokens')` where `xxx` is the name of the source code file.

---

## Contributors
- Kamal Penmetcha
- Karandeep Singh Grewal
- Nikhil Hiremath
- Subramanian Arunachalam

## Acknowledgments
- Dr. Ajay Bansal
- Sakshi Jain

