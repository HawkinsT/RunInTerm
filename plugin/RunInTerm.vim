scriptencoding utf-8

if &compatible
            \ || (v:version < 800)
            \ || exists("g:loaded_RunInTerm")
  finish
endif
let g:loaded_RunInTerm = v:true

if !exists("g:RunInTerm_pos")
  let g:RunInTerm_pos = "bottom"
endif

if !exists("g:RunInTerm_height")
  let g:RunInTerm_height = 16
endif

if !exists("g:RunInTerm_width")
  let g:RunInTerm_width = 84
endif

function! RunInTerminal(...)
  if g:RunInTerm_pos ==? "left" || g:RunInTerm_pos ==? "top"
    let term_position = "topleft "
  elseif g:RunInTerm_pos ==? "right" || g:RunInTerm_pos ==? "bottom"
    let term_position = "botright "
  endif

  if !exists("g:RunInTerm_script_window")
    let g:RunInTerm_script_window = 0
  endif
  
  let code_window = win_getid()

  if win_id2win(g:RunInTerm_script_window) > 0
    execute win_id2win(g:RunInTerm_script_window).'quit!'
  endif

  let g:RunInTerm_temp_filename = "RunInTerm_" . @% . ".tmp"

  if !a:0
    execute "write! " . g:RunInTerm_temp_filename
    let argument = " " . &filetype . " " . g:RunInTerm_temp_filename 
  else
    let argument = " " . a:1
    if a:1 != ""
      if a:0 == 2
        let argument .= " " . a:2
      else
        execute "write! " . g:RunInTerm_temp_filename
        let argument .= " " . g:RunInTerm_temp_filename
        if a:0 == 3
          let argument .= " " . a:3
        endif
      endif
    endif
  endif

  if g:RunInTerm_pos ==? "left" || g:RunInTerm_pos ==? "right"
    if has('nvim')
      execute term_position . "vsplit"
      execute "terminal" argument
    else
      execute term_position . "vertical terminal" . argument
    endif
  else
    if has('nvim')
      execute term_position . g:RunInTerm_height . "split"
      execute "terminal" argument
    else
      execute term_position . "terminal ++rows=" . g:RunInTerm_height
                  \ . argument
    endif
  endif

  let g:RunInTerm_script_window = win_getid()

  if exists("g:RunInTerm_width")
    execute "vertical resize " . g:RunInTerm_width
  endif

  " Delete temp file on terminal exit event (or BufWinLeave)
  if has('nvim')
    " Better, but Vim 8.2 lacks this event
    autocmd TermClose * :call delete(g:RunInTerm_temp_filename)
  else
    autocmd BufWinLeave * :call delete(g:RunInTerm_temp_filename)
  endif

  " If terminal created with no arguments or 'bash', keep focus
  if trim(argument) == "" || trim(argument) == "bash"
    startinsert
  else
    call win_gotoid(code_window)
  endif

endfunction
