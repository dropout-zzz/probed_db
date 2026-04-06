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
  'i915' 'mei_pxp' 'mei_hdcp' 'intel_gtt'
  'radeon'
)

function dropout_merge() {
  sort -k 1,1 "${dropout_files[@]}" | uniq
}

function dropout_filter() {
  echo "${dropout_ignores[*]}" | sed -e 's/^/^(/' -e 's/ /|/g' -e 's/$/)$/'
}

if [ "${#dropout_files}" -eq 0 ]; then
  echo "E: empty file list in script" >&2
  exit 1
fi

dropout_merge | grep -Ev "$(dropout_filter)" > merged.txt

if [ "${#dropout_ignores}" -ne 0 ]; then
  echo "W: excluding the following modules: ${dropout_ignores[*]}" >&2
fi
