#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
for f in "$@"; do
  # macOS: -i'' SEM espaço
  /usr/bin/perl -CSDA -Mutf8 -i'' -pe 's/≠/\\(\\neq\\)/g' "$f"
done
