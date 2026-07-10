#!/usr/bin/env bash
# check-references.sh — 检查文档路径与链接有效性
#
# 检查项：
# 1. 文档中引用的 .md 文件存在
# 2. 文档中引用的图片存在
# 3. 无残留的旧路径（plan/、spec/、source/global/）
#
# 用法：bash scripts/check-references.sh

set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0

echo "→ Check: document references and paths"

# 1. 残留旧路径（排除 _archive、CHANGELOG.md、scripts/README.md 中的示例引用）
STALE_PATHS=$(grep -rEn '\b(plan/|spec/modules|source/global/|source/prototype/|^.*requirement/05\.)' \
  --include='*.md' \
  --exclude-dir='_archive' \
  --exclude-dir='scripts' \
  --exclude='CHANGELOG.md' \
  . 2>/dev/null | grep -v '已废弃\|历史\|v[0-9]\+\.[0-9]' || true)

if [ -n "$STALE_PATHS" ]; then
  echo "❌ Found stale path references:"
  echo "$STALE_PATHS" | sed 's/^/   /'
  EXIT_CODE=1
fi

# 2. Markdown 链接有效性 — 检查 [text](path) 中的相对路径 .md 文件
BROKEN_LINKS=""
while IFS=: read -r file line; do
  # 提取 ](相对路径.md) 格式
  links=$(echo "$line" | grep -oE '\]\([^)]+\.md[^)]*\)' | sed 's/^](\([^)]*\))$/\1/' | sed 's/#.*//')
  for link in $links; do
    # 跳过绝对 URL 和锚点
    [[ "$link" =~ ^https?:// ]] && continue
    [[ -z "$link" ]] && continue

    # 解析相对路径
    dir=$(dirname "$file")
    target=$(cd "$dir" 2>/dev/null && realpath -q "$link" 2>/dev/null || echo "")
    if [ -n "$target" ] && [ ! -f "$target" ]; then
      BROKEN_LINKS="$BROKEN_LINKS\n   $file: $link"
    fi
  done
done < <(grep -rn '\](.*\.md' --include='*.md' --exclude-dir='_archive' . 2>/dev/null | head -200)

if [ -n "$BROKEN_LINKS" ]; then
  echo -e "❌ Broken markdown links:$BROKEN_LINKS"
  EXIT_CODE=1
fi

# 3. 图片路径有效性
BROKEN_IMAGES=""
while IFS=: read -r file line; do
  imgs=$(echo "$line" | grep -oE '!\[[^]]*\]\([^)]+\.(png|jpg|jpeg|webp|svg)\)' | sed 's/.*(\([^)]*\))$/\1/')
  for img in $imgs; do
    [[ "$img" =~ ^https?:// ]] && continue
    [[ "$img" =~ 页面名|5\.x- ]] && continue  # 跳过模板占位

    dir=$(dirname "$file")
    target=$(cd "$dir" 2>/dev/null && realpath -q "$img" 2>/dev/null || echo "")
    if [ -n "$target" ] && [ ! -f "$target" ]; then
      BROKEN_IMAGES="$BROKEN_IMAGES\n   $file: $img"
    fi
  done
done < <(grep -rn '!\[.*\](.*\.\(png\|jpg\|jpeg\|webp\|svg\))' --include='*.md' --exclude-dir='_archive' . 2>/dev/null)

if [ -n "$BROKEN_IMAGES" ]; then
  echo -e "❌ Broken image references:$BROKEN_IMAGES"
  EXIT_CODE=1
fi

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ References OK (no stale paths, all links/images resolve)"
fi

exit $EXIT_CODE
