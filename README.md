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

## 目录结构

```text
ai-learning-lab/
├── README.md                    # 本文件：仓库说明与写作规范
├── .gitignore
├── .github/
│   └── workflows/
│       └── pages.yml            # 推送 main 后自动部署 html/ 到 GitHub Pages
└── html/
    ├── index.html               # 总索引：分类导航 + 搜索
    ├── CNAME                    # 自定义域名 ai.lior.ren
    ├── _template/               # 新页面的起手模板（不对外展示）
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

1. **建目录**：`html/<分类>/<slug>/index.html`，`slug` 用小写短横线命名（如 `context-budget-calc`）。
2. **从模板起步**：复制 `html/_template/index.html`，改标题与内容。模板里已经带好返回索引的链接和统一的设计令牌。
3. **登记到索引**：打开 `html/index.html`，在 `LABS` 数组里追加一项：

   ```js
   {
     cat: 'rag',                                  // 必须是 CATEGORIES 里的 key
     title: 'Chunking Lab',
     desc: '一句话说明这个页面能让人看见什么。',
     path: './rag/chunking-lab/index.html',
     tags: ['切分', 'chunk', 'overlap', '召回']
   }
   ```

4. **自测**：本地打开 `html/index.html`，确认卡片能点开、返回索引正常、移动端不横向溢出。

### 写作约定

- **单文件自包含**：CSS 与 JS 内联，不引外部资源（Google Fonts 可选，需有系统字体兜底）。
- **相对路径**：页面位于 `html/<分类>/<slug>/`，回到索引是 `../../index.html`。
- **一个页面只讲一个机制**：宁可多做几个小页面，也不要把三个主题塞进一页。
- **说清边界**：如果页面里的数据是教学近似值（模拟分词、示意曲线），必须在页面上明确标注，不要把示意值说成官方数值。
- **配色**：深色底 `#0a0c0b` + 石灰绿强调 `#cbff62`，与既有页面保持一致。

## 已有页面

| 页面 | 分类 | 说明 |
| --- | --- | --- |
| [LLM Runtime Lab](html/llm-core/llm-runtime-lab/index.html) | 大模型基础机制 | Token 切分、上下文预算、位置注意力、Temperature / Top-p / Top-k 采样模拟 |

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
