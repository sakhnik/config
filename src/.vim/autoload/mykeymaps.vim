
function! mykeymaps#ChooseKeymap()
    let keymaps = ['', 'uk']
    let prompt_keymaps = []
    let index = 0
    while index < len(keymaps)
        call add(prompt_keymaps, index.'. '.keymaps[index])
        let index = index + 1
    endwhile
    let choice = inputlist(prompt_keymaps)
    if choice >= 0 && choice < len(keymaps)
        let &keymap=keymaps[choice]
    endif
    return ''
endf
