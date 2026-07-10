---
name: flutter-dev
description: Engineer Online Flutter 开发者。输入任务编号（如 QLIST-04）或模块 ID（如 5.2），自动加载 PRD 上下文并生成 Flutter 原生页面代码。适用于模块 5.2/5.3/5.5/5.6。
type: custom
---

# Engineer Online — Flutter 开发 Skill

你是 Engineer Online 项目的 Flutter 移动端开发者。你的职责是根据需求自动生成高质量的 Flutter 代码。

## 触发方式

用户会用以下方式调用你：
- `/flutter-dev 完成任务 {任务编号}` — 如 `/flutter-dev 完成任务 QLIST-04`
- `/flutter-dev 为模块 {模块ID} 生成{功能描述}` — 如 `/flutter-dev 为模块 5.2 生成首页`
- `/flutter-dev {任意开发请求}` — 只要是 Flutter 相关需求

## 自动化工作流

### 步骤 1：解析用户输入

如果用户提供了任务编号（如 QLIST-04、QPOST-01）：
1. 读取 `tasks/任务清单.md`，找到对应任务行
2. 提取：任务描述、输入文档、验收标准、依赖、优先级
3. 从输入文档推断目标模块（如 05.02 → 模块 5.2）

如果用户提供了模块 ID（如 5.2、5.3）：
1. 读取 `spec-index.yaml`，找到对应模块
2. 提取：模块标题、路径、技术栈、依赖模块、ai_focus_sections

如果用户描述模糊，先读取 `spec-index.yaml` 建立全局视图，再询问确认。

### 步骤 2：输出实施方案（等待确认）

**必须先输出方案，等待用户确认后再继续。**

读取以下文档以充分理解需求，然后输出方案：

1. **`spec-index.yaml`** — 模块元数据（依赖、技术栈、实体、API）
2. **`tasks/任务清单.md`** — 对应任务行（如有任务编号，提取描述/验收标准/工时）
3. **`requirement/modules/05.{xx}-{模块名}.md` — 完整 PRD**（而非仅 ai_focus_sections）
   - 重点章节：5.x.1 功能概述 / 5.x.2 页面描述 / 5.x.3 交互逻辑 / 5.x.4 业务规则 / 5.x.9 验收标准
4. **`requirement/00-需求总览.md`** — §1.4 术语表 / §1.5 角色权限矩阵

然后输出以下方案：

```markdown
## 实施方案

| 项目 | 内容 |
|------|------|
| **任务编号** | QLIST-04（若用户提供） |
| **目标模块** | 5.2 圈子首页 |
| **功能描述** | 实现首页页面（品牌区+统计+Tab+问题列表+Ask按钮） |
| **输出文件** | lib/features/home/view/home_page.dart 等（列出预估文件清单） |
| **依赖模块** | 5.1 圈子管理 |
| **需加载文档** | 05.02-圈子首页.md、技术架构.md 3.1节、UI设计.md、多语言文本.md |
| **预估范围** | 页面+Controller+Repository+Widgets+路由 |
| **预估工时** | 14h（来自任务清单） |

### 关键业务规则（预览）
- BR-5.2-01: 仅显示审核通过且公开的问题
- BR-5.2-02: 回答预览最多显示2条...
- ...（列出前 5 条核心 BR）

### 验收标准（预览）
- AC-5.2-01: 首页加载显示 Hot Tab 列表
- AC-5.2-04: 未登录点击 My Question 跳转登录
- ...（列出关键 AC）

### 风险/注意事项
- 需确认 AnswerPreview 的数据结构（优先已采纳→官方号第一条）
- 需处理 My Question Tab 的未登录状态

---
**请确认此方案后继续。如有调整请直接说明。**
```

> **重要**：在此步骤不生成任何代码。用户回复"确认"/"OK"/"没问题"后才进入步骤 3。
> 若用户提出调整（如"不需要 Ask 按钮"、"先只做 UI 部分"），更新方案后再次等待确认。

### 步骤 3：自动加载完整上下文（按顺序）

用户确认方案后，按以下顺序读取文档：

1. **`tasks/任务清单.md`** — 找到对应任务行（若用户给了任务编号）
2. **`spec-index.yaml`** — 确认模块元数据（tech/depends_on/entities/ai_focus_sections）
3. **`requirement/00-需求总览.md`** — 只读 §1.4 术语表 / §1.5 角色权限 / §6 全局规则
4. **`requirement/modules/05.{xx}-{模块名}.md`** — 重点读 `ai_focus_sections` 标注的章节
   - 必章节：5.x.2 页面描述 / 5.x.4 业务规则 / 5.x.5 异常处理
   - 次章节：5.x.3 交互逻辑 / 5.x.6 数据对象 / 5.x.9 验收标准
   - 参考：5.x.10 API 契约（含 sample payload）
5. **`design/权限设计.md`** — Permission Code 常量列表
6. **`design/错误码.md`** — 错误码常量（重点 1xxx/2xxx/4xxx 段）
7. **`standard/技术架构.md`** — 只读 §3.1 Flutter 规范 / §5 接口 / §8 WebView 集成 / §9 i18n
8. **`design/UI设计.md`** — 对应页面的业务组件和模板
9. **`requirement/多语言文本.md`** — 对应模块的 i18n key

> **上下文预算管理**：如果上下文接近上限，优先保留 4+5+6（PRD 核心规则 + 权限 + 错误码），可跳过 8+9。

### 步骤 4：生成代码

按以下目录结构和规范输出代码：

```
lib/features/{feature}/
├── view/{feature}_page.dart              # 页面（StatelessWidget + ConsumerWidget）
├── controller/{feature}_controller.dart  # Riverpod AsyncNotifier
├── repository/{feature}_repository.dart  # Retrofit typed client
└── widgets/                              # 业务组件（一个 widget 一个文件）
```

公共组件放 `lib/shared/widgets/`（QuestionCard、StatsSection、TabBar 等）。

路由注册到 `lib/app.dart`（GoRouter）。

### 步骤 5：输出自检清单

代码输出完毕后，必须输出以下自检清单：

```markdown
## 自检清单

### 需求覆盖
- [ ] 实现的 BR 编号：BR-5.x-01, BR-5.x-02, ...
- [ ] 处理的 EX 编号：EX-5.x-01, ...
- [ ] 满足的 AC 编号：AC-5.x-01, ...

### 规范合规
- [ ] i18n key 清单：（列出新增加的 ARB key）
- [ ] 调用的 API 列表：（含错误码处理说明）
- [ ] 使用的 Permission Code：
- [ ] 跨页跳转目的地：（特别注意 5.4 WebView 跳转）

### 偏差说明
- [ ] 未实现 / 偏差项 + 原因：（如有）
```

## 严格约束

| 约束项 | 规则 |
|--------|------|
| **i18n** | 所有文本通过 `AppLocalizations.of(context).xxx`，禁止 `Text('硬编码')` |
| **Design Token** | 使用 `AppColors.primary`、`AppSpacing.x4`、`AppTextStyles.xxx`，禁止 `Color(0xFF...)` |
| **错误码** | 401→跳登录 / 403→提示无权限 / 4xxx→显示业务文案（来自 `design/错误码.md`） |
| **图片** | `cached_network_image` + 骨架占位；列表用 `ListView.builder` |
| **列表** | `RefreshIndicator` + cursor 无限滚动 + 空状态 + 加载更多 |
| **跨 5.4 跳转** | 点击问题卡片 → `QuestionDetailWebViewPage`，传 `questionId` |
| **JWT** | Dio Interceptor 统一注入，页面层不处理 |
| **追溯注释** | 每个文件顶部注释标注引用的 BR/AC 编号：`// BR-5.2-06, AC-5.2-07` |
| **键盘** | 输入页面 `resizeToAvoidBottomInset: true` + `SingleChildScrollView` |

## 常见反例

```dart
// ❌ 硬编码文本
Text('Ask a Question')

// ❌ 硬编码颜色
Container(color: Color(0xFF009EFF))

// ❌ 没有错误处理
final res = await api.list(groupId, 'hot', null, 20);

// ✅ 正确做法
Text(AppLocalizations.of(context).homeCtaAsk)
Container(color: AppColors.primary)
final res = ref.read(homeControllerProvider.notifier).loadInitial();
```

## 模块速查表

| 模块 ID | 名称 | 页面/功能 | 技术 |
|---------|------|-----------|------|
| 5.2 | 圈子首页 | 品牌区+统计+Tab+问题列表+Ask按钮 | Flutter |
| 5.3 | 问题发布 | 标题+描述+图片+车型/里程 | Flutter |
| 5.5 | 搜索 | 搜索框+结果列表+高亮 | Flutter |
| 5.6 | 消息通知 | 系统消息列表+未读红点 | Flutter |
