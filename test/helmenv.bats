#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run helmenv
  assert_failure
  assert_line 0 "$(helmenv---version)"
}

@test "invalid command" {
  run helmenv does-not-exist
  assert_failure
  assert_output "helmenv: no such command \`does-not-exist'"
}

@test "default HELMENV_ROOT" {
  HELMENV_ROOT="" HOME=/home/mislav run helmenv root
  assert_success
  assert_output "/home/mislav/.helmenv"
}

@test "inherited HELMENV_ROOT" {
  HELMENV_ROOT=/opt/helmenv run helmenv root
  assert_success
  assert_output "/opt/helmenv"
}
