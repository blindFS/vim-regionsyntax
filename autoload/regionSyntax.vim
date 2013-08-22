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

function! regionSyntax#searchAndEnable(localft, i)
    let s:newft = matchstr(getline('.'), a:i['ft'])
    if s:newft == ""
        let s:newft = a:i['ft']
    endif
    call regionSyntax#TextEnableCodeSnip(s:newft, substitute(getline('.'), '"', '.', 'g'), substitute(a:i['end'], '"', '.', 'g'), 'SpecialComment')
endfunction

function! regionSyntax#CodeRegionSyntax(localft) abort
    if !exists('b:oldft')
        let b:oldft = []
    endif
    let s:pos = getpos('.')
    if exists('g:regionsyntax_map[a:localft]')
        for i in g:regionsyntax_map[a:localft]
            silent execute "%global/".i['start']."/call regionSyntax#searchAndEnable(a:localft, i)"
        endfor
    endif
    call setpos('.', s:pos)
endfunction
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
