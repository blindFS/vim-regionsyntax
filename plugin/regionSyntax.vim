" command! -range -nargs=1 -complete=filetype RegionSyntax
" \call regionSyntax#TextEnableCodeSnip(<f-args>, substitute(getline("'<"), '"', '\\"', 'g'), substitute(getline("'>"), '"', '\\"', 'g'), 'SpecialComment')
command! -range -nargs=1 -complete=filetype RegionSyntax call regionSyntax#fromSelection(<f-args>)
if !exists('g:regionsyntax_enabled_extension')
    let g:regionsyntax_enabled_extension = ['wiki', 'md', 'mkd', 'markdown']
endif

if !exists('g:regionsyntax_map')
    let g:regionsyntax_map = {}
    let g:regionsyntax_map["vimwiki"] = [{
                \ 'start' : '\m^[ \t]*{{{class[ \t]*=[ \t]*.[ \t]*<syntax>[ \t]*.[ \t]*$',
                \ 'end' : '^[ \t]*}}}[ \t]*$'
                \ },
                \{'start' : '\m^[ \t]*{{\$[ \t]*$',
                \ 'ft' : 'tex',
                \ 'end' : '\m^[ \t]*}}\$[ \t]*$'
                \}
                \ ]
    let g:regionsyntax_map["mkd"] = [{
                \ 'start' : '\m^[ \t]*{%[ \t]*highlight[ \t]\+<syntax>.*%}[ \t]*$',
                \ 'end' : '^[ \t]*{%[ \t]*endhighlight[ \t]*%}[ \t]*$',
                \ },
                \ {'start' : '\m^[ \t]*```[ \t]*<syntax>[ \t]*$',
                \ 'end' : '^[ \t]*```[ \t]*$'
                \ }]
endif

for s:ft in g:regionsyntax_enabled_extension
    execute "autocmd InsertLeave,BufWritePost *.".s:ft." call regionSyntax#CodeRegionSyntax(&ft)"
    execute "autocmd BufReadPost,BufNewFile *.".s:ft." let b:oldft=[]|call regionSyntax#CodeRegionSyntax(&ft)"
endfor
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
