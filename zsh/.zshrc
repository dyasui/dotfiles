# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export nvim="/usr/local/bin/nvim"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias la='ls -a --color'
alias lt='eza -Tl'
alias c='clear'
alias skim='/Applications/Skim.app/Contents/MacOS/Skim'
alias icat='kitten icat'
alias diff='kitten diff'
alias wordlelist="curl -s https://raw.githubusercontent.com/tabatkins/wordle-list/main/words"
alias cat="bat"
alias ssh="kitten ssh"
alias ddgr="BROWSER=w3m ddgr"
alias qvim="NVIM_APPNAME=quarto-nvim-kickstarter nvim"

# for apt installation of fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Shell integrations
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval "$($(brew --prefix)/bin/brew shellenv)"
eval "$(zoxide init --cmd cd zsh)"

# enable vi mode
bindkey -v
alias config='/usr/bin/git --git-dir=/home/dante/dotfiles --work-tree=/home/dante'

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/dante/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# Created by `pipx` on 2024-10-20 22:29:12
export PATH="$PATH:/home/dante/.local/bin"
