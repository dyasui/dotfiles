function! s:customNvimRMappings()
   nmap <buffer> <Leader>sr <Plug>RStart
   imap <buffer> <Leader>sr <Plug>RStart
   vmap <buffer> <Leader>sr <Plug>RStart
   vmap C-Enter <Plug>RSendSelection
endfunction
augroup myNvimR
   au!
   autocmd filetype r call s:customNvimRMappings()
augroup end
