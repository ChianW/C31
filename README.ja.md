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

### 1. ハードゲート付きワークフロー——チェックリストではない

> *由来：Compound Engineering Plugin（ライフサイクル）+ 12-Factor Agents（F12：ステートレスリデューサー）+ Archon（決定論的パイプライン）*

ほとんどの AI ワークフローはチェックリストです。C31 のライフサイクルは**パイプライン**——各ステップは前のステップからの構造化された出力のみを入力として受け取り、次のステップのための構造化された出力を生成します。コンテキストはファイルで渡され、会話ではありません。

```
ブレスト → 計画 → 実装 → 簡素化 → レビュー → コンパウンド
   ↓         ↓       ↓        ↓          ↓          ↓
決定文書  計画+    テスト   回帰なし    承認済み   docs/solutions/
（番号）  脅威     通過     検証              + INDEXエントリ
         モデル
```

各ステップには**検証ゲート**があります——次のステップが始まる前に真でなければならない二項条件です。計画には人間の承認が必要です。テストはレビューの前に通過する必要があります。ソリューションは完了宣言の前に INDEX エントリが必要です。

> **なぜ重要か：** ドキュメントのない INDEX エントリは見えません。INDEX エントリのないドキュメントも見えません。C31 は両方を強制します。→ [完全なワークフローアーキテクチャ](WORKFLOW.md)

---

### 2. マルチエージェントオーケストレーション——4 つのパターン

> *由来：Compound Engineering（コンパウンドサブエージェント）+ Archon（サブエージェントガバナンス）+ Superpowers（レポートを信頼するな）*

C31 は 4 つの異なるサブエージェントオーケストレーションパターンを使用します。すべての共通する中核アーキテクチャ原則：**並列で動作する専門化されたエージェントは、すべてをやろうとする単体エージェントより優れています。**

#### パターン A — 並列対立レビュー

4 つの隔離されたエージェントが同じコードを同時にレビューします。5 番目のエージェントがそれらの間の矛盾を検出します。

```
            コード / Diff
               │（ブロードキャスト）
  ┌────────────┼────────────┬────────────┐
  ▼            ▼            ▼            ▼
正確性        セキュリティ  保守性        簡潔性
（隔離）      （隔離）      （隔離）      （隔離）
  │            │            │            │
  └────────────┼────────────┴────────────┘
               ▼
        矛盾検出エージェント（5番目）
        矛盾検出 · 重大度ギャップ · 人間フラグ
               ▼
        統合レポート：APPROVED / WARNED / BLOCKED
```

**なぜ隔離されたエージェント？** 隔離はグループシンクを防ぎます。セキュリティ脆弱性を探しているレビュアーは、過剰エンジニアリングには気づきません——それだけを探していない限り。4 つのエージェントはすべて読み取り専用モードで動作し、他のエージェントの発見を知らないため、意見の相違がノイズではなくシグナルになります。

#### パターン B — 並列知識抽出

問題が解決されると、3 つのエージェントが同時に実行され、ソリューションの異なる次元を抽出します：

| エージェント | 抽出内容 |
|------------|----------|
| **コンテキストアナライザー** | 状況は何だったか？何を試みたか？どんな制約があったか？ |
| **ソリューション抽出器** | 正確な修正は何か？根本原因は？なぜ機能するか？逐語コマンド。|
| **関連ドキュメント検索器** | どの先行ソリューションが関連しているか？INDEX のギャップは？|

出力は単一のソリューション文書 + 必須の INDEX エントリにまとめられます。

#### パターン C — Fix-it カスケード

```
「修正して」→ C31-debug → 修正（外科的）→ 検証 → C31-compound
                                  ↑___失敗___|
```

デバッグリクエストで自動トリガー。自己閉鎖ループ。3 連続失敗ルール：同じ種類の修正が 3 回連続で失敗すると、カスケードは停止してエスカレーション——盲目的な再試行なし。

#### パターン D — 12 ゲート完全自動化（C31-lfg）

承認済みの計画に対して、`lfg` は中断なしに決定論的な 12 ゲートパイプラインを完了まで実行します：

`計画検証 → 依存関係チェック → テストベースライン → 実装 → マルチレビュー → ユニットテスト → 統合テスト → Nyquist カバレッジ → 簡素化 → セキュリティスキャン → ビルド検証 → コンパウンド`

停止条件は明確です。それ以外はすべて無人で実行されます。

---

### 3. デフォルトで自律的

> *由来：12-Factor Agents（F12）+ ECC（確信度スコアリング）*

**デフォルトの状態は完全な自律性です。** AI は中断なしに実行、反復、自己修正、知識の蓄積を行います。人間の介入は、まさに 2 つの条件のために予約されています：

- **不可逆的なスコープ** — ファイルの上書き、削除、外部公開
- **意図の確信度が低い** — 0.55 未満の場合、1 つの明確化質問。その後実行。

その他すべて——12 ゲートパイプライン、Fix-it カスケード、並列レビュー、知識抽出——は閉じた自律ループで実行されます。

**確信度ルーティング**はいつ AI が行動前に話すかを決定します：

| 確信度 | 行動 |
|--------|------|
| ≥0.75 | 直接実行。チェックインなし。|
| 0.55–0.74 | 一文の確認：「X という意味ですか？」|
| <0.55 | 1 つの明確化質問。その後実行。|

---

### 4. 自己改善ループ

> *由来：ECC（継続的学習 + 確信度スコアリング）+ agent-skills（反追従性）*

C31 のインスティンクトシステムは完全に自律的に進化します。設定ファイルも人間の教育も不要です。

```
パターン観察 → 候補インスティンクト（確信度：0.5）
パターン繰り返し → 検証中インスティンクト（確信度：0.7）
パターン検証 → インスティンクト（確信度：0.9）——自動適用、確認不要

ユーザーが「それは違う」と言う → 確信度が 0.1 に低下 → 非推奨 → 再度提案されない
```

プリロードされたシードインスティンクト：
```
instinct-001-no-overwrite.md     confidence: 0.95  ← 既存ファイルを上書きしない
instinct-002-research-first.md   confidence: 0.90  ← 行動前に必ず調査
instinct-003-surgical-changes.md confidence: 0.90  ← 必要なものだけを変更
instinct-004-compound-trigger.md confidence: 0.85  ← ≥2 ファイル変更後に自動コンパウンド
```

セッション状態は会話をまたいで永続化されます：`session_state.json` + 日次日記 + インスティンクトインデックス。各セッションは前回終了した場所から開始します。

```
~/.cystem31/
├── memory/
│   ├── session_state.json   ← アクティブなプロジェクト、未完了タスク、保留中の決定
│   ├── diary/YYYY-MM-DD.md  ← 日次セッションログ
│   └── instincts/           ← 確信度スコア付きの進化した行動パターン
└── solutions-registry.md    ← クロスプロジェクトのソリューションインデックス
```

---

### 5. 知識フライホイール

> *由来：Compound Engineering Plugin（コンパウンドステップ）+ GSD Core（メモリよりアーティファクト）*

解決されたすべての問題が検索可能な組織の記憶になります。フライホイール：

```
解決 → C31-compound → docs/solutions/[カテゴリ]/YYYY-MM-DD.md
                              ↓
                        INDEX.md を更新  ← 必須
                              ↓
                 solutions-registry.md（クロスプロジェクト）
                              ↓
              次のセッション：プレサーチがサイレントにレジストリをチェック
                              ↓
              ヒット → 「📋 先行アートを発見」→ コンテキストに注入
              ミス → サイレントに継続
                              ↓
          同じ問題の次の発生：数時間ではなく数分
```

C31 でブートストラップされた新しいプロジェクトは、すべての先行ソリューションを即座に継承します。

---

### 6. コンテキスト健全性モニタリング

> *由来：12-Factor Agents（F3：コンテキストウィンドウを所有する）+ GSD Core（コンテキスト劣化）*

長時間セッションは AI の品質をサイレントに低下させます。C31 は監視し、対処します：

| 状態 | 使用率 | アクション |
|------|--------|----------|
| 🟢 グリーン | <50% | 通常動作 |
| 🟡 イエロー | 50–70% | 完了した作業の圧縮を開始 |
| 🟠 オレンジ | 70–85% | 決定をファイルへ移動、仮定をアーカイブ |
| 🔴 レッド | >85% | 強制チェックポイント：状態を書き込んでから継続 |

---

### 7. 心理的フレーミング層

> *由来：Superpowers（チャルディーニ合規メカニズム）+ agent-skills（疑念ゲート、反追従性）*

- **ステップバイステップ推論**：出力前の内部思考連鎖でエラーを約 34% 削減
- **クリティックゲート**：300 語超の推論的結論に対して自動自己監査をトリガー
- **反追従性**：技術的厳密さが社交的快適さに優先——異議に対しては独立した評価をトリガーし、妥協しない
- **疑念ゲート**：不可逆操作に対して、主張を書く → 最小監査可能ユニットを分離 → 対立的レビュアーを生成

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
| **[エンジニアリング哲学](PHILOSOPHY.md)** | 5 つの Karpathy 原則 + 疑念駆動開発 + Chesterton のフェンス + 確信度ルーティング |
| **[ワークフローアーキテクチャ](WORKFLOW.md)** | 6 ステップライフサイクル + 4 つのマルチエージェントオーケストレーションパターン（Mermaid 図付き）|
| **[C31 対各フレームワーク](ADVANTAGES.md)** | 7 つのフレームワークが単独で不十分な理由と C31 が追加するもの |
| **[エラーガバナンス](ERROR-GOVERNANCE.md)** | 3 段階エラー分類 · Fix-it カスケード · 自律的なライフサイクル変更の禁止 |
| **[メモリシステム](AGENTS.template.md#session-startup-protocol)** | セッション状態、日記、インスティンクトの連携方法 |
| **[インスティンクト進化](AGENTS.template.md#instinct-system)** | パターンが候補から自動適用インスティンクトへ昇格する仕組み |
| **[コンテキスト健全性](AGENTS.template.md#own-your-context-window)** | 長時間セッションのための 4 状態コンテキストシステムの管理 |
| **[スキルインデックス](skills/)** | EN · ZH · JA のトリガーを持つ全 43+ スキル |
| **[サブエージェントテンプレート](agents/)** | すぐに使えるレビュアー、コンパウンド、デバッグのサブエージェント promptテンプレート |

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

## Agent Harness Papers — 論文シリーズ

問題からシステムへの全過程を記録した 10 本の記事——C31 の背後にあるフレームワーク、第一原理から最終統合まで。

| 番号 | タイトル |
|------|----------|
| [第 0 部](https://github.com/ChianW/C31-papers/blob/master/part0_introduction.md) | なぜ Agent Harness が必要か |
| [第 1 部](https://github.com/ChianW/C31-papers/blob/master/part1_12_factor_agents.md) | 12-Factor Agents — アーキテクチャ宣言 |
| [第 2 部](https://github.com/ChianW/C31-papers/blob/master/part2_superpowers.md) | Superpowers — 心理学ハック |
| [第 3 部](https://github.com/ChianW/C31-papers/blob/master/part3_ecc.md) | Everything Claude Code — オペレーティングレイヤー |
| [第 4 部](https://github.com/ChianW/C31-papers/blob/master/part4_agent_skills.md) | Agent Skills — 怠惰防止フレームワーク |
| [第 5 部](https://github.com/ChianW/C31-papers/blob/master/part5_cep.md) | Compound Engineering — コンパウンドエンジン |
| [第 6 部](https://github.com/ChianW/C31-papers/blob/master/part6_archon.md) | Archon — 決定論的 AI パイプライン |
| [第 7 部](https://github.com/ChianW/C31-papers/blob/master/part7_gsd_core.md) | GSD Core — コンテキスト劣化の命名 |
| [第 8 部](https://github.com/ChianW/C31-papers/blob/master/part8_comparison.md) | 7 つのフレームワーク比較 |
| [第 9 部](https://github.com/ChianW/C31-papers/blob/master/part9_building_c31.md) | ゼロから C31 へ |
| [**第 10 部**](https://github.com/ChianW/C31-papers/blob/master/part10_the_architecture.md) | **アーキテクチャ——プロダクションにおける C31** |

→ **[ChianW/C31-papers](https://github.com/ChianW/C31-papers)**

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
