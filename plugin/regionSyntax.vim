command! -range -nargs=1 -complete=filetype RegionSyntax call regionSyntax#TextEnableCodeSnip(<f-args>, substitute(getline("'<"), '"', '\\"', 'g'), substitute(getline("'>"), '"', '\\"', 'g'), 'SpecialComment')
if !exists('g:regionsyntax_enabled_extension')
    let g:regionsyntax_enabled_extension = ['wiki', 'md', 'mkd', 'markdown']
endif

if !exists('g:regionsyntax_map')
    let g:regionsyntax_map = {}
    let g:regionsyntax_map["vimwiki"] = [{
                \ 'start' : '\m^[ \t]*{{{class[ \t]*=[ \t]*.[ \t]*\w\+[ \t]*.[ \t]*$',
                \ 'ft' : '\mclass[ \t]*=[ \t]*.\zs\w\+',
                \ 'end' : '^[ \t]*}}}[ \t]*$'
                \ }]
    let g:regionsyntax_map["vimwiki"] += [{
                \ 'start' : '\m^[ \t]*{{\$[ \t]*$',
                \ 'ft' : 'tex',
                \ 'end' : '^[ \t]*}}\$[ \t]*$'
                \ }]
    let g:regionsyntax_map["mkd"] = [{
                \ 'start' : '\m^[ \t]*{%[ \t]*highlight[ \t]\+\w\+.*%}[ \t]*$',
                \ 'ft' : '\mhighlight[ \t]\+\zs\w\+',
                \ 'end' : '^[ \t]*{%[ \t]*endhighlight[ \t]*%}[ \t]*$',
                \ }]
    let g:regionsyntax_map["mkd"] += [{
                \ 'start' : '\m^[ \t]*```[ \t]*\w\+[ \t]*$',
                \ 'ft' : '\m```[ \t]*\zs\w\+',
                \ 'end' : '^[ \t]*```[ \t]*$'
                \ }]
endif

for s:ft in g:regionsyntax_enabled_extension
    execute "autocmd InsertLeave,BufWritePost *.".s:ft." call regionSyntax#CodeRegionSyntax(&ft)"
    execute "autocmd BufReadPost,BufNewFile *.".s:ft." let b:oldstart=[]|call regionSyntax#CodeRegionSyntax(&ft)"
endfor
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
