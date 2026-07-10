---
doc_type: "ui_design"
version: "1.0.0"
updated: "2026-07-09"
scope: "NPS 问卷投放"
---

# UI 设计

> **文档版本**: 1.0.0  
> **更新日期**: 2026-07-09  
> **适用范围**: NPS 问卷投放模块  
> **关联文档**: `standard/UI设计规范.md`, `requirement/modules/01.01.1~01.01.5`

---

## 1. 业务组件

### 1.1 投放浮标组件（Flutter）

**组件名**：`CampaignEntryFloat`

**使用场景**：车控页右下角展示问卷入口。

**Props**：

```dart
class CampaignEntryFloatProps {
  final String? pic;              // 入口图标 URL
  final String label;             // 默认 "Campaign"
  final VoidCallback onTap;       // 点击回调
  final VoidCallback onClose;     // 关闭回调
}
```

**样式规格**：

| 属性 | 值 | 说明 |
|------|-----|------|
| 尺寸 | 56×56px | 圆形浮标 |
| 位置 | 右下角 | 距离屏幕边缘 16px，避让安全区 |
| 圆角 | 完全圆角（9999px） | |
| 阴影 | `--shadow-md` | 见 `standard/UI设计规范.md` |
| 背景 | `--color-bg-white` | 若未配置图片 |
| 关闭按钮 | 20×20px | 位于浮标左上角，点击区域 ≥ 44×44pt |

**行为**：
- 点击浮标：打开问卷页。
- 点击关闭：浮标消失，按 `cool_off` 计算并持久化下次显示时间。

### 1.2 投放计划表单组件（Web CMS）

**组件名**：`CampaignForm`

**使用场景**：新建/编辑投放计划抽屉。

**Props**：

```typescript
interface CampaignFormProps {
  mode: 'create' | 'edit' | 'view';
  initialValues?: CampaignFormValues;
  onSubmit: (values: CampaignFormValues) => void;
  onCancel: () => void;
}
```

**关键字段**：

| 字段 | 组件 | 校验规则 |
|------|------|----------|
| campaignName | Input | 必填，1-200 字符 |
| campaignCode | Input | 必填，1-64 字符，唯一；编辑态只读 |
| position | Select | 必填 |
| pic | ImageUploader | 非必填，≤3MB，jpg/png |
| urls | TableInput | 必填，至少 1 行，比例之和=100% |
| dispatchCondition | Select | 必填 |
| model | Select | 非必填 |
| timeRange | DateTimeRange | 必填 |
| coolOffHours | Select | 必填 |
| dailyDispatchLimit | InputNumber | 必填，正整数 |
| displayDurationDays | InputNumber | 必填，正整数 |

### 1.3 URL 比例分配输入组件（Web CMS）

**组件名**：`UrlAllocationInput`

**说明**：表格形式输入 URL ID、URL、分配比例；底部实时显示当前比例总和；总和不为 100% 时保存按钮禁用。

### 1.4 投放数据表格组件（Web CMS）

**组件名**：`DeliveryTable`

**说明**：含多选框、分页、批量操作栏；敏感字段脱敏展示；推送失败行高亮显示。

---

## 2. 页面模板

### 2.1 投放计划列表页（Web CMS）

**布局**：
- 顶部：筛选区（计划名称/ID、投放位置、创建时间、投放时间、搜索/重置按钮）
- 中部：创建按钮 + 表格
- 表格列：序号、计划名称、计划编码、投放位置、图片、下发条件、显示频率、起止时间、创建时间、启用状态、操作

**空状态**：显示 `van-empty` / Ant Design `Empty` 组件，文案“暂无投放计划”。

### 2.2 投放计划抽屉（Web CMS）

**布局**：
- 宽度 600px，右侧滑出
- 分块：基本信息（名称、编码、位置）、跳转链接、下发条件、时间配置
- 底部：保存 / 取消按钮

### 2.3 投放数据列表页（Web CMS）

**布局**：
- 顶部：筛选区（计划名称/编码、用户手机号/邮箱、车型、下发时间、完成状态、推送状态、搜索/重置按钮）
- 中部：导入 / 导出 / 删除 / 推送按钮 + 表格
- 表格列：多选框、序号、计划名称、计划编码、用户昵称、手机号、邮箱、车型、问卷ID、问卷URL、投放时间段、下发时间、是否已完成、推送状态、操作

### 2.4 车控页问卷入口（Flutter）

**布局**：
- 浮标叠加在车控页内容之上
- 位于右下角，避开底部导航栏与安全区

### 2.5 问卷页（Flutter WebView 容器）

**布局**：
- 顶部原生导航栏：返回按钮 + 标题“NPS问卷”
- 主体：WebView 加载 CSI H5
- 底部：无原生按钮（Submit 在 H5 内）

---

## 3. 交互规范

### 3.1 浮标动画

| 场景 | 动画 | 时长 | 缓动 |
|------|------|------|------|
| 浮标出现 | 从右下方向内缩放 + 淡入 | 300ms | ease-out |
| 浮标关闭 | 向外缩放 + 淡出 | 200ms | ease-in |
| 关闭按钮出现 | 淡入 | 200ms | ease-out |

### 3.2 抽屉动画

| 场景 | 动画 | 时长 | 缓动 |
|------|------|------|------|
| 抽屉打开 | 从右侧滑入 | 300ms | ease-out |
| 抽屉关闭 | 向右侧滑出 | 200ms | ease-in |

### 3.3 WebView 加载状态

- 加载中：显示原生 loading 指示器
- 加载失败：显示重试页面，含“点击重试”按钮
- 加载完成：隐藏 loading

---

## 4. 状态样式

### 4.1 推送状态标签

| 状态 | 背景色 | 文字色 |
|------|--------|--------|
| 未推送 | `--color-tip-bg` | `--color-tip` |
| 已推送 | rgba(82,196,26,0.1) | `--color-success` |
| 推送失败 | rgba(235,10,30,0.1) | `--color-warning` |

### 4.2 启用状态开关

- 启用：蓝色（`--color-primary`）
- 停用：灰色（`--color-disabled`）

---

## 5. 响应式适配

### 5.1 管理后台

- 最小宽度 1280px
- 表格列支持横向滚动
- 抽屉宽度固定 600px

### 5.2 App 端

- 适配 iPhone SE（375px）至 iPhone Pro Max（430px）
- 浮标位置随屏幕宽度调整，保持右下角 16px 边距
- 适配底部安全区（`env(safe-area-inset-bottom)`）
