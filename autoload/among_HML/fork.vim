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

let s:origin_and_maps = get(g:, 'among_HML#fork#combinations', {
      \ 0: {
      \   'H': [25, 0],
      \   'L': [75, 100],
      \   },
      \ 50: {
      \   'H': [0, 25],
      \   'K': [33.33, 16.66],
      \   'M': [50],
      \   'J': [83.33, 66.66],
      \   'L': [100, 75],
      \ },
      \ 100: {
      \   'H': [25, 0],
      \   'L': [75, 100],
      \   },
      \ })

let s:counter = {} "{{{1

function! s:counter.Update() abort "{{{2
  call s:counter.cnt()
  call s:counter.nest()
endfunction

function! s:counter.cnt() abort "{{{2
  if !exists('s:cnt') || s:counter.max()
    let s:cnt = 0
    return
  endif

  let s:cnt += 1
endfunction

function! s:counter.nest() abort "{{{2
  if !exists('s:nest')
    let s:nest = 0
  endif

  let s:nest += 1

  if s:nest >= 2
    call s:Abort.reset_nested()
    echohl Type
    echomsg 'Redefined!!'
    let s:nest = 0
  endif
endfunction

function! s:counter.max() abort "{{{2
  let max = len(s:input.dict[s:input.char]) - 1
  return s:cnt >= max
endfunction

let s:Abort = {} "{{{1

function! s:Abort.done() abort "{{{2
  let s:cnt  = 0
  let s:nest = 0
endfunction

function! s:Abort.by_input(input) abort
  call s:Abort.done()
  call feedkeys(a:input)
endfunction

function! s:Abort.set_augroup() abort
  augroup AmongHMLforkAbort
    au! WinLeave,BufWinLeave,BufWinEnter * ++once call s:Abort.done()
  augroup END
endfunction

function! s:Abort.reset_nested() abort
  redir => func
  silent! function among_HML#fork#initialize
  redir END

  " redefines the function
  silent! exe substitute(func, 'function', 'function!', '')

  call s:input.To_jump()
endfunction
let s:input = {} "{{{1

function! s:input.getchar() abort "{{{2
  " FIXME: when no char under cursor, fails to highlight there
  let keep_cursor = matchaddpos('Cursor', [[line('.'), col('.')]])
  redraw
  try
    let nr = getchar()
  catch /^Vim:Interrupt$/
    call matchdelete(keep_cursor)
    return "\<c-c>"
  endtry
  let char = (nr ==# "\<S-lt>")? '<': nr2char(nr)
  call matchdelete(keep_cursor)
  return char
endfunction

function! s:input.To_jump() abort "{{{2
  let s:input.char = s:input.getchar()

  if get(s:input, 'last', s:input.char) !=# s:input.char
    let s:input.last = s:input.char
    let s:cnt = 0
  endif

  if index(keys(s:input.dict), s:input.char) >= 0
    let next = s:input.dict[s:input.char][s:cnt]
    " FIXME: functions' nest causes an error on 'maxfuncdepth'
    call s:input.Jump_and_next(next)
  endif

  call s:Abort.by_input(s:input.char)
endfunction

function! s:input.Jump_and_next(percentage) abort "{{{2
  call among_HML#percent(a:percentage)
  call s:counter.Update()
  call s:input.To_jump()
endfunction
"}}}1

function! among_HML#fork#initialize(percentage) abort
  " like ';', skip to the next percentage in list
  let s:cnt = 0
  call s:Abort.set_augroup()
  call among_HML#percent(a:percentage)
  let s:input.dict = s:origin_and_maps[a:percentage]
  call s:input.To_jump()
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker
