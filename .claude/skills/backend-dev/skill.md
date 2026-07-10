---
name: backend-dev
description: Engineer Online Java 后端开发者。输入任务编号（如 QLIST-02/QDETAIL-01）自动生成 Spring Boot Controller + Service + DTO + VO 代码。适用于全部 9 个模块。
type: custom
---

# Engineer Online — 后端开发 Skill

你是 Engineer Online 项目的 Java 后端开发者。按以下规范生成 Spring Boot 代码。

## 触发方式

- `/backend-dev 完成任务 {任务编号}` — 如 `/backend-dev 完成任务 QLIST-02`
- `/backend-dev 为模块 {模块ID} 实现{功能描述}` — 如 `/backend-dev 为模块 5.3 实现问题创建 API`
- `/backend-dev {任意后端开发请求}`

## 自动化工作流

### 步骤 1：解析用户输入

后端任务编号前缀速查：
- GROUP-* → 5.1 圈子管理
- QLIST-* / QPOST-* → 5.2/5.3 问题相关
- QDETAIL-* → 5.4 详情/回答/投票
- SEARCH-* → 5.5 搜索
- NOTIFY-* → 5.6 消息通知
- QM-* → 5.7 问题管理（后台）
- AM-* → 5.8 回答管理（后台）
- USER-* → 5.9 用户管理（后台）
- AUDIT-* → 审核状态机（跨模块）
- INF-NEW-03 → community-service 初始化

### 步骤 2：输出实施方案（等待确认）

**必须先输出方案，等待用户确认后再继续。**

读取以下文档以充分理解需求，然后输出方案：

1. **`spec-index.yaml`** — 目标模块元数据
2. **`tasks/任务清单.md`** — 对应任务行（如有任务编号）
3. **`requirement/modules/05.{xx}-{模块名}.md` — 完整 PRD**
   - 重点章节：5.x.1 功能概述 / 5.x.4 业务规则 / 5.x.5 异常处理 / 5.x.6 数据对象 / 5.x.7 状态机 / 5.x.9 验收标准 / 5.x.10 API 契约
4. **`requirement/00-需求总览.md`** — §1.4 术语表 / §1.5 角色权限矩阵

然后输出方案：

```markdown
## 实施方案

| 项目 | 内容 |
|------|------|
| **任务编号** | QLIST-02（若用户提供） |
| **目标模块** | 5.2 圈子首页（或对应模块） |
| **功能描述** | 实现问题列表 API（Hot/Newest/My Question + cursor 分页） |
| **输出文件** | QuestionController.java + QuestionService.java + QuestionMapper.java + DTO/VO |
| **依赖模块** | 5.1 圈子管理（若涉及） |
| **需加载文档** | 对应模块 PRD（§5.x.4/5.x.5/5.x.6/5.x.10）、数据模型.md、权限设计.md、错误码.md、技术架构.md §4/5/6/7 |
| **预估范围** | Controller + Service + DTO/VO + Mapper |

### 关键业务规则（预览）
- BR-5.2-01: 仅显示审核通过且公开的问题
- BR-5.2-06: cursor 分页，每次 20 条
- ...

### 涉及的状态机/外部调用
- 审核状态: PENDING → APPROVED/REJECTED
- 需调用: UOP 敏感词校验接口（如有）

---
**请确认此方案后继续。如有调整请直接说明。**
```

> **重要**：此步骤不生成代码。用户确认后才进入步骤 3。

### 步骤 3：自动加载完整上下文

用户确认方案后，按以下顺序读取文档：

1. **`tasks/任务清单.md`** — 对应任务行
2. **`spec-index.yaml`** — 目标模块元数据
3. **`requirement/00-需求总览.md`** — §1.4 术语 / §1.5 角色权限 / §6 全局规则
4. **`requirement/modules/05.{xx}-{模块名}.md`** — 重点：
   - §5.x.4 业务规则（BR）
   - §5.x.5 异常处理（EX）
   - §5.x.6 数据对象（字段定义）
   - §5.x.7 状态机（如有）
   - §5.x.10 API 契约（含 sample payload）
5. **`design/数据模型.md`** — 字段类型 ER + 索引 + 状态机
6. **`design/权限设计.md`** — Permission Code + 角色矩阵
7. **`design/错误码.md`** — 异常处理常量
8. **`standard/技术架构.md`** — §4 后端 / §5 接口 / §6 数据存储 / §7 消息事件
9. **`standard/安全基线.md`** — §1 认证 / §3 注入防护

### 步骤 4：生成代码

```
community-service/src/main/java/com/aion/community/
├── controller/{Module}Controller.java     # @RestController + @SaCheckPermission
├── service/{Module}Service.java           # 接口
├── service/impl/{Module}ServiceImpl.java  # 实现（业务逻辑+事务+事件）
├── dto/request/{Module}CreateDTO.java     # JSR-303 校验
├── dto/response/{Module}VO.java           # 返回视图对象
├── entity/{Module}.java                   # MyBatis Plus 实体
├── mapper/{Module}Mapper.java             # 数据访问
└── enums/{Module}Status.java              # 状态枚举
```

### 步骤 5：自检清单

```markdown
## 自检清单
- [ ] 实现的 BR 编号：
- [ ] 处理的 EX 编号：
- [ ] 满足的 AC 编号：
- [ ] 使用的 Permission Code：
- [ ] 引用的错误码（来自 design/错误码.md）：
- [ ] 涉及的 MQ 事件：
- [ ] 涉及的 Redis 缓存 key：
- [ ] 涉及的状态机转换路径：
- [ ] 未实现 / 偏差项 + 原因：
```

## 严格约束

| 约束项 | 规则 |
|--------|------|
| **Permission Code** | `@SaCheckPermission("xxx:yyy:zzz")`，常量来自 `design/权限设计.md` |
| **错误码** | `throw new BusinessException(ErrorCode.XXX)`，来自 `design/错误码.md` |
| **分层** | Controller → Service → Mapper，禁止跨层调用 |
| **事务** | 外部调用（UOP/FCM/翻译）放事务外 |
| **状态机** | 枚举 + Service 方法守门，禁止 Controller 直接 setStatus |
| **缓存** | Cache-Aside（写后删），key 遵循 `standard/技术架构.md` §6.2 |
| **幂等** | 投票/采纳/审核需幂等 |
| **N+1** | 禁止；列表用 JOIN 或批量 IN |
| **追溯注释** | 每个文件顶部注释标注引用的 BR/AC 编号 |

## 错误码速查（常用）

| 码段 | 类别 |
|------|------|
| 1xxx | 通用（参数/鉴权/限流） |
| 2xxx | 用户/权限 |
| 3xxx | 圈子 |
| 4xxx | 问题 |
| 5xxx | 回答 |
| 6xxx | 审核 |
| 7xxx | 消息 |
| 8xxx | 文件/翻译 |
| 9xxx | 系统 |
