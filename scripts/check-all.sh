#!/usr/bin/env bash
# check-all.sh — 一键运行所有文档检查
#
# 用法：bash scripts/check-all.sh

cd "$(dirname "$0")/.."

FAILED=0
SCRIPTS=(
  "check-traceability.sh"
  "check-numbering.sh"
  "check-references.sh"
  "check-tables.sh"
  "check-stats.sh"
  "check-ac-coverage.sh"
)

echo "============================================"
echo "  Engineer Online — Doc Lint"
echo "============================================"

for script in "${SCRIPTS[@]}"; do
  echo ""
  if ! bash "scripts/$script"; then
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo "============================================"
if [ $FAILED -eq 0 ]; then
  echo "  ✅ All ${#SCRIPTS[@]} checks passed"
  echo "============================================"
  exit 0
else
  echo "  ❌ $FAILED / ${#SCRIPTS[@]} checks failed"
  echo "============================================"
  exit 1
fi
