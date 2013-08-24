function! regionSyntax#TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        unlet b:current_syntax
    endif
    try
        execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
                \ matchgroup='.a:textSnipHl.'
                \ start="'.a:start.'" end="'.a:end.'"
                \ contains=@'.group
endfunction

function! regionSyntax#searchAndEnable(localft, rule) abort
    if exists("a:rule['ft']")
        let s:newft = a:rule['ft']
    else
        let s:newft = matchstr(getline('.'), substitute(a:rule['start'], '<syntax>', '\\zs\\w\\+\\ze', ''))
    endif
    if s:newft !~ '\m\w\+'
        echoerr "Key 'ft' is needed if no '<syntax>' contained in 'start'!"
    endif
    if index(b:oldft, s:newft) == -1
        let s:start = escape(a:rule['start'], '"')
        let s:end = escape(a:rule['end'], '"')
        call regionSyntax#TextEnableCodeSnip(s:newft, substitute(s:start, '<syntax>', s:newft, 'g'), s:end, 'SpecialComment')
        let b:oldft += [s:newft]
    endif
endfunction

function! regionSyntax#CodeRegionSyntax(localft) abort
    if !exists('b:oldft')
        let b:oldft= []
    endif
    let s:pos = getpos('.')
    if exists('g:regionsyntax_map[a:localft]')
        for rule in g:regionsyntax_map[a:localft]
            silent execute "%global/".substitute(rule['start'], '<syntax>', '\\w\\+', 'g')."/call regionSyntax#searchAndEnable(a:localft, rule)"
        endfor
    endif
    call setpos('.', s:pos)
endfunction

function! regionSyntax#fromSelection(ft)
    let s:l1 = line("'<")
    let s:l2 = line("'>")
    while getline(s:l1) =~ '^[ \t]*$' && s:l1 < s:l2
        let s:l1 += 1
    endwhile
    while getline(s:l2) =~ '^[ \t]*$' && s:l1 < s:l2
        let s:l1 -= 1
    endwhile
    let s:start = escape(getline(s:l1), '\^$.*[]"~')
    let s:end = escape(getline(s:l2), '\^$.*[]"~')
    let @/ = s:end
    call regionSyntax#TextEnableCodeSnip(a:ft, s:start, s:end, 'SpecialComment' )
endfunction
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
