function __fish_complete_pa -d 'Complete pa'
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 2; and string match -q -r $argv[1] $cmd[2]
end

complete -c pa -f
complete -c pa -n "__fish_complete_pa ^[des]" -a "(pa l)"
complete -c pa -n "__fish_complete_pa ^l" -a "(pa l | sed 's/[^/]\+\$//' | grep '/\$' | sort -u)"
