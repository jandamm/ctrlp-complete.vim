# ctrlp-complete

Search current completion options in [CtrlP][1]

![Example][2]

## Configuration

All this plugin provides is a mapping: `<Plug>(ctrlp_complete)`

Map it like this to use `<C-f>` to search completions when you can see a pum.

```vim
imap <expr> <C-f> pumvisible() ? '<Plug>(ctrlp_complete)' : '<C-f>'
```

If you don't use `menu` or `menuone` as a completeopt:

```vim
imap <C-f> <Plug>(ctrlp_complete)
```
## Usage

Start a completion (e.g. `<C-x><C-o>`) and press your mapping.
This will open CtrlP where you can search all possible completions.

## Advanced

There is also an `autocmd`: `User ctrlp_complete`.
When this `autocmd` is triggered the selected completion is inserted
and you're in insert mode again.

```vim
" Always add a space after ctrlp complete has inserted your selection.
autocmd User ctrlp_complete call feedkeys(' ', 'n')
```

## Installation

You have to have [CtrlP][1] installed. Install this plugin the same way.

## License

CtrlP Complete is distributed under Vim's [license][3].

[1]: https://github.com/ctrlpvim/ctrlp.vim
[2]: example.png
[3]: http://vimdoc.sourceforge.net/htmldoc/uganda.html
