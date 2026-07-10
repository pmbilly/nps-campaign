---
doc_type: "ui_spec"
version: "1.1.0"
updated: "2026-04-26"
scope: "H5 (5.4) + Flutter (5.2/5.3/5.5/5.6) + 运营管理后台 (5.1/5.7/5.8/5.9)"
canvas: "375×812px (iPhone X)"
owner: "Billy"
---

# Engineer Online — UI设计规范与组件库规格

> **文档版本**: 1.1.0
> **更新日期**: 2026-04-26
> **适用范围**: H5 详情页（5.4） + Flutter 原生页面（5.2/5.3/5.5/5.6） + 运营管理后台（5.1/5.7/5.8）
> **关联文档**: `standard/技术架构.md`, `requirement/00-需求总览.md`, `requirement/modules/05.01~05.09`
> **设计画布**: 375×812px (iPhone X 基准)

---

## 0. 跨技术栈说明

| 章节 | 适用范围 |
|------|---------|
| 第 1 章 Design Token | **共享** — Flutter / H5 / 运营管理后台 三端 |
| 第 2 章 原子组件 | 主要面向 H5/Vant；Flutter 端应实现等价 widget |
| 第 3 章 业务组件 | 描述视觉/行为规格，由 Flutter / H5 各自实现 |
| 第 4 章 页面模板 | 4.1/4.2/4.4/4.5 → Flutter 原生（5.2/5.3/5.5/5.6）；4.3 → H5 详情页（5.4）；4.6 → 运营管理后台 |
| 第 5 章 Flutter WebView 适配 | 仅 5.4 H5 |
| 第 6-8 章 动画 / 响应式 / 图标 | 三端通用；Flutter 端用 `Tween` / `Hero` / `flutter_svg`，H5 端用 CSS transition |

**核心原则**：

1. **Token 同源**：所有颜色 / 字号 / 间距 / 圆角 / 阴影由本规范第 1 章定义。Flutter 端从 `core/design_tokens.dart` 引用，H5 端从 `assets/styles/design-tokens.css` 引用，运营管理后台从 Ant Design Theme 引用。三套常量值必须保持一致。
2. **视觉一致**：同一业务组件（如 QuestionCard）在 Flutter 和 H5 中的视觉差异不能用肉眼分辨。
3. **行为一致**：状态/交互（loading / empty / error / 投票按钮已点态）行为相同。
4. **技术差异容忍**：滚动惯性、字体细节微差可由原生平台默认行为接管。

---

## 1. Design Token 系统

### 1.1 颜色体系

```css
/* CSS Variables - 在 :root 中定义 */
:root {
  /* ========== 主色 Primary ========== */
  --color-primary: #009EFF;
  --color-primary-light: #008FE6;      /* 主色-辅助 */
  --color-primary-bg: #E5F3FF;         /* 主色-辅助-背景，用于选中态、轻提示背景 */

  /* ========== 辅助色 Secondary ========== */
  --color-warning: #EB0A1E;            /* 警示色 */
  --color-warning-bg: #FFEFE0;           /* 警示色-浅背景 */
  --color-tip: #FFA762;                 /* 提示色 */
  --color-tip-bg: #FFF8F2;              /* 提示色-背景 */

  /* ========== 文字梯度 Text ========== */
  --color-text-primary: #191A1D;        /* 文字-1：标题、重要内容 */
  --color-text-secondary: #363F4F;      /* 文字-2：正文、常规内容 */
  --color-text-tertiary: #697588;       /* 文字-3：辅助说明、时间 */
  --color-text-quaternary: #9FA9BB;     /* 文字-4：占位符、禁用态 */

  /* ========== 分隔线与背景 Background ========== */
  --color-divider: #CAD1DD;             /* 分隔线 */
  --color-bg-page: #EAEDF6;             /* 页面背景色 */
  --color-bg-card: #F8FAFD;             /* 卡片背景色 */
  --color-bg-white: #FFFFFF;            /* 纯白背景 */

  /* ========== 状态色 Status ========== */
  --color-success: #52C41A;
  --color-error: #EB0A1E;
  --color-info: #009EFF;
  --color-disabled: #C8C9CC;

  /* ========== 特殊场景 ========== */
  --color-adopt-badge: #52C41A;        /* Adopt采纳标记 - 绿色 */
  --color-adopt-bg: rgba(82, 196, 26, 0.1); /* Adopt背景 */
  --color-author-tag: #EB0A1E;          /* Author红色标签 */
  --color-official-v: #009EFF;          /* 官方号V徽章 */
  --color-brand-label-bg: #F2F3F5;     /* 品牌标签背景(GAC) */
  --color-brand-label-text: #697588;   /* 品牌标签文字 */
  --color-search-highlight: #EB0A1E;   /* 搜索关键词高亮 */
}
```

**使用规则**:
- 文字颜色严格按层级使用：`primary` > `secondary` > `tertiary` > `quaternary`
- 禁用态统一使用 `--color-disabled`，禁止自定义灰色
- 链接色统一使用 `--color-primary`，hover态亮度降低10%

### 1.2 字体体系

```css
:root {
  /* 字体家族 */
  --font-family-base: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  --font-family-number: 'DIN Alternate', 'Helvetica Neue', Arial, sans-serif; /* 数字用等宽字体 */

  /* 字号层级 */
  --font-size-h1: 20px;        /* 页面大标题 */
  --font-size-h2: 18px;        /* 模块标题 */
  --font-size-h3: 16px;        /* 卡片标题、问题标题 */
  --font-size-body: 14px;      /* 正文、描述 */
  --font-size-small: 12px;     /* 辅助文字、时间、标签 */
  --font-size-tiny: 10px;      /* 角标、微标 */

  /* 字重 */
  --font-weight-regular: 400;
  --font-weight-medium: 500;    /* 标题、按钮 */
  --font-weight-semibold: 600;  /* 数字统计、强调 */
  --font-weight-bold: 700;     /* 极少使用 */

  /* 行高 */
  --line-height-tight: 1.25;    /* 标题 */
  --line-height-normal: 1.5;    /* 正文 */
  --line-height-loose: 1.75;    /* 多行文本 */
}
```

**字体映射表**:

| 场景 | 字号 | 字重 | 行高 | 颜色 |
|------|------|------|------|------|
| 页面标题 | 20px | 500 | 1.25 | --color-text-primary |
| 问题标题 | 16px | 500 | 1.4 | --color-text-primary |
| 正文/描述 | 14px | 400 | 1.5 | --color-text-secondary |
| 摘要/预览 | 14px | 400 | 1.5 | --color-text-tertiary |
| 时间/统计标签 | 12px | 400 | 1.25 | --color-text-tertiary |
| 占位符 | 14px | 400 | 1.5 | --color-text-quaternary |
| 按钮文字 | 16px | 500 | 1 | --color-bg-white |
| 品牌标签 | 10px | 500 | 1 | --color-brand-label-text |
| 数字统计 | 24px | 600 | 1 | --color-text-primary |

### 1.3 间距体系

```css
:root {
  /* 基础间距（8px网格系统） */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;

  /* 页面边距 */
  --page-padding: 16px;           /* 页面左右边距 */
  --section-gap: 12px;            /* 模块间间距 */
  --card-padding: 16px;           /* 卡片内边距 */
  --card-gap: 12px;               /* 卡片间间距 */
}
```

**间距使用规范**:
- 页面内容区左右边距：16px（--page-padding）
- 卡片内部padding：16px
- 卡片之间间距：12px
- 表单元素间距：24px（大间距）或 16px（常规）
- 图标与文字间距：8px
- 列表项高度：最小48px（触控友好）

### 1.4 圆角体系

```css
:root {
  --radius-sm: 4px;       /* 选项、toast、小区域按钮 */
  --radius-md: 8px;       /* 卡片、toast、气泡浮窗、小区域卡片 */
  --radius-lg: 12px;      /* 弹窗、悬浮半屏页面、大范围卡片 */
  --radius-xl: 16px;      /* 底部固定按钮、大卡片 */
  --radius-full: 9999px;  /* 头像、标签、完全圆角按钮 */
}
```

**圆角使用规则**:
- 按钮：完全圆角 `radius-full`（胶囊形）
- 卡片/列表项：`radius-md` (8px)
- 弹窗/抽屉：`radius-lg` (12px) 或顶部 `radius-xl` (16px)
- 输入框：`radius-md` (8px) 或 `radius-sm` (4px)
- 图片：`radius-md` (8px)
- **嵌套规则**：内层卡片圆角必须小于外层，如外层12px，内层8px

### 1.5 阴影体系

```css
:root {
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
  --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12);
  --shadow-float: 0 -4px 16px rgba(0, 0, 0, 0.1);  /* 底部悬浮按钮阴影 */
}
```

### 1.6 描边规范

- **常规描边**：0.5px @1x，颜色 `--color-divider`
- **强调描边**：1px @1x，颜色 `--color-primary` 或 `--color-warning`
- **使用场景**：输入框边框、卡片边框、分割线、按钮描边

---

## 2. 原子组件规格

### 2.1 按钮 Button

#### 主按钮 Primary Button

```typescript
interface PrimaryButtonProps {
  text: string;
  loading?: boolean;        // 显示loading图标+文字
  disabled?: boolean;       // 禁用态，背景色变为 --color-disabled
  size?: 'large' | 'medium' | 'small';
  onClick?: () => void;
}
```

**样式规格**:

| 属性 | 值 | 说明 |
|------|-----|------|
| 背景色 | --color-primary (#009EFF) | 常态 |
| 文字色 | --color-bg-white | 白色 |
| 高度 | 48px (large) / 40px (medium) / 32px (small) | |
| 圆角 | radius-full (9999px) | 胶囊形 |
| 字体 | 16px / 500 | |
| 内边距 | 0 24px | 左右24px |
| 禁用态 | 背景 --color-disabled，文字白色 | |
| 点击态 | 背景亮度降低10% | |
| 加载态 | 左侧显示loading图标，文字保留 | |

**使用场景**:
- "Ask a Question" 底部固定按钮（large）
- "Post" 发布按钮（medium）
- "Submit" 表单提交按钮（large）
- "I know" / "Confirm" 弹窗确认按钮（medium）

#### 次要按钮 Secondary Button

```typescript
interface SecondaryButtonProps {
  text: string;
  disabled?: boolean;
  size?: 'large' | 'medium' | 'small';
  onClick?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景色 | transparent |
| 边框 | 1px solid --color-primary |
| 文字色 | --color-primary |
| 高度 | 同主按钮 |
| 圆角 | radius-full |
| 禁用态 | 边框和文字变为 --color-disabled |

**使用场景**:
- "Cancel" 取消按钮
- "Disagree" 不同意按钮
- "Continuing authorization" 继续授权按钮

#### 文字按钮 Text Button

```typescript
interface TextButtonProps {
  text: string;
  color?: 'primary' | 'danger' | 'default';
  onClick?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | transparent |
| 无边框 | |
| 文字色 | primary: --color-primary, danger: --color-warning, default: --color-text-secondary |
| 字体 | 14px / 400 |

**使用场景**:
- "Send" 发送验证码
- "Learn more" 链接
- "Translate" 翻译按钮
- "Delete" 删除按钮（danger红色）
- "Reply" 回复按钮

#### 底部固定按钮 Bottom Fixed Button

```typescript
interface BottomFixedButtonProps {
  text: string;
  loading?: boolean;
  disabled?: boolean;
  safeArea?: boolean;       // 是否适配安全区
  onClick?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 定位 | fixed, bottom: 0 |
| 宽度 | 100% - 32px (左右16px边距) |
| 高度 | 48px |
| 圆角 | radius-xl (16px) |
| 背景 | --color-primary |
| 阴影 | --shadow-float |
| 安全区 | padding-bottom: env(safe-area-inset-bottom) |

**使用场景**:
- "Ask a Question" 首页底部按钮
- "Submit" 表单底部提交按钮
- "Confirm" 弹窗底部确认

### 2.2 表单 Form

#### 输入框 Input

```typescript
interface InputProps {
  label?: string;           // 字段标签，如 "Name"
  placeholder?: string;     // 占位符
  value?: string;
  required?: boolean;       // 是否必填，显示红色*号
  disabled?: boolean;
  error?: string;           // 错误提示文字
  type?: 'text' | 'textarea' | 'number' | 'tel';
  maxLength?: number;
  showCount?: boolean;      // 是否显示字数统计
  rightSlot?: any;           // 右侧插槽（Vue slot），如 "Send"按钮
  onChange?: (val: string) => void;
  onBlur?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 标签字体 | 14px / 400 / --color-text-secondary |
| 标签下边距 | 8px |
| 输入框高度 | 48px (单行) / 自适应 (多行textarea) |
| 输入框背景 | --color-bg-white |
| 输入框边框 | 1px solid --color-divider |
| 输入框圆角 | radius-md (8px) |
| 输入框内边距 | 0 16px |
| 占位符颜色 | --color-text-quaternary |
| 输入文字 | 14px / 400 / --color-text-primary |
| 聚焦边框 | 1px solid --color-primary |
| 错误边框 | 1px solid --color-warning |
| 错误文字 | 12px / 400 / --color-warning，位于输入框下方 |
| 必填标记 | 标签前红色*号 |

**特殊变体**:

**验证码输入框**:
- 右侧插槽："Send" 文字按钮（primary色）
- 发送后显示倒计时 "56s"（--color-text-quaternary）

**手机号输入框**:
- 左侧前缀："+66" 下拉选择器
- 右侧输入框：纯数字

**多行文本域 Textarea**:
- 最小高度：120px
- 最大高度：300px
- 可拖拽调整高度（或自动增高）
- 右下角显示字数统计 "0/200"

#### 选择器 Select / 导航项 NavItem

```typescript
interface NavItemProps {
  label: string;            // 左侧标签，如 "Service Center"
  value?: string;           // 右侧值，如 "AION Thailand..."
  placeholder?: string;      // 空值时显示，如 "Select >"
  required?: boolean;
  disabled?: boolean;
  onClick?: () => void;     // 点击跳转选择页或打开picker
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 高度 | 56px |
| 背景 | transparent |
| 下边框 | 1px solid --color-divider (底部) |
| 标签 | 14px / 400 / --color-text-secondary |
| 值 | 14px / 400 / --color-text-primary |
| 占位符 | 14px / 400 / --color-text-quaternary |
| 右侧箭头 | > 图标，--color-text-quaternary |
| 点击态 | 背景 --color-bg-page |

**使用场景**:
- "Vehicle" 车型选择
- "Total Mileage" 里程选择
- "Service Center" 服务中心选择
- "Appointment Time" 预约时间选择

#### 图片上传 ImageUploader

```typescript
interface ImageUploaderProps {
  images: string[];         // 已上传图片URL列表
  maxCount?: number;        // 最大上传数量，默认9
  onUpload?: (file: File) => Promise<string>;  // 返回图片URL
  onDelete?: (index: number) => void;
  onPreview?: (index: number) => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 容器 | flex布局，换行 |
| 单张尺寸 | 100px × 100px |
| 间距 | 8px |
| 圆角 | radius-md (8px) |
| 添加按钮 | 边框 1px dashed --color-divider，内部 "+" 号 |
| 删除按钮 | 右上角小圆角按钮，红色背景，白色×图标 |
| 上传中 | 显示进度环或loading图标 |

### 2.3 弹窗 Modal / Dialog

#### 确认弹窗 Confirm Dialog

```typescript
interface ConfirmDialogProps {
  title?: string;           // 标题，如 "Notice"
  content: string;           // 内容文字
  confirmText?: string;      // 确认按钮文字，默认 "Confirm"
  cancelText?: string;     // 取消按钮文字，默认 "Cancel"
  type?: 'default' | 'warning' | 'success';  // 影响图标颜色
  onConfirm?: () => void;
  onCancel?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 遮罩 | rgba(0,0,0,0.6) |
| 弹窗宽度 | 280px (居中) |
| 弹窗背景 | --color-bg-white |
| 弹窗圆角 | radius-lg (12px) |
| 标题 | 18px / 500 / --color-text-primary，居中，上边距24px |
| 内容 | 14px / 400 / --color-text-secondary，居中，左右24px，上下16px |
| 按钮区 | 底部，左右16px，下边距16px，两按钮间距12px |
| 确认按钮 | 主按钮样式，medium |
| 取消按钮 | 次要按钮样式，medium |
| 关闭图标 | 右上角 × 图标（可选，用于复杂弹窗） |

**变体 - 成功提示弹窗**:
- 顶部显示成功图标（绿色圆圈+白色✓）
- 标题："Succeed"
- 单按钮："I know"（主按钮）

**变体 - 警告提示弹窗**:
- 顶部显示警告图标（黄色/橙色圆圈+!）
- 内容中关键文字高亮（--color-primary）
- 双按钮："Cancel authorization"（主按钮，warning色）+ "Continuing authorization"（次要按钮）

#### 底部动作面板 Action Sheet

```typescript
interface ActionSheetProps {
  title?: string;
  actions: { text: string; color?: string; disabled?: boolean }[];
  cancelText?: string;
  onSelect?: (index: number) => void;
  onCancel?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 位置 | 底部弹出 |
| 背景 | --color-bg-white |
| 顶部圆角 | radius-xl (16px) |
| 标题 | 14px / 400 / --color-text-tertiary，居中，padding 16px |
| 选项 | 高度 56px，文字居中，16px / 400 |
| 选项点击态 | 背景 --color-bg-page |
| 危险选项 | 文字 --color-warning |
| 取消按钮 | 独立区域，上边距8px，背景 --color-bg-page |

**使用场景**:
- "Navigate" 导航选择（Apple Maps / Google Maps / Send to Car）
- "Share" 分享选项
- "Delete" 删除确认（危险选项）

#### 半屏弹窗 Half-Screen Modal

```typescript
interface HalfScreenModalProps {
  title: string;
  showClose?: boolean;
  children?: any;           // Vue slot 内容
  onClose?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 位置 | 底部弹出，高度占屏幕70-80% |
| 背景 | --color-bg-white |
| 顶部圆角 | radius-xl (16px) |
| 标题栏 | 高度 56px，居中，16px / 500 |
| 关闭按钮 | 右上角 × 图标 |
| 内容区 | 可滚动 |
| 底部按钮 | 如有，固定底部，主按钮large |

**使用场景**:
- "Battery temperature control schedule" 定时设置
- "Charging schedule" 充电计划
- "Appointment Time" 预约时间选择
- "Terms and Conditions" 条款详情

### 2.4 加载与状态 Loading & Status

#### 页面加载骨架屏 Skeleton

```typescript
interface SkeletonProps {
  rows?: number;            // 行数，默认3
  avatar?: boolean;         // 是否显示头像占位
  image?: boolean;          // 是否显示图片占位
  action?: boolean;         // 是否显示按钮占位
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | --color-bg-card |
| 动画 | shimmer渐变动画，从左到右 |
|  shimmer颜色 | linear-gradient(90deg, transparent, rgba(255,255,255,0.5), transparent) |
| 头像占位 | 圆形，40px |
| 标题占位 | 圆角4px，高度16px，宽度60% |
| 行占位 | 圆角4px，高度12px，宽度100% |
| 图片占位 | 圆角8px，宽高比16:9或1:1 |
| 按钮占位 | 圆角9999px，高度48px，宽度100% |

#### 下拉刷新 PullRefresh

```typescript
interface PullRefreshProps {
  refreshing: boolean;
  onRefresh: () => Promise<void>;
  children?: any;           // Vue slot 内容
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 触发距离 | 下拉60px |
| 加载图标 | 旋转loading图标 + "下拉加载" 文字 |
| 释放提示 | "释放立即刷新" |
| 加载中 | 旋转loading图标 + "加载中..." |
| 图标颜色 | --color-primary |
| 文字 | 12px / --color-text-tertiary |

#### 加载更多 List Loading

```typescript
interface ListLoadingProps {
  loading: boolean;
  finished: boolean;
  error?: boolean;
  onLoad?: () => void;
  onRetry?: () => void;
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 加载中 | 居中，loading图标 + "Loading..." |
| 无更多 | 居中，"No more questions"，12px / --color-text-quaternary |
| 加载失败 | 居中，"Loading failed, click to retry"，可点击 |
| 距离底部 | 触发加载的距离：100px |

#### Toast 轻提示

```typescript
interface ToastProps {
  type?: 'text' | 'loading' | 'success' | 'fail';
  message: string;
  duration?: number;        // 默认2000ms
  position?: 'top' | 'middle' | 'bottom';
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | rgba(0,0,0,0.7) |
| 文字 | 14px / 400 / white |
| 圆角 | radius-md (8px) |
| 内边距 | 12px 24px |
| 位置 | middle: 垂直居中，bottom: 底部100px |
| 图标 | loading: 旋转图标，success: 绿色✓，fail: 红色× |

### 2.5 标签与徽标 Tag & Badge

#### 品牌标签 BrandLabel

```typescript
interface BrandLabelProps {
  text: string;             // 如 "GAC"
  size?: 'small' | 'medium';
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | --color-brand-label-bg (#F2F3F5) |
| 文字 | --color-brand-label-text (#697588) |
| 字体 | 10px / 500 |
| 内边距 | 2px 8px |
| 圆角 | radius-sm (4px) |

#### V认证徽章 VerifiedBadge

```typescript
interface VerifiedBadgeProps {
  size?: 'small' | 'medium' | 'large';
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | --color-official-v (#009EFF) |
| 图标 | 白色 V 字形 |
| 尺寸 | small: 12px, medium: 16px, large: 20px |
| 圆角 | 圆形 |
| 位置 | 头像右下角，重叠1/4 |

#### Adopt采纳标记 AdoptBadge

```typescript
interface AdoptBadgeProps {
  size?: 'small' | 'medium';
}
```

**样式规格**:

| 属性 | 值 |
|------|-----|
| 背景 | 绿色虚线圆环或绿色印章样式 |
| 文字 | "Adopt"，绿色 |
| 字体 | 12px / 500 |
| 位置 | 回答卡片右上角 |

#### 状态标签 StatusTag

```typescript
interface StatusTagProps {
  status: 'pending' | 'approved' | 'rejected' | 'synced' | 'sync_failed';
  text?: string;
}
```

**样式规格**:

| 状态 | 背景 | 文字色 |
|------|------|--------|
| pending | --color-tip-bg | --color-tip |
| approved | rgba(82,196,26,0.1) | --color-success |
| rejected | rgba(235,10,30,0.1) | --color-warning |
| synced | rgba(82,196,26,0.1) | --color-success |
| sync_failed | rgba(235,10,30,0.1) | --color-warning |

---

## 3. 业务组件规格

> 📌 **已迁移至 [`design/UI设计.md`](../design/UI设计.md) §2**
>
> 本章内容（QuestionCard / AnswerCard / OfficialAccountHeader / NotificationCard / SearchResultCard）已迁移到方案设计文档。

---

## 4. 页面模板规格

> 📌 **已迁移至 [`design/UI设计.md`](../design/UI设计.md) §3**
>
> 本章内容（首页 / 提问页 / 详情页 / 搜索页 / 消息页 / 管理后台）已迁移到方案设计文档。

---

## 5. Flutter WebView 适配规范

### 5.1 安全区适配

```css
/* 页面根元素 */
.page-container {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

/* 底部固定按钮 */
.bottom-fixed-button {
  padding-bottom: calc(16px + env(safe-area-inset-bottom));
}
```

### 5.2 状态栏处理

- **iOS**: WebView内H5不显示状态栏信息，由Flutter原生控制
- **Android**: 同上
- **H5导航栏**: 顶部预留44px（不含状态栏），状态栏区域背景与页面一致或透明

### 5.3 返回手势适配

```typescript
// composables/useBackHandler.ts
export function useBackHandler(handler: () => boolean) {
  onMounted(() => {
    // 注册Flutter返回事件监听
    window.flutterBridge?.onNativeEvent('backPressed', () => {
      const handled = handler();
      if (!handled) {
        window.flutterBridge?.callNative('goBack', {});
      }
    });
  });
}

// 在提问页使用（有未保存内容时拦截）
useBackHandler(() => {
  if (hasUnsavedChanges.value) {
    showConfirmDialog({
      title: '确定放弃编辑？',
      onConfirm: () => router.back(),
    });
    return true; // 已处理，阻止原生返回
  }
  return false; // 未处理，允许原生返回
});
```

### 5.4 主题同步

```typescript
// 从Flutter获取主题色并动态设置CSS变量
const theme = await window.flutterBridge?.callNative('getThemeColor', {});
if (theme?.primaryColor) {
  document.documentElement.style.setProperty('--color-primary', theme.primaryColor);
}
```

---

## 6. 动画与交互规范

### 6.1 转场动画

| 场景 | 动画 | 时长 | 缓动 |
|------|------|------|------|
| 页面进入 | 从右向左滑入 | 300ms | ease-out |
| 页面返回 | 从左向右滑出 | 300ms | ease-in |
| 弹窗出现 | 从底部向上滑入 + 遮罩淡入 | 300ms | ease-out |
| 弹窗关闭 | 向下滑出 + 遮罩淡出 | 200ms | ease-in |
| 抽屉出现 | 从右侧滑入 | 300ms | ease-out |
| Tab切换 | 指示器滑动 | 300ms | ease |
| 列表加载 | 骨架屏shimmer | 1.5s | linear infinite |
| 按钮点击 | 背景色加深 | 100ms | ease |
| Toast出现 | 淡入 | 200ms | ease-out |
| Toast消失 | 淡出 | 200ms | ease-in |

### 6.2 手势交互

| 手势 | 响应 | 说明 |
|------|------|------|
| 点击 | 元素高亮/反馈 | 所有可点击元素 |
| 长按 | 图片预览/复制文字 | 问题内容区 |
| 左滑 | 无 | 本版本不支持 |
| 下拉 | 刷新列表 | 首页、问题列表 |
| 上滑 | 加载更多 | 所有列表页 |
| 双指缩放 | 图片放大 | 图片预览模式 |

---

## 7. 响应式与适配

### 7.1 断点定义

本项目为移动端H5，主要适配以下设备：

| 设备类型 | 宽度范围 | 基准 |
|---------|---------|------|
| 小屏手机 | 320px - 375px | iPhone SE/8 |
| 标准手机 | 375px - 414px | iPhone X/12/13/14 |
| 大屏手机 | 414px - 480px | iPhone Plus/Max |
| 小平板 | 480px - 768px | iPad Mini（较少） |

### 7.2 适配策略

- **布局**: 使用flex + 百分比，禁止固定宽度（除弹窗外）
- **字体**: 使用px（非rem），因为Flutter WebView内1rem行为不稳定
- **图片**: 使用 `object-fit: cover`，固定宽高比
- **安全区**: 必须适配刘海屏、圆角屏、底部手势条

### 7.3 特殊处理

**iOS**:
- `-webkit-tap-highlight-color: transparent` 去除点击高亮
- 输入框聚焦时禁止页面缩放（viewport设置）
- 日期选择器使用原生样式

**Android**:
- 去除默认蓝色点击态
- 底部导航栏适配（可能占用额外空间）

---

## 8. 图标规范

### 8.1 图标库

使用 **Iconfont** 或 **SVG Sprite**，统一图标管理。

### 8.2 图标尺寸

| 场景 | 尺寸 | 颜色 |
|------|------|------|
| 导航栏图标 | 24px | --color-text-primary |
| 列表项图标 | 20px | --color-text-tertiary |
| 按钮内图标 | 16px | 继承按钮文字色 |
| 状态图标 | 16px | 对应状态色 |
| 空状态图标 | 80px | --color-text-quaternary |

### 8.3 必需图标清单

| 图标名 | 用途 | 来源 |
|--------|------|------|
| back | 返回 | Vant Icon |
| search | 搜索 | Vant Icon |
| share | 分享 | Vant Icon |
| delete | 删除 | Vant Icon |
| like / like-o | 赞 | Vant Icon |
| dislike / dislike-o | 踩 | Vant Icon |
| comment-o | 评论 | Vant Icon |
| chat-o | 回复 | Vant Icon |
| fire-o | Hot | Vant Icon |
| clock-o | 时间 | Vant Icon |
| plus | 添加图片 | Vant Icon |
| close | 关闭 | Vant Icon |
| arrow | 右箭头 | Vant Icon |
| arrow-down | 下拉 | Vant Icon |
| arrow-up | 上拉 | Vant Icon |
| checked / checked-o | 选中 | Vant Icon |
| warning-o | 警告 | Vant Icon |
| info-o | 提示 | Vant Icon |
| success | 成功 | Vant Icon |
| fail | 失败 | Vant Icon |
| photo-o | 图片 | Vant Icon |
| play-group-o | 视频播放 | Vant Icon |
| location-o | 位置 | Vant Icon |
| phone-o | 电话 | Vant Icon |
| mail-o | 邮件 | Vant Icon |
| user-o | 用户 | Vant Icon |
| setting-o | 设置 | Vant Icon |
| more-o | 更多 | Vant Icon |
| bell | 通知 | Vant Icon |
| translate | 翻译 | 自定义SVG |
| adopt | 采纳 | 自定义SVG |
| verified | V认证 | 自定义SVG |
| brand-gac | GAC品牌 | 自定义SVG |

---

## 9. Spec Coding 组件生成指令

### 9.1 生成问题卡片

```
基于UI设计规范，生成Vue 3 + Vant的QuestionCard组件：
- 使用Props接口：QuestionCardProps（见3.1节）
- 样式严格遵循Design Token：颜色/字体/间距/圆角
- 图片区域：1张占满宽度，2-3张横向排列（100px×100px）
- 回答预览区：灰色背景#F5F5F5，圆角8px，padding 12px
- 官方号标识：头像40px + V徽章16px + 品牌标签 + 职位
- Adopt标记：右上角绿色印章
- 搜索高亮：关键词红色高亮
- 点击跳转：emit 'click' 事件，传入questionId
- 使用Vant组件：van-image（懒加载）、van-tag
```

### 9.2 生成回答卡片

```
基于UI设计规范，生成Vue 3 + Vant的AnswerCard组件：
- 使用Props接口：AnswerCardProps（见3.2节）
- 包含：回答者信息区、内容区、操作栏、嵌套回复区
- Accept按钮：仅isAuthor=true时显示，主按钮small
- 投票按钮：👍/👎图标 + 数字，已投态变色
- 嵌套回复：左边距48px，回复关系"Wayne ▸ Billy"格式
- Author标签：红色12px文字
- 翻译按钮：文字按钮，点击触发翻译API
- 使用Vant组件：van-button、van-image、van-icon
```

### 9.3 生成首页页面

```
基于UI设计规范和PRD 05.02，生成NuxtJS页面 pages/index.vue：
- 布局：AppHeader + BrandSection + StatsSection + TabBar + QuestionList + BottomFixedButton
- 状态管理：Pinia store管理列表状态（loading/error/empty/hasMore）
- 无限滚动：Vant List组件，每次加载20条
- 下拉刷新：Vant PullRefresh组件
- Tab切换：Hot/Newest/My Question，切换时重置列表
- Ask按钮：底部固定，适配安全区
- 空状态：van-empty组件，描述"暂无问题，快来提问吧"
- 骨架屏：自定义Skeleton组件（3行）
- API调用：GET /api/v1/groups/{groupId}/questions?tab={tab}&page={page}
```

### 9.4 生成管理后台表格

```
基于UI设计规范，生成Vue 3 + Ant Design Vue的管理后台列表页：
- 使用组件：a-table、a-form、a-input、a-select、a-button、a-drawer
- 表格列：按PRD 05.07定义
- 筛选区：表单布局，标签右对齐
- 批量操作：选中行后显示批量操作栏
- 分页：a-pagination，默认20条
- 抽屉：右侧600px，用于编辑/查看详情
- 权限：v-permission指令控制按钮显示
```

---

## 附录 A：Vant 组件映射表

| 自定义组件 | Vant基础组件 | 说明 |
|-----------|-------------|------|
| AppHeader | van-nav-bar | 自定义样式 |
| PrimaryButton | van-button (type=primary, round) | |
| SecondaryButton | van-button (type=default, round) | 自定义边框色 |
| TextButton | van-button (type=default, plain) | 无边框 |
| Input | van-field | 表单输入 |
| Textarea | van-field (type=textarea) | 多行输入 |
| ImageUploader | van-uploader | 图片上传 |
| ConfirmDialog | van-dialog | 确认弹窗 |
| ActionSheet | van-action-sheet | 底部面板 |
| HalfScreenModal | van-popup (position=bottom, round) | 半屏弹窗 |
| PullRefresh | van-pull-refresh | 下拉刷新 |
| ListLoading | van-list | 无限滚动 |
| Toast | van-toast | 轻提示 |
| Skeleton | van-skeleton | 骨架屏 |
| BrandLabel | van-tag (type=default, size=medium) | 自定义样式 |
| StatusTag | van-tag | 自定义颜色 |
| Empty | van-empty | 空状态 |
| Loading | van-loading | 加载中 |
| ImagePreview | van-image-preview | 图片预览 |
| Search | van-search | 搜索输入 |
| Tabs | van-tabs | Tab切换 |
| Cell | van-cell | 列表项、导航项 |
| Checkbox | van-checkbox | 复选框 |
| Switch | van-switch | 开关 |
| Picker | van-picker | 选择器 |
| DatetimePicker | van-datetime-picker | 时间选择 |
| Stepper | van-stepper | 步进器 |
| Rate | van-rate | 评分 |
| Progress | van-progress | 进度条 |
| Group | van-circle | 环形进度 |
| NoticeBar | van-notice-bar | 通知栏 |
| Swipe | van-swipe | 轮播 |
| Grid | van-grid | 宫格 |
| Divider | van-divider | 分割线 |
| Sticky | van-sticky | 吸顶 |
| SwipeCell | van-swipe-cell | 滑动单元格 |
| IndexBar | van-index-bar | 索引栏 |

---

## 附录 B：Less 变量文件

```less
// assets/styles/variables.less

// 颜色
@primary: #009EFF;
@primary-light: #008FE6;
@primary-bg: #E5F3FF;
@warning: #EB0A1E;
@warning-bg: #FFEFE0;
@tip: #FFA762;
@tip-bg: #FFF8F2;
@text-primary: #191A1D;
@text-secondary: #363F4F;
@text-tertiary: #697588;
@text-quaternary: #9FA9BB;
@divider: #CAD1DD;
@bg-page: #EAEDF6;
@bg-card: #F8FAFD;
@bg-white: #FFFFFF;
@success: #52C41A;
@error: #EB0A1E;
@info: #009EFF;
@disabled: #C8C9CC;

// 字体
@font-size-h1: 20px;
@font-size-h2: 18px;
@font-size-h3: 16px;
@font-size-body: 14px;
@font-size-small: 12px;
@font-size-tiny: 10px;

// 间距
@space-1: 4px;
@space-2: 8px;
@space-3: 12px;
@space-4: 16px;
@space-5: 20px;
@space-6: 24px;
@space-8: 32px;
@space-10: 40px;
@space-12: 48px;

@page-padding: 16px;
@section-gap: 12px;
@card-padding: 16px;
@card-gap: 12px;

// 圆角
@radius-sm: 4px;
@radius-md: 8px;
@radius-lg: 12px;
@radius-xl: 16px;
@radius-full: 9999px;

// 阴影
@shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
@shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
@shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12);
@shadow-float: 0 -4px 16px rgba(0, 0, 0, 0.1);
```

---

## 附录 C：Ant Design Vue 后台主题定制

```typescript
// operation-admin/src/theme.ts
import type { ThemeConfig } from 'ant-design-vue';

export const theme: ThemeConfig = {
  token: {
    colorPrimary: '#009EFF',
    colorSuccess: '#52C41A',
    colorWarning: '#FAAD14',
    colorError: '#EB0A1E',
    colorInfo: '#009EFF',
    borderRadius: 4,
    borderRadiusSM: 4,
    borderRadiusLG: 8,
    fontSize: 14,
    fontSizeSM: 12,
    fontSizeLG: 16,
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    // 侧边栏
    colorBgLayout: '#f0f2f5',
    // 表格
    colorBgContainer: '#ffffff',
    // 按钮
    controlHeight: 32,
    controlHeightLG: 40,
    controlHeightSM: 24,
  },
};
```
