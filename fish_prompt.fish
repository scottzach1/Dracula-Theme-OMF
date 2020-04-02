# name: eclm-clone
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l purple (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
    set arrow "$green➜ "
  else
    set arrow "$red➜ "
  end
  set -l cwd $purple(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $cyan(_git_branch_name)
    set git_info "$cyan ($git_branch)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $arrow $cwd $git_info $normal ' '
end
