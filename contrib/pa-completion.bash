_pa() {
    if [[ $COMP_CWORD -ne 2 ]]; then return; fi
    case "${COMP_WORDS[1]}" in [des]*)
        names=()

        # Escape all password names so compgen doesn't break.
        while read -r name; do
            names+=("$(printf "%q\n" "$name")")
        done < <(pa list)

        mapfile -t COMPREPLY < <(compgen -W "${names[*]}" -- "${COMP_WORDS[2]}")
        ;;
    esac
}

complete -o filenames -o nospace -F _pa pa
