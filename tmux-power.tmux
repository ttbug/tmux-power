#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo $value || echo $2
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# short for Theme-Colour
TC="$(tmux_get '@tmux_power_theme')"
case $TC in
    'gold' )
        TC='yellow'
        ;;
    'fire' )
        TC='red'
        ;;
    'forest' )
        TC='green'
        ;;
    'ocean' )
        TC='colour39'
        ;;
    'night' )
        TC='blue'
        ;;
    'gay' )
        TC='magenta'
        ;;
esac
GR0=colour235
GR1=colour236
GR2=colour237
GR3=colour238
GR4=colour239
GR5=colour240
GR6=colour241
BG="$GR0"
FG="$GR6"

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)

# Network speed
show_upload_speed="$(tmux_get @tmux_power_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_download_speed false)"
# tmux-net-speed has no support for mac
if [[ $(uname) == 'Darwin' ]]; then
    show_upload_speed=false
    show_download_speed=false
fi
upload_speed_icon=$(tmux_get @tmux_power_upload_speed_icon '')
download_speed_icon=$(tmux_get @tmux_power_download_speed_icon '')

#     
# Left side of status bar
tmux_set status-left-bg "$GR0"
tmux_set status-left-fg colour243
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$GR0,bg=$TC,bold]  $user@#h #[fg=$TC,bg=$GR2,nobold]#[fg=$TC,bg=$GR2]  #S "
if "$show_upload_speed"; then
    LS="$LS#[fg=$GR2,bg=$GR1]#[fg=$TC,bg=$GR1] $upload_speed_icon#{upload_speed} #[fg=$GR1,bg=$BG]"
else
    LS="$LS#[fg=$GR2,bg=$BG]"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg $GR0
tmux_set status-right-fg colour243
tmux_set status-right-length 150
RS="#[fg=$TC,bg=$GR2]  %T #[fg=$TC,bg=$GR2]#[fg=$GR0,bg=$TC]  %F "
if "$show_download_speed"; then
    RS="#[fg=$GR1,bg=$BG]#[fg=$TC,bg=$GR1] $download_speed_icon#{download_speed} #[fg=$GR2,bg=$GR1]$RS"
else
    RS="#[fg=$GR2,bg=$BG]$RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$GR2]#[fg=$TC,bold] #I:#W#F #[fg=$GR2,bg=$BG,nobold]"

# Current window status
tmux_set window-status-current-bg $TC
tmux_set window-status-current-fg $BG

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Pane border
tmux_set pane-border-bg default
tmux_set pane-border-fg $GR3

# Active pane border
tmux_set pane-active-border-fg $TC
tmux_set pane-active-border-bg default

# Pane number indicator
tmux_set display-panes-colour $GR3
tmux_set display-panes-active-colour $TC

# Clock mode
tmux_set clock-mode-colour $TC
tmux_set clock-mode-style 24

# Message
tmux_set message-fg $TC
tmux_set message-bg $BG

# Command message
tmux_set message-command-fg $TC
tmux_set message-command-bg $BG

# Copy mode highlight
tmux_set mode-bg $TC
tmux_set mode-fg $BG
