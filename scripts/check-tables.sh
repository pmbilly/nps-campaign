#!/usr/bin/env bash
# check-tables.sh — 检查 Markdown 表格前是否有空行（Obsidian 渲染要求）
#
# 用法：bash scripts/check-tables.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0

echo "→ Check: Markdown tables with missing blank lines"

ISSUES=""
while IFS= read -r file; do
  out=$(awk '
    NR > 1 && /^\|/ && prev != "" && prev !~ /^\|/ && prev !~ /^$/ && prev !~ /^---/ && prev !~ /^>/ {
      print FILENAME ":" NR ": prev line not blank: " prev
    }
    { prev = $0 }
  ' "$file" 2>/dev/null)

  if [ -n "$out" ]; then
    ISSUES="$ISSUES\n$out"
  fi
done < <(find . -name '*.md' -not -path './_archive/*' -not -path './.obsidian/*' -not -path './.claude/*')

if [ -n "$ISSUES" ]; then
  echo -e "❌ Tables missing blank line before them:$ISSUES"
  EXIT_CODE=1
else
  echo "✅ All tables correctly formatted"
fi

exit $EXIT_CODE
