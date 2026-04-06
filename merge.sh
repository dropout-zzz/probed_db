#!/bin/bash

dropout_files=(
  'archbroot2.txt'
  'archmba9.txt'
)

sort -k 1,1 "${dropout_files[@]}" | uniq > merged.txt
