# Video Content Analysis

**Status**: Three-tier fallback video content analysis
**Dependencies**: yt-dlp (proxy required), kimi_search, kimi_fetch
**Tags**: #content-analysis #video #tech-pulse #youtube #bilibili

---

## Three-Tier Fallback Strategy

```
L1: yt-dlp direct subtitle extraction (most accurate, requires proxy)
L2: Search third-party transcripts (Lilys.ai, Glasp, YouTube auto-captions, note sites)
L3: web_fetch page metadata (title, description — lightest option)
```

---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | video-content-analysis |
| ZH | 视频分析, 内容分析 |
| JA | 動画分析, コンテンツ分析 |

> **Output language**: Respond automatically in the user's conversation language.

## L1: yt-dlp Direct Extraction (Most Accurate)

**Prerequisite**: Proxy configured on the server

```bash
# Extract subtitles
yt-dlp --write-sub --skip-download --sub-langs en,zh-CN,zh-TW,auto "URL"

# Extract metadata + subtitle list
yt-dlp --dump-json --skip-download "URL" | jq '{title, uploader, duration, upload_date, subtitle_languages: (.subtitles | keys)}'

# Extract audio + Whisper transcription (fallback)
yt-dlp --extract-audio --audio-format mp3 -o "audio.%(ext)s" "URL"
```

**Proxy Configuration**:
```bash
# Temporary proxy (single command)
export http_proxy="socks5://user:pass@host:port"
export https_proxy="socks5://user:pass@host:port"
yt-dlp --write-sub --skip-download "URL"

# Or use yt-dlp's built-in proxy flag
yt-dlp --proxy "socks5://user:pass@host:port" --write-sub --skip-download "URL"
```

---

## L2: Third-Party Transcript Search (Fallback)

**Triggered automatically when L1 fails.** Search the following sources:

### Search Query Templates

```
# YouTube video
site:lilys.ai "youtube.com/watch?v=VIDEO_ID"
site:lilys.ai "youtu.be/VIDEO_ID"
VIDEO_TITLE "transcript" "summary"
VIDEO_TITLE "文字稿" "笔记"

# Bilibili video
site:lilys.ai "bilibili.com/video/BV"
site:bilibili.com "BV" "字幕"
"BVxxxxx" "transcript"

# General
"VIDEO_TITLE" "字幕" "完整"
"VIDEO_TITLE" "transcript" "full"
```

### Known Third-Party Transcript Sources

| Platform | URL Pattern | Quality | Coverage |
|----------|-------------|---------|----------|
| Lilys.ai | `lilys.ai/notes/ID` | ⭐⭐⭐ | Popular videos |
| Glasp | `glasp.co/...` | ⭐⭐⭐ | Popular videos |
| YouTube auto-captions | YouTube built-in | ⭐⭐ | All videos |
| Note sites / blogs | Various blogs | ⭐⭐ | Popular videos |
| Bilibili auto-captions | Bilibili built-in | ⭐⭐ | Some videos |

### Extracting Transcripts

```bash
# Lilys.ai page extraction
kimi_fetch "https://lilys.ai/notes/ID" | grep -A 10 -B 2 "transcript\|字幕\|文字稿"

# General: search then kimi_fetch the target page
kimi_search "VIDEO_TITLE transcript site:lilys.ai"
```

---

## L3: Page Metadata Extraction (Final Fallback)

**When both L1 and L2 fail.** Extract text content from the video page: title, description, comments, etc.

```bash
# YouTube page
kimi_fetch "https://youtube.com/watch?v=VIDEO_ID" | head -200

# Bilibili page
kimi_fetch "https://www.bilibili.com/video/BVxxxxx" | head -200

# Extract structured information
kimi_fetch "URL" | grep -E "title|description|comment|字幕|transcript" | head -20
```

---

## One-Click Analysis Flow

**User action**: Drop a video link

**Automatic execution**:

1. Identify platform (YouTube / Bilibili / other)
2. Try L1: yt-dlp → success → output subtitles + summary
3. L1 fails → Try L2: search third-party transcripts → success → output transcript + summary
4. L2 fails → Try L3: web_fetch page → output metadata + description summary
5. Generate final summary: title, core content, timestamped key points, personal assessment

---

## Integration with Tech Pulse

**Video content monitoring cron**:

```yaml
# Daily scan of specified YouTube/Bilibili channels for new videos
# Extract subtitles → keyword matching → push summary if hit

channels_to_monitor:
  - youtube_channel: "UCxxxxx"  # AI/tech channel
  - youtube_channel: "UCxxxxx"  # Investment channel
  - bilibili_user: "UIDxxxxx"   # Bilibili creator

keywords: ["AI", "LLM", "投资", "量化", "策略", "OpenClaw"]
```

---

## Proxy Configuration (Pending User Setup)

**Current status**: Server proxy not configured — L1 unavailable

**After configuration**:
```bash
# 1. Configure system proxy
export http_proxy="socks5://USER:PASS@HOST:PORT"
export https_proxy="socks5://USER:PASS@HOST:PORT"

# 2. Test
curl -s --max-time 10 ipinfo.io

# 3. Test yt-dlp
yt-dlp --proxy "socks5://USER:PASS@HOST:PORT" --print title "https://youtube.com/watch?v=dQw4w9WgXcQ"

# 4. Write to persistent config (~/.bashrc or systemd environment)
echo 'export http_proxy="socks5://USER:PASS@HOST:PORT"' >> ~/.bashrc
echo 'export https_proxy="socks5://USER:PASS@HOST:PORT"' >> ~/.bashrc
```




*v1.0 - 2026-06-07 | Three-tier fallback: yt-dlp → third-party transcripts → page metadata*

