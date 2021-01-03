" ============================================================================
" File: autoload/among_HML.vim
" Author: kaile256
" License: MIT License
" ============================================================================

if v:version < 700 | finish | endif

if exists('g:loaded_among_HML') | finish | endif
let g:loaded_among_HML = 1

" save cpoptions {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

function! among_HML#jump(percentage)
  let save_so = &scrolloff
  set scrolloff=0

  norm! L
  let dest = round(winline() * a:percentage /100.0)

  if a:percentage <= 50
    norm! M
  endif

  while winline() > dest
    norm! gk
    if winline() == 1 | break | endif
  endwhile

  let &scrolloff = save_so
endfunction

" restore cpoptions {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker
