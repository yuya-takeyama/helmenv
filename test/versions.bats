#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

stub_system_helm() {
  local stub="${HELMENV_TEST_DIR}/bin/helm"
  mkdir -p "$(dirname "$stub")"
  touch "$stub" && chmod +x "$stub"
}

@test "no versions installed" {
  stub_system_helm
  assert [ ! -d "${HELMENV_ROOT}/versions" ]
  run helmenv-versions
  assert_success "* system (set by ${HELMENV_ROOT}/version)"
}


@test "bare output no versions installed" {
  assert [ ! -d "${HELMENV_ROOT}/versions" ]
  run helmenv-versions --bare
  assert_success ""
}

@test "single version installed" {
  stub_system_helm
  create_version "1.9"
  run helmenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${HELMENV_ROOT}/version)
  1.9
OUT
}

@test "single version bare" {
  create_version "1.9"
  run helmenv-versions --bare
  assert_success "1.9"
}

@test "multiple versions" {
  stub_system_helm
  create_version "1.10.8"
  create_version "1.11.3"
  create_version "1.13.0"
  run helmenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${HELMENV_ROOT}/version)
  1.10.8
  1.11.3
  1.13.0
OUT
}

@test "indicates current version" {
  stub_system_helm
  create_version "1.11.3"
  create_version "1.13.0"
  HELMENV_VERSION=1.11.3 run helmenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by HELMENV_VERSION environment variable)
  1.13.0
OUT
}

@test "bare doesn't indicate current version" {
  create_version "1.11.3"
  create_version "1.13.0"
  HELMENV_VERSION=1.11.3 run helmenv-versions --bare
  assert_success
  assert_output <<OUT
1.11.3
1.13.0
OUT
}

@test "globally selected version" {
  stub_system_helm
  create_version "1.11.3"
  create_version "1.13.0"
  cat > "${HELMENV_ROOT}/version" <<<"1.11.3"
  run helmenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by ${HELMENV_ROOT}/version)
  1.13.0
OUT
}

@test "per-project version" {
  stub_system_helm
  create_version "1.11.3"
  create_version "1.13.0"
  cat > ".helm-version" <<<"1.11.3"
  run helmenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.11.3 (set by ${HELMENV_TEST_DIR}/.helm-version)
  1.13.0
OUT
}

@test "ignores non-directories under versions" {
  create_version "1.9"
  touch "${HELMENV_ROOT}/versions/hello"

  run helmenv-versions --bare
  assert_success "1.9"
}

@test "lists symlinks under versions" {
  create_version "1.10.8"
  ln -s "1.10.8" "${HELMENV_ROOT}/versions/1.10"

  run helmenv-versions --bare
  assert_success
  assert_output <<OUT
1.10
1.10.8
OUT
}

@test "doesn't list symlink aliases when --skip-aliases" {
  create_version "1.10.8"
  ln -s "1.10.8" "${HELMENV_ROOT}/versions/1.10"
  mkdir moo
  ln -s "${PWD}/moo" "${HELMENV_ROOT}/versions/1.9"

  run helmenv-versions --bare --skip-aliases
  assert_success

  assert_output <<OUT
1.10.8
1.9
OUT
}
