#!/usr/bin/env sh
set -Eeuo pipefail

USER_ID=${LOCAL_USER_ID:-9001}

adduser -u $USER_ID -D mopidy
export HOME=/home/mopidy

chown mopidy $HOME
exec su-exec mopidy "$@"
