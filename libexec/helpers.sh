function error_and_die() {
  echo -e "helmenv: $(basename ${0}): \033[0;31m[ERROR] ${1}\033[0;39m" >&2
  exit 1
}

function info() {
  echo -e "\033[0;32m[INFO] ${1}\033[0;39m"
}
