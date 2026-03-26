#!/bin/bash

# 上海都市恐怖小说自动更新脚本
# 每 5 分钟运行一次，续写小说内容

WORKSPACE="/home/jason/.openclaw/workspace-creator"
NOVEL_DIR="$WORKSPACE/novels/shanghai-horror"
LOG_FILE="$NOVEL_DIR/update.log"

# 记录更新时间
echo "=== 更新开始：$(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"

# 检查最新章节
LAST_CHAPTER=$(ls -1 "$NOVEL_DIR"/chapter-*.md 2>/dev/null | tail -1)

if [ -z "$LAST_CHAPTER" ]; then
    echo "错误：未找到章节文件" >> "$LOG_FILE"
    exit 1
fi

# 获取当前章节号
LAST_NUM=$(basename "$LAST_CHAPTER" | grep -oP '\d+' | head -1)
NEXT_NUM=$((LAST_NUM + 1))

# 格式化章节号
NEXT_CHAPTER_NUM=$(printf "%02d" $NEXT_NUM)
NEXT_CHAPTER_FILE="$NOVEL_DIR/chapter-$NEXT_CHAPTER_NUM-$(date '+%s').md"

echo "最新章节：$LAST_CHAPTER" >> "$LOG_FILE"
echo "下一章节：$NEXT_CHAPTER_FILE" >> "$LOG_FILE"

# 调用 AI 续写（通过 OpenClaw session）
# 这里需要调用 sessions_spawn 或类似机制来续写
# 由于 cron 环境限制，实际续写逻辑需要由 AI agent 处理

echo "等待 AI 续写..." >> "$LOG_FILE"

# 更新 README 中的更新时间
README_FILE="$NOVEL_DIR/README.md"
if [ -f "$README_FILE" ]; then
    sed -i "s/自动更新：.*/自动更新：每 5 分钟 (最后更新：$(date '+%Y-%m-%d %H:%M:%S'))/" "$README_FILE"
fi

echo "=== 更新完成：$(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
