" Author: Nicolas Derumigny <nderumigny@gmail.com>
" Description: Fix Verilog files with verible.

function! s:set_variables() abort
    call ale#Set('verible_executable', 'verible-verilog-format')
    call ale#Set('verible_options', '')
endfunction

call s:set_variables()


function! ale#fixers#verible#Var(buffer, name) abort
    return ale#Var(a:buffer, 'verible_' . a:name)
endfunction

function! ale#fixers#verible#FindOptions(buffer) abort
    let l:proj_options = ale#fixers#verible#Var(a:buffer, 'options')

    " If user has set project options variable then use it and skip any searching.
    if !empty(l:proj_options)
        return l:proj_options
    endif

    " If no options variable is found return an empty string.
    return ''
endfunction

function! ale#fixers#verible#Fix(buffer) abort
    let l:executable = ale#fixers#verible#Var(a:buffer, 'executable')
    let l:options = ale#fixers#verible#FindOptions(a:buffer)
    let l:command = ale#Escape(expand('#' . a:buffer))

    return {
    \   'command': ale#Escape(l:executable) . ' '
    \     . l:options . ' '
    \     . l:command
    \}
endfunction
