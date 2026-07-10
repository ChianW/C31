# C31 — Agent Harness システム

**スキルだけじゃない。完全なエージェントハーネスシステム。**

永続するメモリ。進化するインスティンクト。健全なコンテキスト。  
5ヶ月以上の日々のプロダクション運用から生まれた。**[chian.io](https://chian.io)** と **[chian.io/investment-os](https://chian.io/investment-os)** を支える。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-50+-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#互換性)
[![Languages](https://img.shields.io/badge/languages-EN%20%7C%20ZH%20%7C%20JA-orange.svg)](#languages)

> 🇺🇸 [English](README.md) · 🇨🇳 [中文](README.zh.md) · 🇯🇵 [日本語](README.ja.md)

---

## C31 で構築されたプロダクト

| プロジェクト | 説明 |
|------------|------|
| **[chian.io](https://chian.io)** | *「人間であることは、ひとつの居山だ。」* — 趣味、判断力、人間の独自性を探求するナレッジプラットフォーム & パーソナル OS。プロダクト：Investment OS、The Silicon Boardroom（ポッドキャスト）、Project Q、System Reboot。 |
| **[chian.io/investment-os](https://chian.io/investment-os)** | *マスタークローンシステム* — バフェットの 70 年分の株主への手紙（1956–2025）+ ハワード・マークスの 160+ めも（1990–2026）を完全にクロスリンクされたナレッジグラフに解読。人間と AI エージェントの両方がクエリ可能。 |

*C31 で何か作りましたか？ PR を開いてここに追加してください。*

---

## C31 とは？

C31 は **agent harness システム** ——あなたと AI ツールの間に位置するレイヤーで、セッションのたびに前回より賢くなります。

ほとんどのプロンプトコレクションは一回限りの指示を与えるだけです。C31 は **AI のための永続的なオペレーティングシステム** を提供します：

| レイヤー | 機能 |
|---------|------|
| **スキル**（50+ 個） | 構造化ワークフロー：ブレスト → 計画 → 実装 → **簡素化** → レビュー → コンパウンド |
| **メモリシステム** | `session_state.json` + 日記 + インスティンクト——状態がセッション間で永続化 |
| **インスティンクト進化** | AI は毎回のインタラクションから学習；パターンが `候補 → 検証中 → インスティンクト` へと昇格 |
| **コンテキスト健全性** | 🟢🟡🟠🔴 四状態モニタリングで長時間セッションのコンテキスト劣化を防止 |
| **心理的フレーミング層** | ステップバイステップ推論の強制 + 確信度チェック出力の検証 |
| **クリティックゲート** | 自動品質ゲート：300 語超かつ推論的結論を含む出力は自己監査をトリガー |

---

## 5 層アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.template.md（GEMINI.md / CLAUDE.md / AGENTS.md）    │
│  ─ エンジニアリング原則    ─ 意思決定の境界                  │
│  ─ アンビエント重み付け    ─ クリティックゲート              │
│  ─ 心理的フレーミング層    ─ Fix-it カスケード              │
├─────────────────────────────────────────────────────────────┤
│  スキル（SKILLS）（50+ 個）                                  │
│  core/ · review/ · product/ · utils/ · personal/            │
├─────────────────────────────────────────────────────────────┤
│  メモリシステム（MEMORY SYSTEM）                             │
│  session_state.json  ←→  diary/日記  ←→  instincts/         │
├─────────────────────────────────────────────────────────────┤
│  インスティンクト進化（INSTINCT EVOLUTION）                  │
│  候補（1/3） → 検証中（2/3） → インスティンクト（3/3）       │
│  確信度：0.3–0.9 · 0.3 未満は非推奨                         │
├─────────────────────────────────────────────────────────────┤
│  コンテキスト健全性（CONTEXT HEALTH）                        │
│  🟢 <50%  🟡 50-70%  🟠 70-85%  🔴 >85% → 強制チェックポイント │
└─────────────────────────────────────────────────────────────┘
```

---

## C31 が異なる理由

### 1. 永続するメモリ

ステートレスなプロンプトファイルとは異なり、C31 は記憶します。`session_state.json` がアクティブなプロジェクト、未完了タスク、保留中の決定を追跡します。日記は日々の作業を記録します。インスティンクトファイルは確信度スコアと共に学習済みパターンを保存します。

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← 直近のトピック、未完了タスク、完了タスク
│   ├── diary/YYYY-MM-DD.md  ← 日次セッションログ
│   └── instincts/           ← 進化した行動パターン
└── solutions-registry.md    ← 記録された全解決策のインデックス
```

### 2. 進化するインスティンクト

AI はルールに従うだけでなく、インスティンクトを積み上げます。パターンが 3 回成功すると、`インスティンクト`（自動適用、確認不要）に昇格します。ユーザーが「それは違う」と言うと、確信度スコアが 0.3 未満に下がり、そのパターンは非推奨となります。

```
instinct-001-no-overwrite.md     confidence: 0.95  ← 自動適用
instinct-002-research-first.md   confidence: 0.90  ← 自動適用
instinct-003-surgical-changes.md confidence: 0.90  ← 自動適用
instinct-004-C31-compound.md      confidence: 0.85  ← 自動適用
```

### 3. コンテキスト健全性モニタリング

長時間セッションは AI の品質を低下させます。C31 はコンテキストウィンドウの使用状況を監視し、自動的に対処します：

| 状態 | 使用率 | アクション |
|------|--------|-----------|
| 🟢 グリーン | <50% | 通常動作 |
| 🟡 イエロー | 50–70% | 完了した作業の圧縮を開始 |
| 🟠 オレンジ | 70–85% | 決定をファイルへ移動、仮定をアーカイブ |
| 🔴 レッド | >85% | 強制チェックポイント：状態を書き込んでから継続 |

### 4. 心理的フレーミング層

C31 は研究に裏付けられた認知技術をハーネスに直接組み込んでいます：
- **ステップバイステップ推論**：複雑な分析は出力前に内部で展開（エラーを約 34% 削減）
- **確信度チェック**：重要な出力にはギャップアノテーションが付与
- **クリティックゲート**：300 語超の推論的結論に対して自動的に自己監査をトリガー
- **反追従性**：技術的厳密さが社交的快適さに優先——異議に対しては独立した評価をトリガーし、妥協しない

### 5. 知識のコンパウンド

解決された問題はすべて組織の記憶になります。`C31-compound` ワークフローは解決策を INDEX エントリとともに `docs/solutions/` に書き込みます。次に同じ種類の問題が現れたとき、数時間ではなく数分で解決できます。

---

## クイックインストール

```bash
git clone https://github.com/ChianW/C31.git
cd C31
./install.sh          # macOS / Linux — コアスキルをインストール
.\install.ps1         # Windows PowerShell

./install.sh all      # すべてをインストール（50+ スキル）
./install.sh product  # プロダクト/ビジネススキルのみ
```

**次に `AGENTS.template.md` をプロジェクトのルートディレクトリにコピーしてください：**

| ツール | ファイル名 | 言語 |
|--------|-----------|------|
| Gemini CLI / Antigravity | `GEMINI.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| Claude Code / Codex | `CLAUDE.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |
| OpenClaw / Hermes / Kimi CLI | `AGENTS.md` | [EN](AGENTS.template.md) · [中文](AGENTS.template.zh.md) · [日本語](AGENTS.template.ja.md) |

`{YOUR_HOME}`、`{YOUR_PROJECT}`、`{MEMORY_DIR}` を実際のパスに置き換えてください。

---

## ガイド

> 完全なドキュメントは [PHILOSOPHY.md](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

| ガイド | 学べること |
|--------|-----------|
| **[クイックスタート](AGENTS.template.md)** | インストール、設定、最初の C31 セッションの実行 |
| **[エンジニアリング哲学](PHILOSOPHY.md)** | 5 つの Karpathy 原則 + 疑念駆動開発 + Chesterton のフェンス |
| **[メモリシステム](AGENTS.template.md#session-startup-protocol)** | セッション状態、日記、インスティンクトの連携方法 |
| **[インスティンクト進化](AGENTS.template.md#instinct-system)** | パターンが候補から自動適用インスティンクトへ昇格する仕組み |
| **[コンテキスト健全性](AGENTS.template.md#own-your-context-window)** | 長時間セッションのための 4 状態コンテキストシステムの管理 |
| **[スキルインデックス](skills/)** | EN · ZH · JA のトリガーを持つ全 50+ スキル |

---

## スキルインデックス

### 🔧 core/（18 個）— エンジニアリングワークフロー

| スキル | 英語トリガー | 中文 | 日本語 |
|-------|------------|------|--------|
| C31-1st | `first principles` | 第一性原理 | 第一原理 |
| C31-brainstorm | `brainstorm` | 头脑风暴 | ブレスト |
| C31-plan | `plan` | 制定计划 | 計画を立てる |
| C31-spec | `spec` | 写需求 | 仕様を書く |
| C31-work | `work` | 开干 | 実装する |
| C31-research | `research` | 调研 | 調査する |
| C31-coding-discipline | `coding` | 写代码 | コーディング |
| C31-debug | `debug` | 调试 | デバッグ |
| C31-compound | `compound` | 复利 | 知識を記録 |
| C31-strategy | `strategy` | 定战略 | 戦略を立てる |
| C31-lfg | `lfg` | 开干 | やろう |
| C31-context-engineering | `context` | 上下文 | コンテキスト管理 |
| C31-adopt-project | `adopt` | 看看这个项目 | プロジェクト調査 |
| C31-compound-refresh | `refresh` | 更新知识库 | ドキュメント更新 |
| C31-workflow-bug-reproduction | `reproduce` | 复现bug | バグ再現 |
| ce-simplify-code | `simplify` | 简化代码 | コード簡素化 |
| ce-pov | `pov` | 技术决策 | 技術判定 |
| ce-promote | `promote` | 发布公告 | リリース告知 |

### 🔍 review/（5 個）— マルチエージェントコードレビュー

`C31-review` · `C31-review-security` · `C31-review-architecture` · `C31-review-adversarial` · `C31-multi-review`

### 💼 product/（11 個）— プロダクト & ビジネス

`c31-community` · `c31-validate` · `c31-mvp` · `c31-process` · `c31-sell` · `c31-market` · `c31-grow` · `c31-price` · `c31-gutcheck` · `c31-values` · `growth-hacker`

### 🛠️ utils/（8 個）· 🧘 personal/（2 個）· ⚙️ platform-specific/（2 個）

---

## 思想的基盤

C31 は 9 つのフレームワークの設計哲学を統合し、統一されたハーネスとして構築しています：

| ソース | C31 への主要な貢献 |
|--------|-----------------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5 つのコアエンジニアリング原則（礎石） |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | ステートレスリデューサー · コンテキスト所有権 · エラーの圧縮 |
| **[ECC](https://github.com/affaan-m/ecc)** | インスティンクト進化システム · コンテキスト健全性カラー · 継続的学習ループ |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | ブレスト→計画→実装→**簡素化**→レビュー→コンパウンド ライフサイクル·削除テスト·行動変更検証 |
| **[Superpowers](https://github.com/obra/superpowers)** | サブエージェント駆動開発 · 完了前の検証 |
| **[Archon](https://github.com/coleam00/Archon)** | エージェントライフサイクルガバナンス · 自律的な状態変更の禁止 |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | コンテキストエンジニアリング · メモリよりアーティファクト · 計画品質ゲート |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | 疑念駆動開発 · Chesterton のフェンス · 反追従性 |
| **心理的フレーミング** | ステップバイステップ推論 · 確信度チェック · クリティックゲート |

---

## 互換性

Markdown コンテキストファイルをサポートする AI コーディングツールであれば動作します：

| プラットフォーム | インストール | 設定ファイル |
|--------------|------------|------------|
| **Antigravity**（Gemini CLI） | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windows の場合：`.\install.ps1` を使用してください

---

## 言語

- 🇺🇸 [English](README.md)
- 🇨🇳 [中文](README.zh.md)
- 🇯🇵 [日本語](README.ja.md)（このページ）

---

## コントリビューション

1. リポジトリをフォーク
2. 適切な `skills/` カテゴリにスキルを追加
3. SKILL.md のフロントマターに多言語トリガー（EN · ZH · JA）を含める
4. PR を開く

C31 で何か構築しましたか？**C31 で構築されたプロダクト** テーブルに追加してください。

---

## ライセンス

MIT — [LICENSE](LICENSE) を参照

> 🇺🇸 [English](README.md) · 🇨🇳 [中文](README.zh.md) · 🇯🇵 [日本語](README.ja.md)
