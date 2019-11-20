" ============================================================================
" File: autoload/among_HML/fork.vim
" Author: kaile256
" License: MIT license {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" ============================================================================

" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

if get(g:, 'among_HML#fork#disable', 0) | finish | endif

if has('nvim-0.3.0')
  let s:call = '<Cmd>call '
  let s:modes = 'nx'
else
  let s:call = ':<c-u>call '
  let s:modes = 'n'
endif

function! among_HML#fork#initialize(beginning, combinations) abort
  let char = matchstr(a:beginning, '\a\+')
  let percentage = matchstr(a:beginning, '\d\+')
  let rhs = percentage !=# '' ? s:call .'among_HML#percent('. percentage .')<cr>' : '<Nop>'

  try
    call submode#enter_with('HML/fork_'. a:beginning, s:modes, 's', char, rhs)
    " Note: in operator, should jump directly to destination
    call submode#enter_with('HML/fork_'. a:beginning, 'o', 's', char)

    for char in keys(a:combinations)
      call submode#map('HML/fork_'. a:beginning, s:modes .'o', 's', char, s:call .'among_HML#percent('. a:combinations[char] .')<cr>')
    endfor
  catch
    if !exists('*submode#enter_with')
      echoerr v:exception .': this function depends on kana/vim-submode, please install it and check your runtime path'
    endif
  endtry
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker
