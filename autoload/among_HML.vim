" ============================================================================
" File: autoload/among_HML.vim
" Author: kaile256
" License: MIT License
" ============================================================================

" save cpoptions {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

if exists('g:loaded_among_HML') | finish | endif
let g:loaded_among_HML = 1

function! among_HML#percent(percentage) abort range
  if 0 <= a:percentage && a:percentage <= 100
  else
    throw 'Argument must be between 0 and 100.'
  endif

  norm! L
  let l:wanted = float2nr(round(winline() * a:percentage /100.0))
  while winline() > l:wanted
    norm! gk
  endwhile
endfunction

" restore cpoptions {{{
let &cpo = s:save_cpo
unlet s:save_cpo
"}}}
" vim: ts=2 sts=2 sw=2 et fdm=marker
