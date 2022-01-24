export PATH=$HOME/bin:$HOME/.local/bin:$PATH
setopt NO_CASE_GLOB # case insensitive globbing

### HISTORY
setopt EXTENDED_HISTORY # history metadata
SAVEHIST=5000
HISTSIZE=2000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY # append history live
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS # do not store duplicates
setopt HIST_FIND_NO_DUPS # no dupes when searching
setopt HIST_REDUCE_BLANKS # no blank lines
setopt HIST_VERIFY # show command before running
setopt CORRECT
setopt CORRECT_ALL

### AUTOCOMPLETE
#https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix 

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' # case insensitive-path completion

autoload -Uz compinit && compinit


### PROMPT
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUPSTREAM="verbose git"
GIT_PS1_SHOWCOLORHINTS=true
setopt PROMPT_SUBST

CMD_STATUS='%(?.%F{46}√%f.%F{196}X%f %?)'
PWD_STATUS='%B%F{147}%3~%f%b'
PRIV_STATUS='%(!.#.$)'

PROMPT='${CMD_STATUS} ${PWD_STATUS} ${PRIV_STATUS} '
RPROMPT='%c$(__git_ps1) %*'

### PIPENV
PIPENV_DEFAULT_PYTHON_VERSION=3.10
WORKON_HOME=~/.venvs

### NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
