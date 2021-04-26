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
### If `swipl` is installed as command line (Tested on Arch Linux and MacOS)
```
 python Lexer.py --evaluate TestProgram.imp
```

### If `swipl` is not installed as command line
```
 python Lexer.py TestProgram.imp
```
- Open your prolog application in the src directory
- Load the `main.pl` file
- Type `main('xxx.imptokens')` where `xxx` is the name of the source code file.

---

## Vim Integration
> Enables you to run IMP files from Vim
>
> Note: IMP File needs to be inside the `src` directory and vim should be opened from the `src` directory only.
- Add to vimrc
```
augroup imp_ft
  au!
  autocmd BufNewFile,BufRead *.imp  set filetype=imp
augroup END
```

- Add to ~/.vim/ftplugin/imp.vim
```
nnoremap <F10> :w<CR>:!python Lexer.py --evaluate %<CR>
```
- Go to `src` directory
- Create new IMP file.
```
touch newFile.imp
```
- Open the IMP file.
```
vim newFile.imp
```
- Press <kbd>F10</kbd> to run the IMP Program


## Contributors
- Kamal Penmetcha
- Karandeep Singh Grewal
- Nikhil Hiremath
- Subramanian Arunachalam

## Acknowledgments
- Dr. Ajay Bansal
- Sakshi Jain

## Youtube Video Link
https://www.youtube.com/watch?v=3dZ7Q3DcN08
