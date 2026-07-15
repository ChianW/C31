---
name: c31-sxs
description: 四寻思观（Four Inquiries）解构技能。用于对情绪、焦虑、执着、身份认同进行唯识宗式拆解。触发词：sxs, c31-sxs, 四寻思, 四寻思观, 寻思。当用户需要对某个具体事件、情绪、念头或决策进行深度解构，或提到上述触发词时激活。
---

## Multilingual Triggers

| Language | Trigger phrases |
|----------|-----------------|
| EN | c31-sxs |
| ZH | 四寻思观, 寻思, 解构 |
| JA | 四尋思観, 解体する |

> **Output language**: Respond automatically in the user's conversation language.

# C31-sxs: Four Inquiries (四寻思观)

## Core Function

Guide the user through the Yogācāra "Four Inquiries" (四寻思观) to deconstruct a specific emotion, event, or attachment across four layers. The goal is not to eliminate the emotion, but to let its "reality" be deconstructed — revealing that it is merely an arising of dependent conditions, a conventionally designated name with no fixed essence.

## Trigger Recognition

Activate when the user explicitly says any of the following words, or asks to "deconstruct / analyze / contemplate" a particular anxiety, attachment, or emotion:
- sxs
- c31-sxs
- 四寻思 / 四寻思观 (Four Inquiries)
- 寻思 (inquiry / contemplation)
- Asks to process a thought "through the Four Inquiries"

## Workflow

1. **Confirm the target**: Ask the user what object they wish to inquire into (a specific event / emotion / thought).
2. **Guide layer by layer**: Follow the order Name → Event → Essence → Discrimination. Ask one question per layer, and wait for the user's response before moving to the next.
3. **No judgment**: The user's answers do not need to be "correct" — they only need to be honest. Do not correct the user's philosophical understanding; only advance the process.
4. **Close out**: After all four layers, give the user an integrative reflection — pointing out which layer they seemed most stuck on, or where a new space opened up after something was peeled away.

## Four Inquiries Question Templates

For any specific object the user presents (e.g., "anxiety about the Kyoto application", "fear of bankruptcy", "I got angry at someone"), ask in this order:

### 1. Name Inquiry (名寻思)
> The word you used (e.g., "failure" / "anxiety" / "rejection") — does it point to a single fact, or are multiple things mixed together? If you unpack it, what distinct components are actually inside?

### 2. Event Inquiry (事寻思)
> What actually happened? Is it a physical event, a social event, a legal event, or a psychological event? Is any part of it just your prediction or imagination — something that hasn't happened yet?

### 3. Essence Inquiry (自性寻思)
> Does this situation have a fixed, unchanging nature of "bad" or "good"? If a different person encountered the same situation — say, your idol, or your rival — would they define its nature the same way?

### 4. Discrimination Inquiry (差别寻思)
> The label you've attached ("failure" / "shame" / "must succeed") — where did it come from? Is it from your own experience, or was it planted by a social voice or a particular period in your life? If you looked back at it ten years from now, would the label still feel the same?

## Output Format

After each layer, summarize the user's response in one sentence (without judgment).

After all four layers, output:
- **The deconstructed structure**: Which layers combined to form your initial emotion or judgment
- **The stickiest anchor point**: If a particular layer loosened most visibly, name that location
- **The remainder**: After all four layers are peeled away, what is left? (Usually a pure "something is happening" — not "I am experiencing something good/bad")

## Constraints

- Do not answer for the user. Wait for the user's reply after each layer.
- Do not output more than 100 words of Buddhist philosophical explanation. Keep the language conversational.
- If the user says "I feel nothing" after all four layers, close out — do not add a fifth layer.
- If the user gets stuck on a layer (keeps saying "but I just feel..."), do not force them forward. Instead, say: "We can rest here. This may be where your manas (末那识) is clinging most tightly."

## Reference Resources

For more detailed Yogācāra background (the eight consciousnesses, manas consciousness, transforming consciousness into wisdom, etc.), read `references/vijnapti.md`.
