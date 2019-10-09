vim-among_HML
=============

vim-among_HML provides a set of motions, extending H/M/L motion.

Why?
----

`H/M/L` are my favorite motions, but they are inflexible.
Though `H/L` can also jump by `[count]`, counting lines is not so intuitive.
vim-among_HML provides an autoload-function, by which we can jump more intuitively than `H/M/L`.

Installation
------------

Install the plugin using your favorite package manager

#### For dein.vim
```vim
call dein#add('kaile256/vim-among_HML')
```

Usage
-----

```vim
" assign a percentage as you want between 0 and 100, like below
:call among_HML#percent(12.5) " for 1/8 height of lines
```

#### Examples

vim-among_HML defines no default keymappings,
so you should define some keymappings, like the examples below, in your vimrc or init.vim.

```vim
" if you prefer to jump in 1/4 or 3/4 height of lines (i.e., 25% or 75% height);
nnoremap <silent> K :<c-u>call among_HML#percent(25)<cr>
nnoremap <silent> J :<c-u>call among_HML#percent(75)<cr>

onoremap <silent> K :call among_HML#percent(25)<cr>
onoremap <silent> J :call among_HML#percent(75)<cr>

" optional:
" Mnemonic: Get the Keyword
nnoremap gK K
" Mnemonic: <space>-leaving Join
nnoremap <space>J J
```

If you use `neovim >= 0.3.0`
```vim
xnoremap <silent> K <Cmd>call among_HML#percent(25)<cr>
xnoremap <silent> J <Cmd>call among_HML#percent(75)<cr>
xnoremap gK K
xnoremap <space>J J
```

