# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

HIST_STAMPS="mm/dd/yyyy"

plugins=(git aws zsh-autosuggestions zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,underline"

bindkey -v
export LC_ALL="en_US.UTF-8"
export dry="--dry-run=client -o yaml";
export PATH=$PATH:$HOME/go/bin;
export GOBIN=$HOME/go/bin;

source $ZSH/oh-my-zsh.sh

# source ~/Documents/zsh-autocomplete/zsh-autocomplete.plugin.zsh

EDITOR="code"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# aliases

# Terraform aliases
alias tera="terraform"

# K8s aliases
alias k="kubectl"
alias ka="kubectl apply -f"
alias kd="kubectl delete"
alias ke="kubectl edit"
alias kc="kubectl create"
alias kr="kubectl run"
alias krp="kubectl replace"
alias krpf="kubectl replace --force -f"
alias kds="kubectl describe"
alias kg="kubectl get"
alias ksetns="kubectl config set-context --current --namespace"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gpl="git pull"
alias gp="git push"

# IDE aliases
alias c="code ."

# tmux aliases
alias ta="tmux attach-session -t"
alias tn="tmux new-session -t"
alias tk="tmux kill-session -t"
alias tka="tmux kill-session -a"
alias tl="tmux ls"

# Workspace aliases
alias cov="cd $HOME/Workspace/FProjects/Cov"
alias iap="cd $HOME/Workspace/FProjects/Iap"
alias psn="cd $HOME/Workspace/Personal"

# Kubectl completion
source <(kubectl completion zsh)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
