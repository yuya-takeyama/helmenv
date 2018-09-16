#!/usr/bin/env bats

load test_helper

@test "default" {
  run helmenv-global
  assert_success
  assert_output "system"
}

@test "read HELMENV_ROOT/version" {
  mkdir -p "$HELMENV_ROOT"
  echo "1.2.3" > "$HELMENV_ROOT/version"
  run helmenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set HELMENV_ROOT/version" {
  mkdir -p "$HELMENV_ROOT/versions/1.2.3/bin"
  run helmenv-global "1.2.3"
  assert_success
  run helmenv-global
  assert_success "1.2.3"
}

@test "fail setting invalid HELMENV_ROOT/version" {
  mkdir -p "$HELMENV_ROOT"
  run helmenv-global "1.2.3"
  assert_failure "helmenv: version \`1.2.3' is not installed"
}
