#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${HELMENV_TEST_DIR}/myproject"
  cd "${HELMENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.helm-version" ]
  run helmenv-local
  assert_failure "helmenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .helm-version
  run helmenv-local
  assert_success "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .helm-version
  mkdir -p "subdir" && cd "subdir"
  run helmenv-local
  assert_success "1.2.3"
}

@test "ignores HELMENV_DIR" {
  echo "1.2.3" > .helm-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.helm-version"
  HELMENV_DIR="$HOME" run helmenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${HELMENV_ROOT}/versions/1.2.3/bin"
  run helmenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helm-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .helm-version
  mkdir -p "${HELMENV_ROOT}/versions/1.2.3/bin"
  run helmenv-local
  assert_success "1.0-pre"
  run helmenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helm-version)" = "1.2.3" ]
}

@test "unsets local version" {
  touch .helm-version
  run helmenv-local --unset
  assert_success ""
  assert [ ! -e .helm-version ]
}
