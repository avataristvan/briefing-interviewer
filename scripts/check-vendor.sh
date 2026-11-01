#!/usr/bin/env bash
# Checks that the vendored Pocock copy is intact and embedded verbatim in the core skill.
# Exit: 0 ok, 1 block differs, 2 marker block missing, 3 vendored file checksum mismatch.
set -euo pipefail

root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
vendored="$root/vendor/mattpocock-skills/grilling/SKILL.md"
meta="$root/vendor/mattpocock-skills/VENDORED.md"
core="$root/skills/interviewing/SKILL.md"

if [ ! -f "$vendored" ] || [ ! -f "$meta" ]; then
  echo "vendored file or VENDORED.md missing" >&2
  exit 2
fi

expected=$(sed -n 's/^sha256: \([0-9a-f]\{64\}\)$/\1/p' "$meta" | head -n1)
actual=$(sha256sum "$vendored" | cut -d' ' -f1)
if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
  echo "checksum mismatch: VENDORED.md='${expected:-<missing>}' file='$actual'" >&2
  exit 3
fi

if [ ! -f "$core" ] \
  || [ "$(grep -c '^<!-- BEGIN VENDORED:' "$core")" -ne 1 ] \
  || [ "$(grep -c -x '<!-- END VENDORED -->' "$core")" -ne 1 ]; then
  echo "marker block missing" >&2
  exit 2
fi

# strip leading/trailing blank lines (a trailing newline is added back by awk)
normalise() {
  awk 'NF { started = 1 } started { buf[++n] = $0; if (NF) last = n } END { for (i = 1; i <= last; i++) print buf[i] }'
}

body=$(awk 'seen >= 2 { print } $0 == "---" && seen < 2 { seen++ }' "$vendored" | normalise)
block=$(awk '/^<!-- END VENDORED -->$/ { on = 0 } on { print } /^<!-- BEGIN VENDORED:/ { on = 1 }' "$core" | normalise)

if diff <(printf '%s\n' "$body") <(printf '%s\n' "$block"); then
  echo "vendor block matches"
else
  exit 1
fi
