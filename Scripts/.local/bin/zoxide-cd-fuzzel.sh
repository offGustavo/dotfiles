#!/bin/bash 


selected=$(zoxide query -l -s | fuzzel -d)
selected=$(echo "$selected" | awk '{print $2}')

cd $selected
