" =============================================================================
" File:          autoload/ctrlp/complete.vim
" Description:   Completion extension for ctrlp.vim
" =============================================================================

if ( exists('g:loaded_ctrlp_complete') && g:loaded_ctrlp_complete )
	finish
endif
let g:loaded_ctrlp_complete = 1

call add(g:ctrlp_ext_vars, {
			\ 'init': 'ctrlp#complete#init()',
			\ 'accept': 'ctrlp#complete#accept',
			\ 'lname': 'completion',
			\ 'sname': 'comp',
			\ 'type': 'line',
			\ 'exit': 'ctrlp#complete#exit()',
			\ 'sort': 0
			\ })

function! ctrlp#complete#init() abort
	let l=complete_info(['items'])
	let nl=[]
	for k in l.items
		call add(nl, k['word']. ' : ' .k['info'] . ' '. k['menu'] )
	endfor
	return nl
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
	let @z=split(a:str, '\zs :')[0]
	call ctrlp#exit()
	normal! vb"_d"zp
	let @z = reg_z
	call feedkeys('a')
endfunction

function! ctrlp#complete#exit() abort
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#complete#id() abort
	return s:id
endfunction
