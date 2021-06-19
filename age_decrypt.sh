#!/bin/bash

priv_key=(~/.config/age/username.priv.age)

read -ep "Enter encrypted .age file > " input

if [ -f $input ] ; then
    case $input in
        *.age)  read -ep "Enter output file name > " output ;;
        *)     echo "'$input' is not a valid file" ;;

    esac

else
        echo "'$input' is not a valid file"
        exit
fi

age -d $priv_key | age -d -i - -o $output $input
