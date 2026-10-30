#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────
# 生成一个新的 lab 页面骨架
#
#   bash scripts/new-page.sh <分类> <slug> "<页面标题>"
#   bash scripts/new-page.sh rag chunking-lab "Chunking Lab"
#
# 它会：创建目录 → 复制模板 → 修正相对路径与标题
# 不会：改内容、注册到索引页（这两步需要手动，见输出提示）
# ────────────────────────────────────────────────────────────
set -euo pipefail

HTML_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../html" && pwd)"
CAT="${1:-}"
SLUG="${2:-}"
TITLE="${3:-}"

if [ -z "$CAT" ] || [ -z "$SLUG" ] || [ -z "$TITLE" ]; then
  echo "用法: bash scripts/new-page.sh <分类> <slug> \"<页面标题>\""
  echo
  echo "可用分类:"
  find "$HTML_DIR" -maxdepth 1 -mindepth 1 -type d \
    ! -name '_template' ! -name 'assets' -printf '  %f\n' | sort
  exit 1
fi

if [ ! -d "$HTML_DIR/$CAT" ]; then
  echo "✗ 分类不存在: html/$CAT/"
  echo "  现有分类: $(find "$HTML_DIR" -maxdepth 1 -mindepth 1 -type d ! -name '_template' ! -name 'assets' -printf '%f ')"
  exit 1
fi

DIR="$HTML_DIR/$CAT/$SLUG"
if [ -e "$DIR" ]; then
  echo "✗ 目录已存在: html/$CAT/$SLUG/"
  exit 1
fi

mkdir -p "$DIR"

# 页面层级比模板深一级，所有 ../ 需要变成 ../../
# 用 | 作分隔符，避免路径里的 / 冲突
sed -e 's|"\.\./|"../../|g' \
    -e "s|<title>页面模板|<title>$TITLE|" \
    -e "s|> 页面标题\$|> $TITLE|" \
    "$HTML_DIR/_template/index.html" > "$DIR/index.html"

echo "✓ 已生成 html/$CAT/$SLUG/index.html"
echo
echo "接下来三件事："
echo "  1. 编辑 index.html —— 改 <meta description>、首屏 h1/p、各章节内容"
echo "  2. 在 html/index.html 的 LABS 数组追加一项："
echo "       { cat:'$CAT', title:'$TITLE', desc:'…',"
echo "         path:'./$CAT/$SLUG/index.html', tags:['…'] }"
echo "  3. 提交推送"
echo "       git add -A && git commit -m \"feat($CAT): 新增 $TITLE\" && git push"
echo
echo "本地预览: open html/$CAT/$SLUG/index.html"
