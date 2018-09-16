#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run helmenv-version-file-write
  assert_failure "Usage: helmenv version-file-write <file> <version>"
  run helmenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".helm-version" ]
  run helmenv-version-file-write ".helm-version" "1.11.3"
  assert_failure "helmenv: version \`1.11.3' is not installed"
  assert [ ! -e ".helm-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${HELMENV_ROOT}/versions/1.10.8/bin"
  assert [ ! -e "my-version" ]
  run helmenv-version-file-write "${PWD}/my-version" "1.10.8"
  assert_success ""
  assert [ "$(cat my-version)" = "1.10.8" ]
}
