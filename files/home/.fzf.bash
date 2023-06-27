# Setup fzf
# ---------
if [[ ! "$PATH" == */home/breno/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/breno/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/breno/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/breno/.fzf/shell/key-bindings.bash"

# Colors
export FZF_DEFAULT_COMMAND="fd --hidden -i -t f -j 3 --exclude '.git/'"

FZF_DEFAULT_OPTS='-m --no-reverse --info=inline --bind ctrl-v:select-all,ctrl-u:deselect-all'
# FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi --preview-window 'right:50%' --preview 'bat --color=always --style=header,grid --line-range :100 {}'"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'


