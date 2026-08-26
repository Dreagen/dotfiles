set -g fish_greeting

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
end

# fzf 
if type -q fzf
    fzf --fish | source 
end

# example integration with bat : <cltr+f>
# bind -M insert \ce '$EDITOR $(fzf --preview="bat --color=always --plain {}")' 


set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack 

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias vc='code'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
#abbr mkdir 'mkdir -p'

# set custom path
set -U fish_user_paths $HOME/.local/share/nvim/mason/bin/ $fish_user_paths
set -U fish_user_paths $HOME/dev/dataglide/repos/dev-tools/cli-tools/amd64 $fish_user_paths
set -U fish_user_paths $HOME/dotnet $fish_user_paths
set -U fish_user_paths $HOME/.dotnet/tools $fish_user_paths
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
set -U fish_user_paths /opt/android-sdk/cmdline-tools/latest/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

set -x DOTNET_ROOT $HOME/dotnet

if test -f $HOME/.config/fish/config_private.fish
    source $HOME/.config/fish/config_private.fish
end

if test -f $HOME/dev/dataglide/repos/dev-tools/fish/config_ext.fish
    source $HOME/dev/dataglide/repos/dev-tools/fish/config_ext.fish
end

function hist
    # Use fzf to search history and insert selected command into the command line
    commandline --replace (history | fzf)
end
 
function ffind
    cd (find ~/ -type d -print | fzf)
end
bind -M insert \cf 'ffind; commandline -f repaint'
bind \cf 'ffind; commandline -f repaint'

# set so flutter can see chrome
set -x CHROME_EXECUTABLE /usr/bin/google-chrome-stable
