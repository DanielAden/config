if [ -f ~/.workrc ]; then 
    . ~/.workrc;
fi

if [ -f ~/.personalrc ]; then 
    . ~/.personalrc;
fi

source ~/.git-prompt.sh

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="$HOME/.cargo/bin:$PATH"
export PATH
. "$HOME/.cargo/env"

PATH="$HOME/go/bin:$PATH"

# Add lunarvim etc. to path
PATH="$HOME/.local/bin:$PATH"

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
# RPROMPT='${vcs_info_msg_0_}'
PROMPT='%~ ${vcs_info_msg_0_}'$'\n''$ '
zstyle ':vcs_info:git:*' formats '(%b)'

	
# Vim CLI
set -o vi

# https://pencilflip.medium.com/my-zshrc-file-on-mac-adapted-from-bashrc-and-inputrc-16ac09efeb95
# Adds --INSERT-- and --NORMAL-- to right side of screen
# function zle-line-init zle-keymap-select {         
#   RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"    
#   RPS2=$RPS1    
#   zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

# vi mode
# Taken from here: https://unix.stackexchange.com/a/614203
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# bun completions
[ -s "/Users/danieladen/.bun/_bun" ] && source "/Users/danieladen/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
