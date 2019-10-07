function! among_HML#do(percentage) abort range
  norm! L
  let l:cent = winline()
  while winline() > a:percentage * l:cent /100
    norm! gk
  endwhile
endfunction

nnoremap <silent> <Plug>(among_HML:one-quarter)   :<c-u>call among_HML#do(25)<cr>
nnoremap <silent> <Plug>(among_HML:three-quarter) :<c-u>call among_HML#do(75)<cr>
"nnoremap <expr><silent> <Plug>(among_HML:one-quarter)   among_HML#do(25)
"nnoremap <expr><silent> <Plug>(among_HML:three-quarter) among_HML#do(75)

if has('nvim')
  " TODO: keep in visual mode without <Cmd>.
  xnoremap <silent> <Plug>(among_HML:one-quarter)   <Cmd>call among_HML#do(25)<cr>
  xnoremap <silent> <Plug>(among_HML:three-quarter) <Cmd>call among_HML#do(75)<cr>
else
  "xnoremap <expr><silent> <Plug>(among_HML:one-quarter)   among_HML#do(25)<cr>
  "xnoremap <expr><silent> <Plug>(among_HML:three-quarter) among_HML#do(75)<cr>
endif

if exists('g:among_HML_ratio_no_default_mappings') | finish | endif

nmap K <Plug>(among_HML:one-quarter)
nmap J <Plug>(among_HML:three-quarter)

nnoremap <space>J J
nnoremap gK K

if exists('g:among_HML_keep_maps_normal')
  augroup among_HML_keep_nmaps
    au!
    au BufWinEnter * silent! exe 'nmap <buffer> gK       '. substitute(execute('nmap <buffer> K'), '\v.+K', '', '')
    au BufWinEnter * silent! exe 'nmap <buffer> <space>J '. substitute(execute('nmap <buffer> J'), '\v.+J', '', '')

    au BufWinEnter * silent! nunmap <buffer> K
    au BufWinEnter * silent! nunmap <buffer> J
  augroup END
endif

if has('nvim')
  xmap K <Plug>(among_HML:one-quarter)
  xmap J <Plug>(among_HML:three-quarter)

  xnoremap gK K
  xnoremap <space>J J
endif

if exists('g:among_HML_keep_maps_visual')
  augroup among_HML_keep_xmaps
    au!
    au BufWinEnter * silent! exe 'xmap <buffer> gK       '. substitute(execute('xmap <buffer> K'), '\v.+K', '', '')
    au BufWinEnter * silent! exe 'xmap <buffer> <space>J '. substitute(execute('xmap <buffer> J'), '\v.+J', '', '')

    au BufWinEnter * silent! xunmap <buffer> K
    au BufWinEnter * silent! xunmap <buffer> J
  augroup END
endif
