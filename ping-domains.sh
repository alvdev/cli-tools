#!/bin/bash

file="domains.txt"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

if [[ -s "$file" ]]; then
    echo
    echo "# Domain's file is: $file"
    echo
    echo "# $file contains the next domains: "
    echo
    while read -r domain; do
        echo "- $domain"
    done < $file

    echo
    read -rp "Add more domains separated by whitespace: " domains

    # $domains is stored as a string between "" instead as an array
    for domain in $domains; do
        [[ -n "$domain" ]] && echo "$domain" >> "$file"
    done
fi

if [[ ! -s "$file" ]]; then
    echo
    echo "# $file doesn't exist"
    echo
    read -rp "Add domains to ping separated by whitespaces: " domains

    [[ -z $domains ]] && echo && printf "%b" "${RED}No domains to ping${NC}" && echo && exit

    for domain in $domains; do
        echo "$domain" >> $file
    done
fi

echo
echo "# Pinging domains..."
echo

while read -r domain; do
    if ping -c2 -q "$domain" &> /dev/null; then
        printf "%-25s %b" "- ${domain}" "${GREEN}UP${NC}\n"
    else
        printf "%-25s %b" "- $domain" "${RED}DOWN${NC}\n"
    fi
done < $file
