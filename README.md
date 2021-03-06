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

Install the plugin using your favorite package manager.
This is a sample configuration in TOML format
for [Dein](https://github.com/Shougo/dein.vim) users:

```toml
[[plugin]]
repo = 'kaile256/vim-among_HML'
lazy = 1
on_func = ['among_HML#']
hook_add = '''
" Write your configuration referring to the examples below.
'''
```

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

" Jump in 1/4 or 3/4 height of lines (i.e., 25% or 75% height);
noremap <silent> K <Cmd>call among_HML#jump(25)<cr>
noremap <silent> J <Cmd>call among_HML#jump(75)<cr>

" Optional mappings with mnemonics:
" Get the Keyword
nnoremap gK K
xnoremap gK K
" <Space>-leaving Join in contrast to the default `gJ`
nnoremap <space>J J
xnoremap <space>J J
```

### Fork Motion

With [kana/vim-submode](https://github.com/kana/vim-submode) installed,
you can jump in fork.

```vim
let g:submode_keep_leaving_key = 1 " recommended

noremap <silent> M <Cmd>call among_HML#fork#init_jump(
      \ 'M', '50', {
      \ 'H': '0',
      \ 'K': '25',
      \ 'J': '75',
      \ 'L': '100',
      \ })<CR>
" Fork mappings are usually annoying in Operator-pending mode.
ounmap M
```

Now, you can spare your keymappings.

For more examples and informations, please read documentation
([online](https://github.com/kaile256/vim-among_HML/blob/master/doc/among_HML.txt),
or `:h among_HML` in your Vim/Neovim)
