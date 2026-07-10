# Video Content Analysis

**Status**: 三层 fallback 视频内容分析
**依赖**: yt-dlp (需代理), kimi_search, kimi_fetch
**Tags**: #content-analysis #video #tech-pulse #youtube #bilibili

---

## 三层 Fallback 策略

```
L1: yt-dlp 直接提取字幕 (最准确，需代理)
L2: 搜索第三方转录稿 (Lilys.ai, Glasp, YouTube 自动字幕, 笔记站)
L3: web_fetch 读取视频页面 (元数据 + 描述，最轻量)
```

---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | video-content-analysis |
| ZH | 视频分析, 内容分析 |
| JA | 動画分析, コンテンツ分析 |

> **Output language**: Respond automatically in the user's conversation language.

## L1: yt-dlp 直接提取 (最准)

**前提**: 服务器已配置代理

```bash
# 提取字幕
yt-dlp --write-sub --skip-download --sub-langs en,zh-CN,zh-TW,auto "URL"

# 提取元数据 + 字幕列表
yt-dlp --dump-json --skip-download "URL" | jq '{title, uploader, duration, upload_date, subtitle_languages: (.subtitles | keys)}'

# 提取音频 + Whisper 转录（备用）
yt-dlp --extract-audio --audio-format mp3 -o "audio.%(ext)s" "URL"
```

**代理配置**:
```bash
# 临时代理（单次命令）
export http_proxy="socks5://user:pass@host:port"
export https_proxy="socks5://user:pass@host:port"
yt-dlp --write-sub --skip-download "URL"

# 或 yt-dlp 自带代理参数
yt-dlp --proxy "socks5://user:pass@host:port" --write-sub --skip-download "URL"
```

---

## L2: 第三方转录稿搜索 (fallback)

**当 L1 失败时自动触发。** 搜索以下源：

### 搜索查询模板

```
# YouTube 视频
site:lilys.ai "youtube.com/watch?v=VIDEO_ID"
site:lilys.ai "youtu.be/VIDEO_ID"
VIDEO_TITLE "transcript" "summary"
VIDEO_TITLE "文字稿" "笔记"

# B站视频
site:lilys.ai "bilibili.com/video/BV"
site:bilibili.com "BV" "字幕"
"BVxxxxx" "transcript"

# 通用
"VIDEO_TITLE" "字幕" "完整"
"VIDEO_TITLE" "transcript" "full"
```

### 已知的第三方转录源

| 平台 | URL 模式 | 质量 | 覆盖率 |
|------|----------|------|--------|
| Lilys.ai | `lilys.ai/notes/ID` | ⭐⭐⭐ | 热门视频 |
| Glasp | `glasp.co/...` | ⭐⭐⭐ | 热门视频 |
| YouTube 自动字幕 | YouTube 自带 | ⭐⭐ | 所有视频 |
| 笔记站/博客 | 各种博客 | ⭐⭐ | 热门视频 |
| B站 自动字幕 | B站 自带 | ⭐⭐ | 部分视频 |

### 提取转录稿

```bash
# Lilys.ai 页面提取
kimi_fetch "https://lilys.ai/notes/ID" | grep -A 10 -B 2 "transcript\|字幕\|文字稿"

# 通用：搜索后 kimi_fetch 目标页面
kimi_search "VIDEO_TITLE transcript site:lilys.ai"
```

---

## L3: 页面元数据提取 (最终 fallback)

**当 L1 和 L2 都失败时。** 提取视频页面的标题、描述、评论等文字信息。

```bash
# YouTube 页面
kimi_fetch "https://youtube.com/watch?v=VIDEO_ID" | head -200

# B站页面
kimi_fetch "https://www.bilibili.com/video/BVxxxxx" | head -200

# 提取结构化信息
kimi_fetch "URL" | grep -E "title|description|comment|字幕|transcript" | head -20
```

---

## 一键分析流程

**用户操作**: 丢一个视频链接给我

**我的自动执行**:

1. 识别平台 (YouTube/B站/其他)
2. 尝试 L1: yt-dlp → 成功 → 输出字幕 + 总结
3. L1 失败 → 尝试 L2: 搜索第三方转录稿 → 成功 → 输出转录稿 + 总结
4. L2 失败 → 尝试 L3: web_fetch 页面 → 输出元数据 + 描述总结
5. 生成最终总结：标题、核心内容、时间戳关键点、个人评价

---

## 整合到 Tech Pulse

**视频内容监控 cron**:

```yaml
# 每日扫描指定 YouTube/B站 频道新视频
# 提取字幕 → 关键词匹配 → 有命中则推送摘要

channels_to_monitor:
  - youtube_channel: "UCxxxxx"  # AI/tech 频道
  - youtube_channel: "UCxxxxx"  # 投资频道
  - bilibili_user: "UIDxxxxx"   # B站 up 主

keywords: ["AI", "LLM", "投资", "量化", "策略", "OpenClaw"]
```

---

## 代理配置（待用户完成）

**当前状态**: 服务器未配置代理，L1 不可用

**配置后**:
```bash
# 1. 配置系统代理
export http_proxy="socks5://USER:PASS@HOST:PORT"
export https_proxy="socks5://USER:PASS@HOST:PORT"

# 2. 测试
curl -s --max-time 10 ipinfo.io

# 3. 测试 yt-dlp
yt-dlp --proxy "socks5://USER:PASS@HOST:PORT" --print title "https://youtube.com/watch?v=dQw4w9WgXcQ"

# 4. 写入持久化配置（~/.bashrc 或 systemd 环境）
echo 'export http_proxy="socks5://USER:PASS@HOST:PORT"' >> ~/.bashrc
echo 'export https_proxy="socks5://USER:PASS@HOST:PORT"' >> ~/.bashrc
```




*v1.0 - 2026-06-07 | 三层 fallback: yt-dlp → 第三方转录 → 页面元数据*
