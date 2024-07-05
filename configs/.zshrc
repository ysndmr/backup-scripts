# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/yasindemir/.oh-my-zsh"

#ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_THEME="robbyrussell"


plugins=(web-search zsh-better-npm-completion zsh-autosuggestions fzf git tmux ag autojump brew fd vi-mode yarn zsh-interactive-cd nvm npm node 
urltools ripgrep jira copyfile copypath web-search)

source $ZSH/oh-my-zsh.sh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



bindkey '^R' fzf-history-widget

function mr() {
	open -a "Google Chrome" "https://gitlab.com/success-factory-development/ticketfactory/-/merge_requests/new?nav_source=webide&merge_request%5Bsource_branch%5D=$(git rev-parse --abbrev-ref HEAD)&merge_request%5Btarget_branch%5D=develop"
}
