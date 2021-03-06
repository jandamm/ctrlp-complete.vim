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
			\ 'type': 'tabs',
			\ 'exit': 'ctrlp#complete#exit()'
			\ }

function! ctrlp#complete#start() abort
	let s:comps = complete_info(['items']).items
	call feedkeys("\<C-e>\<ESC>", 'n')

	call timer_start(0, { -> s:start() })
endfunction

function! s:start() abort
	" Init CtrlP before adding to ext_vars
	" Otherwise it would result in shifted extension when using ctrlp completion
	" before any other ctrlp extension.
	if !exists('s:used_before')
		call ctrlp#init('')
		let s:used_before = 1 " Ideally this would be replaced by a check if CtrlP was used before.
	endif
	call add(g:ctrlp_ext_vars, s:plugin)
	let s:ext_id = len(g:ctrlp_ext_vars)
	call ctrlp#init(ctrlp#getvar('g:ctrlp_builtins') + s:ext_id)
endfunction

function! ctrlp#complete#init() abort
	let ret = []
	let index = 1
	for comp in s:comps
		let word = !empty(comp.abbr) ? comp.abbr : comp.word
		call add(ret, printf('%s	: %s - %s #%i', word, comp.info, comp.menu, index))
		let index += 1
	endfor
	call s:highlight()
	return ret
endfunction

function! s:highlight() abort
	if ctrlp#nosy() | return | endif
	call ctrlp#hicheck('CtrlPCompleteWord', 'Identifier')
	call ctrlp#hicheck('CtrlPCompleteNumber', 'Comment')
	sy match CtrlPCompleteWord '\v\zs.+\ze\t: '
	sy match CtrlPCompleteNumber '\v#\d+'
endfunction

" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#complete#accept(mode, str) abort
	let selection = s:comps[substitute(a:str, '\v^.*\#(\d+)$', '\1', '') - 1].word
	call ctrlp#exit()

	" Get context
	let pos = getcurpos()
	let cursor = pos[2]
	let line = getline('.')
	let lline = strpart(line, 0, cursor)

	" Insert selection
	let repl = substitute(lline, '\v^(.*[^a-z_])[a-z_]*$', '\1'.selection, '')
	call setline(pos[1], repl . strpart(line, cursor))

	" Adjust cursor position
	let pos[2] += len(repl) - len(lline)
	call setpos('.', pos)
	call feedkeys('a')

	" Autocmd if not confirmed with <C-s> (silent)
	if a:mode !=? 'h' && exists('#User#ctrlp_complete')
		doautocmd <nomodeline> User ctrlp_complete
	endif
endfunction

function! ctrlp#complete#exit() abort
	if s:ext_id > 0
		call remove(g:ctrlp_ext_vars, s:ext_id - 1)
	endif

	let s:comps = []
	let s:ext_id = -1
endfunction
