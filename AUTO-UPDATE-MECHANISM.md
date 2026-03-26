# 上海都市恐怖小说 - 自动更新机制

## 方案选择

使用 **OpenClaw HEARTBEAT 机制** 而非 cron，因为：
- ✅ Heartbeat 可以调用完整的 AI agent 能力
- ✅ 可以访问 workspace 文件和记忆系统
- ✅ 可以续写内容并保存
- ❌ Cron 只能运行 shell 脚本，无法调用 AI

## 配置步骤

### 1. HEARTBEAT.md 配置

在 `~/workspace-creator/HEARTBEAT.md` 中添加：

```markdown
# 小说自动更新
- 检查 novels/shanghai-horror/ 最新章节
- 如果距离上次更新超过 30 分钟，续写新一章
- 每章目标字数：3000-4000 字
- 更新 README.md 和更新日志
```

### 2. 更新流程

```
Heartbeat 触发
    ↓
检查最新章节编号和更新时间
    ↓
如果超过 30 分钟未更新 → 续写下一章
如果不足 30 分钟 → 跳过（避免重复）
    ↓
读取前情提要 + 最新章节
    ↓
调用 AI 续写新内容
    ↓
保存为新章节文件
    ↓
更新 README.md 和日志
    ↓
完成
```

### 3. 文件结构

```
novels/shanghai-horror/
├── README.md              # 小说信息 + 更新状态
├── UPDATE-MECHANISM.md    # 本文档
├── update-state.json      # 更新状态（最后更新时间、最新章节等）
├── chapter-00-intro.md    # 序章
├── chapter-01-*.md        # 第一章
├── chapter-02-*.md        # 第二章
├── chapter-03-*.md        # 第三章
├── chapter-04-*.md        # 第四章（待创作）
└── update.log             # 更新日志
```

### 4. 更新状态文件 (update-state.json)

```json
{
  "lastUpdate": "2026-03-27T05:30:00+08:00",
  "latestChapter": "chapter-03-red-qipao.md",
  "latestChapterNum": 3,
  "totalWords": 12000,
  "nextChapterDue": "2026-03-27T06:00:00+08:00"
}
```

### 5. 更新频率

- **默认**: 每 30-60 分钟更新一章（避免太频繁导致质量下降）
- **创作时间**: 每章约需 2-5 分钟 AI 生成时间
- **建议**: 在 HEARTBEAT 中设置检查频率为 30 分钟

## 手动触发

如需立即更新，在群聊中对我说：
- "继续写小说"
- "更新上海恐怖小说"
- "写下一章"

## 注意事项

1. **不要同时运行多个更新** - 检查 update-state.json 避免冲突
2. **保持故事连贯性** - 每次续写前阅读最近 1-2 章
3. **质量优先** - 如果 AI 状态不佳，宁可跳过本次更新
4. **定期备份** - 每次更新后 git commit

## 故障排查

如果更新停止：
1. 检查 HEARTBEAT.md 是否有任务配置
2. 检查 update-state.json 状态
3. 查看 update.log 日志
4. 手动触发一次更新测试

---

**创建日期**: 2026-03-27  
**最后更新**: 2026-03-27
