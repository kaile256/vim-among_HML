" ============================================================================
" File: autoload/among_HML.vim
" Author: kaile256
" License: MIT License
" ============================================================================

if !has('patch7.4.156') | finish | endif

if exists('g:loaded_among_HML') | finish | endif
let g:loaded_among_HML = 1

" save cpoptions {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

function! among_HML#percent(percentage) abort
  norm! L
  let l:dest = round(winline() * a:percentage /100.0)

  while winline() > l:dest
    norm! gk

    if winline() == 1 | return | endif
  endwhile
endfunction

" restore cpoptions {{{
let &cpo = s:save_cpo
unlet s:save_cpo
"}}}
" vim: ts=2 sts=2 sw=2 et fdm=marker
