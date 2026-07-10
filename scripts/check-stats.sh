#!/usr/bin/env bash
# check-stats.sh — 验证需求总览 front matter 统计数字是否与实际一致
#
# 用法：bash scripts/check-stats.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0
OVERVIEW="requirement/00-需求总览.md"
MODULES_DIR="requirement/modules"

echo "→ Check: stats vs actual counts"

# 实际统计
ACTUAL_BR=$(grep -rhoE '\*\*BR-[0-9]+\.[0-9]+-[0-9]+\*\*' "$MODULES_DIR" 2>/dev/null | grep -oE 'BR-[0-9]+\.[0-9]+-[0-9]+' | sort -u | wc -l | tr -d ' ')
ACTUAL_EX=$(grep -rhoE 'EX-[0-9]+\.[0-9]+-[0-9]+' "$MODULES_DIR" 2>/dev/null | sort -u | wc -l | tr -d ' ')
ACTUAL_AC=$(grep -rhoE 'AC-[0-9]+\.[0-9]+-[0-9]+' "$MODULES_DIR" 2>/dev/null | sort -u | wc -l | tr -d ' ')
ACTUAL_MODULES=$(ls "$MODULES_DIR"/05.*.md 2>/dev/null | wc -l | tr -d ' ')

# front matter 中声明的数字
README_MODULES=$(grep -oE 'module_count: [0-9]+' "$OVERVIEW" | grep -oE '[0-9]+' || echo "N/A")
README_BR=$(grep -oE 'br_count: [0-9]+' "$OVERVIEW" | grep -oE '[0-9]+' || echo "N/A")
README_EX=$(grep -oE 'ex_count: [0-9]+' "$OVERVIEW" | grep -oE '[0-9]+' || echo "N/A")
README_AC=$(grep -oE 'ac_count: [0-9]+' "$OVERVIEW" | grep -oE '[0-9]+' || echo "N/A")

check_stat() {
  local name="$1" actual="$2" readme="$3"
  if [ "$readme" = "N/A" ]; then
    echo "   ⚠ $name: not found in front matter, actual=$actual"
  elif [ "$actual" != "$readme" ]; then
    echo "❌ $name: front_matter=$readme, actual=$actual"
    EXIT_CODE=1
  else
    echo "   ✓ $name: $actual"
  fi
}

check_stat "功能模块数" "$ACTUAL_MODULES" "$README_MODULES"
check_stat "业务规则 BR" "$ACTUAL_BR" "$README_BR"
check_stat "异常处理 EX" "$ACTUAL_EX" "$README_EX"
check_stat "验收标准 AC" "$ACTUAL_AC" "$README_AC"

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ Stats check passed"
fi

exit $EXIT_CODE
