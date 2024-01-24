#!/usr/bin/env sh
set -Eeuo pipefail

set_env_var () {
    local var="$1"
    local value="${2:-}"

    # check if the env var 'var' is set
    if [ -n "${!var:-}" ]; then
        value="${!var}"
    fi

    export "$var"="$value"
}

set_env_var "USER_ID" "9001"
set_env_var "MOPIDY_ADDONS"

if [ -n "$MOPIDY_ADDONS" ]; then 
    python3 -m pip install --no-cache-dir $MOPIDY_ADDONS; 
fi 

adduser -u $USER_ID -D mopidy
export HOME=/home/mopidy
chown mopidy $HOME

exec su-exec mopidy "$@"
