#!/bin/bash

# 上海恐怖小说自动更新脚本
# 每 30 分钟检查一次，如需更新则调用 AI 续写

NOVEL_DIR="/home/jason/.openclaw/workspace-creator/novels/shanghai-horror"
STATE_FILE="$NOVEL_DIR/.update-state.json"
LOG_FILE="$NOVEL_DIR/.update.log"

# 记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== 检查更新 ==="

# 检查是否需要更新（距离上次更新超过 30 分钟）
if [ -f "$STATE_FILE" ]; then
    LAST_UPDATE=$(cat "$STATE_FILE" | grep -o '"lastUpdate"[^,]*' | cut -d'"' -f4)
    if [ -n "$LAST_UPDATE" ]; then
        LAST_TS=$(date -d "$LAST_UPDATE" +%s 2>/dev/null || echo 0)
        NOW_TS=$(date +%s)
        DIFF=$(( (NOW_TS - LAST_TS) / 60 ))
        
        if [ $DIFF -lt 30 ]; then
            log "距离上次更新仅 ${DIFF} 分钟，跳过"
            exit 0
        fi
    fi
fi

log "开始续写新篇章..."

# 创建更新请求文件
REQUEST_FILE="$NOVEL_DIR/.update-request.txt"
cat > "$REQUEST_FILE" << 'EOF'
请续写《静安寺路的第十三级台阶》下一章。

要求：
1. 阅读 STORY-BIBLE.md 了解故事框架
2. 阅读最后一章，保持剧情连贯
3. 新章节字数：3500-4500 字
4. 保存为 chapter-XX-标题.md 格式
5. 更新 README.md 的章节列表
6. 提交 git 并推送

现在开始写第五章。
EOF

log "更新请求已创建，等待 AI 处理"
log "=== 检查完成 ==="
log ""
