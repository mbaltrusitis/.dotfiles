#!/usr/bin/env bash

# Description: Construct a custom Bash prompt defining `PS1`
# Notes:
#     - Install by sourcing this file in your shell profile and appending it to
#       your PROMPT_COMMAND (Bash) or precmd() (Zsh)
#     - `__setup_ps1` closes over all of the necessary functions needed to make
#       the custom prompt without polluting your shell's namespace
__setup_ps1() {

    typeset -r default_background="\e[40m"
    typeset -r default_font_color="\e[30m"
    typeset theme_background
    typeset theme_font_color

    if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ] ; then
        theme_background="\e[41m"
        theme_font_color="\e[31m"
    else
        theme_background="\e[45m"
        theme_font_color="\e[35m"
    fi

    put_component_format() {
        component="$default_background$theme_font_color"   # set background to black, set text to purple
        component+=""
        component+="$theme_background$default_font_color"  # set background to purple, set text to black
        component+="$1"
        component+="$default_background$theme_font_color"  # set background to black, set text to purple
        component+=""
        printf "%s" "$component"
    }

    put_ps1_start() {
        local ps1_start
        ps1_start+="\n"
        ps1_start+="\[\e[40m\]\[\e[35m\]" # set background to black, set text to purple"
        ps1_start+="╭╴"
        printf "%s" "$ps1_start"
    }

    put_ps1_final() {
        local ps1_final
        ps1_final=""
        ps1_final+="\n"
        ps1_final+="╰╴"
        ps1_final+="\[\e[m\]"
        printf "%s" "$ps1_final"
    }

    fetch_git_branch_name() {
        git branch --show-current
    }

    fetch_git_short_hash() {
        git rev-parse --short HEAD 2> /dev/null
    }

    put_git_component() {
        if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null; then
            git_branch="$(fetch_git_branch_name)"
            git_hash="$(fetch_git_short_hash)"
            git_component="$(put_component_format " $git_branch~$git_hash")"
        else
            git_component=""
        fi
        printf "%s" "$git_component"
    }

    put_python_venv_component() {
        if [ -n "$VIRTUAL_ENV" ]; then
            venv_name="$(basename "$VIRTUAL_ENV")"
            venv_component="$(put_component_format " $venv_name")"
        else
            venv_component=""
        fi
        printf "%s" "$venv_component"
    }

    put_username_component() {
        typeset -r username_component="$(put_component_format "  \u")"
        printf "%s" "$username_component"
    }

    put_hostname_component() {
        typeset -r hostname_component="$(put_component_format "  \h")"
        printf "%s" "$hostname_component"
    }

    fetch_ps1_components() {
        export PS1=""
        PS1+="$(put_ps1_start)"
        PS1+="$(put_hostname_component)"
        PS1+=" "
        PS1+="$(put_username_component)"
        PS1+=" "
        PS1+="$(put_git_component)"
        PS1+=" "
        PS1+="$(put_python_venv_component)"
        PS1+="$(put_ps1_final)"
    }

    fetch_ps1_components
}

