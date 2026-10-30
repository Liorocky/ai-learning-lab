# AI Learning Lab

**在线浏览 → https://ai.lior.ren/**

把大模型与 AI 工程里容易混淆的机制，做成**可以亲手操作的单页实验**。每个页面都是自包含的 HTML：无依赖、无构建步骤、无后端、不调用任何 API，双击即可打开。

仓库同时也是这些页面的归档目录——按主题分类，持续增补。

## 快速开始

直接访问线上版：**https://ai.lior.ren/**

本地运行：

```bash
git clone https://github.com/Liorocky/ai-learning-lab.git
cd ai-learning-lab
```

用浏览器打开 `html/index.html`，它就是所有页面的导航台（支持按分类筛选和关键词搜索）。

> 页面全部是纯静态资源，`file://` 协议下即可完整运行；也可以用任意静态服务器预览。

## 要新增页面？先读 [DESIGN.md](DESIGN.md)

`DESIGN.md` 是**所有页面样式与结构的唯一规范来源**：设计令牌、组件清单、页面骨架、文案规则、自检清单都在里面。配色改 `html/assets/tokens.css`，组件改 `html/assets/lab.css`。

- 组件库的活示例：[`html/_template/index.html`](html/_template/index.html)（可直接打开，所有可用组件都在这一页）
- 参考实现：[`html/llm-core/llm-runtime-lab/index.html`](html/llm-core/llm-runtime-lab/index.html)
- 让 AI 接手时：把仓库路径告诉它，或直接说「读 DESIGN.md，新增一个 XX 页面」

## 目录结构

```text
ai-learning-lab/
├── README.md                    # 本文件：仓库说明
├── DESIGN.md                    # 页面开发规范（唯一来源）
├── AGENTS.md                    # AI 工具入口：约束与命令速查
├── .gitignore
├── .github/
│   └── workflows/
│       └── pages.yml            # 推送 main 后自动部署 html/ 到 GitHub Pages
├── scripts/
│   └── new-page.sh              # 生成页面骨架，自动修正相对路径与标题
└── html/
    ├── index.html               # 总索引：分类导航 + 搜索
    ├── CNAME                    # 自定义域名 ai.lior.ren
    ├── favicon.svg              # 站点图标（Lucide sparkles，ISC 协议）
    ├── assets/
    │   ├── tokens.css           # 设计令牌 + 基础层：改配色只改这里
    │   └── lab.css              # 通用组件：顶栏、卡片、控件、表格
    ├── _template/
    │   └── index.html           # 组件库 + 起手模板（不登记到索引）
    ├── llm-core/                # 大模型基础机制
    │   └── llm-runtime-lab/
    │       └── index.html
    ├── prompting/               # 提示工程与输出控制
    ├── rag/                     # 检索增强与知识库
    ├── agents/                  # Agent 与工具调用
    ├── engineering/             # 工程化与运维
    └── playground/              # 实验场：草稿与零散想法
```

### 分类约定

| 目录 | 放什么 | 典型主题 |
| --- | --- | --- |
| `llm-core/` | 模型自身怎么运转 | tokenizer、上下文窗口、注意力、采样与解码、KV Cache、微调与对齐 |
| `prompting/` | 如何组织输入与约束输出 | 结构化输出、few-shot、CoT、失败重试、schema 校验 |
| `rag/` | 外部知识的接入链路 | 切分策略、embedding、向量检索、rerank、引用与召回评估 |
| `agents/` | 模型如何行动 | function calling、规划、多智能体、workflow、human-in-the-loop |
| `engineering/` | 让它稳定又便宜地跑起来 | 推理性能、缓存、成本测算、评估体系、可观测性、灰度与回滚 |
| `playground/` | 还没想好归类的 | 草图、一次性试验、视觉化小玩具 |

分类不追求学术严谨，只求**新增页面时能立刻决定它该放哪**。确实归不进去的，先扔 `playground/`。

## 新增一个页面

```bash
# 1. 生成骨架（自动修正相对路径、标题）
bash scripts/new-page.sh rag chunking-lab "Chunking Lab"

# 2. 写内容，并把条目追加到 html/index.html 的 LABS 数组
# 3. 提交推送
git add -A && git commit -m "feat(rag): 新增 Chunking Lab" && git push
```

第 2 步的 `LABS` 条目：

```js
{
  cat: 'rag',                                  // 必须是 CATEGORIES 里的 key
  title: 'Chunking Lab',
  desc: '一句话说明这个页面能让人看见什么。',
  path: './rag/chunking-lab/index.html',
  tags: ['切分', 'chunk', 'overlap', '召回']
}
```

**漏了 `LABS`，页面在线但首页看不到** —— 这是新增页面唯一的常见遗漏。

具体的样式约束、组件用法、文案规则见 [DESIGN.md](DESIGN.md)。这里不再重复，避免两处规范漂移。

## 已有页面

| 页面 | 分类 | 说明 |
| --- | --- | --- |
| [LLM Runtime Lab](html/llm-core/llm-runtime-lab/index.html) | 大模型基础机制 | Token 切分、上下文预算、位置注意力、Temperature / Top-p / Top-k 采样模拟，附 26 条工程概念速查表（`logprobs`、`finish_reason`、Prompt Caching、`reasoning_content` 等，支持搜索） |

## 提交与同步

```bash
git add -A
git commit -m "feat(<分类>): 新增 <页面名>"
git push
```

提交信息用 `feat / fix / docs / chore` 前缀，括号里写分类目录名，方便回溯。

### 自动上线

推送到 `main` 会触发 [`.github/workflows/pages.yml`](.github/workflows/pages.yml)，该工作流把 `html/` 整个目录作为站点根发布到 GitHub Pages，通常 1–2 分钟生效：

**https://ai.lior.ren/**

因为发布根目录就是 `html/`，新增页面只要被索引页登记，推送后即可通过线上地址访问，无需改动任何部署配置。

### 自定义域名

站点绑定在 `ai.lior.ren`，相关配置分两处：

| 位置 | 内容 |
| --- | --- |
| 仓库 `html/CNAME` | `ai.lior.ren` —— 告诉 Pages 用哪个域名 |
| Cloudflare DNS | `CNAME` 记录：`ai` → `liorocky.github.io`，**必须为 DNS only（灰色云）** |

一旦开启橙色的代理状态，Cloudflare 会用自身 IP 应答，GitHub 无法完成域名验证、签不出证书，站点会卡在 `DNS check unsuccessful`。

`liorocky.github.io/ai-learning-lab/` 仍然有效，会自动 301 跳转到自定义域名。

## License

MIT
