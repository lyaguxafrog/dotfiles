#!/usr/bin/env sh

# SPDX-License-Identifier: ISC

SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

hold()
{
    APP="$(siq "${1}" "$APPS_FILE")"

    [ -n "$APP" ] || exit ${?}
}

case "${1}" in
    -g) hold "${2}"

        # If the value of $APP contains double-quotes, escape it
        # to preserve double-quotes when displayed to output.
        if [ -z "${APP##*\"*\"*}" ]; then
            ZAPP="$(sed -e '1s|"|\\"|g' <<- APP
						${APP}
					APP
                  )"
        fi

        eval "echo \"${ZAPP:-${APP}}\""
    ;;
    * ) hold "${1}"

        eval "LANG=\"$SYSTEM_LANG\" exec ${APP} \${*#\"${1}\"} >&2 &"
    ;;
esac

exit ${?}
