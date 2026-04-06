#!/bin/bash

set -e
set -o pipefail

dropout_files=(
  'archbroot2.txt'
  'archmba9.txt'
)

# FIXME: per-machine blacklist
dropout_ignores=(
  'ac97_bus'
  'snd_pcm_dmaengine'
)

function dropout_merge() {
  sort -k 1,1 "${dropout_files[@]}" | uniq
}

function dropout_filter() {
  echo "${dropout_ignores[*]}" | sed -e 's/^/^(/' -e 's/ /|/g' -e 's/$/)$/'
}

dropout_merge | grep -Ev "$(dropout_filter)" > merged.txt

echo "W: excluding the following modules: ${dropout_ignores[*]}" >&2
