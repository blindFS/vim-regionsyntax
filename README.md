### What for? ###

When editing files with certain code blocks,it's nice to have them highlighted properly.
![image](https://raw.githubusercontent.com/farseer90718/vim-regionsyntax/master/screenshot.png)

### How to use it? ###

`:[range]RegionSyntax filetype` highlight the selected block.
`:RegionSyntaxToggle` enable/disable this plugin.
Or you can specify new rules for dynamic syntax highlighting with the global variable g:regionsyntax_map.

Say you would like to highlight this

    $$
    ...
    $$

in html as tex,you could use the following config.

```vim
let g:regionsyntax_map = {
            \ 'html':
            \ [{
            \   'start' : '\m^[ \t]*\$\$[ \t]*$',
            \   'ft' : 'tex',
            \   'end' : '^[ \t]*\$\$[ \t]*$'
            \ }]}
```

You could set a list of rules for a certain local filetype.
for more info, please view the [doc](https://raw.github.com/farseer90718/vim-regionsyntax/master/doc/regionsyntax.txt)

### License

MIT
