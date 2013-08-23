### What for? ###

When editing files with certain code blocks,it's nice to have them highlighted properly.

### How to use it? ###

Use `:[range]RegionSyntax filetype` to highlight the selected block.
Or you can specify new rules for dynamic syntax highlighting with the global variable g:regionsyntax_map and g:regionsyntax_enabled_extension.

Say you would like to highlight this

    $$
    ...
    $$

in html as tex,you could use the following config 

    let g:regionsyntax_map["html"] = [{
                \ 'start' : '\m^[ \t]*\$\$[ \t]*$',
                \ 'ft' : 'tex',
                \ 'end' : '^[ \t]*\$\$[ \t]*$'
                \ }]

    let g:regionsyntax_enabled_extension += ['html']

'vimwiki' is the local filetype set to be enabled.You could set a list of rules for a certain local filetype.
Each rule contains a start pattern, an end pattern, and the new filetype pattern to be found within the start pattern or is specified.
By default,it enables vimwiki,markdown with liquid template and github flavored code block.
