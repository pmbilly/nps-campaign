---
name: spec-review
description: 需求评审 HTML 生成器。基于 spec 文档和 asset/templates/spec-review.html 模板，直接编辑性输出结构稳定、视觉精致的单文件 HTML，供产品评审、开发对齐、上线前 review 使用。
type: custom
---
# 需求评审 HTML 生成 Skill

你是评审材料专家。**核心工作方式：阅读 spec 文档 → 在脑中组织内容 → 直接编辑性输出 HTML。** 不要写脚本来"机械填充"。

## 触发方式

- `/spec-review 生成本次评审 HTML`
- `/spec-review 为模块 {模块号} 生成评审 HTML`
- `/spec-review 增量更新本次评审 HTML`

## 设计哲学

**评审 HTML 不是"信息齐全的展示型文档"，而是"高效的评审工具"。** 它应该围绕三件事服务：让评审者**做决策**、**暴露风险**、**签字进入开发**。

每个章节都要回答："读完这一节后，评审者能否更好地推进项目？"

## 章节结构（10 节，固定顺序）

具体数量（模块数、流程步骤数、Tab 数量等）由 spec 内容决定，下表只描述章节用途和关键设计要素。

| § | 章节 | 价值 | 关键设计 |
|---|---|---|---|
| 1 | 产品概述 | 5 分钟内回答"做什么/为什么/给谁" | 核心问题 + 目标 + **关键特性标签云** + 用户卡 + 4 列术语表 |
| 2 | 业务流程 | 看清端到端流转，识别失败路径 | **紧凑流转胶囊条**（步骤编号 + 角色 + 模块标注）+ 顶部 Pill Tab：业务流程图 / 页面流程图 / 时序图 |
| 3 | 功能架构 | 一眼看清模块组织、技术栈 | 按层分组的 fntree 卡片（层数随项目而定） |
| 4 | 模块详情 | 评审最频繁的章节 | 左右联动模块列表。详情含：核心功能 / 关联实体/API / Permission / **关键 BR（可折叠）** / **AC 验收标准** / 查看原型 |
| 5 | 原型预览 | 业务方对齐 UI 共识 | 卡片画廊（**4:3 比例**，object-fit: contain）+ 分类筛选 + lightbox + 底部分类统计 |
| 6 | 角色与权限 | 后端鉴权、前端可见性的源头 | 左侧 Tab：角色定义 / 权限矩阵 / 角色规则 / Permission Code |
| 7 | 全局规范 | 跨模块统一约束 | 左侧 Tab：按主题（认证/内容/审核/分页/搜索/通知/多语言/错误/时间...）拆分 |
| 8 | 方案设计 | 技术决策依据 | 左侧 Tab：技术架构（分层架构卡 + 技术栈卡）/ 数据模型（实体卡片含完整字段）/ 部署 / 决策 / 错误码 |
| 9 | AI 开发指南 | 评审完直接告诉团队怎么用 AI 开发 | Spec Coding 简介 + Skill 卡 + 工作流步骤 + 触发方式 |
| 10 | 评审决策面板 | 评审输出物 | 已对齐项 + 待澄清风险 + 开放问题 + 决策时间表 |

## Hero 区设计

Hero 包含 4 张 hero-stat 卡片（数字 + 标签 + 副说明），按重要性排序：

| 卡 | 内容 | 数据来源 |
|---|---|---|
| 1 | 功能模块数 | spec 索引文件中模块数量（如 `spec-index.yaml`） |
| 2 | 业务规则 BR 数 | 全模块 BR 总数 |
| 3 | 验收标准 AC 数 | 全模块 AC 总数 |
| 4 | 核心实体数 | 数据模型设计文档中的实体数量（含 User 等关联实体） |

**TL;DR 决策面板（4 张卡）是可选模块**，仅在以下信息明确时启用：本期范围、上线里程碑、待决策项、关键风险。任一项未确定（如里程碑日期未定）则不启用，避免误导评审者。

## BR / AC 数据准确性（关键）

**严禁凭印象写 BR/AC**，必须从 PRD 文档中**逐条复制原文**：

1. 从模块文档的"业务规则"段读取每条 BR
2. 完整复制每条 BR 的编号和文本（**保持原始编号顺序，包括跳号 / 废弃编号**）
3. AC 同理，从"验收标准"段复制（保持 Given/When/Then 三段格式）
4. 模板中前 5 条不加 `class="hidden"`，第 6 条起加 `class="hidden"`
5. "展开剩余 N 条 ↓" 按钮的 N = 总条数 - 5

**重要**：每个项目的 BR 编号体系不同——可能存在跳号、废弃编号、子编号。生成前先打开模块文档**逐条核对**，不要根据章节号或个人记忆推断。

## §1 产品概述的"关键特性"标签云（必填）

放在"目标用户"上方，列出该产品的**差异化关键特性**（数量随项目而定，建议 6–12 个），每个用 emoji + 短文本：

```html
<h3>关键特性</h3>
<div class="card clr-blue">
  <div class="feature-tags">
    <span class="feature-tag clr-slate">🛡 {特性一}</span>
    <span class="feature-tag clr-slate">🌐 {特性二}</span>
    <!-- ... 项目专属特性 -->
  </div>
</div>
```

特性挑选原则：能让评审者一眼看到"这个产品的差异化亮点"，而不是堆砌通用功能（"用户登录"、"分页列表"这种通用特性不算）。

颜色用 `clr-slate` 统一中性色，避免 10 个不同颜色让人眼花。

## §2 业务流程胶囊条

胶囊条是端到端流转的紧凑展示。**胶囊条本身就承担"用户旅程"的展示职责，不要在 Tab 里再单独做一个"用户旅程"页**——避免内容重复。

每个 step 含：
- 数字徽章（统一深色实底 + 白字，**不要**为每步加 `clr-*` 类）
- 步骤名称（短，2–4 字，如"创建圈子"/"浏览首页"/"内容审核"）
- 角色 + 模块编号（一行，灰色，如"后台管理员 · 5.1"）

容器横向滚动支持窄屏。下方 Tab 仅放图片和时序图（业务流程图 / 页面流程图 / 各类时序图）。

步骤数量由 spec 文档决定，不要硬编码。

## 视觉规范补充

### Section 交替背景

为了让长文档的章节有节奏感，按"奇数白 / 偶数灰"交替（共 10 个 section）：

| 序号 | section id | class |
|---|---|---|
| 1 | overview | （默认白） |
| 2 | flows | `section-alt`（灰） |
| 3 | architecture | （默认白） |
| 4 | modules | `section-alt`（灰） |
| 5 | prototypes | （默认白） |
| 6 | roles | `section-alt`（灰） |
| 7 | rules | （默认白） |
| 8 | design | `section-alt`（灰） |
| 9 | ai-guide | （默认白） |
| 10 | aisummary | `section-alt`（灰） |

### Tab 样式统一为 Pill 风格

所有 Tab（`tabs-top` / `proto-filter` / `arch-sub`）使用同一种 shadcn 风格的 pill 按钮：

- 单个按钮独立排列（**不要用圆角矩形外框包裹**），按钮之间间距 `0.375rem`
- 默认：白底 · 1px 边框 · 浅灰文字
- hover：变深色文字
- active：深色实底 + 白字 + 同色边框

避免下划线、底部边框、外框包裹等不统一样式。CSS 写法示例：

```css
.tabs-top { display: flex; gap: 0.375rem; flex-wrap: wrap; margin-bottom: 1.5rem; }
.tabs-top .tab-btn {
  padding: 0.5rem 1rem; border-radius: var(--radius);
  background: white; border: 1px solid var(--border);
  color: var(--fg-muted); font-weight: 500; cursor: pointer;
}
.tabs-top .tab-btn.active { background: var(--fg); color: white; border-color: var(--fg); }
```

### Mermaid 在隐藏 Pane 中的渲染

`§8 方案设计` 用左右联动 sv-pane，初次加载时只有第一个 pane（如"技术架构"）可见，其余 pane（如"数据模型"、"部署拓扑"）`display:none`。

mermaid 10 默认 `startOnLoad: true` 会跳过 `display:none` 的元素，导致状态机/部署拓扑图不显示或右侧显示为空。

**正确做法**：关闭 `startOnLoad`，加载时手动暂时显示所有 pane → 调用 `mermaid.run()` → 还原 display 状态。

```js
mermaid.initialize({ startOnLoad: false, theme: 'base', /* ... */ });
(async () => {
  const hidden = document.querySelectorAll('.sv-pane, .tab-pane, .arch-pane');
  const prev = [];
  hidden.forEach(p => { prev.push(p.style.display); p.style.display = 'block'; });
  try { await mermaid.run({ querySelector: '.mermaid' }); }
  catch (e) { console.warn('mermaid render error', e); }
  hidden.forEach((p, i) => { p.style.display = prev[i] || ''; });
})();
```

### 业务流程胶囊条样式（stepper 风格）

`.process-strip` 用 stepper 视觉而不是"卡片+箭头"：

- 容器淡渐变背景（白→浅灰）+ 1px 边框
- 标题左侧带一个小圆点（蓝色）作为标识
- 步骤排列在一条**水平连接线**上（`.process-step::after` 伪元素绘制）
- 每步：白底圆形数字徽章（默认浅色边框）+ 名称（粗体）+ 角色·模块号（灰色）
- hover 数字徽章：填深色 + 轻微放大（`scale(1.08)`）

`.process-step` **不要**为每一步加 `clr-*` 类——保持视觉统一、避免花哨。

不再用 `<span class="process-arrow">→</span>` 文字箭头分隔步骤——连接线由伪元素绘制，更精致也避免文本断行问题。

### OQ 卡片样式（轻量）

不要用渐变背景，用白底 + 黄色左边框（3px）：
```css
.oq-card { background: white; border-left: 3px solid #f59e0b; box-shadow: var(--shadow-xs); }
```

## §5 原型预览（4:3 比例 + 底部统计）

**重要**：卡片用 4:3 比例。原型截图常常一图多状态（横向布局），不是纯纵向移动端截图。

```css
.proto-card-img { aspect-ratio: 4/3; }
.proto-card-img img { object-fit: contain; }  /* 不裁剪，完整显示 */
```

底部加 `.proto-stat` 分类统计卡。分类按项目实际终端拆分（常见：APP / H5 / 后台 / 总计），数量由项目而定。

## §8 技术架构 — 不放架构图 PNG

**禁止**在"技术架构" Tab 引用大尺寸架构图 PNG。原因：
- 架构图是技术开发的实施细节，不是产品评审材料
- 加载慢，评审会议根本不会看
- 用"分层架构卡片 + 技术栈卡片"代替更结构化、加载更快

直接放：分层架构（`arch-layer-card`，按项目层数列出）+ 核心技术栈（`card grid-3`，按技术栈分组）。

## §8 数据模型注意事项

**关联实体不要漏**：除了业务核心实体，凡是被多个核心实体引用的（如 `User`），都应作为独立实体卡片列出，即使只展示最少字段（`id / nickname / role`）。

数据模型卡片的 §8 数据 Tab 完整结构（实体卡片）：

```html
<div class="entity-card clr-blue">
  <div class="entity-card-head">
    <div>
      <strong class="entity-name">{EntityName}</strong>
      <span class="entity-name-cn">（{中文名}）</span>
    </div>
    <div class="entity-rel">
      <span class="entity-rel-tag">{关系一}</span>
      <span class="entity-rel-tag">{关系二}</span>
    </div>
  </div>
  <div class="entity-card-meta">表名 <code>{table_name}</code></div>
  <table class="entity-fields">
    <tr><td class="ef-name">id</td><td class="ef-type">bigint PK</td><td class="ef-desc">自增主键</td></tr>
    <tr><td>{字段}</td><td>{SQL 类型}</td><td>{说明（含枚举值）}</td></tr>
  </table>
</div>
```

布局规范：
- 实体卡 grid-2 排列
- 字段表 3 列：字段名（mono，深色） / 类型（mono，蓝色） / 描述（深灰）
- 类型列必须用具体 SQL 类型：`bigint`, `VARCHAR(n)`, `JSON`, `TEXT`, `BOOLEAN`, `DATETIME`, `INT`
- 主键标 `bigint PK`，外键标 `bigint FK`
- 描述若有枚举值列出（如 `PENDING / APPROVED / REJECTED`）
- 版本变更标注（如 `v2.3.0: 200→400`）
- 必含字段：`id` / `created_at` / `updated_at` / `deleted_at`

## 视觉规范（严格遵守）

### 通用

- **整体风格**：shadcn 灵感，轻量 CSS（不依赖 Tailwind），slate/blue/teal 主色调
- **节奏**：每章 4rem 间距，sticky 顶部导航 + 滚动高亮
- **字体**：ui-sans-serif，mono 用于代码与字段名
- **颜色 token**：`clr-blue / clr-green / clr-purple / clr-orange / clr-red / clr-amber / clr-indigo / clr-teal / clr-rose / clr-slate`，每个含 c-bg/c-border/c-fg/c-strong 4 色
- **Section 强调色**：每章 `.section-eyebrow` 用对应的彩色（蓝→紫→橙→青...）

### Hero

- 渐变背景（白→slate）+ 两个角的彩色光斑
- 主标题用 H1 + accent 文字渐变
- "脉冲点" 状态徽章
- 4 张 hero-stat 卡（左边 3px 强调色边）

### 功能架构（§3）

`fntree-row.cols-2` 双列布局。每层一张白卡：
- Layer head：彩色 icon 圆 + 标题 + 子说明
- Modules 列表：每个模块小卡（彩色背景）+ id 徽章

### 模块详情（§4）

**左右联动**：左 17rem sticky 列表（id 徽章 + 名称） + 右侧详情面板（min-height 22rem）。

详情面板结构（按顺序）：

```
┌─ 模块头部（modhead） ────────────┐
│ [模块徽章] [优先级] [技术] [层级] │
│ # 模块标题                       │
│ 一句话描述                       │
└──────────────────────────────────┘
┌─ 核心功能（modblock） ─┐ ┌─ 关联实体/API + Permission ─┐
│ • 功能 1              │ │ • 实体清单                  │
│ • 功能 2              │ │ • API 清单                  │
│ ...                   │ │ • Permission Code           │
└───────────────────────┘ └─────────────────────────────┘
┌─ 关键业务规则（br-list，前 5 条默认显示，剩余折叠） ┐
│ [BR-编号] 规则文本                                   │
│ [展开剩余 N 条 ↓]                                    │
└──────────────────────────────────────────────────────┘
┌─ 验收标准 AC（ac-list） ┐
│ [AC-编号] Given-When-Then                            │
└──────────────────────────────────────────────────────┘
[查看原型按钮]
```

### 业务规则折叠（§4 模块详情）

```html
<ul class="br-list" data-collapse>
  <li>...前 5 条</li>
  <li class="hidden">...剩余</li>
  <li class="hidden">...剩余</li>
  <button class="br-expand-btn">展开剩余 N 条 ↓</button>
</ul>
```

JS 行为：点击按钮切换 `.hidden` 类，按钮文字切换"展开/收起"。

### 验收标准 AC（§4 模块详情）

```html
<div class="modblock">
  <h4>✅ 验收标准</h4>
  <ul class="ac-list">
    <li><span class="ac-code">AC-{模块号}-{编号}</span><span><strong>Given</strong> {前置条件} <strong>When</strong> {操作} <strong>Then</strong> {预期结果}</span></li>
  </ul>
</div>
```

Given/When/Then 用粗体强调。

### 评审决策面板（§10）

合并三块内容：

```
┌─ 已对齐项（左） ─┐ ┌─ 待澄清风险（右） ─┐
│ ✓ ...           │ │ ! ...              │
└─────────────────┘ └────────────────────┘
┌─ 开放问题 OQ（黄色卡片） ─────────────────┐
│ OQ-{编号} ...                             │
└───────────────────────────────────────────┘
┌─ 决策时间表 ───────────────────────────────┐
│ 截止日期 │ 决策项 │ 负责人 │ 状态         │
└───────────────────────────────────────────┘
```

## 工作流（5 步）

### 步骤 1：解析用户输入

判断生成范围：
- 全量：覆盖所有模块
- 单模块：仅渲染该模块详情，其他模块淡化
- 增量：与最近一次 spec-review 对比

### 步骤 2：输出实施方案（等待确认）

阅读项目核心文档（路径因项目而异，常见：`spec-index.yaml`、`README.md`、需求总览、功能结构图）。

输出方案表格供确认：

```markdown
## 实施方案

| 项目 | 内容 |
|------|------|
| 生成范围 | 全量 / 单模块 / 增量 |
| 输出文件 | demo/spec-review-{YYYY-MM-DD}.html |
| 模板版本 | asset/templates/spec-review.html |
| 章节计划 | 10 章节 |

### 关键统计预览
- {N} 模块 / {N} BR / {N} AC / {N} Permission Code / {N} 实体 / {N} 错误码

### 数据来源
（按项目实际路径列出，常见有以下来源）
- 需求总览（术语 + 角色 + 全局规则）
- 功能结构（功能架构层级）
- 模块文档（模块详情）
- 数据模型设计（实体字段、状态机）
- 权限设计（Permission + 角色）
- 技术方案 / 部署设计 / 错误码
- 技术架构标准（分层架构）
- 流程图 / 架构图 / 原型截图（asset 目录）

### 风险/注意
- 模块详情含 AC 验收标准块
- 业务规则可折叠（前 5 条显示）
- 数据模型用实体卡片+完整字段表

---
**请确认方案后继续。**
```

### 步骤 3：深度阅读 spec 并建立心智模型

**这是整个 skill 最关键的一步。** 评审 HTML 的质量取决于 AI 是否真正"读懂了项目"，而不是机械地堆砌段落。

读 spec 不是从第一行读到最后一行——是带着问题去读，分阶段构建理解。

#### 3.1 探索阶段：先建立项目地图（不读内容）

用 `list_directory` 和 `file_search` 摸清项目结构，**不要假设具体路径存在**。重点查找：

| 类别 | 常见位置（按优先级） |
|---|---|
| 索引/总览 | `spec-index.yaml` / `README.md` / `requirement/00-*.md` |
| 需求文档 | `requirement/` / `docs/requirement/` / `prd/` |
| 模块明细 | `requirement/modules/` / `requirement/05-*` |
| 设计文档 | `design/` / `docs/design/` / `architecture/` |
| 图片资源 | `asset/` / `assets/` / `static/` |
| 标准/规范 | `standard/` / `docs/standard/` |
| 变更记录 | `CHANGELOG.md` / `docs/changelog/` |

输出一份"项目地图"心智备忘（无需写到文件，自己掌握即可），包括：模块数、有哪些设计文档、原型/流程图位置。

#### 3.2 顶层扫读：3 分钟建立全局认知

**并行**读取顶层文档（用 `read_files` 一次拉多个文件），**只看以下要点**，不深入细节：

1. **README + 需求总览**：
   - 项目一句话定位（用于 hero lead）
   - 关键统计数字（模块/BR/AC/Permission/实体）
   - 目标用户与业务价值
2. **功能结构图**：模块的层级与归属（平台层/应用层/...）
3. **spec 索引**：模块 ID、名称、优先级、技术栈

读完应该能回答以下问题，**不能回答的话回去再读**：
- 这个产品解决什么问题？给谁用？
- 有几个模块？分几层？哪个是核心？
- 关键统计数字是多少？
- 项目目前阶段（评审中/开发中/已上线）？

#### 3.3 模块深读：并行拉所有模块文档

用 `read_files` 一次性传入所有模块文档路径，**并行读取**。每读一个模块，从中只提取以下结构化信息（在脑中或临时笔记中组织）：

| 提取项 | 来源段落 | 用途 |
|---|---|---|
| 一句话描述 | 功能概述 | §4 modhead-desc |
| 优先级 / 技术栈 / 端 | 文档头部元数据 | §4 modhead 徽章 |
| 核心功能列表（3–6 条） | 功能列表 | §4 核心功能 modblock |
| 关联实体 / API / Permission | 数据对象 / API 段 | §4 关联实体 modblock |
| **完整 BR 列表（编号 + 原文）** | 业务规则 | §4 br-list（**逐条复制，不改写**） |
| **完整 AC 列表（编号 + Given/When/Then）** | 验收标准 | §4 ac-list（挑 3–5 条最核心） |
| 原型截图引用 | 原型 / 界面段 | §4 查看原型按钮 + §5 原型卡 |

**关键纪律**：
- BR / AC **必须复制原文**，不要总结、不要改写、不要凭印象。如有跳号或废弃编号要保留原状。
- 提取过程中如发现任何模块文档内部矛盾（如 BR 编号重复、AC 与 BR 对不上），立即记录到"风险清单"，后续放进 §10 评审决策面板的"待澄清风险"。

#### 3.4 设计深读：跨文档交叉验证

读取设计文档（数据模型 / 权限 / 错误码 / 部署 / 技术方案），重点是**交叉验证**而不是孤立提取：

- **数据模型**：每个实体的字段、状态机、关系。验证：模块文档提到的"关联实体"是否都在数据模型中存在？
- **权限设计**：角色 + Permission Code 矩阵。验证：模块文档里出现的 Permission Code 是否都在权限设计中定义？反向验证有没有"定义了但没用"的孤立 Permission？
- **错误码**：分段编码体系 + 关键错误码。验证：模块文档里引用的错误码是否都已注册？
- **技术方案 / 部署 / 架构标准**：分层结构、技术栈、容量规划。

发现的不一致**全部记录**——这是评审 HTML 的核心价值（暴露风险），不是要 AI 偷偷"修复"它们。

#### 3.5 资源盘点：图片清单

`list_directory` 查看 `asset/flowchart/`, `asset/architecture/`, `asset/prototype/` 等图片目录。建立映射表：

| 图片文件 | 用途 | 引用位置 |
|---|---|---|
| 业务流程图.png | 端到端流转 | §2 flow-business Tab |
| 页面流程图.png | 页面跳转 | §2 flow-page Tab |
| 各原型截图 | 卡片画廊 | §5 proto-grid |

#### 3.6 心智模型自检（写 HTML 前）

在动手写 HTML 前，**强制问自己以下问题**，能流畅回答才进入步骤 4。回答不上来就回去补读。

- [ ] 我能用 30 秒讲清楚这个产品做什么、给谁用、和市面上同类产品的差异
- [ ] 我能默写出端到端核心流程（从用户输入到最终结果，每一步是谁在做、用哪个模块）
- [ ] 我知道每个模块里"最容易出问题 / 最值得评审讨论"的是哪条业务规则
- [ ] 我知道每个核心实体的字段、关键状态机、关联关系
- [ ] 我能说出本次评审里**至少 3 个未对齐的开放问题**和**至少 3 个潜在风险**
- [ ] 我清楚每个模块的 Permission Code 列表和对应角色

这一步看起来"形式主义"，但**跳过它的代价是生成出"信息全但没有洞察"的评审 HTML**——评审者读完只会觉得"看着挺齐全，但没什么用"。

#### 3.7 输出规划（写在脑中或临时笔记）

正式写 HTML 前，先决定每节的关键内容：

- **§1 关键特性**（6–12 条）：挑能体现产品差异化的特性，不要写"用户登录""分页"这种通用功能
- **§2 流转步骤**：从全局视角抽出端到端关键步骤（数量取决于业务复杂度，常见 5–12 步），每步标注角色和模块号
- **§4 每模块的"关键 BR"前 5 条**：按"产品决策含金量"排序，挑那些"如果不告诉评审者，开发就会做错"的 BR 排前面
- **§4 每模块的"核心 AC" 3–5 条**：覆盖正常 / 异常 / 边界，避免全是 happy path
- **§8 数据模型**：实体卡按"领域核心 → 关联表 → 辅助表"的顺序排
- **§10 风险与 OQ**：从前面的"风险清单"和未关闭 OQ 中筛选，按紧急度排序

### 步骤 4：直接编辑性写 HTML

**严禁写脚本。** 用 `fs_write` / `fs_append` / `str_replace` 工具直接编辑。

复制模板到 `demo/spec-review-{date}.html`，逐段处理 REPEAT 块和占位符。

#### 4.1 图片资源处理

**不在 demo 下复制图片副本**——直接用 `../asset/...` 引用仓库根的 `asset/` 目录（单一真相源，避免维护两份图片不一致）。

写完 HTML 后检查所有 `<img src>` 和 `data-protoview` 属性：
- 路径形式必须是 `../asset/...`（**不要**写 `asset/...`、`../../asset/...` 或绝对 URL）
- 引用的图片在仓库根 `asset/<子目录>/` 下必须真实存在（grep `<img src` 后逐个用 `ls` 验证）

#### 4.2 更新索引页

写完新评审 HTML 后，在 `demo/index.html` 的"需求评审 HTML"卡片列表里追加一个 `<a class="featured ...">` 链接（**相对路径**，如 `spec-review-{date}.html`，因为 `index.html` 与新评审 HTML 同在 `demo/` 目录），并把"最新"徽章移到新版本上、旧版本徽章移除。

注意嵌套块的正确顺序：
- 先填外层（如 `module_panel`）
- 再填内层（`mp_feature` / `mp_br` / `mp_ac`）
- 最后清理所有 REPEAT/OPTIONAL 注释标签

### 步骤 5：质量验收

```markdown
## 自检清单

### 内容完整性
- [ ] 10 个 section 全部渲染
- [ ] §2 业务流程胶囊条覆盖端到端流转
- [ ] §4 每个模块含「验收标准 AC」块
- [ ] §4 业务规则展开/收起按钮工作
- [ ] §8 数据模型用实体卡片样式（含完整字段）
- [ ] §8 技术架构含分层架构卡片 + 技术栈卡片
- [ ] §9 AI 开发指南：Skill 卡 + 工作流 + 触发方式
- [ ] §10 评审决策面板（已对齐 + 风险 + OQ + 时间表）

### 数据准确
- [ ] 模块清单与 spec 索引文件一致
- [ ] BR/AC/Permission 数字与项目 README 一致
- [ ] 实体字段与数据模型设计文档一致
- [ ] 图片路径用 `../asset/...` 开头（指向仓库根的 `asset/`），**不要**用 `asset/...` 或 `../../asset/...`
- [ ] 引用的图片在仓库根 `asset/<子目录>/` 下都存在（grep `<img src` 后逐个验证）
- [ ] `demo/index.html` 的卡片列表已追加新评审入口（相对路径）

### 视觉与交互
- [ ] 所有左侧 Tab（§4/§6/§7/§8）切换正常
- [ ] 顶部 Tab（§2）切换正常
- [ ] 业务规则折叠/展开正常
- [ ] lightbox + "查看原型"按钮可触发
- [ ] sticky 导航滚动高亮当前 section
- [ ] 隐藏 pane 中的 mermaid 图正常显示
- [ ] grep "{{" 输出为空
- [ ] grep "REPEAT:|OPTIONAL:" 应只剩模板注释（占位符已展开）
- [ ] 项目 doc lint（如 `bash scripts/check-all.sh`）通过
```

## 严格约束

| 约束 | 规则 |
|---|---|
| 不要写脚本 | 严禁 Python/JS 脚本填充。直接编辑 HTML |
| 模板源 | 不允许就地修改 `asset/templates/spec-review.html`，复制后再填 |
| CSS/JS | 完全保留模板的 `<style>` 和 `<script>` |
| 数据来源 | 仅来自 spec 文档，禁止编造 |
| 图片路径 | HTML 在 `demo/` 中，引用 asset目录下的图片，**不要**用绝对路径或相对路径回退到项目根 |
| 输出位置 | `demo/spec-review-{YYYY-MM-DD}.html` |
| doc lint | 完成后项目 lint 必须通过 |

## 写作技巧

1. **术语表**：术语（中文粗体）/ 英文 code / 定义 / 备注，从需求总览全量提取
2. **流转胶囊条**：emoji icon + 主标题 + 一行子说明，按流程进度自然展开
3. **模块详情描述**：重写模块文档的功能概述，更紧凑（一句话讲清楚）
4. **关键 BR 选取**：前 5 条挑最体现产品决策的（如关键业务规则、核心约束、易遗漏的边界），剩余折叠
5. **AC 选取**：挑 3-5 条覆盖正常 / 异常 / 边界 的核心 AC
6. **流程图优先用图片**：spec 中已有的流程图 PNG 比 Mermaid 信息量大、加载快
7. **AI 开发指南**：Skill 卡用对应技术栈颜色（如 flutter-蓝 / h5-绿 / vue-紫 / java-橙 / db-红 / test-青 / spec-靛 / review-amber）。具体 Skill 数量按项目实际配置而定
8. **决策时间表**：从 OQ 中提取截止日期，按时间排序

## 项目无关性原则

本 skill 是**通用方法论**，不假定具体的：
- 模块数量（可能 5 个，也可能 20 个）
- 业务规则数量、AC 数量、Permission 数量
- 数据实体数量
- 技术架构层数（5 层、3 层均可）
- 业务流程步骤数（5 步、10 步、15 步均可）
- AI 开发指南中的 Skill 数量

生成时请：
1. **从 spec 文档提取真实数量**填入 Hero stats、章节标题、自检清单
2. **从模块文档逐条复制 BR/AC**，不要按章节号或模板默认值推断
3. 章节顺序固定（10 节），但每节内的细分 Tab、卡片数量按 spec 内容生成

## 视觉风格关键词

- **shadcn 风格**：白底 + slate 浅灰边框 + 主色辅助
- **玻璃卡片**：`backdrop-filter: blur(12px)` + 半透明背景
- **彩色徽章**：圆角矩形 + clr-* 色组
- **左侧紧凑列表**：17rem 宽，sticky top: 5rem
- **三列字段表**：字段名 mono 深色 / 类型 mono 蓝色 / 描述 灰色
- **可折叠列表**：默认显示前 N 条，下方"展开剩余 M 条 ↓"按钮
