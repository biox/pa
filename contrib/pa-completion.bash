_pa() {
    [[ $COMP_CWORD -ne 2 ]] && return

    names=()

    while read -r name; do names+=("${name@Q}"); done < <(case "${COMP_WORDS[1]}" in
        [des]*) pa l ;;
        l*) pa l | sed 's/[^/]\+$//' | grep '/$' | sort -u ;;
        esac)

    mapfile -t COMPREPLY < <(compgen -W "${names[*]}" -- "${COMP_WORDS[2]}")
}

complete -o filenames -F _pa pa
