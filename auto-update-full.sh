#!/bin/bash

# 上海恐怖小说 - 全自动更新脚本
# 通过 OpenClaw Gateway API 创建子 agent 任务

NOVEL_DIR="/home/jason/.openclaw/workspace-creator/novels/shanghai-horror"
STATE_FILE="$NOVEL_DIR/.update-state.json"
LOG_FILE="$NOVEL_DIR/.auto-update.log"
GATEWAY_URL="http://localhost:19000"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 开始检查更新 ==="

# 检查是否需要更新
NEED_UPDATE=false
if [ -f "$STATE_FILE" ]; then
    LAST_UPDATE=$(grep -o '"lastUpdate"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
    if [ -n "$LAST_UPDATE" ]; then
        LAST_TS=$(date -d "$LAST_UPDATE" +%s 2>/dev/null || echo 0)
        NOW_TS=$(date +%s)
        DIFF=$(( (NOW_TS - LAST_TS) / 60 ))
        
        log "距离上次更新：${DIFF} 分钟"
        
        if [ $DIFF -ge 30 ]; then
            NEED_UPDATE=true
            log "超过 30 分钟，需要更新"
        else
            log "不足 30 分钟，跳过更新"
            exit 0
        fi
    fi
fi

if [ "$NEED_UPDATE" = false ]; then
    log "无需更新，退出"
    exit 0
fi

log "开始创建子 agent 任务..."

# 创建子 agent 会话
# 使用 openclaw agent 命令运行一次性任务
TASK_PROMPT="请续写上海恐怖小说《静安寺路的第十三级台阶》下一章。

要求：
1. 阅读 $NOVEL_DIR/STORY-BIBLE.md 了解故事框架
2. 阅读 $NOVEL_DIR/ 下最新章节
3. 新章节字数：3500-4500 字
4. 保存为 chapter-XX-标题.md 格式
5. 更新 README.md 的章节列表
6. 更新 $NOVEL_DIR/.update-state.json
7. Git 提交并推送到 GitHub
8. 在飞书群 oc_dcf59834784e60c1ca436f72f13e37fb 汇报更新结果

现在请开始工作。"

# 使用 openclaw agent 运行一次性任务
OUTPUT=$(cd "$NOVEL_DIR" && openclaw agent \
  --prompt "$TASK_PROMPT" \
  --cwd "$NOVEL_DIR" \
  2>&1)

EXIT_CODE=$?

log "子 agent 执行完成，退出码：$EXIT_CODE"
log "输出：$OUTPUT"
log "=== 更新完成 ==="
log ""

# 发送通知到飞书群（如果成功）
if [ $EXIT_CODE -eq 0 ]; then
    # 提取最新章节信息
    if [ -f "$STATE_FILE" ]; then
        CHAPTER=$(grep -o '"latestChapter"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
        WORDS=$(grep -o '"totalWords"[^,]*' "$STATE_FILE" | grep -o '[0-9]*')
        
        # 这里可以通过飞书 API 发送通知
        log "✅ 更新成功：$CHAPTER (总字数：$WORDS)"
    fi
else
    log "❌ 更新失败，请检查日志"
fi

exit $EXIT_CODE
