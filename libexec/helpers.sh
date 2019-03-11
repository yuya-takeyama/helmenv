function error_and_die() {
  echo -e "helmenv: $(basename ${0}): \033[0;31m[ERROR] ${1}\033[0;39m" >&2
  exit 1
}

function info() {
  echo -e "\033[0;32m[INFO] ${1}\033[0;39m"
}

function realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}