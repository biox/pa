# password ass (pa)

A simple password manager using [age](https://github.com/FiloSottile/age) written in POSIX `sh`. Based on [pash](https://github.com/dylanaraps/pash) by [dylanaraps](https://github.com/dylanaraps).

- Automatically generates an `age` key if one is not detected.
- Written in safe and [shellcheck](https://www.shellcheck.net/) compliant POSIX `sh`.
- Only `120~` LOC (*minus blank lines and comments*).
- Configurable password generation using `/dev/urandom`.
- Guards against `set -x`, `ps` and `/proc` leakage.
- Easily extendible through the shell.
- Ability to edit passwords using `$EDITOR`

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Dependencies](#dependencies)
* [Usage](#usage)
* [FAQ](#faq)
    * [Where are passwords stored?](#where-are-passwords-stored)
    * [How do I rename an entry?](#how-do-i-rename-an-entry)
    * [How can I extend pa?](#how-can-i-extend-pa)

<!-- vim-markdown-toc -->

## Dependencies

- `age`

## Usage

```
  pa
    a simple password manager based on age

  commands:
    [a]dd  [name] - Add a password entry.
    [d]el  [name] - Delete a password entry.
    [e]dit [name] - Edit a password entry with nvim.
    [l]ist        - List all entries.
    [s]how [name] - Show password for an entry.

  env vars:
    Password length:   export PA_LENGTH=50
    Password pattern:  export PA_PATTERN=_A-Z-a-z-0-9
    Password/key dir:  export PA_DIR=~/.local/share/pa
```

Examples:

```
pa add web/gmail
pa list | grep chan
pa del facebook
pa show github
pa edit sourcehut
```

## FAQ

### How does this differ from `pass`, etc?

I was looking for a shell-based password manager that used age. Actually, see my blog post if you're really that curious:

https://j3s.sh/thought/storing-passwords-with-age.html

### Where are passwords stored?

The passwords are stored in `age` encrypted files located at `${XDG_DATA_HOME:=$HOME/.local/share}/pa}`.

### How do I change the password store location?

Set the environment variable `PA_DIR` to a directory.

```sh
# Default: '~/.local/share/pa'.
export PA_DIR=~/.local/share/pa

# This can also be used as a one-off.
PA_DIR=/mnt/drive/pa pa list
```

### How do I rename an entry?

It's a file! Standard UNIX utilities can be used here.



### How can I extend `pa`?

A shell function can be used to add new commands and functionality to `pa`. The following example adds `pa git` to execute `git` commands on the password store.

```sh
pa() {
    case $1 in
        g*)
            cd "${PA_DIR:=${XDG_DATA_HOME:=$HOME/.local/share}/pa/passwords}"
            shift
            git "$@"
        ;;

        *)
            command pa "$@"
        ;;
    esac
}
```

