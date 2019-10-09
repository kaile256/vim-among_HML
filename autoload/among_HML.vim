" ============================================================================
" File: autoload/among_HML.vim
" Author: kaile256
" License: MIT License
" ============================================================================

" save cpoptions {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

function! among_HML#_jump() abort range
  norm! L
  let l:last = winline()
  " it works higher than 6 line window.
  while winline() > float2nr(round(s:percentage * l:last /100.0))
    norm! gk
  endwhile
endfunction

function! among_HML#percent(percentage) abort range
  if 0 <= a:percentage && a:percentage <= 100
  else
    throw 'Argument must be between 0 to 100.'
  endif
  let s:percentage = a:percentage
  call among_HML#_jump()
endfunction

" restore cpoptions {{{1
let &cpo = s:save_cpo
unlet s:save_cpo
" vim: ts=2 sts=2 sw=2 et fdm=marker
