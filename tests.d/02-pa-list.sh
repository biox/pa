#!/bin/sh

set -eu

CDPATH="" cd -- "$(dirname -- "$0")/.."

die() {
    printf '%s: %s.\n' "$(basename "$0")" "$1" >&2
    exit 1
}

setup() {
    test_dir="$(mktemp -d)"
    old_xdg_data_home="${XDG_DATA_HOME:-}"
    export XDG_DATA_HOME="$test_dir"
}

teardown() {
    [ -n "$test_dir" ] && rm -rf "$test_dir"      
    XDG_DATA_HOME="$old_xdg_data_home"
}

setup
sh pa list || die "pa list should return success"
[ -s "$test_dir/pa/identities" ] ||
    die "pa list should create an identity"
git_msg="$(cd "$test_dir/pa/passwords" && git log --pretty=format:"%s")"
[ "$git_msg" = "initial commit" ] || die "pa list should set up git"
teardown

setup
output="$(sh pa list)"
[ -z "$output" ] || die "pa list output should be empty"
teardown
