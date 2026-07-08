# TrueFit AI — Layers & Architecture

## Architecture Overview

The TrueFit AI Comparison feature is built following a clean, layered architecture that separates concerns between **data sourcing**, **business logic**, and **UI presentation**.

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│     AIComparisonView, RichComparisonView,               │
│     ProductAnalysisCard, FollowUpCard, ChatBubble       │
└───────────────────────┬─────────────────────────────────┘
                        │ @StateObject / @Published
┌───────────────────────▼─────────────────────────────────┐
│                   ViewModel Layer                        │
│              AIComparisonViewModel                      │
│   (Orchestration, Prompt Engineering, JSON Parsing)     │
└───────────────────────┬─────────────────────────────────┘
                        │ async/await
┌───────────────────────▼─────────────────────────────────┐
│                   Service Layer                          │
│                   GeminiService                         │
│      (HTTP Client, System Instruction, Auth)            │
└───────────────────────┬─────────────────────────────────┘
                        │ URLSession
┌───────────────────────▼─────────────────────────────────┐
│                   External AI API                        │
│     Google Gemini REST API (generativelanguage.googleapis.com) │
└─────────────────────────────────────────────────────────┘
```

---

## Layer 1: Presentation Layer

**Location:** `Packages/Features/AIComparison/View/`

**Files:**
- `AIComparisonView.swift` — Root view. Owns the `ScrollView`, chat input, and orchestrates which sub-component to show.
- `RichComparisonView` — Renders the initial AI comparison result. Contains the AI summary card and the horizontal product cards scroll.
- `ProductAnalysisCard` — Per-product card showing title, summary, pros, cons, and "Best For".
- `FollowUpCard` — Card shown in response to follow-up chat questions. Renders a title, explanation, and bulleted key points.
- `ChatBubble` — Generic message bubble. Intelligently routes to `FollowUpCard` if the message is parseable as `AIFollowUpResult`; otherwise renders styled text.

**Design Rules:**
- No business logic. No API calls. No JSON parsing.
- Only reads from `@Published` ViewModel properties.
- Uses TrueFit design system tokens exclusively (`Spacing.*`, `Radius.*`, `Color.*`, `trueFitTextStyle()`).

---

## Layer 2: ViewModel Layer

**Location:** `Packages/Features/AIComparison/ViewModel/AIComparisonViewModel.swift`

**Responsibilities:**
- Holds the state of the comparison session (`messages`, `comparisonResult`, `isLoading`, `errorMessage`).
- Engineers the prompt for each agent type (initial comparison vs. follow-up).
- Calls `GeminiService` to fetch responses.
- Parses JSON responses into typed Swift models (`AIComparisonResult`, `AIFollowUpResult`).
- Falls back gracefully to raw text if parsing fails.

**Key Models (defined in this file):**
```
AIComparisonResult
├── ProductAnalysis[]
│   ├── productId: String
│   ├── title: String
│   ├── summary: String
│   ├── pros: [String]
│   ├── cons: [String]
│   └── bestFor: String
└── overallSummary: String

AIFollowUpResult
├── title: String
├── explanation: String
└── keyPoints: [KeyPoint]
    ├── pointTitle: String
    └── pointDescription: String
```

**Prompt Engineering Strategy:**
- **Initial comparison**: The product list + full JSON schema is embedded directly in the user message. The AI is asked to return ONLY raw JSON matching the schema.
- **Follow-up**: The user's question is enhanced before being sent — a copy of the message with an appended JSON schema instruction is sent to Gemini. The original clean message remains in the local history for display purposes.

---

## Layer 3: Service Layer

**Location:** `Packages/Core/Networking/AI/GeminiService.swift`

**Responsibilities:**
- Singleton (`GeminiService.shared`) HTTP client.
- Reads the Gemini API key securely from `Bundle.main.infoDictionary["GeminiAPIKey"]`.
- Injects the global `systemInstruction` (AI persona and scope constraints) into every single request.
- Constructs the Gemini-format `contents` array from `[ChatMessage]`.
- Handles HTTP response validation and error propagation.

**Security:**
- The API key is NEVER hardcoded in source code.
- Flow: `Config.xcconfig` (gitignored) → `Info.plist` (`$(GEMINI_API_KEY)`) → `Bundle.main` → `GeminiConfig.apiKey`.
- Teammates must copy `Config.xcconfig.example` → `Config.xcconfig` and provide their own key.

**API Endpoint:**
```
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-robotics-er-1.6-preview:generateContent?key={KEY}
```

**Request Body Shape:**
```json
{
    "systemInstruction": {
        "parts": [{ "text": "<system_prompt>" }]
    },
    "contents": [
        { "role": "user", "parts": [{ "text": "..." }] },
        { "role": "model", "parts": [{ "text": "..." }] }
    ]
}
```

---

## Layer 4: Configuration Layer

**Location:** Project root

| File | Purpose |
|---|---|
| `Config.xcconfig` | Gitignored. Holds real secret keys. |
| `Config.xcconfig.example` | Committed. Template for teammates. |
| `TrueFit/Info.plist` | Maps `$(GEMINI_API_KEY)` from xcconfig to `GeminiAPIKey`. |

---

## Data Flow Diagram (Initial Comparison)

```
User long-presses products → ComparisonManager.selectedProducts
           │
           ▼
User taps "Compare" → AIComparisonView(products:)
           │
           ▼
AIComparisonViewModel.startComparison()
    → builds prompt with product data + JSON schema
    → appends to messages[]
    → calls GeminiService.generateContent(messages:)
           │
           ▼
GeminiService
    → reads apiKey from Bundle
    → attaches systemInstruction
    → POST to Gemini REST API
    → returns raw text response
           │
           ▼
AIComparisonViewModel
    → strips ``` fences
    → JSONDecoder.decode(AIComparisonResult.self)
    → sets comparisonResult + hasStructuredResult = true
           │
           ▼
AIComparisonView
    → if hasStructuredResult → RichComparisonView(result:)
    → else → ChatBubble (text fallback)
```
