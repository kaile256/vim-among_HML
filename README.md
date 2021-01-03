# vim-among_HML

vim-among_HML provides a set of motions, extending H/M/L motion.

## Demo

![among_HML#fork](https://user-images.githubusercontent.com/46470475/71517891-7b5bd000-28f3-11ea-8ee4-3a72a1888541.gif)

In demo, type `K` to 1/4 height of lines in window and `J` to 3/4.
Addition to them, `KK` in sequence will jump 1/4 at first, and then, to 1/8;
`KJ` to 3/8; `JK` to 5/8; `JJ` to 7/8.

You can copy the keymappings in doc/among_HML.txt;
type `:help among_HML-example` in commandline of vim.
[kana/vim-submode](https://github.com/kana/vim-submode)
is necessary for the use in sequence.

## Installation

Install the plugin using your favorite package manager

### For dein.vim

```vim
call dein#add('kaile256/vim-among_HML')
```

or if you prefer to write in toml and to load this plugin lazy, add

```vim
call dein#load_toml('foo.toml', {'lazy': 1})
```

in your vimrc and then, add

```toml
[[plugin]]
repo = 'kaile256/vim-among_HML'
on_func = 'among_HML#'
```

in foo.toml.

## Examples

```vim
" assign a percentage as you want, like below
:call among_HML#jump(12.5) " for 1/8 height of lines
```

vim-among_HML defines no default keymappings;
so you should define some keymappings, like the examples below,
in your vimrc or init.vim.

```vim
set scrolloff=0 " recommended (default)

" if you prefer to jump in 1/4 or 3/4 height of lines (i.e., 25% or 75% height);
nnoremap <silent> K :<c-u>call among_HML#jump(25)<cr>
nnoremap <silent> J :<c-u>call among_HML#jump(75)<cr>

onoremap <silent> K :call among_HML#jump(25)<cr>
onoremap <silent> J :call among_HML#jump(75)<cr>

" optional:
" Mnemonic: Get the Keyword
nnoremap gK K
" Mnemonic: <space>-leaving Join
nnoremap <space>J J
```

When either `has('nvim-0.3.0')` or `has('patch-8.2.1978')` returns `1`,
you can define keymappings at once with `<Cmd>` as below:

```vim
noremap <silent> K <Cmd>call among_HML#jump(25)<cr>
noremap <silent> J <Cmd>call among_HML#jump(75)<cr>
nnoremap gK K
nnoremap <space>J J
```

### Fork Motion

With [kana/vim-submode](https://github.com/kana/vim-submode) installed,
you can jump in fork.

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

When either `has('nvim-0.3.0')` or `has('patch-8.2.1978')` returns `1`,
you can define keymappings at once with `<Cmd>` as below:

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
