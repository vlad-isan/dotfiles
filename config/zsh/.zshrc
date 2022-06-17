#!/usr/bin/env zsh

export DOTFILES="$HOME/dotfiles"

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=999999999                   # Maximum events for internal history
export SAVEHIST=999999999                   # Maximum events in history file

# man pages
export MANPAGER='nvim +Man!'

fpath=($DOTFILES/config/zsh/plugins $fpath)

# +------------+
# | NAVIGATION |
# +------------+

setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

. $DOTFILES/config/zsh/plugins/bd.zsh

# +---------+
# | HISTORY |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# +--------+
# | COLORS |
# +--------+

# Override colors
# eval "$(dircolors -b $DOTFILES/config/zsh/.dircolors)"

# +---------+
# | ALIASES |
# +---------+

. $DOTFILES/aliases/aliases.sh

# +---------+
# | SCRIPTS |
# +---------+

# . $DOTFILES/zsh/scripts.zsh

. "$DOTFILES/config/zsh/plugins/fg_bg.sh"
zle -N fg-bg
bindkey '^Z' fg-bg

# +--------------------+
# | TIME NOTIFICATIONS |
# +--------------------+

# Send notification when command line done
# . $DOTFILES/config/zsh/plugins/notifyosd.zsh

# +--------+
# | PROMPT |
# +--------+

fpath=($DOTFILES/config/zsh/prompt $fpath)
source $DOTFILES/config/zsh/prompt/prompt_purification_setup.sh

# +-----------+
# | PROFILING |
# +-----------+

zmodload zsh/zprof

# +-----------+
# | VI KEYMAP |
# +-----------+

# Vi mode
# bindkey -v
# export KEYTIMEOUT=1

# Change cursor
. "$DOTFILES/config/zsh/plugins/cursor_mode.sh"

# Add Vi text-objects for brackets and quotes
# autoload -Uz select-bracketed select-quoted
# zle -N select-quoted
# zle -N select-bracketed
# for km in viopp visual; do
#   bindkey -M $km -- '-' vi-up-line-or-history
#   for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
#     bindkey -M $km $c select-quoted
#   done
#   for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
#     bindkey -M $km $c select-bracketed
#   done
# done
# # Emulation of vim-surround
# autoload -Uz surround
# zle -N delete-surround surround
# zle -N add-surround surround
# zle -N change-surround surround
# bindkey -M vicmd cs change-surround
# bindkey -M vicmd ds delete-surround
# bindkey -M vicmd ys add-surround
# bindkey -M visual S add-surround
# # Increment a number
# autoload -Uz incarg
# zle -N incarg
# bindkey -M vicmd '^a' incarg
# +------------+
# | COMPLETION |
# +------------+
. $DOTFILES/config/zsh/completion.zsh
autoload -Uz $DOTFILES/config/zsh/plugins/kubectl-completion/zsh-kubectl-completion
# +-----+
# | Git |
# +-----+
# Add command gitit to open Github repo in default browser from a local repo
. $DOTFILES/config/zsh/plugins/gitit.zsh
# +-----+
# | FZF |
# +-----+
# if [ $(command -v "fzf") ]; then
    # source /usr/share/fzf/completion.zsh
    # source /usr/share/fzf/key-bindings.zsh
    # source $DOTFILES/config/zsh/scripts_fzf.zsh # fzf Scripts
    # Search with fzf and open selected file with Vim
    # bindkey -s '^v' 'vim $(fzf);^M'
# fi
# +---------+
# | BINDING |
# +---------+
#
# edit current command line with vim (vim-mode, then v)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^v' edit-command-line
# . "$DOTFILES/config/zsh/bindings.zsh"

# +---------------------+
# | SYNTAX HIGHLIGHTING |
# +---------------------+
. $DOTFILES/config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable reverse & forward search
bindkey '^r' history-incremental-search-backward
bindkey '^R' history-incremental-pattern-search-backward


#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#end-nvm

#jenv
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
#end-jenv
export PATH="/usr/local/opt/mongodb-community@4.0/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export GPG_TTY=$(tty)
export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"
export ARTIFACTORY_USERNAME=vlad.isan@eurostar.com
export ARTIFACTORY_PASSWORD=AKCp8jQ8hZWnXmDb7LM9dpHK7GCu6jYuibgtGKMGq12oQw6xr4FqHhLmdT8csD5MsPej1WVQs
export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export PATH="/usr/local/opt/llvm/bin:$PATH"


. "$HOME/.cargo/env"
