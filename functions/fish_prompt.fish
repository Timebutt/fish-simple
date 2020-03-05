function fish_prompt -d "Simple fish prompt"
    set -l superuser_char "⚡️  "
    set -l command_char "❯ "
    set -l prev_status $status

    # new line
    printf "\e[K\n"

    # current user
    print_color red $USER

    # current working directory
    printf " in "
    print_color yellow (pwd)

    # git
    if git_is_repo
        set -l ahead_char "↑"
        set -l behind_char "↓"
        set -l diverged_char "↓↑"
        set -l uptodate_char "✓"
        set -l touched_char "++"
        set -l branch_name (git_branch_name)
        set -l git_ahead_char (git_ahead $ahead_char $behind_char $diverged_char $uptodate_char)

        # set git state
        set git_state $git_ahead_char
        if git_is_touched
            set git_state $touched_char
        end

        # print git branch + status
        printf " on "
        print_color blue "$branch_name $git_state"
    end

    # new line
    printf "\e[K\n"

    # root indicator
    test (whoami) = root; and set -l command_char $superuser_char

    # last command status
    if test $prev_status -eq 0
        print_color yellow $command_char
    else
        print_color red $command_char
    end
end
