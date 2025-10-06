# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/share/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/zsh/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="alanpeabody"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-auto-venv/auto-venv.zsh
autoload -U compinit && compinit

# History configurations
HISTSIZE=5000
HISTFILE=/home/wetar/.config/zsh/zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Make ls command has some icons in it
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'

# Mufetch and fastfetch checking
# if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
#     if [[ $(playerctl status) = "Stopped" ]]; then
#         fastfetch
#     elif [ $(nmcli -t -f STATE general status) = "connected" ]; then
#         if [[ $(mpc current) == ".Feast - Kami Belum Tentu" || $(mpc current) == "Sombr - Back To Friends" || $(mpc current) == "Gigi Perez - Sailor Song" || $(mpc current) == ".Feast - Peradaban" || $(mpc current) == "Eyedress - Jealous" ]]; then
#         mufetch search -s 16 "$(mpc current --format '%title% - %artist% - %album%')"
#         else
#             mufetch search -s 16 "$(mpc current)"
#         fi
#     else
#         fastfetch
#     fi
# fi

# Only use fastfetch
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]]; then
    fastfetch
fi

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export HISTFILE="$HOME/.config/zsh/zsh_history"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#787c99,fg+:#ffffff,bg:#000000,bg+:#000000
    --height=80%
    --color=hl:#5f87af,hl+:#c20000,info:#ffffff,marker:#ffffff
    --color=prompt:#ffffff,spinner:#af5fff,pointer:#af5fff,header:#87afaf
    --color=border:#ffffff,label:#aeaeae,query:#d9d9d9
    --border="sharp" --border-label="" --preview-window="border-sharp" --prompt="N "
    --marker="◆ " --pointer="" --separator="─" --scrollbar="│"
    --info="right"  --preview "bat --style=numbers --color=always {} | head -500"'

# Enable zoxide
eval "$(zoxide init --cmd cd zsh)"

# Making some aliases
alias gpo="git push -u origin main"
alias ga="git add ."
alias gp="git pull"
alias gr="git restore"
alias gc="git commit -am "
alias delcache="sudo paccache -rk0 && paru -Scc && paru -Sccd && rm -rf $HOME/.local/share/zoxide && npm cache clean --force && rm -rf $HOME/.npm && rm -rf $HOME/.cache/paru && rm -rf $HOME/.cache/ && echo 'Cache successfully cleaned'"
alias delhist="rm -rf $HOME/.config/zsh/zsh_history && echo 'All histories successfully cleaned'"
alias paup="paru -Syu"
alias pare="paru -Rnsc"
alias pain="paru -S"
alias pase="paru -Ss"
