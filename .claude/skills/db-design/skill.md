---
name: db-design
description: Engineer Online 数据库设计者。输入任务编号（如 GROUP-01/QLIST-01）自动生成 MySQL DDL + MyBatis Plus 实体。适用于全部模块的数据库设计任务。
type: custom
---

# Engineer Online — 数据库设计 Skill

你是 Engineer Online 项目的数据库设计者。按以下规范生成 MySQL DDL 和 MyBatis Plus 实体。

## 触发方式

- `/db-design 完成任务 {任务编号}` — 如 `/db-design 完成任务 GROUP-01`
- `/db-design 为{实体名}设计数据库表` — 如 `/db-design 为 Question 设计数据库表`
- `/db-design {任意数据库设计请求}`

## 自动化工作流

### 步骤 1：解析用户输入

数据库任务编号前缀速查：
- GROUP-01 → t_community_group + t_community_group_translation
- QLIST-01 → t_community_question
- QDETAIL-01/02/03 → t_community_answer + t_community_vote
- NOTIFY-01 → t_community_notification
- AUDIT-01 → 审核状态字段 + 审核日志

如果用户指定实体名（如 Question/Answer/Vote）：
1. 读取 `spec-index.yaml`，找到包含该实体的模块
2. 从模块路径读取 PRD 中的数据对象定义

### 步骤 2：输出实施方案（等待确认）

**必须先输出方案，等待用户确认后再继续。**

读取以下文档以充分理解需求，然后输出方案：

1. **`spec-index.yaml`** — 确认实体所属模块
2. **`tasks/任务清单.md`** — 对应任务行（如有任务编号）
3. **`requirement/modules/05.{xx}-{模块名}.md` — 完整 PRD**
   - 重点章节：5.x.1 功能概述 / 5.x.4 业务规则 / 5.x.5 异常处理 / 5.x.6 数据对象 / 5.x.7 状态机
4. **`requirement/00-需求总览.md`** — §1.4 术语表

然后输出方案：

```markdown
## 实施方案

| 项目 | 内容 |
|------|------|
| **任务编号** | GROUP-01（若用户提供） |
| **目标实体** | Group + GroupTranslation |
| **功能描述** | 设计圈子主表和多语言翻译表 |
| **输出文件** | V1__create_community_group.sql + V2__create_community_group_translation.sql + Group.java + GroupTranslation.java |
| **需加载文档** | 05.01-圈子管理.md §5.1.6、数据模型.md、技术架构.md §6.1 |
| **预估范围** | 2 张表的 DDL + 2 个 Entity + 2 个 Mapper |

### 关键字段（预览）
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | ... |
| name | VARCHAR(100) | ... |
| ... | ... | ... |

---
**请确认此方案后继续。如有调整请直接说明。**
```

> **重要**：此步骤不生成代码。用户确认后才进入步骤 3。

### 步骤 3：自动加载完整上下文

用户确认方案后，按以下顺序读取文档：

1. **`tasks/任务清单.md`** — 对应任务行（若有任务编号）
2. **`spec-index.yaml`** — 确认实体所属模块
3. **`requirement/modules/05.{xx}-{模块名}.md`** — §5.x.6 数据对象（字段定义、类型、约束）
4. **`design/数据模型.md`** — ER 图 + 字段详表 + 索引策略 + 状态机（SSOT）
5. **`standard/技术架构.md`** — §6 数据存储（表命名、字段类型、索引规范）

### 步骤 4：生成代码

```
# DDL
migrations/V{n}__create_{table}.sql

# Java Entity
community-service/src/main/java/com/aion/community/
├── entity/{Module}.java              # MyBatis Plus 注解
└── mapper/{Module}Mapper.java        # + XML（复杂查询）
```

### 步骤 5：自检清单

```markdown
## 自检清单
- [ ] 表名遵循 `t_community_xxx`
- [ ] 字段与 `design/数据模型.md` 完全对应
- [ ] 必须字段齐全（id / created_at / updated_at / deleted）
- [ ] 索引覆盖外键和筛选字段
- [ ] 字符集 utf8mb4
- [ ] 注释完整
- [ ] DDL 可逆（提供 rollback）
- [ ] 未实现 / 偏差项 + 原因：
```

## 严格约束

| 约束项 | 规则 |
|--------|------|
| **表名** | `t_community_{entity}`，如 `t_community_question` |
| **字段名** | snake_case，如 `created_at`、`is_hot` |
| **必须字段** | id / created_at / updated_at / deleted（每张表） |
| **字符集** | utf8mb4 / utf8mb4_0900_ai_ci |
| **枚举** | VARCHAR(20)，禁止 ENUM 类型 |
| **JSON** | MySQL 原生 JSON 类型（图片数组等） |
| **索引** | 外键必建索引；复合索引遵循最左前缀 |
| **软删除** | `deleted` TINYINT + MyBatis Plus `@TableLogic` |
| **冗余计数** | 由 MQ 事件异步维护，禁止 SELECT COUNT(*) |
| **主键** | BIGINT AUTO_INCREMENT |
| **时间戳** | TIMESTAMPTZ DEFAULT now() |

## 常用字段类型映射

| PRD 类型 | MySQL 类型 | 说明 |
|----------|-----------|------|
| string | VARCHAR(n) | 标题 200 / 名称 100 / 描述 500 / 内容 TEXT |
| integer | BIGINT | 主键、外键、计数 |
| boolean | TINYINT(1) | 0/1 |
| datetime | TIMESTAMPTZ | 系统生成 |
| enum | VARCHAR(20) | 状态字段 |
| string[] | JSON | 图片 URL 数组 |
| ref:{Entity} | BIGINT | 外键 |
| richtext | TEXT | 富文本内容 |
| image / file | JSON | URL 数组 |
