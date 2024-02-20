#!/usr/bin/env sh


exec >/dev/null 2>&1
. "${HOME}/.joyfuld"

# https://gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#:~:text=expand_aliases
[ -z "$BASH" ] || shopt -s expand_aliases

{ [ "$(joyd_launch_apps -g terminal)" = 'urxvtc' ] && urxvtd -f -q; } &


joyd_toggle_mode apply
joyd_tray_programs exec

picom -b

snixmbed

if [ -x "$(command -v lxpolkit)" ]; then
    lxpolkit &
else
    $(find ${LIBS_PATH} -type f -iname 'polkit-gnome-authentication-agent-*' | sed 1q) &
fi

{ [ -x "$(command -v xss-lock)" ] && xss-lock -q -l "${JOYD_DIR}/xss-lock-tsl.sh"; } &

joyd_mpd_notifier
# setxkbmap -layout us,ru -variant -option grp:caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp &


# Any additions should be added below.


