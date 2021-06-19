
## Will update this laster.


# passage - age based password/secrets manager

A simple password manager using [age](https://github.com/FiloSottile/age) written in POSIX `bash`. Based on [pash](https://github.com/dylanaraps/pash) by [dylanaraps](https://github.com/dylanaraps). I forked this project from [pa] https://github.com/biox/pa by [biox](https://github.com/biox/).  Also, this has nothing to do with [passage] https://github.com/stchris/passage which was based on Rust and that project appears to be archived.

- Automatically generates an `age` key if one is not detected.
- Written in safe and [shellcheck](https://www.shellcheck.net/) compliant POSIX `bashsh`.
- Only `120~` LOC (*minus blank lines and comments*).
- Configurable password generation using `/dev/urandom`.
- Guards against `set -x`, `ps` and `/proc` leakage.
- Easily extendible through the shell.
- Ability to edit passwords using `$EDITOR`

I am just a ham fisted knucklehead and have never claimed to be a developer.  I have been a long time user of [pass](www.passwordstore.org) and have been following [age](https://github.com/FiloSottile/age) for quite some time.  I have been waiting for Age and Pass to get together at some point, so when I saw `pa` as a pass+age type password manager, figured I would mess around with it for my own purposes.

Changes thus far for my usage are: using `.passage` for storage, I use `~/.config/age` to store my keypairs since they are synced via my personal git repo across multiple machines and `age-keygen` is a password protected file because I do not want to sync my keypairs in plain text, since MacOS does not use `/dev/shm` I added a random `/tmp` directory using OpenSSL, and I am using `pbcopy` since I run MacOS.

I'm also throwing in a few scripts that I have used in the past for age encryption and decryption, as I have integrated `age` into my day to day usage.  The gist can be seen here also -> https://gist.github.com/chrisswanda/bc537f87df7ab958773b3dab2d8f1f44

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Dependencies](#dependencies)
* [Usage](#usage)
* [FAQ](#faq)
    * [Where are passwords stored?](#where-are-passwords-stored)
    * [How do I rename an entry?](#how-do-i-rename-an-entry)
    * [How can I extend passage?](#how-can-i-extend-passage)

<!-- vim-markdown-toc -->

## Dependencies

- `age`
- `age-keygen`

## Usage

Examples: `passage add web/gmail`, `passage list`, `passage del facebook`, `passage show github`, `passage edit sourcehut`, `passage git pull/push/status`.

```
USAGE

passage 0.0.1 - age-based password manager
- show [name]    - Show password for an entry.
- copy [name]    - Copy password to clipboard. Clears in 30 seconds.
- list           - List all entries.
- tree           - List all entries in a tree.
- add  [name]    - Create a new password, randomly generated.
- edit [name]    - Edit a password entry with vim.
- del  [name]    - Delete a password entry.
- git  [command] - push, pull, status
```

## FAQ

### Where are passwords stored?

The passwords are stored in `age` encrypted files located at `${XDG_DATA_HOME:=$HOME/}.passage}`.

### How do I change the password store location?

Set the environment variable `PASSAGE_DIR` to a directory.

```sh
# Default: '~/.passage'.
export PASSAGE_DIR=~/.passage

```
Or you can set it to whatever directory you want:
```sh
export PA_DIR=~/.local/some_other_dir
```

### Any other environment variables?

```sh
You can change the password length
# Password length:   export PA_LENGTH=21

And you can set your password characters
# Password pattern:  export PA_PATTERN=_A-Z-a-z-0-9
```

### How do I rename an entry?

You can just drop into your $PASSAGE_DIR, and merely just rename the file.  `mv test_file.age new_test_file.age`

### How can I extend `passage`?

A shell function can be used to add new commands and functionality to `passage`. The following example adds `passage git` to execute `git` commands on the password store.

```sh
passage() {
    case $1 in
        g*)
            cd "${PASSAGE_DIR:=${XDG_DATA_HOME:=$HOME/}.passage}"
            shift
            git "$@"
        ;;

        *)
            command passage "$@"
        ;;
    esac
}
```

