function! among_HML#do(percentage) abort
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
  "xnoremap <expr><silent> <Plug>(among_HML:one-quarter)   among_HML#do(25)<cr>
  "xnoremap <expr><silent> <Plug>(among_HML:three-quarter) among_HML#do(75)<cr>
endif

if exists('g:among_HML_ratio_no_default_mappings') | finish | endif

nmap K <Plug>(among_HML:one-quarter)
nmap J <Plug>(among_HML:three-quarter)

nnoremap <space>J J
nnoremap gK K

if has('nvim')
  xmap K <Plug>(among_HML:one-quarter)
  xmap J <Plug>(among_HML:three-quarter)

  xnoremap <space>J J
  xnoremap gK K
endif
