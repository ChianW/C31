# Cystem31 (C31)

**AIコーディングエージェントのためのエンジニアリング規律ワークフローシステム。**  
10ヶ月以上の毎日の本番使用から生まれました。[chian.io](https://chian.io) と [chian.io/investment-os](https://chian.io/investment-os) のすべてのコンテンツを支えています。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-43-green.svg)](skills/)
[![Platforms](https://img.shields.io/badge/platforms-6%2B-purple.svg)](#対応プラットフォーム)

---

## C31で構築されたプロジェクト

> 以下のプロジェクトは、設計・計画・実装の全フェーズをC31ワークフローで完了しました：

| プロジェクト | 概要 | 使用C31スキル |
|-------------|------|--------------|
| **[chian.io](https://chian.io)** | パーソナルOSと知識プラットフォーム | C31-brainstorm · C31-plan · C31-work · C31-compound |
| **[chian.io/investment-os](https://chian.io/investment-os)** | AI駆動の投資知識システム | C31-spec · C31-review · C31-coding-discipline · C31-strategy |

*C31でプロジェクトを作ったら、PRでここに追加してください。*

---

## Cystem31とは？

C31は43個のスキル（markdownの指示ファイル）の集合であり、Claude・Gemini・KimiなどあらゆるAIコーディングエージェントに体系的なエンジニアリング規律を与えます。

**プロンプトライブラリではありません。** 思考を体系化する方法論です：

- **コーディング前**：要件をブレインストーミングし、仮定を明示し、計画を立てる
- **コーディング中**：外科的な変更、疑念駆動の意思決定、「後で」を残さない
- **コーディング後**：マルチエージェントレビュー、解決策を機関知識として記録する

結果：すべてのセッションが複利として積み重なります。今日記録した解決策が来週の数時間を節約します。

---

## クイックインストール

```bash
# コアスキルのクローンとインストール（推奨）
git clone https://github.com/ChianW/Cystem31.git
cd Cystem31
./install.sh            # macOS / Linux
.\install.ps1           # Windows PowerShell

# 全てインストール
./install.sh all

# プロダクト/ビジネススキルのみ
./install.sh product
```

次に `AGENTS.template.md` をプロジェクトルートにコピーし、以下のファイル名に変更：
- `GEMINI.md` → Gemini CLI / Antigravity
- `CLAUDE.md` → Claude Code / Codex
- `AGENTS.md` → OpenClaw / Hermes / Kimi CLI

---

## スキル一覧

### 🔧 core/ — エンジニアリングワークフロー（15スキル）

| スキル | トリガー | 機能 |
|--------|---------|------|
| C31-1st | `第一原理`, `first principles`, `第一性原理` | 問題を公理まで分解し、真実から再構築する |
| C31-brainstorm | `ブレインストーミング`, `brainstorm`, `头脑风暴` | 曖昧な要件を番号付き意思決定ポイントに変換 |
| C31-plan | `計画を立てる`, `plan`, `制定计划` | 要件を検証済みの実行可能な計画に変換 |
| C31-spec | `仕様を書く`, `spec`, `写需求` | 意図と実装の契約としてPRDを作成 |
| C31-work | `実装する`, `work`, `开干` | タスク追跡と品質ゲートによる計画実行 |
| C31-research | `調査する`, `research`, `调研` | フレームワークドキュメント・git履歴・コミュニティ問題の統合調査 |
| C31-coding-discipline | `コーディング`, `coding`, `写代码` | 強制セルフレビュー付き7ステップTDDワークフロー |
| C31-debug | `デバッグ`, `debug`, `调试` | 再現から根本原因、修正検証までの体系的デバッグ |
| C31-compound | `知識を記録する`, `compound`, `复利` | 解決済み問題を文書化し知識を複利的に蓄積 |
| C31-strategy | `戦略を立てる`, `strategy`, `定战略` | STRATEGY.mdを作成し下流の作業すべてを固定 |
| C31-lfg | `やろう`, `lfg`, `开干` | 計画準備完了時の全自動9ゲート実行パイプライン |
| C31-context-engineering | `コンテキスト管理`, `context`, `上下文` | コンテキストウィンドウの健全性管理、コンテキスト腐敗の防止 |
| C31-adopt-project | `プロジェクト調査`, `adopt`, `看看这个项目` | 5フェーズ調査：哲学→ギャップ分析→統合 |
| C31-compound-refresh | `ドキュメント更新`, `refresh compound`, `更新知识库` | 新しい知見で既存のcompoundドキュメントを更新 |
| C31-workflow-bug-reproduction | `バグ再現`, `reproduce`, `复现bug` | 仮説→最小再現→検証済み根本原因 |

### 🔍 review/ — コードレビュー（5スキル）

| スキル | トリガー | 機能 |
|--------|---------|------|
| C31-review | `レビュー`, `review`, `审查` | 並列マルチペルソナレビュー + UAT + カバレッジチェック |
| C31-review-security | `セキュリティレビュー`, `security review` | 脆弱性・認証ギャップ・インジェクション・XSS |
| C31-review-architecture | `アーキテクチャレビュー`, `arch review` | 結合・レイヤリング・抽象化リーク・境界 |
| C31-review-adversarial | `対抗レビュー`, `adversarial review` | 障害伝播・未宣言仮定・TOCTOU |
| C31-multi-review | `マルチエージェントレビュー`, `multi-review` | 4エージェント対抗並列レビュー + 競合検出 |

### 💼 product/ — プロダクト・ビジネス（11スキル）

| スキル | トリガー | 機能 |
|--------|---------|------|
| c31-community | `コミュニティを見つける`, `community` | 適切なサービスコミュニティを見つけて検証 |
| c31-validate | `アイデアを検証する`, `validate` | 作る前にアイデアをテスト |
| c31-mvp | `MVP`, `最小限のプロダクト` | 手動優先→プロセス化→プロダクト化 |
| c31-process | `プロセス化`, `processize` | 手動デリバリーを再現可能なプロセスに変換 |
| c31-sell | `最初の顧客`, `first customers` | 最初の100人の有料顧客獲得戦略 |
| c31-market | `マーケティング`, `content strategy` | オーディエンスファーストのコンテンツマーケティング |
| c31-grow | `持続可能な成長`, `profitable growth` | バーンアウトなしの持続可能な成長 |
| c31-price | `価格設定`, `pricing` | 価値ベースの価格戦略 |
| c31-gutcheck | `判断の確認`, `gut check` | ミニマリスト起業家の視点でのあらゆる意思決定レビュー |
| c31-values | `価値観`, `company values` | 文化とコラボレーション原則の定義 |
| growth-hacker | `グロースハック`, `growth` | 体系的な成長実験 |

### 🛠️ utils/ — ユーティリティ（8スキル）

`find-skills` · `time-awareness` · `gsd-map-codebase` · `gsd-new-project` · `gsd-progress` · `gsd-quick` · `gsd-ship` · `worker-safety`

### 🧘 personal/ — パーソナルツール（2スキル）

`c31-sxs`（四尋思観 — 感情・執着・意思決定の仏教的解体） · `video-content-analysis`

---

## コア哲学

> 詳細：[English](PHILOSOPHY.md) · [中文](PHILOSOPHY.zh.md) · [日本語](PHILOSOPHY.ja.md)

**5つの原則（Karpathy由来）：**
1. **考えてからコーディング** — あらゆる行動の前にリサーチフェーズ
2. **シンプルさ優先** — 必要最小限のロジックのみ
3. **外科的変更** — タスクに直接関連するコードのみ変更
4. **目標駆動実行** — テストが完了を定義する
5. **第一原理思考** — 慣習ではなく真実から推論する

**追加原則：** Doubt-Driven Development · Chesterton's Fence · No "Later" · Rollback-First · 複利セッション

---

## 知的基盤

C31は以下のプロジェクトの設計哲学とフレームワークを統合しています：

| ソース | 主な貢献 |
|--------|---------|
| **[Karpathy AI Skills](https://karpathy.ai)** | 5つのコアエンジニアリング原則 |
| **[12-factor-agents](https://github.com/humanlayer/12-factor-agents)** | ステートレスReducerパターン・コンテキスト所有権・エラー圧縮 |
| **[ECC](https://github.com/affaan-m/ecc)** | 継続学習ループ・コンテキスト健全性システム・本能進化 |
| **[Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)** | ブレスト→計画→実装→レビュー→複利 ライフサイクル |
| **[Superpowers](https://github.com/obra/superpowers)** | サブエージェント駆動開発・完了前検証 |
| **[Archon](https://github.com/coleam00/Archon)** | エージェントライフサイクルガバナンス・自律変更禁止 |
| **[GSD Core](https://github.com/open-gsd/gsd-core)** | コンテキストエンジニアリング・Artifacts-over-Memory・計画品質ゲート |
| **[agent-skills](https://github.com/addyosmani/agent-skills)** | Doubt-Driven Development・Chesterton's Fence・反迎合 |
| **心理的フレーミング** | ステップバイステップ推論・信頼度チェック出力検証 |

---

## 対応プラットフォーム

| プラットフォーム | インストール | AGENTSファイル |
|----------------|------------|--------------|
| **Antigravity**（Gemini CLI） | `./install.sh` | `GEMINI.md` |
| **Claude Code** | `./install.sh` | `CLAUDE.md` |
| **Codex** | `./install.sh` | `CLAUDE.md` |
| **Kimi CLI** | `./install.sh` | `AGENTS.md` |
| **OpenClaw** | `./install.sh` | `AGENTS.md` |
| **Hermes** | `./install.sh` | `AGENTS.md` |

Windowsユーザーは `.\install.ps1` を使用してください。

---

## コントリビュート

1. リポジトリをフォーク
2. 適切な `skills/` カテゴリにスキルを追加
3. [SKILL.mdフォーマット](skills/core/C31-brainstorm/SKILL.md)に従い、多言語トリガーを含める
4. PRを作成

C31でプロジェクトを構築しましたか？上の**C31で構築されたプロジェクト**テーブルにあなたのプロジェクトを追加してください。

---

## ライセンス

MIT — [LICENSE](LICENSE)を参照

---

## 言語 / Languages / 语言

- 🇺🇸 [English](README.md)
- 🇨🇳 [中文](README.zh.md)
- 🇯🇵 [日本語](README.ja.md)（このページ）
