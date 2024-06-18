function __fish_complete_pa_name -d 'Complete pa password names'
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 2; and string match -q -r '^[des]' $cmd[2]
end

complete -c pa -f
complete -c pa -n "__fish_complete_pa_name" -a "(pa list)"
