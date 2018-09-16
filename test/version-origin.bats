#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${HELMENV_ROOT}/version" ]
  run helmenv-version-origin
  assert_success "${HELMENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$HELMENV_ROOT"
  touch "${HELMENV_ROOT}/version"
  run helmenv-version-origin
  assert_success "${HELMENV_ROOT}/version"
}

@test "detects HELMENV_VERSION" {
  HELMENV_VERSION=1 run helmenv-version-origin
  assert_success "HELMENV_VERSION environment variable"
}

@test "detects local file" {
  echo "system" > .helm-version
  run helmenv-version-origin
  assert_success "${PWD}/.helm-version"
}

@test "doesn't inherit HELMENV_VERSION_ORIGIN from environment" {
  HELMENV_VERSION_ORIGIN=ignored run helmenv-version-origin
  assert_success "${HELMENV_ROOT}/version"
}
