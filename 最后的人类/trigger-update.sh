#!/bin/bash

# 《最后的人类》- 自动更新触发器 v6
# 发送消息到群聊，触发 AI 创作新章节

NOVEL_DIR="/home/jason/.openclaw/workspace-creator/novels/最后的人类"
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

# 读取当前状态
LATEST_CHAPTER=$(grep -o '"latestChapter"[^,]*' "$STATE_FILE" | cut -d'"' -f4)
LATEST_NUM=$(grep -o '"latestChapterNum"[^,]*' "$STATE_FILE" | grep -o '[0-9]*')
NEXT_NUM=$((LATEST_NUM + 1))
TOTAL_WORDS=$(grep -o '"totalWords"[^,]*' "$STATE_FILE" | grep -o '[0-9]*')

log "最新章节：$LATEST_CHAPTER (第$LATEST_NUM 章)"
log "发送触发消息到群聊..."

# 发送飞书消息到群聊
/home/jason/.npm-global/bin/openclaw message send \
  --channel feishu \
  --target "chat:$GROUP_CHAT_ID" \
  --message "🔔 **小说自动更新触发 - 第 $NEXT_NUM 章**

距离上次更新已超过 ${DIFF} 分钟，请**立即使用 subagent 创作**《最后的人类》第 $NEXT_NUM 章。

**当前进度**：
- 已完成：序章 + 第 1-$LATEST_NUM 章
- 累计字数：约 $TOTAL_WORDS 字
- 最新章节：$LATEST_CHAPTER

**创作要求**：
1. 字数：4000-5000 字
2. 保持硬科幻风格
3. 延续上一章剧情
4. 保存文件到 novels/最后的人类/
5. 更新 .update-state.json 和 README.md
6. 提交 git commit

**重要**：请使用 subagent 创作，不要手动写！

请开始工作！📝" \
  2>&1 | tee -a "$LOG_FILE"

log "✅ 触发消息已发送"
log "=== 完成 ==="
log ""
