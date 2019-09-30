# copied from colcon_cd/function/colcon_cd.sh

colcon_cd() {
  if [ $# = 0 ]; then
    # change the working directory to the previously saved path
    if [ "$_colcon_cd_root" = "" ]; then
      echo "No previous path saved. Either call 'colcon_cd <pkgname>' from a" \
        "directory where <pkgname> can be found or 'colcon_cd --set' to" \
        "directly save the current working directory." 1>&2
      return 1
    fi
    if [ "$_colcon_cd_root" != "$(pwd)" ]; then
      cd "$_colcon_cd_root"
    fi

  elif [ $# = 1 ]; then
    if [ "$1" = "--set" ]; then
      # store the current working directory for future invocations
      _colcon_cd_root="$(pwd)"
      echo "Saved the current working directory for future invocations of" \
        "'colcon_cd <pkgname>' as well as to return to using 'colcon_cd'." \
        "Call 'colcon_cd --reset' to unset the saved path."
      return 0
    elif [ "$1" = "--reset" ]; then
      # unset the save path
      unset _colcon_cd_root
      return 0
    fi

    _colcon_cd_cmd="colcon list --packages-select $1 --paths-only"

    if [ "$_colcon_cd_root" != "" ]; then
      # try to find the given package from the saved path
      _colcon_cd_pwd="$(pwd)"
      cd "$_colcon_cd_root"

      _colcon_cd_pkg_path="$(COLCON_LOG_PATH=/dev/null $_colcon_cd_cmd 2> /dev/null)"
      if [ $? -eq 0 ] && [ "$_colcon_cd_pkg_path" != "" ]; then
        cd "$_colcon_cd_pkg_path"
        unset _colcon_cd_pkg_path
        unset _colcon_cd_pwd
        return 0
      fi
      unset _colcon_cd_pkg_path

      cd "$_colcon_cd_pwd"
      unset _colcon_cd_pwd
    fi

    # try to find the given package from the current working directory
    _colcon_cd_pkg_path="$(COLCON_LOG_PATH=/dev/null $_colcon_cd_cmd 2> /dev/null)"
    if [ $? -eq 0 ] && [ "$_colcon_cd_pkg_path" != "" ]; then
      if [ "$_colcon_cd_root" = "" ]; then
        # store the current working directory for future invocations
        _colcon_cd_root="$(pwd)"
        echo "Saved the directory '$_colcon_cd_root' for future invocations" \
          "of 'colcon_cd <pkgname>' as well as to return to using " \
          "'colcon_cd'. Call 'colcon_cd --reset' to unset the saved path."
      fi
      cd "$_colcon_cd_pkg_path"
      unset _colcon_cd_pkg_path
      return 0
    fi
    unset _colcon_cd_pkg_path

    if [ "$_colcon_cd_root" != "" ]; then
      echo "Could neither find package '$1' from '$_colcon_cd_root' nor from" \
        "the current working directory" 1>&2
    else
      echo "Could not find package '$1' from the current working" \
        "directory" 1>&2
    fi
    return 1

  else
    echo "'colcon_cd' only supports zero or one arguments" 1>&2
    return 1
  fi
}
