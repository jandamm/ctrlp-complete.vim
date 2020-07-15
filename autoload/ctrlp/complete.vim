" =============================================================================
" File:          autoload/ctrlp/complete.vim
" Description:   Completion extension for ctrlp.vim
" =============================================================================

if ( exists('g:loaded_ctrlp_complete') && g:loaded_ctrlp_complete )
	finish
endif
let g:loaded_ctrlp_complete = 1

let s:ext_id = -1
let s:comps = []

let s:plugin = {
			\ 'init': 'ctrlp#complete#init()',
			\ 'accept': 'ctrlp#complete#accept',
			\ 'lname': 'completion',
			\ 'sname': 'comp',
			\ 'type': 'line',
			\ 'exit': 'ctrlp#complete#exit()'
			\ }

function! ctrlp#complete#start() abort
	call add(g:ctrlp_ext_vars, s:plugin)
	let s:ext_id = len(g:ctrlp_ext_vars)
	call ctrlp#init(ctrlp#getvar('g:ctrlp_builtins') + s:ext_id)
endfunction

function! ctrlp#complete#init() abort
	if empty(s:comps)
		let s:comps = complete_info(['items']).items
	endif
	let nl = []
	let i = 1
	for k in s:comps
		call add(ret, index . '- '  . k['abbr'] . ' : ' . k['info'] . k['menu'])
		let index += 1
	endfor
	return ret
endfunction

" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#complete#accept(mode, str) abort
	let reg_z = @z
	let index = split(a:str, '\v^\d+\zs- ')[0] - 1
	let @z = s:comps[index].word
	call ctrlp#exit()
	normal! vb"_d"zp
	let @z = reg_z
	call feedkeys('a')
endfunction

function! ctrlp#complete#exit() abort
	if s:ext_id > 0
		call remove(g:ctrlp_ext_vars, s:ext_id - 1)
	endif

	let s:comps = []
	let s:ext_id = -1
endfunction
