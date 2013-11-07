### What for? ###

When editing files with certain code blocks,it's nice to have them highlighted properly.

### How to use it? ###

Use `:[range]RegionSyntax filetype` to highlight the selected block.
Or you can specify new rules for dynamic syntax highlighting with the global variable g:regionsyntax_map and g:regionsyntax_enabled_extension.

Say you would like to highlight this

    $$
    ...
    $$

in html as tex,you could use the following config.

```vim
let g:regionsyntax_map["html"] = [{
            \ 'start' : '\m^[ \t]*\$\$[ \t]*$',
            \ 'ft' : 'tex',
            \ 'end' : '^[ \t]*\$\$[ \t]*$'
            \ }]

let g:regionsyntax_enabled_extension += ['html']
```

'html' is the local filetype set to be enabled.You could set a list of rules for a certain local filetype.
for more info, please view the [doc](https://raw.github.com/farseer90718/vim-regionsyntax/master/doc/regionsyntax.txt)

### License

MIT
