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

if get(g:, 'among_HML_enable_succession', 0) | finish | endif

let s:maps = {}
let s:maps.combinations = get(g:, 'among_HML_succession_combinations', {})

for percent in keys(s:maps.combinations)
  let s:maps.combinations[percent] = get(s:maps.combinations, percent, {})
endfor

let s:counter = {}

function! s:counter() dict abort
  if !exists('s:count')
    return self.zero()
  endif

  let s:count += 1
  return s:count
endfunction

function! s:counter.zero() abort
  let s:count = 0
  return s:count
endfunction

let s:Keymaps = {} "{{{

if has('nvim-0.3.0')
  let s:maps.call = '<Cmd>call'
  let s:maps.modes = [nxo]
else
  let s:maps.call = ':<c-u>call'
  let s:maps.modes = [no]
endif

function! s:Keymaps.override(lhs, mode) abort
  " Note: keep only among_HML#succession#initialize() call it to override keymappings
  exe a:mode .'noremap <buffer><silent><nowait>' a:lhs s:maps.call 'among_HML#succession#_succeed(' a:lhs ')<cr>'
endfunction
let s:rotate = {}

let s:maps.saved = {}
function! s:Keymaps.save(lhs, mode) abort
  " Note: keep only among_HML#succession#initialize() call it to save keymappings
  let lhs = a:lhs
  let mode = a:mode
  let s:maps.saved[lhs] = maparg(lhs, mode, 0, 1)
  let map = s:maps.saved[lhs]

  if map.rhs =~# '<SID>'
    let map.rhs = substitute(map.rhs, '<SID>', '<SNR>'. map.sid .'_', 'g')
  endif

  " Note: if <buffer>, restore the <buffer>-map after all; if not, just unmap <buffer>.
  if map.buffer == 0
        \ || map.rhs == {}
    let map = {lhs : {'restore': 0} }
    return
  endif

  let args = '<buffer>'
  for arg in ['silent', 'nowait', 'expr']
    if map[arg] == 1
      let args .= '<'. arg .'>'
    endif
  endfor

  let map[lhs] = extend(map[lhs], {
        \ 'restore': 1,
        \ 'mode': mode,
        \ 'lhs': args . lhs,
        \ },
        \ 'force')
endfunction

function! s:Keymaps.restore() abort
  " Note: keep only among_HML#succession#abort() call it to restore keymappings
  for lhs in keys(s:maps.saved)
    let map = s:maps.saved[lhs]
    for mode in s:maps.modes

      if map.restore == 0
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
"}}}

function! s:rotate.new(lhs) abort
  let s:rotate[a:lhs] = function('among_HML#succession#_succeed', a:lhs)
endfunction

let s:char = {-> nr2char(getchar())}

function! among_HML#succession#keymaps() abort
  for lhs in keys(s:maps.combinations)
    for mode in s:maps.modes
      call s:Keymaps.save(lhs, mode)
      call s:Keymaps.override(lhs, mode)
    endfor
  endfor
endfunction

function! among_HML#succession#initialize(percentage) abort
  " like ';', skip to the next percentage in list
  call among_HML#percent(percentage)
  call s:counter.zero()
  call among_HML#succession#keymaps()
endfunction

function! among_HML#succession#_succeed(lhs) abort
  let list = s:maps.combinations[a:count]
  let percent = list[s:counter()]
  if s:count == len(list)
    call s:counter.zero()
  endif
  let count = s:count
  call among_HML#percent(count)
  call counter()
endfunction

function! among_HML#succession#char2percent() abort
  let char = s:char()

  if has_key(s:maps.combinations, char)
    call among_HML#succession#_succeed(char)

  else
    call s:counter.zero()
    exe 'norm' char
  endif
endfunction

function! among_HML#succession#_count_reset() abort
  augroup AmongHMLsuccessionReset
    au! WinLeave,BufWinLeave,BufWinEnter * ++once call s:counter.reset()
  augroup END
endfunction


" restore 'cpoptions' {{{
let &cpo = s:save_cpo
"}}}
" vim: ts=2 sts=2 sw=2 et fdm=marker
