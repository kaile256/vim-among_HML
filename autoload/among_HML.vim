function! among_HML#do(percent) abort
  norm! L
  let l:cent = winline()
  while winline() > a:percent * l:cent /100
    norm! gk
  endwhile
endfunction

nnoremap <silent> <Plug>(HML:one-quarter)   :<c-u>call among_HML#do(25)<cr>
nnoremap <silent> <Plug>(HML:three-quarter) :<c-u>call among_HML#do(75)<cr>

if has('nvim')
  " TODO: keep in visual mode without <Cmd>.
  xnoremap <silent> <Plug>(HML:one-quarter)   <Cmd>call among_HML#do(25)<cr>
  xnoremap <silent> <Plug>(HML:three-quarter) <Cmd>call among_HML#do(75)<cr>
endif

if exists('g:HML_ratio_no_default_mappings') | finish | endif

nmap K <Plug>(HML:one-quarter)
nmap J <Plug>(HML:three-quarter)

nnoremap <space>J J
nnoremap gK K

if has('nvim')
  xmap K <Plug>(HML:one-quarter)
  xmap J <Plug>(HML:three-quarter)

  xnoremap <space>J J
  xnoremap gK K
endif
