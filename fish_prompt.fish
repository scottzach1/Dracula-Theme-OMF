# name: dracula
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  # Set variables and colors
  set -l last_status $status
  set -l cyan (set_color 8be9fd)
  set -l yellow (set_color f1fa8c)
  set -l red (set_color ff5555)
  set -l purple (set_color bd93f9)
  set -l green (set_color 50fa7b)
  set -l normal (set_color normal)
  # Set status arrow
  if test $last_status = 0
    set arrow "$green➜ "
  else
    set arrow "$red➜ "
  end
  # Set current working directory
  set -l cwd $purple(basename (prompt_pwd))
  # Set git info
  if [ (_git_branch_name) ]
    set -l git_branch $cyan(_git_branch_name)
    set git_info "$cyan($git_branch)"

    if [ (_is_git_dirty) ]
      set git_info "$git_info$yellow ✗"
    else
      set git_info "$git_info$green ✔︎"
    end
  end
  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end
  # Output to console
  echo -n -s $arrow $cwd $git_info $normal ' '
end
