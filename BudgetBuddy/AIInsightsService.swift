//
//  AIInsightsService.swift
//  BudgetBuddy
//
//  Calls the Anthropic Claude API to generate spending insights.
//  Only aggregated category totals are sent — no raw transaction details.
//

import Foundation

final class AIInsightsService {

    // MARK: - Public

    func generateInsights(
        aggregate: AISpendingAggregate,
        forceRefresh: Bool = false,
        completion: @escaping (Result<InsightsEnvelope, Error>) -> Void
    ) {
        let cacheKey = InsightsCache.shared.key(
            month: aggregate.month,
            aggHash: aggregate.sha256()
        )

        // Return cached result unless caller forces a refresh
        if !forceRefresh, let cached = InsightsCache.shared.load(key: cacheKey) {
            completion(.success(cached))
            return
        }

        guard let apiKey = KeychainHelper.shared.getAPIKey(), !apiKey.isEmpty else {
            completion(.failure(ServiceError.missingAPIKey))
            return
        }

        callClaude(aggregate: aggregate, apiKey: apiKey) { result in
            if case .success(let env) = result {
                InsightsCache.shared.save(env, key: cacheKey)
            }
            completion(result)
        }
    }

    // MARK: - Private

    private func callClaude(
        aggregate: AISpendingAggregate,
        apiKey: String,
        completion: @escaping (Result<InsightsEnvelope, Error>) -> Void
    ) {
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.timeoutInterval = 20

        let prompt = buildPrompt(from: aggregate)

        let body: [String: Any] = [
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 512,
            "system": systemPrompt,
            "messages": [["role": "user", "content": prompt]]
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(ServiceError.encodingFailed))
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            do {
                let envelope = try Self.parseResponse(data: data)
                completion(.success(envelope))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Prompt construction

    private let systemPrompt = """
    You are a personal finance assistant. The user will send you aggregated spending data \
    (no individual transactions, just category totals). \
    Respond ONLY with a valid JSON object matching this exact schema — no markdown, no extra text:
    {
      "tips": [
        { "title": "Short title", "text": "Actionable advice in 1-2 sentences.", "priority": 1 }
      ]
    }
    Priority 1 = most urgent. Return 2-4 tips. Be specific, practical, and encouraging.
    """

    private func buildPrompt(from agg: AISpendingAggregate) -> String {
        var lines: [String] = ["Here is my spending summary for \(agg.month):"]

        lines.append("Spent so far this month: \(currency(agg.pace.spentToDate))")
        lines.append("Projected month-end total: \(currency(agg.pace.projected))")

        if let budget = agg.budget {
            lines.append("Monthly budget: \(currency(budget))")
        }

        lines.append("\nCategory breakdown:")
        for (cat, amount) in agg.totalsByCategory.sorted(by: { $0.value > $1.value }) {
            lines.append("  \(cat): \(currency(amount))")
        }

        lines.append("\nPlease give me 2-4 actionable tips as JSON.")
        return lines.joined(separator: "\n")
    }

    // MARK: - Response parsing

    private static func parseResponse(data: Data) throws -> InsightsEnvelope {
        // Claude wraps the response in a messages structure
        struct ClaudeResponse: Decodable {
            struct Content: Decodable {
                let type: String
                let text: String?
            }
            let content: [Content]
        }

        let claudeResp = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        guard let text = claudeResp.content.first(where: { $0.type == "text" })?.text else {
            throw ServiceError.emptyResponse
        }

        // Strip any accidental markdown fences
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleaned.data(using: .utf8) else {
            throw ServiceError.decodingFailed
        }

        // InsightsEnvelope.Tip has a UUID `id` field not present in JSON, so decode manually
        struct RawTip: Decodable {
            let title: String
            let text: String
            let priority: Int
        }
        struct RawEnvelope: Decodable {
            let tips: [RawTip]
        }

        let raw = try JSONDecoder().decode(RawEnvelope.self, from: jsonData)
        let tips = raw.tips.map {
            InsightsEnvelope.Tip(title: $0.title, text: $0.text, priority: $0.priority)
        }
        return InsightsEnvelope(tips: tips.sorted { $0.priority < $1.priority })
    }

    // MARK: - Errors

    enum ServiceError: LocalizedError {
        case missingAPIKey, invalidURL, encodingFailed, noData, emptyResponse, decodingFailed

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:  return "No API key found. Add one in Settings."
            case .invalidURL:    return "Invalid API URL."
            case .encodingFailed: return "Failed to encode request."
            case .noData:        return "No data received from server."
            case .emptyResponse: return "Claude returned an empty response."
            case .decodingFailed: return "Could not parse the AI response."
            }
        }
    }
}
