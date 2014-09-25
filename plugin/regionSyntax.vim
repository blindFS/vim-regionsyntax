if exists('g:loaded_regionsyntax') && g:loaded_regionsyntax
    finish
endif
command! -range -nargs=1 -complete=filetype RegionSyntax call regionSyntax#fromSelection(<f-args>)
command! RegionSyntaxToggle call regionSyntax#Toggle()
let g:regionsyntax_on                = get(g:, 'regionsyntax_on', 1)
let g:regionsyntax_map               = get(g:, 'regionsyntax_map', {})

let s:regionsyntax_map = {
            \ "vimwiki" :
            \ [{
            \   'start' : '^[ \t]*{{{class[ \t]*=[ \t]*.[ \t]*<syntax>[ \t]*.[ \t]*$',
            \   'end' : '^[ \t]*}}}[ \t]*$'
            \ },
            \ {
            \   'start' : '^[ \t]*{{\$[ \t]*$',
            \   'ft' : 'tex',
            \   'end' : '^[ \t]*}}\$[ \t]*$'
            \ },
            \ {
            \   'start' : '<script[^>]*>',
            \   'ft' : 'javascript',
            \   'end' : '<.script>'
            \ }],
            \ "markdown" :
            \ [{
            \   'start' : '^[ \t]*{%[ \t]*highlight[ \t]\+<syntax>.*%}[ \t]*$',
            \   'end' : '^[ \t]*{%[ \t]*endhighlight[ \t]*%}[ \t]*$',
            \ },
            \ {
            \   'start' : '^[ \t]*```[ \t]*<syntax>[ \t]*',
            \   'end' : '^[ \t]*```[ \t]*$'
            \ },
            \ {
            \   'start' : '^[ \t]*\$\$[ \t]*$',
            \   'ft' : 'tex',
            \   'end' : '^[ \t]*\$\$[ \t]*$'
            \ }],
            \ "html" :
            \ [{
            \   'start' : '^[ \t]*<script type="text\/template">',
            \   'ft' : 'markdown',
            \   'end' : '^[ \t]*<\/script>'
            \ },
            \ {
            \   'start' : '^[ \t]*\$\$[ \t]*$',
            \   'ft' : 'tex',
            \   'end' : '^[ \t]*\$\$[ \t]*$'
            \ }],}

let g:regionsyntax_map = extend(s:regionsyntax_map, g:regionsyntax_map)

autocmd InsertLeave,BufWritePost * call regionSyntax#CodeRegionSyntax(&syntax)
for s:syn in keys(g:regionsyntax_map)
    execute "autocmd Syntax ".s:syn." let b:regionsyntax_old_ft=[]|call regionSyntax#CodeRegionSyntax(&syntax)"
endfor

let g:loaded_regionsyntax = 1
" vim:ts=4:sw=4:tw=78:ft=vim:fdm=indent:fdl=99
