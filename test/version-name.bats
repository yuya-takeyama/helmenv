#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMENV_ROOT}/versions" ]
  run helmenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  HELMENV_VERSION=system run helmenv-version-name
  assert_success "system"
}

@test "HELMENV_VERSION has precedence over local" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > ".helm-version" <<<"1.10.8"
  run helmenv-version-name
  assert_success "1.10.8"

  HELMENV_VERSION=1.11.3 run helmenv-version-name
  assert_success "1.11.3"
}

@test "local file has precedence over global" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > "${HELMENV_ROOT}/version" <<<"1.10.8"
  run helmenv-version-name
  assert_success "1.10.8"

  cat > ".helm-version" <<<"1.11.3"
  run helmenv-version-name
  assert_success "1.11.3"
}

@test "missing version" {
  HELMENV_VERSION=1.2 run helmenv-version-name
  assert_failure "helmenv: version \`1.2' is not installed (set by HELMENV_VERSION environment variable)"
}
