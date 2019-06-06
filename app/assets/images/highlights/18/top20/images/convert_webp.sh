#!/bin/bash
# First arg is cweb executable
# Second arg is folder
for filename in $2
do
  eval "$1" -q 80 "$filename" -o "$filename.webp"
done
