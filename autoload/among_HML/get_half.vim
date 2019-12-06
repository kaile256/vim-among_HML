" ============================================================================
" File: autoload/among_HML/get_half.vim
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

if !has('patch-7.4.2044') | finish | endif

if exists('g:loaded_among_HML_get_half') | finish | endif
let g:loaded_among_HML_get_half = 1

" save cpoptions {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

function! among_HML#get_half#to(terminal) abort
  let prev = winline()

  call among_HML#percent(a:terminal)
  let dest = round((winline() + prev) /2.0)

  if prev < winline()
    let go_back = 'k'
    let s:yet = {-> winline() > dest}
  else
    let go_back = 'j'
    let s:yet = {-> winline() < dest}
  endif

  while s:yet()
    exe 'norm! g'. go_back
  endwhile
  unlet s:yet
endfunction

" restore cpoptions {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker

