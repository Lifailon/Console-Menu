#!/bin/bash
# Source: https://github.com/Lifailon/Console-Menu
# ©2023 Lifailon
# Apache License 2.0
menu=(
"Process Stats"
"Network Stats"
"Disk Stats"
"Exit"
)

# ASCII Art generated: https://patorjk.com/software/taag/#p=display&f=Ivrit&t=Console%20-%20Menu
logo=(
"   ____                      _                __  __                   "
"  / ___|___  _ __  ___  ___ | | ___          |  \/  | ___ _ __  _   _  "
" | |   / _ \| '_ \/ __|/ _ \| |/ _ \  _____  | |\/| |/ _ \ '_ \| | | | "
" | |__| (_) | | | \__ \ (_) | |  __/ |_____| | |  | |  __/ | | | |_| | "
"  \____\___/|_| |_|___/\___/|_|\___|         |_|  |_|\___|_| |_|\__,_| "
"                                                                       "
)

# Off and on cursor
tput civis
trap ctrl_c INT
function ctrl_c() {
    tput cnorm
    clear
    exit 0
}

clear
selected=0

function show-menu {
    rows=$(tput lines)
    cols=$(tput cols)
    menu_length=${#menu[@]}
    current_row=$((rows / 2 - menu_length / 2))

    # logo
    for i in "${!logo[@]}"; do
        tput cup $current_row $((cols / 2 - ${#logo[$i]} / 2))
        echo "${logo[$i]}"
        ((current_row++))
    done

    # Menu
    for i in "${!menu[@]}"; do
        if [[ $i -eq $selected ]]; then
            tput cup $current_row $((cols / 2 - ${#menu[$i]} / 2))
            echo "> ${menu[$i]}"
        else
            tput cup $current_row $((cols / 2 - ${#menu[$i]} / 2))
            echo "  ${menu[$i]}"
        fi
        ((current_row++))
    done
}

while true; do
    show-menu
    read -rsn1 key
    case $key in
        "")
            clear
            if [[ $selected -eq $(( ${#menu[@]} - 1 )) ]]; then # Exit
                tput cnorm
                break
            else
                line=${menu[$selected]}
                # Main Code
                if [ "$line" == "Process Stats" ]
                    then
                    ps=$(ps -Ao comm,user,cputime,pcpu,pmem,sz,rss,vsz,nlwp,psr,pri,ni)
                    printf "%s\n" "${ps[@]}" | head -n 1
                    printf "%s\n" "${ps[@]}" | sort -r -nk4 | head -n 20
                elif [ "$line" == "Network Stats" ]
                    then
                    ss -t
                elif [ "$line" == "Disk Stats" ]
                    then
                    lsblk -e7
                fi
                read -p "Press Enter to continue..."
            fi
            clear
        ;;
        # up
        "A"|"a")
            if [[ $selected -gt 0 ]]; then
                selected=$((selected-1))
            fi
        ;;
        "B"|"b")
         # down
            if [[ $selected -lt $(( ${#menu[@]} - 1 )) ]]; then
                selected=$((selected+1))
            fi
        ;;
    esac
done