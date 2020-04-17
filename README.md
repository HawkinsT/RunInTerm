# RunInTerm

RunInTerm is a plug-in for the [Neovim](https://www.neovim.io) and [Vim 8+](https://www.vim.org/) editors, providing a convenient way to intelligently, asynchronously, execute buffer contents and terminal commands via Vim's inbuilt terminal emulator.

![RunInTerm Demo](demo/demo.gif)

## Table of contents

  * [Installation](#installation)
  * [Quick Start](#quick-start)
  * [Key Bindings](#key-bindings)
  * [Settings](#settings)

## Installation

Using the [vim-plug](https://github.com/junegunn/vim-plug) plug-in manager, add the following to your `vimrc` file:

```vim
call plug#begin()
  Plug 'HawkinsT/RunInTerm'
call plug#end()
```

Then run `:PlugInstall` from within Vim.

Alternatively, this plug-in may be loaded for only specific file types using (e.g. for perl and python):

```vim
call plug#begin()
  Plug 'HawkinsT/RunInTerm', { 'for': ['perl', 'python'] }
call plug#end()
```

This plug-in may be similarly loaded using other plug-in managers; for this, see their respective documentations.

## Quick Start

This plug-in provides the function `RunInTerminal()`, which may take up to three optional arguments.

If run without arguments, it executes the contents of the current buffer via its `FileType`. For example, within a python buffer, `:call RunInTerminal()` will execute `python RunInTerm_exampleFilename.py.tmp` within Vim's terminal emulator (where RuneInTerm_exampleFilename.py.tmp is a temporary file that is automatically created and cleaned up). 

If run with one argument, this argument will be used instead of the buffer's `FileType`. For example, `:call RunInTerminal("py -2.7")` will execute `py -2.7 RunInTerm_exampleFilename.py.tmp`.

If run with two arguments, the arguments will be passed to the terminal, however no temporary file containing the buffer's contents will be created.

If run with three arguments, a temporary file will be created and passed to the terminal, with the first and third arguments being passed before and after the temporary filename (the second argument will be ignored). For example, `:call RunInTerminal("julia","","--machinefile machinefile")` will execute `julia RunInTerm_exampleFilename.jl.tmp --machinefile machinefile`.

There are also two special cases: if an empty string or "bash" are passed as the first argument, e.g. `RunInTerminal("")`, `RunInTerminal("bash","")`, then Vim's terminal emulator is launched and focus is switched to the terminal instead of remaining on the current window. In the special case of `RunInTerminal("")`, no temporary file is created.

## Key Bindings

No key bindings are set by default; you may specify your own in your `vimrc` file, e.g:

```vim
nnoremap <silent> <leader>r :call RunInTerminal()<CR>
nnoremap <silent> <leader>t :call RunInTerminal("")<CR>
```

You may also specify custom bindings for specific file types, e.g:

```vim
autocmd FileType python    nnoremap <buffer> <silent> <leader>r :call RunInTerminal("py -3.7")<CR>
```

Commands may be run on the current buffer without the use of a temporary file through use of `@%`, e.g:

```vim
autocmd FileType julia     nnoremap <buffer> <silent> <leader>r :w|:call RunInTerminal("julia", @%." --machinefile machinefile")<CR>
```

## Settings

| Option               | Default  | Description                                                                 |
|----------------------|----------|-----------------------------------------------------------------------------|
| `g:RunInTerm_pos`    | "bottom" | Terminal position (allowed values are "left", "right", "top", and "bottom") |
| `g:RunInTerm_height` | 16       | Terminal height (if positioned at the top/bottom)                           |
| `g:RunInTerm_width`  | 84       | Terminal width (if positioned to the left/right)                            |

Settings should be added to your `vimrc` file, e.g:

```vim
let g:RunInTerm_pos = "right"
unlet g:RunInTerm_width
```
