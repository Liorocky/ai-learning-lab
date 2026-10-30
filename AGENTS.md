# AGENTS.md

本仓库是一个纯静态的交互式学习站点：每个页面把 LLM / AI 工程里的某个机制做成**可以亲手操作的单页实验**。

线上地址：https://ai.lior.ren/

## 开始任何页面前

**先读 [DESIGN.md](DESIGN.md)。** 它定义了设计令牌、组件清单、页面骨架、文案规则与自检清单。不要凭感觉另起一套样式。

组件库的活示例在 `html/_template/index.html`，可直接打开看所有可用组件。

## 硬性约束

- 单页自包含：一个 `index.html` + 共享 `html/assets/lab.css`，无构建、无 npm、无框架。
- 不调用任何外部 API，所有数据在页面内模拟，且标注"示意"。
- 双击 `file://` 必须可用 —— 禁止 `fetch()` 读本地文件，数据直接写在 `<script>` 里。
- 样式改动分层：配色/字体改 `html/assets/tokens.css`，组件改 `html/assets/lab.css`，页面只写自己独有的可视化。不要在页面里重写 `:root`。
- 页面路径固定 `html/<分类>/<slug>/index.html`。

## 常用命令

```bash
# 新建页面骨架（自动修正相对路径与标题）
bash scripts/new-page.sh rag chunking-lab "Chunking Lab"

# 本地预览
open html/index.html

# 提交
git add -A && git commit -m "feat(rag): 新增 Chunking Lab" && git push
```

推送到 `main` 后由 `.github/workflows/pages.yml` 自动部署，1–2 分钟生效。

## 分类目录

`llm-core`（模型机制）、`prompting`（提示与输出控制）、`rag`（检索与知识库）、`agents`（工具调用与规划）、`engineering`（性能/成本/观测）、`playground`（草稿）。

拿不准就往 `playground` 放。

## 提交规范

`feat|fix|docs|style|chore(<分类目录名>): 说明`

## 新增页面唯一的遗漏点

在 `html/index.html` 的 `LABS` 数组里追加条目。漏了它，页面在线但首页看不到。
