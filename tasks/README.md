# 任务清单

> NPS 问卷投放 V1.0 — 开发任务分解

## 任务总览

| 编号 | 任务 | 模块 | 优先级 | 实现技术 | 涉及 BR | 涉及 API |
|------|------|------|--------|----------|---------|----------|
| TASK-001 | 投放计划管理 | 05.01 | P0 | Vue 3 + Ant Design Vue + Spring Boot | BR-05.01-01 ~ 08 | 6 个 |
| TASK-002 | 定时下发任务 | 05.03 | P0 | Spring Boot + xxl-job | BR-05.03-01 ~ 08 | 1 个 |
| TASK-003 | App 问卷入口 | 05.04 | P0 | Flutter 原生 | BR-05.04-01 ~ 07 | 1 个 |
| TASK-004 | 问卷页 | 05.05 | P0 | Flutter WebView + H5(CSI) | BR-05.05-01 ~ 07 | 1 个 |
| TASK-005 | 投放数据管理 | 05.02 | P0 | Vue 3 + Ant Design Vue + Spring Boot | BR-05.02-01 ~ 08 | 5 个 |

---

## TASK-001 投放计划管理

**模块**：05.01 | **层级**：平台层 | **技术**：运营管理后台 + Spring Boot

| 子任务 | 描述 | 关键 AC |
|--------|------|---------|
| 1.1 计划列表 | 分页列表、模糊搜索、筛选（投放位置/创建时间/投放时间）、启用开关 | AC-05.01-01, AC-05.01-05 |
| 1.2 新建计划 | 右侧抽屉表单：名称/编码/位置/图片/URL明细/下发条件/车型/起止时间/冷却/日限量/显示时长 | AC-05.01-02, AC-05.01-03 |
| 1.3 编辑计划 | 同上，campaign_code 不可改 | AC-05.01-08 |
| 1.4 查看计划 | 抽屉只读展示 | AC-05.01-04 |
| 1.5 启用/停用 | Switch 切换，停用后不下发 | AC-05.01-05 |
| 1.6 删除计划 | 逻辑删除，二次确认 | AC-05.01-07 |
| 1.7 CSI 透传接收 | 接收 UOP 透传的计划数据，校验后保存/更新 | AC-05.01-01, AC-05.01-06 |
| 1.8 URL 比例校验 | 保存时校验各 URL 比例之和 = 100% | AC-05.01-02, AC-05.01-06 |
| 1.9 图片上传校验 | jpg/png/webp ≤ 3MB | AC-05.01-03 |
| 1.10 计划编码唯一校验 | 新建时检查 campaign_code 唯一 | AC-05.01-07 |

**API**：
- `POST /api/v1/campaigns` — CSI 透传（接收计划）
- `PUT /api/v1/campaigns/{campaignCode}` — CSI 透传（更新计划）
- `GET /api/v1/admin/campaigns` — 管理后台列表
- `POST /api/v1/admin/campaigns` — 管理后台创建
- `PUT /api/v1/admin/campaigns/{id}` — 管理后台更新
- `DELETE /api/v1/admin/campaigns/{id}` — 逻辑删除

---

## TASK-002 定时下发任务

**模块**：05.03 | **层级**：平台层 | **技术**：Spring Boot + xxl-job

| 子任务 | 描述 | 关键 AC |
|--------|------|---------|
| 2.1 xxl-job 调度 | 每日凌晨触发，可配置时刻，支持分片 | AC-05.03-01 |
| 2.2 计划筛选 | 仅处理启用 + 在起止时间内的计划 | AC-05.03-02 |
| 2.3 用户筛选 | 按 country/model/dispatch_condition 筛选已绑车用户 | AC-05.03-03 |
| 2.4 用户排序截断 | 按绑车时间由近到远，取前 N 名 | AC-05.03-04 |
| 2.5 URL 比例分配 | 随机分配问卷链接，一人一条 | AC-05.03-05 |
| 2.6 生成投放记录 | 批量写入 CampaignDelivery，设置 send_time/start_time/end_time | AC-05.03-06 |
| 2.7 CSI 数据同步 | 异步推送至 CSI，标记 push_status | AC-05.03-07 |
| 2.8 异常处理 | 比例异常跳过、服务不可用降级、事务回滚 | AC-05.03-08~11 |

**API**：
- `POST /api/v1/campaigns/deliveries/sync` — 投放数据同步至 CSI

---

## TASK-003 App 问卷入口

**模块**：05.04 | **层级**：业务层 | **技术**：Flutter 原生

| 子任务 | 描述 | 关键 AC |
|--------|------|---------|
| 3.1 问卷查询 | 获取车辆信息后调用问卷查询接口 | AC-05.04-01 |
| 3.2 显示规则判断 | 服务端返回 + 本地 coolOff + 投放时间段三重判断 | AC-05.04-02, AC-05.04-03 |
| 3.3 浮标组件 | 车控页右下角 FloatingButton，显示图片或默认 NPS 文案 | AC-05.04-03 |
| 3.4 关闭按钮 | 浮标右上 × 按钮，触发冷却计算 | AC-05.04-04 |
| 3.5 本地存储 | APP_AD_COOL_OFF_MAP 按 position + campaignCode 存储 | AC-05.04-04 |
| 3.6 冷却逻辑 | cool_off 小时计算，0 = 永久关闭 | AC-05.04-05, AC-05.04-08 |
| 3.7 多计划独立冷却 | 同位置不同 campaignCode 各自独立 | AC-05.04-09 |
| 3.8 完成/过期隐藏 | 已完成或过期的投放不再展示 | AC-05.04-06 |
| 3.9 异常容错 | 接口失败降级、图片加载失败回退、存储损坏兜底 | AC-05.04-07 |

**API**：
- `GET /api/v1/campaigns/user/surveys` — 用户问卷查询

---

## TASK-004 问卷页

**模块**：05.05 | **层级**：业务层 | **技术**：Flutter WebView 容器 + CSI H5

| 子任务 | 描述 | 关键 AC |
|--------|------|---------|
| 4.1 WebView 容器 | 加载 CSI H5 URL（已含 oneId），安全区/手势/主题适配 | AC-05.05-01, AC-05.05-06 |
| 4.2 加载失败重试 | H5 加载失败显示重试页 | AC-05.05-05 |
| 4.3 JSBridge 通道 | Flutter addJavaScriptChannel，H5 postMessage | AC-05.05-02 |
| 4.4 完成回调处理 | 收到 npsSurveyCompleted → 立即隐藏浮标 + 返回车控页 | AC-05.05-03 |
| 4.5 后台状态同步 | 异步调用完成接口，4 次重试（5min/10min/1hr） | AC-05.05-07, AC-05.05-08 |
| 4.6 幂等处理 | 已完成的记录重复调用返回成功 | AC-05.05-04 |
| 4.7 弱网重试 | 首次失败不影响用户侧（已提示成功） | AC-05.05-09 |
| 4.8 H5 未接入兜底 | JSBridge 缺失时浮标不消失 | AC-05.05-10 |

**API**：
- `POST /api/v1/campaigns/user/surveys/complete` — 完成上报

---

## TASK-005 投放数据管理

**模块**：05.02 | **层级**：平台层 | **技术**：运营管理后台 + Spring Boot

| 子任务 | 描述 | 关键 AC |
|--------|------|---------|
| 5.1 数据列表 | 分页列表、多维度筛选、手机号/邮箱脱敏 | AC-05.02-01, AC-05.02-02 |
| 5.2 导入 | 上传 Excel/CSV，按 campaign_code+one_id 匹配更新 | AC-05.02-03 |
| 5.3 导出 | 按筛选条件导出 Excel/CSV，≤ 10MB | AC-05.02-04 |
| 5.4 手动推送 | 勾选记录推送至 CSI，仅限未推送/失败状态 | AC-05.02-05, AC-05.02-09 |
| 5.5 删除 | 单条/批量逻辑删除，二次确认 | AC-05.02-07 |
| 5.6 导入校验 | 文件格式/大小校验、必填列检查、失败详情返回 | AC-05.02-07, AC-05.02-08 |
| 5.7 推送状态流转 | NOT_PUSHED → PUSHED/PUSH_FAILED，失败可重试 | AC-05.02-06 |

**API**：
- `GET /api/v1/admin/campaigns/deliveries` — 投放数据列表
- `POST /api/v1/admin/campaigns/deliveries/import` — 导入
- `POST /api/v1/admin/campaigns/deliveries/export` — 导出
- `POST /api/v1/admin/campaigns/deliveries/push` — 手动推送
- `DELETE /api/v1/admin/campaigns/deliveries/{id}` — 逻辑删除

---

## 公共/基础任务

| 编号 | 任务 | 说明 |
|------|------|------|
| BASE-01 | 数据库 DDL | t_campaign / t_campaign_url / t_campaign_delivery 建表 |
| BASE-02 | 权限配置 | Permission Code 注册与角色绑定 |
| BASE-03 | 多语言 i18n | zh-CN / en-US / th-TH 三语 ARB/JSON |
| BASE-04 | 错误码注册 | 41xx NPS 业务错误码 |
| BASE-05 | 操作审计日志 | 运营人员写操作记录 |
| BASE-06 | 单元测试 | 各模块 Controller/Service 单元测试 |
| BASE-07 | 集成测试 | API 端到端测试 |
| BASE-08 | 埋点上报 | campaign_entry_show/click/close、campaign_survey_complete |

---

## 依赖关系

```
TASK-001 (投放计划) ──→ TASK-002 (定时下发)
                            │
                    ┌───────┴───────┐
                    ↓               ↓
            TASK-005 (数据管理)  TASK-003 (App 入口)
                                    │
                                    ↓
                            TASK-004 (问卷页)
```

- BASE-01 须在 TASK-001/TASK-002/TASK-005 之前完成
- BASE-02 须与 TASK-001/TASK-005 同步
- TASK-003/TASK-004 依赖 TASK-002 生成投放记录
