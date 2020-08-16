# Index

1) [References](#references)
2) [Apps](#apps)
3) [Containers and desktop workspaces](#containers-and-desktop-workspaces)
4) [Keyboard layout](#keyboard-layout)
5) [System mode](#system-mode)

## References
```yaml
$mod:                                               Windows|Super|Mod4 key
$alt:                                               Alt|Mod1 key
<D>:                                                Left(j), Right(;), Down(k), Up(l)
<N>:                                                1-9
```

## Apps
```yaml
# Browser
brave:                                              $alt+1
google-chrome-stable:                               $alt+Shift+1

# Editor
code:                                               $alt+2

# File Manager
pcmanfm:                                            $alt+3
pcmanfm_pkexec:                                     $alt+Shift+3

# Terminal
alacritty:                                          $mod+Return

# App menu
rofi:                                               $mod+d
rofimoji:                                           $mod+Shift+d
morc_menu:                                          $mod+z

# Audio
pulseeffects:                                       $mod+Ctrl+m

# Screenshot
custom_scrot:                                       Print
custom_scrot --select_screen:                       $mod+Shift+Print
```

## Containers and desktop workspaces
```yaml

# Focus
focus mode_toggle:                                  $mod+space
focus <D>:                                          $mod+<D>

# Move
move <D>:                                           $mod+Shift+<D>

# Screen mode
floating_modifier:                                  $mod
floating toggle:                                    $mod+Shift+space
split toggle:                                       $mod+Ctrl+space
fullscreen toggle:                                  $mod+f

# Workspaces
workspace prev:                                     $mod+Ctrl+j
workspace next:                                     $mod+Ctrl+;
workspace <N>:                                      $mod+<N>
move container to workspace <N>; workspace <N>:     $mod+Shift+<N>

# Others
$resize:                                            $mod+r
kill:                                               $mod+Shift+q
```

## Keyboard layout
```yaml
# 🇺🇸 and 🇪🇦
setxkbmap -layout us:                               $mod+q
setxkbmap -layout es:                               $mod+w
```

## System mode
```yaml
$mode_system:                                       $mod+0
```
