    #!/bin/bash
     
    # My notes is a program with which you can write,
    # read, edit and synchronize notes from terminal.
     
    # You can change the folder "/Ubuntu One/notes/"
    # And the editor "vim, vi, pico, joe, whatever"
     
    # Author: TROiKAS troikas@pathfinder.gr
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with this program. If not, see <http://www.gnu.org/licenses/>.
     
    export user=$(whoami)
    my_file="/home/$user/Ubuntu One/notes/"
    editor="nano"
    IFS="`printf '\n\t'`"
    x=1
     
    lstxt() {
    Ele=()
    if [ -f ls.txt ]
    then
        rm ls.txt
    fi
     
    for i in `ls $my_file`
    do
            if [ ${i: -4} == ".not" ]; then
                    Ele=("${Ele[@]}" "$x: ${i%.*}")
                    tput sgr0
                    echo "$i" >> ls.txt
                    x=$(($x+1))
            fi
    done
     
    for value in "${Ele[@]}"; do
        printf "%-8s\n" "${value}"
    done | column
     
    x=$(($x-1))
    }
     
    start(){
            for i in `ls $my_file`
            do
                    if [ ${i: -4} == ".not" ]; then
                            x=$(($x+1))
                    fi
            done
            x=$(($x-1))
            echo -e '\E[30;46m'""
            echo "You have $x notes in: $my_file"
            echo "  <<-------------------------------->>"
            tput sgr0
            x=1
            echo -e '\E[30;43m'""
            echo "Το read a note press \"r\""
            echo "Τo write a new note press \"w\""
            echo "To edit a note press \"e\""
            echo "To delete a note press \"d\""
            echo "Το exit, press \"any other key\""
            tput sgr0
            read ans
    }
     
    start
    while true; do
    if [[ $ans == "r" ]]; then
            lstxt
            echo ""
            echo "For menu press \"m\""
            echo "Please put the number of the note you want to read \"1 to $x\" : "
            read num
            if [[ $num == "m" ]]; then
                    rm ls.txt
                    x=1
                    start
            else
                    while [ "$num" -lt "1" ] || [ "$num" -gt "$x" ] || [[ ! "$num" =~ ^[0-9]+$ ]]
                    do
                            echo "Please put a correct number between 1 and $x."
                            read num
                    done
                    line="`sed -n $num\p ls.txt`"
                    clear
                    echo "$num"\: "${line%.*}"
                    echo "  <<-------------------------------->>"
                    echo ""
                    cat "$my_file$line"
                    echo ""
                    rm ls.txt
                    x=1
                    start
            fi
     
    elif [[ $ans == "w" ]]; then
            echo""
            echo "For menu press \"m\""
            echo "Please write the title of a new note:"
            read n_title
            if [[ $n_title == "m" ]]; then
                    rm ls.txt
                    x=1
                    start
            else
                    while [ -f "$my_file$n_title.not" ]
                    do
                            echo "The $n_title exists. Give another title:"
                            read n_title
                    done
                    echo ""
                    echo "$n_title"
                    echo "  <<-------------------------------->>"
                    echo ""
                    $editor "$my_file$n_title.not"
                    cat "$my_file$n_title.not"
                    echo ""
                    start
            fi
     
    elif [[ $ans == "e" ]]; then
            lstxt
            echo ""
            echo "For menu press \"m\""
            echo "Please put the number of the note you want to edit \"1 to $x\" : "
            read num
            if [[ $num == "m" ]]; then
                    rm ls.txt
                    x=1
                    start
            else
                    while [ "$num" -lt "1" ] || [ "$num" -gt "$x" ] || [[ ! "$num" =~ ^[0-9]+$ ]]
                    do
                            echo "Please put a correct number between 1 and $x :"
                            read num
                    done
                    line="`sed -n $num\p ls.txt`"
                    clear
                    echo ""
                    echo "$num"\: "${line%.*}"
                    echo "  <<-------------------------------->>"
                    echo ""
                    $editor "$my_file$line"
                    cat "$my_file$line"
                    rm ls.txt
                    x=1
                    start
            fi
           
    elif [[ $ans == "d" ]]; then
            lstxt
            echo ""
            echo "For menu press \"m\""
            echo "Please put the number of the note you want to delete \"1 to $x\" : "
            read num
            if [[ $num == "m" ]]; then
                    rm ls.txt
                    x=1
                    start
            else
                    while [ "$num" -lt "1" ] || [ "$num" -gt "$x" ] || [[ ! "$num" =~ ^[0-9]+$ ]]
                    do
                            echo "Please put a correct number between 1 and $x :"
                            read num
                    done
                    line="`sed -n $num\p ls.txt`"
                    clear
                    echo ""
                    echo "$num"\: "${line%.*}"
                    echo "are you sure? y/n"
                    read yeno
                    while [[ x$yeno != xy && x$yeno != xn ]]
                    do
                            echo "Please y or n"
                            read yeno
                    done
                    if [[ $yeno == "y" ]]; then
                            rm "$my_file$line"
                            echo "Deleted."
                            echo ""
                            rm ls.txt
                            x=1
                            start
                    elif [[ $yeno == "n" ]]; then
                            echo ""
                            rm ls.txt
                            x=1
                            start
                    fi
            fi
           
    else
            echo "MyNotes, closed!!!"
            exit
    fi
    done

