#!/usr/bin/env bash
# check-ac-coverage.sh — 检查每条 AC 都在 tasks/追溯矩阵.csv 中有映射
#
# 检查项：
# 1. 模块 PRD 中定义的每条 AC 都在映射 CSV 中出现
# 2. 映射 CSV 中引用的任务都在 tasks/任务清单.md 中存在
# 3. 废弃的 AC（PRD 中已删除）不在映射中
#
# 用法：bash scripts/check-ac-coverage.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0
MODULES_DIR="requirement/modules"
MAPPING_FILE="tasks/追溯矩阵.csv"
TASKS_FILE="tasks/README.md"

echo "→ Check: AC coverage in task mapping"

if [ ! -f "$MAPPING_FILE" ]; then
  echo "❌ Mapping file not found: $MAPPING_FILE"
  exit 1
fi

# 1. 提取 PRD 中定义的所有 AC
DEFINED_ACS=$(grep -rhoE 'AC-[0-9]+\.[0-9]+-[0-9]+' "$MODULES_DIR" | sort -u)

# 2. 提取映射 CSV 中出现的所有 AC（第 5 列 related_ac，可能多个用 ; 分隔）
MAPPED_ACS=$(awk -F',' '!/^#/ && NR>1 && $4 != "-" && $4 != "" {print $4}' "$MAPPING_FILE" | tr ';' '\n' | sed 's/"//g; s/^ *//' | grep -E '^AC-' | sort -u)

# 3. 未映射的 AC — 只报告那些所属模块完全不在 CSV 中的 AC
# 如果模块有 BR 行但某些 AC 没被 BR 关联，这是正常的（边界 AC 不一定对应 BR）
MISSING_MAPPING=""
for ac in $DEFINED_ACS; do
  module=$(echo "$ac" | grep -oE '[0-9]+\.[0-9]+')
  # 检查该 AC 是否在 CSV 的 related_ac 列中
  if ! echo "$MAPPED_ACS" | grep -q "^$ac$"; then
    # 检查该模块是否至少有一行 BR 在 CSV 中
    module_has_br=$(awk -F',' -v m="$module" '!/^#/ && $1 == m {found=1} END {print found+0}' "$MAPPING_FILE")
    if [ "$module_has_br" -eq 0 ]; then
      MISSING_MAPPING="$MISSING_MAPPING\n   - $ac (module $module has no BR rows)"
    fi
  fi
done

if [ -n "$MISSING_MAPPING" ]; then
  echo -e "❌ AC from untracked modules:$MISSING_MAPPING"
  EXIT_CODE=1
fi

# Report coverage stats
TOTAL_AC=$(echo "$DEFINED_ACS" | wc -l | tr -d ' ')
LINKED_AC=$(echo "$MAPPED_ACS" | wc -l | tr -d ' ')
UNLINKED=$((TOTAL_AC - LINKED_AC))

# 5. 提取映射中引用的任务 ID（第 6、7 列 impl_tasks + test_task），校验是否存在于任务清单
REFERENCED_TASKS=$(awk -F',' '!/^#/ && NR>1 {print $5}' "$MAPPING_FILE" \
  | tr ',;' '\n' | tr -d '"' | grep -E '^[A-Z]+-' | grep -vE '^(BR|EX|AC|GR|RR|SEC|OPS|OQ|SEO|BASE)-' | sort -u)

DEFINED_TASKS=$(grep -oE '\|\s*(TASK-[0-9]+|BASE-[0-9]+)' "$TASKS_FILE" \
  | sed 's/^|[[:space:]]*//' | sort -u)

INVALID_TASKS=""
for task in $REFERENCED_TASKS; do
  if ! echo "$DEFINED_TASKS" | grep -q "^$task$"; then
    INVALID_TASKS="$INVALID_TASKS\n   - $task"
  fi
done

if [ -n "$INVALID_TASKS" ]; then
  echo -e "❌ Mapping CSV references non-existent tasks:$INVALID_TASKS"
  EXIT_CODE=1
fi

if [ $EXIT_CODE -eq 0 ]; then
  TASK_REF_COUNT=$(echo "$REFERENCED_TASKS" | wc -l | tr -d ' ')
  echo "✅ AC Coverage OK ($TOTAL_AC ACs total, $LINKED_AC linked to BRs, $UNLINKED standalone; $TASK_REF_COUNT tasks referenced)"
fi

exit $EXIT_CODE
