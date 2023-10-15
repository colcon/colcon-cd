if type register-python-argcomplete3 > /dev/null 2>&1; then
  eval "$(register-python-argcomplete3 colcon_cd)"
elif type register-python-argcomplete > /dev/null 2>&1; then
  eval "$(register-python-argcomplete colcon_cd)"
fi
