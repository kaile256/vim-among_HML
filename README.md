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
or if you prefer to write in toml and to load this plugin lazy
```vim
call dein#load_toml('foo.toml', {'lazy': 1})
```
and then, in toml,
```toml
[[plugin]]
repo = 'kaile256/vim-among_HML'
on_func = 'among_HML#'
```

Examples
-----

```vim
" assign a percentage as you want, like below
:call among_HML#percent(12.5) " for 1/8 height of lines
```
vim-among_HML defines no default keymappings;
so you should define some keymappings, like the examples below, in your vimrc or init.vim.

```vim
set scrolloff=0 " recommended (default)

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

#### Fork Feature
-----------------
With [kana/vim-submode](https://github.com/kana/vim-submode) installed, you can use fork-features
```vim
let g:submode_keep_leaving_key = 1 " recommended

" Note: in vimrc, this lines must be loaded after kana/vim-submode is loaded
call among_HML#fork#init('M', '50', {
      \ 'H': '0',
      \ 'K': '25',
      \ 'J': '75',
      \ 'L': '100',
      \ })
```
For lazy load, you can also define keymaps like below

```vim
nnoremap <silent> M :call among_HML#fork#init('M', '50', {
      \ 'H': '0',
      \ 'K': '25',
      \ 'J': '75',
      \ 'L': '100',
      \ })<bar>
      \ call feedkeys('M')<cr>
```
If you use `neovim >= 0.3.0`, simply noremap
```vim
noremap <silent> M <Cmd>call among_HML#fork#init('M', '50', {
      \ 'H': '0',
      \ 'K': '25',
      \ 'J': '75',
      \ 'L': '100',
      \ })<bar>
      \ call feedkeys('M')<cr>
```
Now, you can spare your keymappings.
For more information, please read documentation.
