# tmux Keybinds

## Index

1) [Prefix](#prefix)
2) [copy-mode-vi](#copy-mode-vi)
2.1) [Cursor](#cursor)
2.2) [Search](#search)
2.3) [Copy](#copy)

## Prefix
```yaml
bind-key -r -T prefix j select-pane -L
bind-key -r -T prefix \; select-pane -R
```

## copy-mode-vi

### Cursor
```yaml
cursor-left:                                j
previous-word:                              J
cursor-right:                               r
next-word:                                  R
cursor-down:                                k
cursor-up:                                  l
start-of-line:                              s
end-of-line:                                d
page-down:                                  '
page-up:                                    [
```

### Search
```yaml
"search down" & "search-forward":           w
"search up" & "search-backward":            W
```

### Copy
```yaml
copy-pipe-and-cancel:                       u
clear-selection:                            p
```
