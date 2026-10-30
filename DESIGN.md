# 页面开发规范

> 本文件是 AI Learning Lab 所有 HTML 页面的**唯一规范来源**。
> 新增或修改页面前请先读它；与本文件冲突的个人习惯以本文件为准。

## 0. 技术约束（不可突破）

| 约束 | 说明 |
| --- | --- |
| 单页自包含 | 一个页面 = 一个 `index.html` + 共享样式。无构建步骤、无 npm。 |
| 无后端 | 不请求任何 API，不做真实模型调用。所有数据在页面内模拟，并明确标注"示意"。 |
| `file://` 可开 | 双击必须能正常显示。禁止用 `fetch()` 读本地 JSON（会触发 CORS），数据直接写在 `<script>` 里。 |
| 唯一外部依赖 | Google Fonts 的 `@import`（在 `lab.css` 内）。断网时应优雅降级到等宽字体，不影响功能。 |
| 零依赖库 | 不引入 React/Vue/Chart.js 等。可视化用原生 DOM + SVG/Canvas 手写。 |

## 1. 目录约定

```
html/
├── index.html                 # 总索引，LABS 数组在这里注册
├── favicon.svg                # 全站图标
├── assets/
│   ├── tokens.css             # 设计令牌 + 基础层 + 字体（改配色只改这里）
│   └── lab.css                # 通用组件骨架，内部 @import tokens.css
├── _template/index.html       # 组件库 + 起手模板（不登记到索引）
├── llm-core/                  # 大模型基础机制
├── prompting/                 # 提示工程与输出控制
├── rag/                       # 检索增强与知识库
├── agents/                    # Agent 与工具调用
├── engineering/               # 工程化与运维
└── playground/                # 草稿与零散试验
```

页面路径固定为 `html/<分类>/<slug>/index.html`，**必须是目录 + index.html**，不要用 `html/rag/xxx.html` 这种平铺形式（相对路径会不一致）。

## 2. 设计令牌

改颜色**只改 `assets/tokens.css` 的 `:root`**，页面内不要出现十六进制色值（页面独有的可视化除外）。

三个文件分工明确，不要越界：

| 文件 | 职责 | 什么时候改 |
| --- | --- | --- |
| `assets/tokens.css` | 颜色变量、字体、`body` 基础、网格纹理、链接与选区默认表现 | 换配色、换字体 |
| `assets/lab.css` | 顶栏、首屏、章节、卡片、控件、表格等通用组件 | 调整组件外观 |
| 页面 `<style>` | 该页独有的可视化（热力图、色块、分布条） | 新增本页特有元素 |

引用方式：内容页只引 `lab.css`（内部 `@import tokens.css`）；索引页只引 `tokens.css`。**不要**在页面里再写一份 `:root`。

| 变量 | 值 | 用途 |
| --- | --- | --- |
| `--bg` | `#0a0c0b` | 页面底色 |
| `--panel` | `#111413` | 卡片背景 |
| `--panel2` | `#161a18` | 卡片内嵌块、表头 |
| `--ink` | `#e9e5dd` | 正文 |
| `--muted` | `#9b9a95` | 次要说明 |
| `--line` | `rgba(233,229,221,.14)` | 所有分隔线、边框 |
| `--lime` | `#cbff62` | 主强调色，每屏只用于 1–2 处 |
| `--blue` | `#63d7ff` | 数据、字段名、代码标识符 |
| `--orange` | `#ff8659` | 警示、风险、被排除的候选 |
| `--yellow` | `#ffd166` | 辅助区分（第三类数据） |
| `--red` | `#ff6574` | 错误、失败状态 |

字体：正文 `"IBM Plex Mono"`，标题 `"Noto Serif SC"`（由 `lab.css` 统一设置，页面内不要再写 `font-family`）。

**可读性下限**：正文对比度 ≥ 4.5:1（WCAG AA）。不要在深色底上用 `#6f716c` 这类中灰写正文——这是已经修过一次的问题。

## 3. 页面骨架

```html
<main class="shell">
  <header class="topbar">           ← 必须有：返回索引 + 页面名 + 运行状态
  <section class="hero">            ← 必须有：eyebrow / h1 / 一句话背景 / hero-note
  <div class="workflow">            ← 可选：页面讲一条链路时，4 段阶段条
  <section>                         ← 每个知识点一节，编号 01. 02. 03.
    <header class="section-head">   ← 标题 + 右对齐说明
    交互区（.grid > .card）
  </section>
  <aside class="callout">           ← 可选：把实验拉回生产
  <footer class="foot">             ← 必须有
</main>
```

路径层级（`html/<分类>/<slug>/`）：

```html
<link rel="stylesheet" href="../../assets/lab.css">
<link rel="icon" type="image/svg+xml" href="../../favicon.svg">
<a class="back" href="../../index.html">← 索引</a>
```

## 4. 可用组件

完整示例见 `html/_template/index.html`（可直接打开预览）。样式全部来自 `lab.css`，**不要重新定义**。

| 组件 | 类名 | 用于 |
| --- | --- | --- |
| 顶栏 | `.topbar` `.brand` `.pulse` `.status` `.back` | 每页必备 |
| 首屏 | `.hero` `.eyebrow` `.hero-note` | 每页必备 |
| 阶段条 | `.workflow` `.flow[data-n]`（5 段加 `.five`） | 链路式页面导航 |
| 章节头 | `.section-head` | 每节开头，左标题右说明 |
| 卡片/栅格 | `.grid`（两栏）`.grid.three` `.card` | 所有交互区 |
| 滑块 | `.control` + `input[type=range]` + `.value` | 参数调节 |
| 指标 | `.metrics` `.metric` | 3 个以内的数值快照 |
| 代码块 | `.code` + `.lime/.blue/.orange/.red` | 展示请求结构、伪代码 |
| 结论区 | `.decision` + `.btn` | 操作 → 结果 |
| 标签流 | `.chips` `.chip` | 累积输出的 token / 步骤 |
| 提示条 | `.alert`（`.bad` 为错误态） | 状态变化说明 |
| 概念表 | `.concept-search` `.concept-group` `.ctable` `.c-name/.c-api/.c-what/.c-when` | 附录式速查 |
| 收尾块 | `.callout` | 最后一屏 |
| 页脚 | `.foot` | 每页必备 |

页面独有样式写在**自己的 `<style>`** 里，并遵守：只写 `lab.css` 没有的类，不要覆盖通用组件的布局。

## 5. 文案规则

标题**写成断言，不写名词短语**：

- ✗ `Token 介绍` → ✓ `Token 不是字符，也不是词。`
- ✗ `上下文窗口` → ✓ `窗口是共享预算，不是输入上限。`

每节 `section-head > p` 说明**怎么操作、看什么**，不复述标题。

概念表第四列「什么时候会想起它」写**触发场景**，不写定义：

- ✗ `用于控制随机性` → ✓ `JSON 解析失败时的第一站——先分清是截断还是模型自己收尾`

模拟数据必须标注不确定性，例如：`示意曲线，不代表任何具体模型的权重`。

## 6. 新增页面（三步）

```bash
# 1. 生成骨架（自动修正路径与标题）
bash scripts/new-page.sh rag chunking-lab "Chunking Lab"

# 2. 写内容；同时在 html/index.html 的 LABS 数组追加一项
#    { cat:'rag', title:'Chunking Lab', desc:'…',
#      path:'./rag/chunking-lab/index.html', tags:['切分','chunk'] }

# 3. 提交推送（1–2 分钟后自动上线）
git add -A && git commit -m "feat(rag): 新增 Chunking Lab" && git push
```

`LABS` 是索引页唯一的数据源，**忘了注册 = 页面在线但首页看不到**，这是最常见的遗漏。

## 7. 交付前自检

- [ ] 直接双击 `index.html`（`file://`）能正常显示，控制台无报错
- [ ] 窄屏 375px 下无横向溢出、无重叠
- [ ] 所有交互控件都有实际反馈，不是静态图
- [ ] 正文对比度 ≥ 4.5:1；没有 `#6f716c` 级别的灰字承载正文
- [ ] 返回索引链接可点，路径深度正确
- [ ] 已追加到 `LABS` 数组
- [ ] 没有引入外部库、没有 `fetch()` 本地文件
- [ ] 模拟数据有"示意"标注

## 8. 已知易错点

| 问题 | 原因 | 处理 |
| --- | --- | --- |
| 子页面样式全丢 | 复制模板没改路径深度 | 用 `scripts/new-page.sh` 生成 |
| 首页看不到新页面 | 漏改 `LABS` | 检查 `html/index.html` 数组 |
| 本地能开、线上白屏 | 用了 `fetch()` 或绝对路径 `/assets/...` | 改相对路径 + 内联数据 |
| 表头看不清 | 深灰小字 | 表头用 `#d6d7cf` 12px 600（已在 `lab.css`） |
| 主题改了但部分页面没变 | 页面内联又写了一份 `:root` | 全局搜 `--lime:`，它只应出现在 `tokens.css` |
| 页面样式全丢、变白底 | `lab.css` 路径错，或 `@import tokens.css` 被移到规则之后 | `@import` 必须在文件所有规则之前 |
