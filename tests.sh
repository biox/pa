#!/bin/sh
#
# Run all the tests in the tests.d folder

set -eu

CDPATH="" cd -- "$(dirname -- "$0")"

die() {
    printf '%s: %s.\n' "$(basename "$0")" "$1" >&2
    exit 1
}

num_tests="$(find tests.d -name "*.sh" | wc -l)"
echo "1..$num_tests"
current_test=0
passes=0
failures=0

for test_file in tests.d/*.sh; do
    current_test=$((current_test + 1))
    if sh "$test_file"; then
        echo "ok $current_test - $(basename "$test_file")"
        passes=$((passes + 1))
    else
        echo "not ok $current_test - $(basename "$test_file")"
        failures=$((failures + 1))
    fi
done

echo "Completed $num_tests tests. $passes passes, $failures failures."

# Exit status is zero if there are no failures
[ "$failures" -eq 0 ]