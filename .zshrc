# Enable Powerlevel10k instant prompt (must stay near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH
export PATH="$HOME/.local/bin:$PATH"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# Completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
setopt nocaseglob nocasematch

# Colori per ls / grep / diff (popola LS_COLORS e abilita --color=auto)
eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Arrow-key history search (matches on already-typed prefix)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Plugins
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#005500'

# Syntax highlighting (deve stare per ultimo)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#39FF14,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00FFAA,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#00FFAA,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#00FFAA,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FFDD00,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#CCAA00'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#CCAA00'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#CCAA00'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#005500'
ZSH_HIGHLIGHT_STYLES[path]='fg=#00FF41,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#00DDBB'

# Powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

