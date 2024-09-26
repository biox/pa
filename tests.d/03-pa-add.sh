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
echo "y" | sh pa add nested/category/account > "$test_dir/pa-add.stdout"
grep -q "Saved 'nested/category/account' to the store." \
    "$test_dir/pa-add.stdout" ||
    die "pa add should say it stored the password"
[ -s "$test_dir/pa/passwords/nested/category/account.age" ] ||
    die "pa add should create an encrypted password file"
cd "$test_dir/pa/passwords" && git log --pretty=format:"%s" \
    > "$test_dir/pa-add-git.actual"
(
    echo "add 'nested/category/account'"
    printf "initial commit"
) > "$test_dir/pa-add-git.expected"
cmp "$test_dir/pa-add-git.actual" "$test_dir/pa-add-git.expected" ||
    die "pa add should create the expected git log"
teardown
