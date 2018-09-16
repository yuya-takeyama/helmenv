#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${HELMENV_ROOT}/versions/${HELMENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export HELMENV_VERSION="0.0.0"
  run helmenv-exec version
  assert_failure "helmenv: version \`0.0.0' is not installed"
}

@test "fails with invalid version set from file" {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
  echo 0.0.1 > .helm-version
  run helmenv-exec rspec
  assert_failure "helmenv: version \`0.0.1' is not installed (set by $PWD/.helm-version)"
}
