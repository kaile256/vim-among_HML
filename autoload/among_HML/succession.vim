" ============================================================================
" File: autoload/among_HML/succession.vim
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

if get(g:, 'among_HML#succession#disable', 0) | finish | endif

let s:maps = {}
let s:origin_and_dict = get(g:, 'among_HML_succession_combinations', {
      \ 0:   {'H': [25, 0]},
      \ 100: {'L': [75, 0]},
      \ })

for percent in keys(s:origin_and_dict)
  let s:origin_and_dict[percent] = get(s:origin_and_dict, percent, {})
endfor

let s:counter = {} "{{{1

function! s:counter.Update() abort "{{{2
  if !exists('s:cnt') || s:counter.max()
    let s:cnt = 0
    return
  endif

  let s:cnt += 1
endfunction

function! s:counter.max() abort "{{{2
  let max = len(s:input.dict[s:input.char]) - 1
  return s:cnt == max
endfunction

function! s:counter.Zero() abort "{{{2
  let s:cnt = 0
endfunction

let s:Keymaps = {} "{{{1 unnecessary?

if has('nvim-0.3.0')
  let s:maps.call = '<Cmd>call'
  let s:maps.modes = ['n', 'x', 'o']
else
  let s:maps.call = ':<c-u>call'
  let s:maps.modes = ['n', 'o']
endif

function! s:Keymaps.override(percentage, lhs, mode) abort
  " Note: keep only among_HML#succession#initialize() call it to override keymappings
  exe a:mode .'noremap <buffer><silent><nowait>' a:lhs s:maps.call 'among_HML#succession#rotate(' a:percentage ',' a:lhs ')<cr>'
endfunction

let s:maps.saved = {}
function! s:Keymaps.save(lhs, mode) abort
  " Note: keep only among_HML#succession#initialize() call it to save keymappings
  let lhs = a:lhs
  let mode = a:mode
  let s:maps.saved[lhs] = maparg(lhs, mode, 0, 1)
  let map = s:maps.saved[lhs]

  if map == {} || map.buffer == 0
    " Note: if <buffer>, restore the <buffer>-map after all;
    "       if not, just unmap <buffer>.
    let map = {}
    return
  endif

  if map.rhs =~# '<SID>'
    let map.rhs = substitute(map.rhs, '<SID>', '<SNR>'. map.sid .'_', 'g')
  endif

  let args = '<buffer>'
  for arg in ['silent', 'nowait', 'expr']
    if has_key(map, arg)
      let args .= '<'. arg .'>'
    endif
  endfor

  call extend(map, {
        \ 'mode': mode,
        \ 'lhs': args . lhs,
        \ })
endfunction

function! s:Keymaps.restore() abort
  " Note: keep only s:aborting() call it to restore keymappings
  for lhs in keys(s:maps.saved)
    let map = s:maps.saved[lhs]
    for mode in s:maps.modes

      if map == {}
        exe mode .'unmap <buffer>' lhs
        break
      endif

      let rhs = map.rhs
      if map.noremap == 1
        exe mode .'noremap' lhs rhs
        break
      else
        exe mode .'map' lhs rhs
        break
      endif

    endfor
  endfor
endfunction

let s:Abort = {} "{{{1

function! s:Abort.done() abort
  let s:cnt = 0
  call s:Keymaps.restore()
endfunction

function! s:Abort.by_input(input) abort
  call s:Abort.done()
  call feedkeys(a:input, 'n')
endfunction

function! s:Abort.set_augroup() abort
  augroup AmongHMLsuccessionAbort
    au! WinLeave,BufWinLeave,BufWinEnter * ++once call s:Abort.done()
  augroup END
endfunction
"}}}1
let s:input = {} "{{{1

function! s:input.get() abort "{{{2
  " FIXME: when no char under cursor, fails to highlight there
  let keep_cursor = matchaddpos('Cursor', [[line('.'), col('.')]])
  redraw
  let input = nr2char(getchar())
  " matchdelete() if "\<c-c>"
  call matchdelete(keep_cursor)
  return (input ==# "\<S-lt>")? '<': input
endfunction

function! s:input.To_jump() abort
  let s:input.char = s:input.get()
  if index(keys(s:input.dict), s:input.char) >= 0
    if get(s:input, 'last', s:input.char) !=# s:input.char
      let s:input.last = s:input.char
      let s:cnt = 0
    endif
    let next = s:input.dict[s:input.char][s:cnt]
    " FIXME: without nesting, no error on 'maxfuncdepth'
    call s:input.Jump_and_next(next)
  endif
  call s:Abort.by_input(s:input.char)
endfunction

function! s:input.Jump_and_next(percentage) abort
  call among_HML#percent(a:percentage)
  call s:counter.Update()
  call s:input.To_jump()
endfunction
"}}}1

"function! among_HML#succession#keymaps(percentage) abort
"  for lhs in keys(s:init_and_rotate)
"    for mode in s:maps.modes
"      call s:Keymaps.save(lhs, mode)
"      call s:Keymaps.override(a:percentage, lhs, mode)
"    endfor
"  endfor
"endfunction

function! among_HML#succession#initialize(percentage) abort
  " like ';', skip to the next percentage in list
  let s:cnt = 0
  call s:Abort.set_augroup()
  call among_HML#percent(a:percentage)
  let s:input.dict = s:origin_and_dict[a:percentage]
  call s:input.To_jump()
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo

" modeline {{{1
" vim: ts=2 sts=2 sw=2 et fdm=marker
