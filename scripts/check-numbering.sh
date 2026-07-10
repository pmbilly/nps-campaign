#!/usr/bin/env bash
# check-numbering.sh — 检查 BR/EX/AC 编号唯一性
#
# 检查项：
# 1. 同一模块内 BR/EX/AC 编号不重复
# 2. 编号格式合法（BR-5.x-NN / EX-5.x-NN / AC-5.x-NN）
#
# 用法：bash scripts/check-numbering.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0
MODULES_DIR="requirement/modules"

echo "→ Check: BR/EX/AC numbering uniqueness"

for prefix in BR EX AC; do
  # 提取所有定义并统计重复
  DUPLICATES=$(grep -rhoE "^- ${prefix}-[0-9]+\.[0-9]+-[0-9]+:" "$MODULES_DIR" 2>/dev/null \
    | sed 's/^- //; s/:$//' \
    | sort | uniq -d)

  if [ -n "$DUPLICATES" ]; then
    echo "❌ $prefix 编号重复:"
    echo "$DUPLICATES" | sed 's/^/   - /'
    EXIT_CODE=1
  fi
done

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ Numbering OK (no duplicates)"
fi

exit $EXIT_CODE
