#shellcheck shell=sh

Describe "pa"
  It "runs without parameters"
    When run script pa
    The output should include "a simple password manager"
    The status should be success
  End

  Describe "when started with an empty XDG_DATA_HOME"
    setup() {
      test_dir="$(mktemp -d)"
      old_xdg_data_home="${XDG_DATA_HOME:-}"
      export XDG_DATA_HOME="$test_dir"
    }

    teardown() {
      [ -n "$test_dir" ] && rm -rf "$test_dir"      
      XDG_DATA_HOME="$old_xdg_data_home"
    }

    git_commit_messages() {
      (cd "$test_dir/pa/passwords" && git log --pretty=format:"%s")
    }

    Before "setup"
    After "teardown"

    It "creates an identity"
      When run script pa list
      The path "$test_dir/pa/identities" should be a file
    End

    It "sets up git"
      When run script pa list
      The result of function git_commit_messages should equal "initial commit"
    End

    It "lists no passwords"
      When run script pa list
      The output should equal ""
      The status should be success
    End

    It "can add an auto-generated password"
      Data "y"
      When run script pa add nested/category/account
      The output should include "Saved 'nested/category/account' to the store."
      The path "$test_dir/pa/passwords/nested/category/account.age" should be a file
      The line 1 of result of function git_commit_messages should equal "add 'nested/category/account'"
      The line 2 of result of function git_commit_messages should equal "initial commit"
    End

    It "respects the PA_LENGTH variable"
      echo "y" | PA_LENGTH=27 ./pa add custom-length >/dev/null
      When run script pa show custom-length
      The length of output should equal 27
    End

    It "can add a custom password"
      (echo "nfoo"; echo "foo") | ./pa add custom-password >/dev/null
      When run script pa show custom-password
      The output should equal "foo"
    End

    It "checks password equality"
      Data
        #|nmy-secret-password
        #|my-wrong-password
      End
      When run script pa add custom-password
      The error should equal "pa: Passwords don't match."
      The result of function git_commit_messages should equal "initial commit"
    End

    It "lists all passwords"
      echo "y" | pa add category/first > /dev/null
      echo "y" | pa add category/second > /dev/null
      echo "y" | pa add empty/temp > /dev/null
      echo "y" | pa add other/third > /dev/null
      echo "y" | pa del empty/temp > /dev/null

      When run script pa list
      The first line of output should equal "category/first"
      The second line of output should equal "category/second"
      The third line of output should equal "other/third"
      The lines of output should equal 3
    End

    It "can edit a password"
      (echo "noriginal"; echo "original") | ./pa add editable-password >/dev/null
      export EDITOR="sed -i -e s/original/edited/"
      When run script pa edit editable-password
      The status should be success
      unset EDITOR

      show() { pa show editable-password; }
      The result of function show should equal "edited"
    End

    It "creates a password when editing a non-existing account"
      export EDITOR="tee"
      Data "from-tee"
      When run script pa edit some/category/new-password
      The status should be success
      unset EDITOR

      show() { pa show some/category/new-password; }
      The result of function show should equal "from-tee"
    End
  End
End