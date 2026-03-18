# BudgetBuddy

A personal finance tracker for iOS built with SwiftUI and SwiftData. BudgetBuddy lets you log and manage your daily expenses, visualize spending trends, and get AI-powered budgeting insights powered by Claude.

---

## Screenshots

> Coming soon

---

## Features

### Core
- **Transaction management** — add, edit, and delete transactions with merchant, amount, date, and category
- **SwiftData persistence** — all data is stored on-device and survives app restarts
- **Category system** — 9 main categories with subcategories and FontAwesome icons
- **Search and filter** — search by merchant name or filter the full list by category

### Dashboard
- **Monthly budget card** — circular progress indicator showing spend vs budget for the current month
- **Monthly expenses bar chart** — interactive chart with tap-to-select month detail, built with Apple's Charts framework
- **Monthly summary** — month-by-month expense breakdown sorted by most recent
- **Recent transactions** — quick view of the 5 most recent transactions with one-tap access to the full list

### Security
- **Face ID / Touch ID** authentication on launch
- **PIN fallback** — set and use a numeric PIN if biometrics are unavailable
- **Keychain storage** — PIN and API key stored securely using the iOS Keychain

### AI Insights
- **Claude-powered tips** — sends aggregated category totals (no raw transaction data) to Anthropic's Claude API and returns 2–4 actionable budgeting tips
- **Privacy-first design** — only monthly category totals leave the device, never individual transactions
- **On-device fallback** — if no API key is set or the network is unavailable, a heuristic engine generates offline tips
- **Caching** — insights are cached per month so the API is not called on every view
- **Rate limiting** — 90 second cooldown between regeneration requests
- **Secure key storage** — API key is stored in the Keychain, never hardcoded

### Calendar
- **Calendar view** — browse transactions by day using a graphical date picker

---

## Tech Stack

| Area | Technology |
|---|---|
| Language | Swift 5.9 |
| UI | SwiftUI |
| Persistence | SwiftData |
| Charts | Apple Charts framework |
| AI | Anthropic Claude API (claude-haiku-4-5) |
| Auth | LocalAuthentication (Face ID / Touch ID) |
| Storage | Keychain Services |
| Dependencies | SwiftUIFontIcon, Swift Collections, SwiftUICharts |

---

## Architecture

The app follows an **MVVM** pattern with SwiftData driving data flow:

- `TransactionListViewModel` — lightweight ObservableObject holding UI state (search text, selected category, monthly budget). Does not own or fetch transaction data.
- Views use `@Query` to fetch transactions directly from SwiftData, sorted and filtered at the query level.
- `SpendingAggregator` — pure on-device logic that computes monthly totals and spending pace from any `[BBTransactionLike]` array, keeping it independent of the app's model layer.
- `AIInsightsService` — handles Claude API calls, caching via `InsightsCache`, and falls back to `HeuristicInsightsGenerator` on failure.

---

## Getting Started

### Requirements
- Xcode 15 or later
- iOS 17 or later
- An Anthropic API key (optional — the app works without one using offline heuristics)

### Setup
1. Clone the repo
   ```bash
   git clone https://github.com/Basim415/BudgetBuddy.git
   ```
2. Open `BudgetBuddy.xcodeproj` in Xcode
3. Build and run on a simulator or device
4. On first launch the app seeds itself with sample transaction data so the dashboard is populated immediately

### AI Insights (optional)
1. Get a free API key at [console.anthropic.com](https://console.anthropic.com)
2. Open the app → Settings (gear icon) → AI Insights
3. Paste your key and tap Save
4. Navigate to Your Insights → tap Regenerate

---

## Roadmap

These are the planned improvements in rough priority order:

- [ ] **Redesigned Insights screen** — visual spending breakdown with category progress bars and month-over-month comparison before the AI tips
- [ ] **Smarter Claude prompt** — include month-over-month deltas, spending pace, and category spike detection for more specific and actionable tips
- [ ] **iCloud sync** — sync transactions across devices using CloudKit + SwiftData
- [ ] **Recurring transactions** — mark transactions as recurring and have them auto-populate each month
- [ ] **Budget per category** — set individual limits per category, not just a single monthly total
- [ ] **Export** — export transactions to CSV
- [ ] **Widgets** — home screen widget showing current month spend vs budget

---

## Dependencies

- [SwiftUIFontIcon](https://github.com/huybuidac/SwiftUIFontIcon) — FontAwesome icons in SwiftUI
- [Swift Collections](https://github.com/apple/swift-collections) — ordered and efficient collection types
- [SwiftUICharts](https://github.com/AppPear/ChartView) — supplementary chart components

---

## License

MIT
