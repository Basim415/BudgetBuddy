//
//  AIInsightsView.swift
//  BudgetBuddy
//
//  Calls Claude for spending insights and falls back to heuristics
//  if the network is unavailable or no API key has been saved.
//

import Foundation
import SwiftUI
import SwiftData

struct AIInsightsView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var envelope: InsightsEnvelope? = nil
    @State private var isLoading = false
    @State private var errorText: String? = nil

    @State private var nextAllowedRequest: Date = .distantPast
    private let cooldown: TimeInterval = 90

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header

                if let errorText {
                    Text(errorText)
                        .foregroundStyle(.orange)
                        .font(.caption)
                        .padding(.bottom, 4)
                }

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Asking Claude…")
                        Spacer()
                    }
                    .padding(.vertical)
                }

                if let envelope {
                    ForEach(envelope.tips) { tip in tipRow(tip) }
                } else if !isLoading && errorText == nil {
                    Text("No insights yet — tap Regenerate.")
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 24)
            }
            .padding()
        }
        .navigationTitle("AI Insights")
        .task { await loadInsights(useCache: true) }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Monthly Tips").font(.headline)
                Text("Only category totals are sent to Claude.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                Task { await loadInsights(useCache: false) }
            } label: {
                Text(Date() < nextAllowedRequest ? "Cooldown…" : "Regenerate")
            }
            .buttonStyle(.borderedProminent)
            .disabled(Date() < nextAllowedRequest || isLoading)
        }
    }

    @ViewBuilder
    private func tipRow(_ tip: InsightsEnvelope.Tip) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(tip.title).font(.subheadline).bold()
            Text(tip.text).font(.body)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Data loading

    @MainActor
    private func loadInsights(useCache: Bool) async {
        isLoading = true
        errorText = nil

        let agg = SpendingAggregator.aggregate(
            transactions: transactions.asBBTransactions,
            month: Date(),
            monthlyBudget: transactionListVM.monthlyBudget
        )

        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            AIInsightsService().generateInsights(aggregate: agg, forceRefresh: !useCache) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let env):
                        self.envelope = env
                        self.errorText = nil
                    case .failure(let err):
                        // Graceful fallback to on-device heuristics
                        self.envelope = HeuristicInsightsGenerator.generate(from: agg)
                        self.errorText = "Showing offline tips (\(err.localizedDescription))"
                    }
                    self.nextAllowedRequest = Date().addingTimeInterval(self.cooldown)
                    cont.resume()
                }
            }
        }
    }
}
