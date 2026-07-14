# TrueFit AI Comparison — Design Document

## 1. Overview

The AI Comparison feature allows users to select 2 or more products from the Home screen and request an intelligent, structured comparison powered by Google Gemini. The AI provides a beautiful, card-based UI that displays a per-product analysis alongside a holistic summary, and supports follow-up questions in a guided chat interface.

---

## 2. Design Principles

| Principle | Application |
|---|---|
| **Structured over conversational** | Initial comparison returns structured JSON, rendered as rich UI cards — not a raw text bubble. |
| **Graceful degradation** | If AI returns malformed JSON, the app falls back to markdown text bubbles. |
| **Security-first** | The Gemini API key is never hardcoded in source. It is injected via `Config.xcconfig` → `Info.plist` → `Bundle.main.infoDictionary` at runtime. |
| **Scoped intelligence** | A strict `systemInstruction` constrains the AI to fashion/shopping topics only. |
| **Consistent design system** | All UI components use TrueFit's design tokens (`Spacing`, `Radius`, `Color`, `trueFitTextStyle`). |

---

## 3. User Flow

```
Home Screen
   │
   ├─ Long-press product → selects product (ComparisonManager)
   ├─ Tap product → navigates to Product Details (no selection)
   │
   └─ Tap Compare button (header)
         ├─ < 2 products selected → TrueFitToast("Select at least 2 products to compare")
         └─ ≥ 2 products selected → Navigate to AIComparisonView
                  │
                  ├─ ViewModel sends JSON-schema prompt to Gemini
                  ├─ Gemini returns structured JSON
                  ├─ App parses → AIComparisonResult
                  │
                  ├─ Display RichComparisonView
                  │     ├─ AI Summary card
                  │     └─ Horizontal product analysis cards (pros/cons/bestFor)
                  │
                  └─ User asks follow-up question
                        ├─ App appends JSON schema instructions to prompt
                        ├─ Gemini responds with structured AIFollowUpResult
                        └─ Display FollowUpCard (title + explanation + key points)
```

---

## 4. Color & Component Design

### Product Analysis Card
- **Background**: `Color.surface`
- **Border radius**: `Radius.lg`
- **Shadow**: `.trueFitShadow(.sm)`
- **Pros**: `Color.semanticSuccess` with `checkmark.circle.fill` icon
- **Cons**: `Color.semanticDanger` with `xmark.circle.fill` icon
- **Best For**: `Color.brandPrimary` label

### Follow-Up Answer Card
- **Icon**: `sparkles` (SF Symbols) in `Color.brandPrimary`
- **Title**: `.headline` text style
- **Explanation**: `.subheadline` in `Color.textSecondary`
- **Key Points**: Bulleted list with `Color.brandPrimary` dot indicator

### Loading State
- `ProgressView` inside a `Color.surface` rounded card

---

## 5. API Payload Structure

### Initial Comparison Prompt Output (from Gemini)
```json
{
    "analyses": [
        {
            "productId": "string",
            "title": "string",
            "summary": "string",
            "pros": ["string"],
            "cons": ["string"],
            "bestFor": "string"
        }
    ],
    "overallSummary": "string"
}
```

### Follow-Up Response Output (from Gemini)
```json
{
    "title": "string",
    "explanation": "string",
    "keyPoints": [
        {
            "pointTitle": "string",
            "pointDescription": "string"
        }
    ]
}
```
