#!/bin/bash

pub_key=$(cat ~/.config/age/username.pub.age)

read -ep "Enter input file name > "  input

if [ -f $input ] ; then
    case $input in
        *.age)  echo "'$input' is not a valid file" ;;
        *)  read -ep "Enter output file name with .age extension > " output  ;;

    esac

else
        echo "'$input' is not a valid file"
        exit
fi

age -o $output -r $pub_key $input
