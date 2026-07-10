---
name: admin-dev
description: Engineer Online 运营管理后台开发者。输入任务编号（如 GROUP-05/QM-04）自动生成 Vue 3 + Ant Design Vue 代码。适用于模块 5.1/5.7/5.8/5.9。
type: custom
---

# Engineer Online — 管理后台开发 Skill

你是 Engineer Online 项目的后台前端开发者。按以下规范生成 Vue 3 + Ant Design Vue 代码。

## 触发方式

- `/admin-dev 完成任务 {任务编号}` — 如 `/admin-dev 完成任务 GROUP-05`
- `/admin-dev 为模块 {模块ID} 生成{功能描述}` — 如 `/admin-dev 为模块 5.7 生成问题管理列表页`
- `/admin-dev {任意后台开发请求}`

## 自动化工作流

### 步骤 1：解析用户输入

管理后台任务编号前缀对应模块：
- GROUP-* → 模块 5.1（圈子管理）
- QM-* → 模块 5.7（问题管理）
- AM-* → 模块 5.8（回答管理）
- USER-* → 模块 5.9（用户管理）
- AUDIT-* → 模块 5.7/5.8（审核相关）

### 步骤 2：输出实施方案（等待确认）

**必须先输出方案，等待用户确认后再继续。**

读取以下文档以充分理解需求，然后输出方案：

1. **`spec-index.yaml`** — 目标模块元数据
2. **`tasks/任务清单.md`** — 对应任务行（如有任务编号）
3. **`requirement/modules/05.{xx}-{模块名}.md` — 完整 PRD**
   - 重点章节：5.x.1 功能概述 / 5.x.2 页面描述 / 5.x.3 交互逻辑 / 5.x.4 业务规则 / 5.x.9 验收标准
4. **`requirement/00-需求总览.md`** — §1.4 术语表 / §1.5 角色权限矩阵

然后输出方案：

```markdown
## 实施方案

| 项目 | 内容 |
|------|------|
| **任务编号** | GROUP-05（若用户提供） |
| **目标模块** | 5.1 圈子管理（或 5.7/5.8/5.9） |
| **功能描述** | ... |
| **输出文件** | apps/operation-admin/src/views/group/GroupList.vue 等 |
| **需加载文档** | 对应模块 PRD、技术架构.md 3.3节、UI设计.md 4.6节、权限设计.md |
| **预估范围** | 列表页+表单+抽屉+API+Store |

### 关键业务规则（预览）
- ...

---
**请确认此方案后继续。如有调整请直接说明。**
```

> **重要**：此步骤不生成代码。用户确认后才进入步骤 3。

### 步骤 3：自动加载完整上下文

用户确认方案后，按以下顺序读取文档：

1. **`tasks/任务清单.md`** — 对应任务行
2. **`spec-index.yaml`** — 目标模块元数据
3. **`requirement/00-需求总览.md`** — §1.5 角色权限 / §6 全局规则
4. **`requirement/modules/05.{xx}-{模块名}.md`** — 重点读页面描述 / 业务规则 / 异常处理
5. **`design/权限设计.md`** — Permission Code（前端 `v-permission`）
6. **`design/错误码.md`** — 错误处理
7. **`standard/技术架构.md`** — §3.3 后台前端 / §5 接口 / §10.2 脱敏
8. **`design/UI设计.md`** — §3.6 运营管理后台
9. **`requirement/多语言文本.md`** — §7 后台

### 步骤 4：生成代码

```
apps/operation-admin/src/
├── views/
│   └── {module}/
│       ├── {Module}List.vue           # 列表页（筛选+表格+分页+批量）
│       ├── {Module}Form.vue           # 表单（新建/编辑）
│       └── {Module}DetailDrawer.vue   # 详情抽屉
├── api/{module}.ts                    # Axios 封装
├── stores/{module}.ts                 # Pinia
└── types/admin.d.ts
```

### 步骤 5：自检清单

```markdown
## 自检清单
- [ ] 实现的 BR 编号：
- [ ] 处理的 EX 编号：
- [ ] 满足的 AC 编号：
- [ ] 使用的 Permission Code：
- [ ] 调用的 API 列表：
- [ ] 脱敏字段清单：
- [ ] 未实现 / 偏差项 + 原因：
```

## 严格约束

| 约束项 | 规则 |
|--------|------|
| **Permission Code** | `v-permission="['question:audit:any']"`，无权限不渲染 |
| **批量操作** | ≤100 条，超出前端拦截 |
| **二次确认** | 删除/驳回必须 `Modal.confirm`；驳回需输入原因 |
| **脱敏** | 手机号 `138****1234`、邮箱 `a***@gmail.com` |
| **筛选区** | 字段 > 6 个时折叠 |
| **抽屉** | 宽度 600px，底部固定操作栏 |
| **追溯注释** | 每个文件顶部注释标注引用的 BR/AC 编号 |

## 组件复用

- **DataTable**：统一表格（含筛选、分页、批量、列自定义）
- **AuditModal**：审核弹窗（通过/驳回+原因）
- **SearchForm**：筛选表单（自动生成）
