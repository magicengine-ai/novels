#!/bin/bash

# 《最后的人类》- 自动更新触发器
# 通过发送飞书消息到群聊，触发 AI 检查并更新小说

NOVEL_DIR="/home/jason/.openclaw/workspace-creator/novels/novel-01"
STATE_FILE="$NOVEL_DIR/.update-state.json"
LOG_FILE="$NOVEL_DIR/.trigger.log"
GROUP_CHAT_ID="oc_dcf59834784e60c1ca436f72f13e37fb"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 检查是否需要更新 ==="

# 检查是否需要更新
NEED_UPDATE=false
if [ -f "$STATE_FILE" ]; then
    LAST_UPDATE=$(grep -o '"lastUpdate"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
    if [ -n "$LAST_UPDATE" ]; then
        LAST_TS=$(date -d "$LAST_UPDATE" +%s 2>/dev/null || echo 0)
        NOW_TS=$(date +%s)
        DIFF=$(( (NOW_TS - LAST_TS) / 60 ))
        
        log "距离上次更新：${DIFF} 分钟"
        
        if [ $DIFF -ge 5 ]; then
            NEED_UPDATE=true
            log "超过 5 分钟，触发更新"
        else
            log "不足 5 分钟，跳过"
            exit 0
        fi
    fi
fi

if [ "$NEED_UPDATE" = false ]; then
    exit 0
fi

# 发送飞书消息到群聊，触发 AI 检查
log "发送触发消息到群聊..."

# 使用 openclaw message 发送
/home/jason/.npm-global/bin/openclaw message send \
  --channel feishu \
  --target "chat:$GROUP_CHAT_ID" \
  --message "🔔 小说自动更新检查

距离上次更新已超过 5 分钟，请检查并续写《最后的人类》下一章。

当前状态：
- 最新章节：$(grep -o '"latestChapter"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
- 总字数：$(grep -o '"totalWords"[^,]*' "$STATE_FILE" | grep -o '[0-9]*')
- 下次更新：$(grep -o '"nextChapterDue"[^,]*' "$STATE_FILE" | cut -d'"' -f4)

请开始工作！📝" \
  2>&1 | tee -a "$LOG_FILE"

log "触发消息已发送"
log "=== 完成 ==="
log ""
)

请开始工作！📝" \
  2>&1 | tee -a "$LOG_FILE"

log "触发消息已发送"
log "=== 完成 ==="
log ""
