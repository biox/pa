#!/bin/sh

set -eu

CDPATH="" cd -- "$(dirname -- "$0")/.."

die() {
    printf '%s: %s.\n' "$(basename "$0")" "$1" >&2
    exit 1
}

sh pa | grep -q "a simple password manager" ||
    die "pa should print a welcome message"