### What for? ###

When editing files with certain code blocks,it's nice to have them highlighted properly.

### How to use it? ###

Use `:[range]RegionSyntax filetype` to highlight the selected block.
Or you can specify new rule for dynamic syntax highlighting with the global variable g:regionsyntax_map.eg:

    let g:regionsyntax_map["vimwiki"] = []
    let g:regionsyntax_map["vimwiki"] += [{
                \ 'start' : '\m^[ \t]*{{{class[ \t]*=[ \t]*.[ \t]*\w\+[ \t]*.[ \t]*$',
                \ 'ft' : '\mclass[ \t]*=[ \t]*.\zs\w\+',
                \ 'end' : '}}}'
                \ }]

'vimwiki' is the local filetype set to be enabled.You could set a list of rules for a certain local filetype.
Each rule contains a start pattern, an end pattern, and the new filetype pattern to be found within the start pattern or is specified.
By default,it enables vimwiki,markdown with liquid template and github flavored code block.
