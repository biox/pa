_pa() {
    [[ $COMP_CWORD -eq 2 ]] && case "${COMP_WORDS[1]}" in [des]*)
        names=()

        # Escape all password names so compgen doesn't break.
        while read -r name; do names+=("${name@Q}"); done < <(pa l)

        mapfile -t COMPREPLY < <(compgen -W "${names[*]}" -- "${COMP_WORDS[2]}")
        ;;
    esac
}

complete -o filenames -F _pa pa
