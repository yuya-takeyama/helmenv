#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMENV_TEST_DIR"
  cd "$HELMENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  echo "system" > "$1"
}

@test "detects global 'version' file" {
  create_file "${HELMENV_ROOT}/version"
  run helmenv-version-file
  assert_success "${HELMENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${HELMENV_ROOT}/version" ]
  assert [ ! -e ".helm-version" ]
  run helmenv-version-file
  assert_success "${HELMENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".helm-version"
  run helmenv-version-file
  assert_success "${HELMENV_TEST_DIR}/.helm-version"
}

@test "in parent directory" {
  create_file ".helm-version"
  mkdir -p project
  cd project
  run helmenv-version-file
  assert_success "${HELMENV_TEST_DIR}/.helm-version"
}

@test "topmost file has precedence" {
  create_file ".helm-version"
  create_file "project/.helm-version"
  cd project
  run helmenv-version-file
  assert_success "${HELMENV_TEST_DIR}/project/.helm-version"
}

@test "HELMENV_DIR has precedence over PWD" {
  create_file "widget/.helm-version"
  create_file "project/.helm-version"
  cd project
  HELMENV_DIR="${HELMENV_TEST_DIR}/widget" run helmenv-version-file
  assert_success "${HELMENV_TEST_DIR}/widget/.helm-version"
}

@test "PWD is searched if HELMENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.helm-version"
  cd project
  HELMENV_DIR="${HELMENV_TEST_DIR}/widget/blank" run helmenv-version-file
  assert_success "${HELMENV_TEST_DIR}/project/.helm-version"
}

@test "finds version file in target directory" {
  create_file "project/.helm-version"
  run helmenv-version-file "${PWD}/project"
  assert_success "${HELMENV_TEST_DIR}/project/.helm-version"
}

@test "fails when no version file in target directory" {
  run helmenv-version-file "$PWD"
  assert_failure ""
}
