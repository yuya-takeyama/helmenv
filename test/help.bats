#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run helmenv-help
  assert_success
  assert_line "Usage: helmenv <command> [<args>]"
  assert_line "Some useful helmenv commands are:"
}

@test "invalid command" {
  run helmenv-help hello
  assert_failure "helmenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${HELMENV_TEST_DIR}/bin"
  cat > "${HELMENV_TEST_DIR}/bin/helmenv-hello" <<SH
#!shebang
# Usage: helmenv hello <world>
# Summary: Says "hello" to you, from helmenv
# This command is useful for saying hello.
echo hello
SH

  run helmenv-help hello
  assert_success
  assert_output <<SH
Usage: helmenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${HELMENV_TEST_DIR}/bin"
  cat > "${HELMENV_TEST_DIR}/bin/helmenv-hello" <<SH
#!shebang
# Usage: helmenv hello <world>
# Summary: Says "hello" to you, from helmenv
echo hello
SH

  run helmenv-help hello
  assert_success
  assert_output <<SH
Usage: helmenv hello <world>

Says "hello" to you, from helmenv
SH
}

@test "extracts only usage" {
  mkdir -p "${HELMENV_TEST_DIR}/bin"
  cat > "${HELMENV_TEST_DIR}/bin/helmenv-hello" <<SH
#!shebang
# Usage: helmenv hello <world>
# Summary: Says "hello" to you, from helmenv
# This extended help won't be shown.
echo hello
SH

  run helmenv-help --usage hello
  assert_success "Usage: helmenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${HELMENV_TEST_DIR}/bin"
  cat > "${HELMENV_TEST_DIR}/bin/helmenv-hello" <<SH
#!shebang
# Usage: helmenv hello <world>
#        helmenv hi [everybody]
#        helmenv hola --translate
# Summary: Says "hello" to you, from helmenv
# Help text.
echo hello
SH

  run helmenv-help hello
  assert_success
  assert_output <<SH
Usage: helmenv hello <world>
       helmenv hi [everybody]
       helmenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${HELMENV_TEST_DIR}/bin"
  cat > "${HELMENV_TEST_DIR}/bin/helmenv-hello" <<SH
#!shebang
# Usage: helmenv hello <world>
# Summary: Says "hello" to you, from helmenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run helmenv-help hello
  assert_success
  assert_output <<SH
Usage: helmenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
