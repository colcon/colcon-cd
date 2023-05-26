#!/usr/bin/env fish

# wrapper around the bash version
function colcon_cd
  # __file_dir will be replaced by the actual directory after funcsave
  # this is needed since funcsave basically copies the function to a new file
  set _stdout_res (bash -c "source __file_dir/colcon_cd.sh; colcon_cd $argv && echo \"\$(pwd)\"")
  set _status $status

  # success, change directory
  if test $_status -eq 0
    # the last line of stdout is the new directory
    set -l _new_dir $_stdout_res[-1]
    # change directory if it's not the current one
    if test $_new_dir != (pwd)
      cd $_new_dir
    end
    # print the stdout without the last line
    for line in $_stdout_res[1..-2]
      echo $line
    end
    return 0
  # failure, print stdout and return with the status code
  else
    for line in $_stdout_res
      echo $line
    end
    return $_status
  end
end

# register the function
funcsave colcon_cd
set _file_dir (dirname (status --current-filename))
# $__fish_config_dir/functions/function_name.fish is the default path where the
# function is saved.
# there should be a better way, but in some systems `funcsave` doesn't print
# the saved path
sed -i "s|__file_dir|$_file_dir|g" "$__fish_config_dir/functions/colcon_cd.fish"
