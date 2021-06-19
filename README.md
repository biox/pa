I will be updating this later.  

This is forked from https://github.com/biox/pa and this user gets all the credit.  I am just a ham fisted knucklehead and have never claimed to be a developer.

Also, this has nothing to do with `passage` https://github.com/stchris/passage which appears to be archived.

I've been a user of Pass (www.passwordstore.org) and have been using, along with following Age for a long time.  I've been waiting for Age and Pass to get together at some time, so when I saw `pa` as a pass/age hybrid, figured I'd mess around with it.  

Changes thus far for my usage are: using `.passage` for storage, I use `~/.config/age` to store my keypairs, since MacOS doesn't use `/dev/shm` I added a random `/tmp` directory using OpenSSL, and `age-keygen` is a password protected file.



Will update this laster.


# passage

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

Examples: `pa add web/gmail`, `pa list`, `pa del facebook`, `pa show github`, `pa edit sourcehut`.

```
USAGE

pa 0.1.0 - age-based password manager
=> [a]dd  [name] - Create a new password, randomly generated
=> [d]el  [name] - Delete a password entry.
=> [e]dit [name] - Edit a password entry with vim.
=> [l]ist        - List all entries.
=> [s]how [name] - Show password for an entry.
Password length:   export PA_LENGTH=50
Password pattern:  export PA_PATTERN=_A-Z-a-z-0-9
Store location:    export PA_DIR=~/.local/share/pa
```

## FAQ

### How does this differ from `pass` or etc?

I was looking for a shell-based password manager that used age. Actually, see my blog post if you're really that curious:

https://j3s.sh/thoughts/storing-passwords-with-age.html

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
            cd "${PA_DIR:=${XDG_DATA_HOME:=$HOME/.local/share}/pa}"
            shift
            git "$@"
        ;;

        *)
            command pa "$@"
        ;;
    esac
}
```

