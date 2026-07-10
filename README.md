# NPS 问卷投放 — Spec Coding 需求规范文档集

> **用途**：本文档集作为标准化的 Spec Coding 需求输入，包含完整的 PRD、技术架构、数据模型、任务清单与可复用的角色 Skill 模板。
> **目标**：让 AI 编码助手能精确理解需求并生成高质量代码；让产品经理输出结构统一的 PRD；让开发者快速理解需求并进入 spec coding。
> **版本**：1.0.0
> **维护人**：Billy

---

## 📁 文档结构

```
nps/
├── README.md                          ← 你正在读的文件（文档索引与导读）
│
├── requirement/                              ← 需求规范（L3 模块级，按迭代变化）
│   ├── 00-需求总览.md                      产品概述/术语表/角色权限/全局规则/NFR
│   ├── modules/                        功能模块 PRD
│   │   ├── 05.01-投放计划管理.md              [平台层] 投放计划 CRUD + CSI 透传接收
│   │   ├── 05.02-投放数据管理.md              [平台层] 投放数据查看/导入/导出/推送/删除
│   │   ├── 05.03-定时下发任务.md              [平台层] 凌晨定时筛选用户 + 分配问卷 + 回流 CSI
│   │   ├── 05.04-App问卷入口.md              [业务层] 车控页右下角浮标 + 冷却控制
│   │   └── 05.05-问卷页.md                   [业务层] WebView 容器 + JSBridge 完成回调
│   ├── 多语言文本.md                    中/英/泰 UI 文本字典
│   └── 功能结构.md                      功能结构权威源
│
├── demo/                              ← 评审 HTML（可分享）
│   └── spec-review-2026-07-09.html     最新需求评审 HTML（11 章节）
│
├── standard/                          ← 组织级规范（L1，跨项目复用，按年变化）
│   ├── 技术架构.md                      技术架构与编码规范
│   ├── UI设计规范.md                    UI 设计规范与组件库规格
│   ├── PRD-TEMPLATE.md                 PRD 模板
│   └── 安全基线.md                      安全基线规范
│
├── design/                            ← 方案设计（L2，按季变化）
│   ├── 技术方案.md                      技术栈 / 分层架构 / 技术决策
│   ├── 权限设计.md                      Permission Code 完整注册表（SSOT）
│   ├── 数据模型.md                      ER + 字段类型 + 索引 + 状态机（SSOT）
│   ├── 错误码.md                        错误码注册表（SSOT）
│   └── UI设计.md                        业务组件 + 页面模板
│
├── tasks/                             ← 任务级规范（L4，按天变化）
│   ├── README.md                       开发任务清单（5 个主任务 + 8 个基础任务）
│   └── 追溯矩阵.csv                    BR → EX → AC → 任务 → API 全链路追溯（SSOT）
│
├── scripts/                           ← 文档质量工具
│   ├── check-all.sh                    一键运行全部检查
│   ├── check-traceability.sh           BR 定义与追溯矩阵一致
│   ├── check-numbering.sh              BR/EX/AC 编号唯一性
│   ├── check-references.sh            路径与链接有效
│   ├── check-tables.sh                 Markdown 表格格式
│   ├── check-stats.sh                  统计数字准确
│   └── check-ac-coverage.sh            AC 任务覆盖
│
├── .claude/skills/                     ← Claude Code Skills（7 个角色模板）
│
└── assets/                            ← 所有图片与资源
    ├── prototype/                       UI 原型截图
    └── flowchart/                       业务流程图
```

---

## 🚪 快速入口

| 使用者 | 推荐入口 | 用途 |
|------|---------|------|
| 接到开发任务的成员 | `tasks/README.md` | 找到任务编号、依赖和验收标准 |
| 产品 / 项目成员 | `requirement/00-需求总览.md` | 先理解产品边界、角色、流程、全局规则 |
| AI 编码助手 | `tasks/追溯矩阵.csv` | BR → AC → 任务 → API 全链路追溯 |
| 具体开发角色 | `.claude/skills/` | 选择对应角色 Skill 触发 AI 生成代码 |

---

## 🔗 标准开发路径（推荐）

| 步骤 | 文档 | 目的 |
|------|------|------|
| 1 | `tasks/README.md` | 确认任务编号、角色、依赖、输入文档、验收标准 |
| 2 | `requirement/modules/05.01~05.05` | 打开对应模块 PRD，理解页面、流程、BR / EX / AC |
| 3 | `requirement/00-需求总览.md` | 补看术语、角色权限、全局规则、NFR |
| 4 | `design/` 下相关文档 | 后端查 `权限设计.md` / `数据模型.md` / `错误码.md`；前端查 `UI设计.md` |
| 5 | `standard/技术架构.md` | 查项目级技术栈、接口规范、错误码、安全与性能要求 |
| 6 | `standard/UI设计规范.md` | 前端任务补看页面模板、组件规格、Design Token |
| 7 | `requirement/多语言文本.md` | 前端任务补看 UI 文案和 i18n key |
| 8 | `.claude/skills/` | 选择对应角色 Skill 触发 AI 生成代码 |
| 9 | `tasks/追溯矩阵.csv` | 改需求或补规则时定位影响范围 |

---

## 🤖 Spec Coding 使用方式

### Skill 驱动（推荐）

在 Claude Code 中使用 `/` 命令：

```
/flutter-dev 请完成任务 TASK-003（App 问卷入口）
```

```
/admin-dev 请完成任务 TASK-001（投放计划管理列表）
```

```
/backend-dev 请完成任务 TASK-002（定时下发任务逻辑）
```

```
/db-design 生成 NPS 投放模块建表语句
```

```
/spec-review 生成本次评审 HTML
```

### 通用模板（跨工具）

```
请基于以下文档完成开发任务 [{任务编号}]：

- 任务来源：tasks/README.md 中的 {任务编号}
- PRD 需求：requirement/modules/{对应模块}.md
- 产品总览：requirement/00-需求总览.md（特别是术语、角色权限、全局规则）
- 方案设计：design/（后端必看 `权限设计.md` + `数据模型.md` + `错误码.md`）
- 技术规范：standard/技术架构.md
- UI 规范：standard/UI设计规范.md
- 多语言文本：requirement/多语言文本.md
- API 契约样例：参考各模块 §X.10 节

请严格遵循文档中的：
1. 数据对象字段定义和命名规范
2. 业务规则（BR-05.0x-NN）
3. 异常处理（EX-05.0x-NN）
4. 验收标准（AC-05.0x-NN）
5. Design Token（颜色、字体、间距、圆角）
6. Permission Code（鉴权码）
7. i18n key（UI 文本）

输出末尾请按对应 Skill 的"自检清单"逐项汇报。
```

### 文档间的交叉引用关系

```
PRD 功能模块 → 驱动 → 技术架构（API / 数据库 / 缓存设计）
PRD 页面描述 → 驱动 → UI 规范（组件规格 / 样式 Token）
PRD 验收标准 → 驱动 → 任务清单（测试用例生成）
PRD 全局规则 → 驱动 → Permission Code → 鉴权拦截器
PRD i18n key → 驱动 → 前端 locales/*.json
PRD Traceability → 支持 → 变更影响分析
技术架构 + UI 规范 → 驱动 → 任务清单（具体开发任务）
```

---

## 🤖 AI 工作指引

### 仓库性质

本仓库是 **NPS 问卷投放的产品文档与规范仓库**，用于存放 Spec Coding 规范文档集。仓库中**没有可编译的代码、没有包管理器、没有测试**。内容包括产品需求文档、技术设计方案、任务清单以及供 AI 生成代码时使用的 Skill 模板。实际的代码开发在其它仓库中进行。

### 文档分层

| 层级 | 目录 | 变化频率 | 内容 |
|---|---|---|---|
| L1 组织级 | `standard/` | 年 | 技术栈、编码规范、UI 规范、安全基线 |
| L2 项目级 | `design/` | 季 | ER、Permission Code、部署、技术决策、错误码 |
| L3 模块级 | `requirement/` | 迭代 | 功能 PRD（BR/EX/AC/API）、i18n、追溯 |
| L4 任务级 | `tasks/` | 天 | 任务卡、依赖、估时 |

### 文档约定

#### Front Matter

PRD 文件（`requirement/modules/05.*.md`、`requirement/00-需求总览.md`）均包含 YAML 前置元数据：

```yaml
---
module: "05.01"
title: "投放计划管理"
priority: "P0"
layer: "platform"
render_tech: "web-cms"
primary_role: "admin_frontend"
depends_on: []
entities:
  - "Campaign"
  - "CampaignUrl"
apis:
  - "POST /api/v1/campaigns"
permission_codes:
  - "campaign:view:any"
---
```

#### 编号体系

文件名使用前导零排序（`05.01-xxx.md`），文档内部及交叉引用使用 `05.01`、`BR-05.01-01`、`AC-05.01-01` 形式。

---

## 📐 编号体系速查

| 前缀 | 含义 | 示例 |
|------|------|------|
| BR | 业务规则 | BR-05.01-01 |
| EX | 异常场景 | EX-05.01-01 |
| AC | 验收标准 | AC-05.01-01 |
| GR | 全局规则 | GR-AUTH-01 |
| RR | 角色规则 | RR-01 |
| E | 页面元素（页面内唯一） | E-A-01 / E-C-01（多页面） |
| SEC | 安全需求 | SEC-01 |
| OPS | 运维需求 | OPS-01 |
| OQ | 待确认事项 | OQ-01 |

---

## 🔐 Permission Code 速查

完整列表见 `design/权限设计.md`。命名规则 `{资源}:{动作}:{范围}`：

| 高频码 | 含义 |
|-------|------|
| `campaign:view:any` | 查看任意投放计划 |
| `campaign:create:any` | 创建投放计划 |
| `campaign:update:any` | 更新投放计划 |
| `campaign:delete:any` | 删除投放计划（逻辑删除） |
| `campaign:enable:any` | 启用/停用投放计划 |
| `campaign_delivery:view:any` | 查看投放数据 |
| `campaign_delivery:import:any` | 导入投放数据 |
| `campaign_delivery:export:any` | 导出投放数据 |
| `campaign_delivery:push:any` | 推送投放数据至 CSI |
| `campaign_delivery:delete:any` | 删除投放数据（逻辑删除） |

---

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| 功能模块数 | 5 个 |
| 业务规则总数 | 38 条 |
| 异常处理场景 | 27 条 |
| 验收标准总数 | 47 条 |
| Permission Code | 10 条 |
| 数据实体 | 3 个（Campaign, CampaignUrl, CampaignDelivery） |
| 开发任务数 | 5 个主任务 + 8 个基础任务 |
| 待确认事项 | 7 个（全部已关闭） |

### 实现技术分布

| 模块 | 实现技术 |
|------|---------|
| 05.01 投放计划管理 | 💻 运营管理后台（Vue 3 + Ant Design Vue） |
| 05.02 投放数据管理 | 💻 运营管理后台（Vue 3 + Ant Design Vue） |
| 05.03 定时下发任务 | ⚙ 服务端（Spring Boot + xxl-job，无前端） |
| 05.04 App 问卷入口 | 🧩 Flutter 原生 |
| 05.05 问卷页 | 🌐 H5 WebView（CSI 提供 H5，App 提供 Flutter 容器） |

---

## ✅ 文档质量

| 检查项 | 状态 |
|--------|------|
| BR 追溯一致性 | ✅ 38 defined / 38 referenced |
| 编号唯一性 | ✅ 无重复 |
| 文档引用路径 | ✅ 无死链 |
| Markdown 表格格式 | ✅ 全部合规 |
| 统计数字 | ✅ 与实际一致 |
| AC 任务覆盖 | ✅ 47 AC / 33 linked / 5 tasks |

> 运行 `bash scripts/check-all.sh` 可重新验证。

---

## 🔄 变更与维护

### 同步更新规则

| 变更点 | 必须同步 |
|---|---|
| 新增/修改业务规则 (BR) | `tasks/追溯矩阵.csv` + 对应 AC |
| 新增鉴权点 | `design/权限设计.md` + `requirement/00-需求总览.md` 权限矩阵 |
| 新增 UI 文本 | `requirement/多语言文本.md`（全部语种） |
| 新增枚举/字段 | `requirement/00-需求总览.md` 术语表 + `design/数据模型.md` |
| 新增/改模块 | `requirement/00-需求总览.md` + `README.md` |
| 新增/改目录或文件 | `README.md` |

### 文档变更流程

1. **发起变更**：修改对应文档
2. **同步更新**：按上方规则修改所有受影响文件
3. **自检**：运行 `bash scripts/check-all.sh`
4. **Review**：至少 1 人 review 后合入

### 编号规则

- 编号全局唯一，不可跳号
- 删除的编号不复用
- 新增编号追加到末尾

### 术语规范

使用 `requirement/00-需求总览.md` 术语表中的受控词汇。禁止使用同义词替代。
