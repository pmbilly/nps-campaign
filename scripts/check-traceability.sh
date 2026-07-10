#!/usr/bin/env bash
# check-traceability.sh — 检查 BR 定义与追溯矩阵是否一致
#
# 检查项：
# 1. 每个模块 PRD 中定义的 BR 都在 tasks/追溯矩阵.csv 中出现
# 2. 追溯矩阵引用的 BR 都有对应的定义
# 3. 已废弃的 BR（有"已废弃"说明）不报错
#
# 用法：bash scripts/check-traceability.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0
MODULES_DIR="requirement/modules"
TRACE_FILE="tasks/追溯矩阵.csv"

echo "→ Check: BR definitions vs traceability matrix"

# 提取模块中定义的 BR（格式: - BR-5.x-NN:）
DEFINED_BRS=$(grep -rhoE 'BR-[0-9]+\.[0-9]+-[0-9]+' "$MODULES_DIR" 2>/dev/null | sort -u)

# 提取追溯矩阵引用的 BR（CSV 第一列，跳过注释和表头）
REFERENCED_BRS=$(awk -F',' '!/^#/ && NR>1 && $2 ~ /^BR-/ {print $2}' "$TRACE_FILE" | sort -u)

# 提取已声明废弃的 BR（CSV 注释行中的编号）
DEPRECATED_BRS=$(grep '^#.*已废弃' "$TRACE_FILE" | grep -oE 'BR-[0-9]+\.[0-9]+-[0-9]+' | sort -u)

# 1. 定义但未追溯的 BR
MISSING_IN_TRACE=$(comm -23 <(echo "$DEFINED_BRS") <(echo "$REFERENCED_BRS"))
if [ -n "$MISSING_IN_TRACE" ]; then
  echo "❌ BR 已定义但未在追溯矩阵中:"
  echo "$MISSING_IN_TRACE" | sed 's/^/   - /'
  EXIT_CODE=1
fi

# 2. 追溯矩阵引用了不存在的 BR（除非在已废弃列表中）
ORPHAN_REFS=$(comm -13 <(echo "$DEFINED_BRS") <(echo "$REFERENCED_BRS"))
if [ -n "$ORPHAN_REFS" ]; then
  REAL_ORPHANS=$(comm -23 <(echo "$ORPHAN_REFS") <(echo "$DEPRECATED_BRS"))
  if [ -n "$REAL_ORPHANS" ]; then
    echo "❌ 追溯矩阵引用了不存在的 BR（且未标注已废弃）:"
    echo "$REAL_ORPHANS" | sed 's/^/   - /'
    EXIT_CODE=1
  fi
fi

if [ $EXIT_CODE -eq 0 ]; then
  DEF_COUNT=$(echo "$DEFINED_BRS" | wc -l | tr -d ' ')
  REF_COUNT=$(echo "$REFERENCED_BRS" | wc -l | tr -d ' ')
  echo "✅ Traceability OK ($DEF_COUNT BRs defined, $REF_COUNT referenced)"
fi

exit $EXIT_CODE
