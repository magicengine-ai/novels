# 上海恐怖小说 - Git 仓库

**仓库位置**: `/home/jason/.openclaw/workspace-creator/novels/shanghai-horror/`

**独立 Git 仓**，与主工作区分离。

---

## 初始化提交

```bash
cd /home/jason/.openclaw/workspace-creator/novels/shanghai-horror
git add -A
git commit -m "Initial commit: 上海都市恐怖小说《静安寺路的第十三级台阶》"
```

---

## 目录结构

```
shanghai-horror/
├── .git/                    # Git 仓库
├── STORY-BIBLE.md           # 故事框架（最重要！）
├── README.md                # 小说简介
├── chapter-00-intro.md      # 序章
├── chapter-01-last-passenger.md
├── chapter-02-thirteenth-step.md
├── chapter-03-red-qipao.md
├── chapter-04-mirror-person.md
├── update-state.json        # 更新状态
├── update.log               # 更新日志
├── AUTO-UPDATE-MECHANISM.md # 自动更新机制
└── update-novel.sh          # 更新脚本（已废弃，改用 HEARTBEAT）
```

---

## 常用命令

### 查看状态
```bash
git status
```

### 添加并提交
```bash
git add -A
git commit -m "feat: 完成第 X 章"
```

### 查看历史
```bash
git log --oneline -10
```

### 查看字数统计
```bash
wc -w chapter-*.md
```

---

## 提交规范

- `feat: 新增章节` - 完成新章节
- `docs: 更新框架` - 修改 STORY-BIBLE.md
- `fix: 修正错误` - 修正错别字或逻辑问题
- `refactor: 重构` - 大幅修改已有章节

---

**创建日期**: 2026-03-27
