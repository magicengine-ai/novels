# 小说自动更新机制

## Cron 配置

- **更新频率：** 每 5 分钟
- **Cron 表达式：** `*/5 * * * *`
- **脚本位置：** `./update-novel.sh`

## 更新流程

1. 脚本检测最新章节文件
2. 计算下一章节编号
3. 调用 AI 续写新章节
4. 更新 README 中的时间戳
5. 记录更新日志到 `update.log`

## 查看更新日志

```bash
tail -f /home/jason/.openclaw/workspace-creator/novels/shanghai-horror/update.log
```

## 查看 Cron 状态

```bash
crontab -l | grep shanghai-horror
```

## 暂停更新

```bash
crontab -e
# 注释掉包含 shanghai-horror 的行
```

## 恢复更新

```bash
crontab -e
# 取消注释对应行
```

## 文件结构

```
shanghai-horror/
├── README.md                 # 小说简介和目录
├── UPDATE-MECHANISM.md       # 本文件
├── update-novel.sh          # 自动更新脚本
├── update.log               # 更新日志
├── chapter-00-intro.md      # 引子
├── chapter-01-last-passenger.md  # 第一章
├── chapter-02-thirteenth-step.md # 第二章
└── chapter-03-red-qipao.md  # 第三章
```

## 创作方向

后续章节将探索：
- 林晚的真实身份
- 红色旗袍女人的起源
- 第十三级台阶的秘密
- 周明的过去
- 殡仪馆的历史
- 车祸真相

---

**最后更新：** 2026-03-26 21:03
