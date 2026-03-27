#!/bin/bash

# 上海恐怖小说自动更新脚本
# 通过 OpenClaw sessions_spawn 触发 AI 续写

NOVEL_DIR="/home/jason/.openclaw/workspace-creator/novels/shanghai-horror"
STATE_FILE="$NOVEL_DIR/.update-state.json"
LOG_FILE="$NOVEL_DIR/.auto-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 开始检查更新 ==="

# 检查是否需要更新
if [ -f "$STATE_FILE" ]; then
    LAST_UPDATE=$(grep -o '"lastUpdate"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
    if [ -n "$LAST_UPDATE" ]; then
        LAST_TS=$(date -d "$LAST_UPDATE" +%s 2>/dev/null || echo 0)
        NOW_TS=$(date +%s)
        DIFF=$(( (NOW_TS - LAST_TS) / 60 ))
        
        log "距离上次更新：${DIFF} 分钟"
        
        if [ $DIFF -lt 30 ]; then
            log "不足 30 分钟，跳过更新"
            exit 0
        fi
    fi
fi

log "开始续写新篇章..."

# 创建任务请求文件
TASK_FILE="$NOVEL_DIR/.task-request.json"
cat > "$TASK_FILE" << 'EOF'
{
  "task": "续写上海恐怖小说《静安寺路的第十三级台阶》下一章",
  "instructions": [
    "1. 阅读 STORY-BIBLE.md 了解故事框架",
    "2. 阅读最新章节，保持剧情连贯",
    "3. 新章节字数：3500-4500 字",
    "4. 保存为 chapter-XX-标题.md 格式",
    "5. 更新 README.md 的章节列表",
    "6. 更新 .update-state.json",
    "7. Git 提交并推送到 GitHub",
    "8. 在群里汇报更新结果"
  ],
  "workspace": "/home/jason/.openclaw/workspace-creator/novels/shanghai-horror"
}
EOF

# 使用 OpenClaw sessions_spawn 创建子 agent 任务
# 注意：这需要 OpenClaw CLI 支持
SESSION_OUTPUT=$(openclaw sessions spawn \
  --task "请续写上海恐怖小说《静安寺路的第十三级台阶》下一章。阅读 STORY-BIBLE.md 和最新章节，写 3500-4500 字，保存为 chapter-XX-标题.md，更新 README.md 和 .update-state.json，然后 git 提交并推送。" \
  --cwd "$NOVEL_DIR" \
  --mode run \
  2>&1)

log "子 agent 已启动：$SESSION_OUTPUT"
log "=== 检查完成 ==="
log ""
