function ffind
    set -l dir (find ~/ -type d -print | fzf)
    test -z "$dir"; and return

    cd $dir

    if test -n "$TMUX"
        tmux rename-session (basename $dir)
        tmux rename-window code
        tmux new-window -d -n terminal -c $dir
        tmux new-window -d -n ai -c $dir
    end
end
