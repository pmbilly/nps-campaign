# Doc Lint 脚本集

> 用途：自动检查文档一致性，防止追溯矩阵脏数据、编号串号、路径失效等维护性问题。

## 快速使用

```bash
# 一键运行全部检查
bash scripts/check-all.sh
```

## 单项检查

| 脚本 | 检查内容 | 触发报错的例子 |
|---|---|---|
| `check-traceability.sh` | BR 定义与追溯矩阵一致 | 新增 BR-5.4-21 但没加到追溯矩阵 |
| `check-numbering.sh` | BR/EX/AC 编号唯一性 | 同一模块出现两个 BR-5.4-01 |
| `check-references.sh` | 路径与链接有效 | 文档里写了 `plan/` 或死链图片 |
| `check-tables.sh` | 表格前有空行（Obsidian 渲染） | `**样式**:` 后紧跟 `\|` 表格 |
| `check-stats.sh` | README 项目统计数字准确 | README 写 76 条 BR，实际 88 条 |
| `check-ac-coverage.sh` | 每条 AC 在 `tasks/追溯矩阵.csv` 中有映射，且引用的任务都存在 | 新增 AC 但忘记加到追溯矩阵 |

## 工作流集成

### 本地开发

改完文档后手动跑：
```bash
bash scripts/check-all.sh
```

### Git pre-commit Hook（可选）

创建 `.git/hooks/pre-commit`：
```bash
#!/bin/sh
bash scripts/check-all.sh || exit 1
```
然后 `chmod +x .git/hooks/pre-commit`。每次 `git commit` 前自动运行。

### GitHub Actions

已配置 `.github/workflows/doc-lint.yml`，推送到 GitHub 后自动生效：
- 每次 push 到 main / master / develop 分支触发
- 每次 PR 提交时触发
- 失败则 PR 页面显示红叉，阻止合并

## 扩展检查

要加新的检查？参考现有脚本结构：

```bash
#!/usr/bin/env bash
set -o pipefail
cd "$(dirname "$0")/.."

EXIT_CODE=0

echo "→ Check: [你的检查名]"

# 你的检查逻辑
# 发现问题时设置 EXIT_CODE=1

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ [检查名] OK"
fi

exit $EXIT_CODE
```

然后加到 `check-all.sh` 的 `SCRIPTS` 数组里。

## 当前状态（基线）

运行结果：

```
✅ Traceability OK (88 BRs defined, 91 referenced)
✅ Numbering OK (no duplicates)
✅ References OK (no stale paths, all links/images resolve)
✅ All tables correctly formatted
✅ README stats match actual counts
```

追溯矩阵"88 defined, 91 referenced"的差值 3 是已废弃但保留说明的 BR（5.6-06、5.7-05、5.7-06），属于预期行为。
