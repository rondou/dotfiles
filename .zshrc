# misc {{{
export CASE_SENSITIVE=true

# disable ctrl-d
setopt IGNORE_EOF

# HIST_IGNORE_ALL_DUPS: If a new command line being added to the history list
# duplicates an older one, the older command is removed from the list (even if
# it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Activate the bash-style comments in interactive mode
setopt INTERACTIVE_COMMENTS
# }}}


# {{{ Powerlevel9k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DISABLE_RPROMPT=true
# POWERLEVEL9K_COLOR_SCHEME="light"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\e[;40m\e[38;5;232m\e[0m"
if [ "$UID" -eq 0 ]; then
  POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="# "
else
  POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$ "
fi
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=( \
  ssh \
  context \
  virtualenv \
  rbenv \
  dir_writable \
  dir \
  vcs \
  status \
  root_indicator \
  background_jobs \
  time \
)
# }}}


# zsh-history-substring-search {{{
bindkey -M emacs "^P" history-substring-search-up
bindkey -M emacs "^N" history-substring-search-down
# }}}


# enable the color support of ls {{{
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors \
    && eval "$(dircolors -b ~/.dircolors 2>/dev/null)" \
    || eval "$(dircolors -b)"
  alias ls="ls --quoting-style=literal --color=auto"
fi
# }}}


# TODO: Move SSH agent out as a standalone plugin
# Refresh SSH agent in case it was dead {{{
if [ ! -z "$SSH_AUTH_SOCK" \
    -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ] ; then
  unlink "$HOME/.ssh/agent_sock" 2>/dev/null
  ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
  export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
fi
# }}}


# {{{ zplug
source ~/.zplug/init.zsh

zplug "bhilburn/powerlevel9k", as:theme
zplug "changyuheng/fz", defer:1
zplug "changyuheng/zsh-interactive-cd"
zplug "rupa/z", use:z.sh
zplug "supercrabtree/k"
zplug "Tarrasch/zsh-bd"
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
# zplug "zsh-users/zsh-autosuggestions"
# zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Enable all oh-my-zsh's features
zplug "lib/bzr", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh
zplug "lib/compfix", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh
zplug "lib/correction", from:oh-my-zsh
zplug "lib/functions", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/nvm", from:oh-my-zsh
zplug "lib/prompt_info_functions", from:oh-my-zsh
zplug "lib/spectrum", from:oh-my-zsh
zplug "lib/termsupport", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
# zplug "plugins/gpg-agent", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/rvm", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
# }}}


# autosuggestions {{{
# this has to be done after the plugin being loaded
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  beginning-of-line
  backward-delete-char
  backward-delete-word
  backward-kill-word
  history-search-forward
  history-search-backward
  history-beginning-search-forward
  history-beginning-search-backward
  history-substring-search-up
  history-substring-search-down
  up-line-or-history
  down-line-or-history
  accept-line
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=black,bold,underline"
# }}}


# fzf {{{
fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"
  ## Solarized Light color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
    --height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind 'shift-tab:up,tab:down'
  "
}
fzf_default_opts && unset fzf_default_opts

# Enable fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi
# }}}


# macOS {{{
if [[ "$OSTYPE" == darwin* ]]; then
  # ls color
  eval "$(gdircolors -b ~/.dircolors 2>/dev/null)" || eval "$(gdircolors -b)"
  alias ls="gls --quoting-style=literal --color=auto"

  # updatedb
  alias updatedb="sudo /usr/libexec/locate.updatedb"

  # include macOS specific executables
  if [ -d "$HOME/bin/darwin" ]; then export PATH="$PATH:$HOME/bin/darwin"; fi
fi
# }}}


# Go {{{
export GOPATH=$HOME/go
export GOBIN=${GOPATH}/bin
[[ ! -d ${GOBIN} ]] || PATH="$PATH:$GOBIN"
# }}}

# fast-syntax-highlighting {{{
FAST_HIGHLIGHT_STYLES[variable]="fg=blue"
zle_highlight+=(paste:none)
# }}}

# rvm {{{
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi
# }}}

# locale {{{
[[ -n "$LANG" ]] || export LANG=en_US.UTF-8
[[ -n "$LC_ALL" ]] || export LC_ALL=en_US.UTF-8
# }}}
