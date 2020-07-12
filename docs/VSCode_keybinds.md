# VSCode Keybinds

## Index

1) [Text editor](#text-editor)
    1 - [Cursors and Selections](#cursors-and-selections)
    2 - [Insert](#insert)
    3 - [Delete](#delete)
    4 - [Bookmarks](#bookmarks)
    5 - [Textmarker](#textmarker)
    6 - [Groups](#groups)
    7 - [Problems](#problems)
    8 - [Suggestions](#suggestions)
    9 - [References](#references)
    10 - [Definitions](#definitions)
    11 - [Refactorization](#refactorization)
2) [Lists](#lists)
3) [Search](#search)
4) [Terminal](#terminal)
5) [Panel](#panel)
6) [Files](#files)
    6 - [Sidebar](#sidebar)
    6 - [OS](#os)
    6 - [Gistpad](#gistpad)

## Text editor

### Cursors and Selections
```yaml
# Left
cursorLeft:                                         Alt+j
cursorLeftSelect:                                   Ctrl+j
cursorWordStartLeft:                                Ctrl+Alt+j
cursorWordStartLeftSelect:                          Ctrl+Shift+j
cursorWordPartLeft:                                 Shift+Alt+j
cursorWordPartLeftSelect:                           Ctrl+Shift+Alt+j

# Right
cursorRight:                                        Alt+;
cursorRightSelect:                                  Shift+Alt+;
cursorWordStartRight:                               Ctrl+Alt+;
cursorWordStartRightSelect:                         Ctrl+Shift+;
cursorWordPartRight:                                Shift+Alt+;
cursorWordPartRightSelect:                          Ctrl+Shift+Alt+;

# Down
cursorDown:                                         Alt+k
cursorDownSelect:                                   Shift+k
editor.action.insertCursorBelow:                    Shift+Alt+k
editor.action.moveLinesDownAction:                  Ctrl+Alt+k
indentation-level-movement.moveDown:                Ctrl+Shift+k
indentation-level-movement.selectDown:              Ctrl+Shift+Alt+k

# Up
cursorUp:                                           Alt+l
cursorUpSelect:                                     Shift+l
editor.action.insertCursorAbove:                    Shift+Alt+l
editor.action.moveLinesUpAction:                    Ctrl+Alt+l
indentation-level-movement.moveUp:                  Ctrl+Shift+l
indentation-level-movement.selectUp:                Ctrl+Shift+Alt+l

# PageUp
cursorPageUp:                                       Alt+[
cursorPageUpSelect:                                 Shift+Alt+[

# PageDown
cursorPageDown:                                     Alt+'
cursorPageDownSelect:                               Shift+Alt+'

# Home
cursorHome:                                         Alt+s
cursorHomeSelect:                                   Shift+Alt+s

# End
cursorEnd:                                          Alt+d
cursorEndSelect:                                    Shift+Alt+d

# Exit
removeSecondaryCursors:                             Alt+p
cancelSelection:                                    Alt+p
```

### Insert
```yaml
editor.action.insertLineBefore:                     Shift+Alt+u
editor.action.insertLineAfter:                      Alt+u
```

### Delete
```yaml
editor.action.deleteLines:                          Ctrl+Shift+i

# Left
deleteLeft:                                         Alt+i
deleteWordLeft:                                     Ctrl+i
deleteWordPartLeft:                                 Ctrl+Shift+Alt+i

# Right
deleteRight:                                        Alt+o
deleteWordRight:                                    Ctrl+o
deleteWordPartRight:                                Ctrl+Shift+Alt+o
```

### Bookmarks
```yaml
bookmarks.toggle:                                   Ctrl+q
bookmarks.listFromAllFiles:                         Ctrl+Alt+q
```

### Textmarker
```yaml
textmarker.toggleHighlight:                         Alt+h
```

### Groups
```yaml
# Focus
workbench.action.keepEditor:                        Ctrl+k Alt+u
workbench.action.focusActiveEditorGroup:            Alt+,
workbench.action.previousEditorInGroup:             Ctrl+Alt+[
workbench.action.nextEditorInGroup:                 Ctrl+Alt+'

# Move editor in the same group
workbench.action.moveEditorLeftInGroup:             Ctrl+Shift+Alt+[
workbench.action.moveEditorRightInGroup:            Ctrl+Shift+Alt+'

# Move editor through the groups
workbench.action.moveEditorToLeftGroup:             Ctrl+k Shift+Alt+j
workbench.action.moveEditorToRightGroup:            Ctrl+k Shift+Alt+;

# Move group
workbench.action.moveActiveEditorGroupLeft:         Ctrl+k Alt+j
workbench.action.moveActiveEditorGroupRight:        Ctrl+k Alt+;
```

### Problems
```yaml
editor.action.marker.prev:                          Shift+Alt+n
editor.action.marker.next:                          Alt+n
```

### Suggestions
```yaml
selectPrevSuggestion:                               Alt+l
selectNextSuggestion:                               Alt+k
acceptSelectedSuggestion:                           Alt+u
hideSuggestWidget:                                  Alt+p
```

### References
```yaml
editor.action.goToReferences:                       Shift+Alt+q
closeReferenceSearch:                               Alt+p
```

### Definitions
```yaml
editor.action.showDefinitionPreviewHover            Ctrl+Alt+e
editor.action.revealDefinition:                     Alt+e
editor.action.peekDefinition:                       Ctrl+e
closeParameterHints:                                Alt+p
```

### Refactorization
```yaml
editor.action.rename:                               Alt+y
cancelRenameInput:                                  Alt+p
```

## Lists
```yaml
# Movement
list.focusDown:                                     Alt+k
list.focusUp:                                       Alt+l
list.focusPageUp:                                   Alt+[
list.focusPageDown:                                 Alt+'

# View
list.expand:                                        Alt+;
list.collapse:                                      Alt+j
list.collapseAll:                                   Shift+Alt+j

# Selection
list.select:                                        Alt+u
```

## Search
```yaml
# Text editor search
toggleFindInSelection:                              Alt+v
addCursorsAtSearchResults:                          Shift+Alt+v
editor.action.previousSelectionMatchFindAction:     Shift+Alt+w
editor.action.nextSelectionMatchFindAction:         Alt+w
editor.action.replaceAll:                           Ctrl+Shift+Alt+1
closeFindWidget:                                    Alt+p

# File search
search.action.replaceAll:                           Ctrl+Shift+Alt+1
search.focus.previousInputBox:                      Ctrl+Alt+k
search.focus.nextInputBox:                          Ctrl+Alt+l
workbench.action.search.toggleQueryDetails:         Ctrl+Shift+Alt+f
search.action.focusSearchList:                      Ctrl+Shift+Alt+w
search.action.focusPreviousSearchResult:            Shift+Alt+w
search.action.focusNextSearchResult:                Alt+w
search.action.expandSearchResults:                  Ctrl+k Ctrl+j
search.action.cancel:                               Alt+p

# History Navigation
history.ShowPrevious:                               Alt+l
history.showNext:                                   Alt+k

# Options
toggleFindWholeWord:                                Alt+m
toggleSearchWholeWord:                              Alt+m
```

## Terminal
```yaml
workbench.action.terminal.focus:                    Alt+.
```

## Panel
```yaml
workbench.action.togglePanel:                       Ctrl+Alt+.
workbench.action.toggleMaximizedPanel:              Ctrl+Shift+Alt+.
```

## Files

### Sidebar
```yaml
workbench.action.toggleSidebarVisibility:           Ctrl+Shift+B
```

### OS
```yaml
# Reveal and Open
workbench.files.action.showActiveFileInExplorer:    Ctrl+k 0
revealFileInOS:                                     Ctrl+k o

# Edition
renameFile:                                         Alt+y
filesExplorer.cancelCut:                            Alt+p
```

### Gistpad
```yaml
gistpad.gists.focus:                                Ctrl+k ;
```
