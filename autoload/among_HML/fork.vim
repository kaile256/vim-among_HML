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

if v:version < 700 | finish | endif
" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

function! s:define_submode(start_key, percentage, combinations)
  if has('nvim-0.3.0') || has('patch-8.2.1978')
    let call = '<Cmd>call '
    let modes = 'nxo'
  else
    let call = ':<c-u>call '
    let modes = 'no'
  endif

  let rhs = call .'among_HML#jump('. a:percentage .')<cr>'

  try
    let mode_name = 'HML/fork_'. a:start_key
    for l:mode in split(modes, '\zs')
      let maparg = maparg(a:start_key, l:mode)
      if maparg ==# '' || maparg =~# 'among_HML#fork#init_jump'
        call submode#enter_with(mode_name, l:mode, 's', a:start_key, rhs)
        for lhs in keys(a:combinations)
          " Note: option-x makes user leave from the submode
          let sub_rhs = call .'among_HML#jump('. a:combinations[lhs] .')<CR>'
          call submode#map(mode_name, l:mode, 'sx', lhs, sub_rhs)
        endfor
      endif
    endfor
  catch
    if !exists('*submode#enter_with')
      echoerr v:exception .': this function depends on kana/vim-submode, please install it and check your runtime path'
    endif
  endtry
endfunction

function! among_HML#fork#init_jump(start_key, perc, combi) abort
  call s:define_submode(a:start_key, a:perc, a:combi)
  call feedkeys(a:start_key, 'm')
endfunction

function! among_HML#fork#init(start_key, perc, combi) abort
  call s:define_submode(a:start_key, a:perc, a:combi)
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker
