#!/usr/bin/env fish
# A fish wrapper for colcon_cd.
# Unlike `colcon_cd.sh`, *execute* this file to register the function.

# Design philosophy:
# 1. do not rewrite the whole function in fish.
# 2. (1.) will cause tab completion to break, but it is acceptable.
# 3. eventually we should have a python module as a backend, and all sgells
#    should use it.

# wrapper around the sh version
function colcon_cd

  # Execute the sh version in a bash shell, using command substitution.
  # The stdout of the bash shell will be stored in _stdout_res.
  # stderr will be printed to the terminal.
  #
  # Note that fish shell interprets newline as a string separator, so
  # _stdout_res will be an array of strings.
  #
  # __file_dir will be replaced by the parent directory of this file after
  # `funcsave` - this is needed since funcsave basically copies the function
  # string to a new file.
  set _stdout_res (bash -c "source __file_dir/colcon_cd.sh; colcon_cd $argv && echo \"\$(pwd)\"")
  # the return code of the bash `colcon_cd`
  set _status $status

  # if success, change the directory
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
  # else failure, print stdout and return with the status code
  else
    for line in $_stdout_res
      echo $line
    end
    return $_status
  end
end

# code to register the function
funcsave colcon_cd
set _file_dir (dirname (status --current-filename))
# $__fish_config_dir/functions/function_name.fish is the default path where the
# function is saved. (see `funced funcsave`)
# there should be a better way, but in some systems `funcsave` doesn't print
# the saved path
sed -i "s|__file_dir|$_file_dir|g" "$__fish_config_dir/functions/colcon_cd.fish"
