#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMENV_ROOT}/versions" ]
  run helmenv-version
  assert_success "system (set by ${HELMENV_ROOT}/version)"
}

@test "set by HELMENV_VERSION" {
  create_version "1.11.3"
  HELMENV_VERSION=1.11.3 run helmenv-version
  assert_success "1.11.3 (set by HELMENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.11.3"
  cat > ".helm-version" <<<"1.11.3"
  run helmenv-version
  assert_success "1.11.3 (set by ${PWD}/.helm-version)"
}

@test "set by global file" {
  create_version "1.11.3"
  cat > "${HELMENV_ROOT}/version" <<<"1.11.3"
  run helmenv-version
  assert_success "1.11.3 (set by ${HELMENV_ROOT}/version)"
}
