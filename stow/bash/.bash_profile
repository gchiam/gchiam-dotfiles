# vim: set filetype=sh:
# shellcheck shell=bash disable=SC2148,SC1090,SC1091,SC2046,SC1004

export LANG=en_US.UTF-8

# Load ~/.extra, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don't want to commit
for file in ~/.{bash_path,ash_extra,bash_exports,bash_aliases,bash_functions,bash_completion,bash_completion-homebrew,bash_local,bash_private,bash_motd}; do
	[ -r "$file" ] && . "$file"
done
unset file

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

umask 002
