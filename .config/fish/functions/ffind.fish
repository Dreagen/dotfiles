function ffind
    set -l dir (find ~/ -type d -print | fzf)
    test -z "$dir"; and return

    cd $dir

    if test -n "$TMUX"
        tmux rename-session (basename $dir)
        tmux rename-window code

        set -l session (tmux display-message -p '#S')
        set -l cd_command "cd -- "(string escape -- $dir)

        for window in terminal ai
            if tmux list-windows -F '#W' | string match -q -- $window
                tmux send-keys -t "$session:$window" C-c "$cd_command" Enter
            else
                tmux new-window -d -n $window -c $dir
            end
        end
    end
end
