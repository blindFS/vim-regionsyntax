function! regionSyntax#TextEnableCodeSnip(filetype, start, end, textSnipHl) abort
    let ft = toupper(a:filetype)
    let group = 'textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax = b:current_syntax
        unlet b:current_syntax
    endif
    try
        execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax = s:current_syntax
    endif
    execute 'syntax region textSnip'.ft.' matchgroup='.a:textSnipHl.' start="'.a:start.'" end="'.a:end.'" contains=@'.group.' containedin=ALL'
endfunction

function! regionSyntax#SearchAndEnable(localft, rule, index) abort
    while !exists('b:regionsyntax_old_ft[a:index]')
        let b:regionsyntax_old_ft += [[]]
    endwhile
    if exists("a:rule.ft")
        let newft = a:rule.ft
    else
        let newft = matchstr(getline('.'), substitute(a:rule.start, '<syntax>', '\\zs\\w\\+\\ze', ''))
    endif
    if newft !~ '\m\w\+'
        echoerr "Key 'ft' is needed if no '<syntax>' contained in 'start'!"
    endif
    let newft_trans = exists('g:regionsyntax_ft_trans[newft]')? g:regionsyntax_ft_trans[newft]: newft
    if index(b:regionsyntax_old_ft[a:index], newft) == -1
        let start = escape(a:rule.start, '"')
        let end = escape(a:rule.end, '"')
        call regionSyntax#TextEnableCodeSnip(newft_trans, substitute(start, '<syntax>', newft, 'g'), end, 'SpecialComment')
        let b:regionsyntax_old_ft[a:index] += [newft]
    endif
endfunction

function! regionSyntax#CodeRegionSyntax(localft) abort
    if index(keys(g:regionsyntax_map), a:localft) == -1
        return
    endif
    if !g:regionsyntax_on
        return
    endif
    let pos = getpos('.')
    if exists('g:regionsyntax_map[a:localft]')
        let index = 0
        for rule in g:regionsyntax_map[a:localft]
            silent execute "%global/".substitute(rule.start, '<syntax>', '\\w\\+', 'g')."/call regionSyntax#SearchAndEnable(a:localft, rule, index)"
            let index += 1
        endfor
    endif
    call setpos('.', pos)
endfunction

function! regionSyntax#fromSelection(ft)
    let l1 = line("'<")
    let l2 = line("'>")
    while getline(l1) =~ '^[ \t]*$' && l1 < l2
        let l1 += 1
    endwhile
    while getline(l2) =~ '^[ \t]*$' && l1 < l2
        let l1 -= 1
    endwhile
    let start = escape(getline(l1), '\^$.*[]"~')
    let end = escape(getline(l2), '\^$.*[]"~')
    call regionSyntax#TextEnableCodeSnip(a:ft, start, end, 'SpecialComment')
endfunction

function! regionSyntax#Toggle()
    let g:regionsyntax_on = !g:regionsyntax_on
    if !g:regionsyntax_on && exists('b:regionsyntax_old_ft')
        for bundle in b:regionsyntax_old_ft
            for ft in bundle
                execute 'syntax clear textSnip'.ft
            endfor
        endfor
        let b:regionsyntax_old_ft = []
    elseif g:regionsyntax_on
        call regionSyntax#CodeRegionSyntax(&filetype)
    endif
endfunction
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
