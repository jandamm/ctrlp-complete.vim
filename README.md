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

When you're using the `autocmd` and want to select an entry without triggering the `autocmd` you can use  `<C-s>` (mnemonic: silent).
It is the mapping for opening in a horizontal split. So by default `<C-CR>` and `<C-x>` work as well.

## Installation

You have to have [CtrlP][1] installed. Install this plugin the same way.

Your Vim needs to support `<CMD>` mappings. `:h <Cmd>` should exist.

## License

CtrlP Complete is distributed under Vim's [license][3].

## Credits

This plugin is based on [this idea][4].

[1]: https://github.com/ctrlpvim/ctrlp.vim
[2]: example.png
[3]: http://vimdoc.sourceforge.net/htmldoc/uganda.html
[4]: https://vim.fandom.com/wiki/Fuzzy_insert_mode_completion_(using_FZF)