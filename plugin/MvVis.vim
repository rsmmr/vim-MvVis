" MvVis - move visually selected text
" Maintainer:  Jorengarenar <https://joren.ga>

if exists('g:loaded_MvVis') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:MvVis(d) abort range
  let c = v:count1
  norm! gv

  let m = mode()
  let m = m ==# "V" ? 2 : (m ==# "v" ? 0 : 1)

  if a:d == 'l' && virtcol('.') == virtcol('$')-1 | return | endif

  let s_old = @s

  if m < 2
    let flag = virtcol('.') == virtcol('$') - (a:d == 'h' ? 1 : 2)
  else
    let flag = line('.') >= line('$') - (a:d == 'j' ? 1 : 0)
  endif

  norm! "sd

  let lines = split(@s, "\n")
  let lines_N = len(lines) - 1

  exec 'norm! ' . c . a:d
  exec 'norm! "s' . (flag ? 'p' : 'P')
  let @s = s_old " why previous two statements cannot be combined I have no idea

  if m == 2 " reselect lines
    norm! V
    if lines_N > 0 | exec "norm! " . lines_N . "j" | endif
  else " reselect horizontal selection
    let lh = strchars(lines[0])-1
    if m == 0
      exec "norm! v" . lh . "ho"
    else
      exec "norm! \<C-v>" . (lines_N > 0 ? lines_N . "j" : "") . lh . "l"
    endif
  endif
endfunction

vnoremap <silent> <Plug>(MvVisLeft)  :<C-u>call <SID>MvVis('h')<CR>
vnoremap <silent> <Plug>(MvVisUp)    :<C-u>call <SID>MvVis('k')<CR>
vnoremap <silent> <Plug>(MvVisDown)  :<C-u>call <SID>MvVis('j')<CR>
vnoremap <silent> <Plug>(MvVisRight) :<C-u>call <SID>MvVis('l')<CR>

if get(g:, "MvVis_mappings", 1)
  vmap <C-h> <Plug>(MvVisLeft)
  vmap <C-j> <Plug>(MvVisDown)
  vmap <C-k> <Plug>(MvVisUp)
  vmap <C-l> <Plug>(MvVisRight)
endif

let g:loaded_MvVis = 1
let &cpo = s:cpo_save | unlet s:cpo_save
