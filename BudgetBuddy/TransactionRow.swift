import SwiftUI
import Foundation
import SwiftUIFontIcon

struct TransactionRow: View {
    var transaction: Transaction

    var body: some View {
        HStack(spacing: 20) {
            // MARK: Category icon
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.appIcon.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.appIcon)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)

                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)

                // `date` is now a real Date — no more dateParsed needed
                Text(transaction.date, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // `transactionType` replaces the old `type` property
            Text(transaction.signedAmount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(transaction.transactionType == "credit" ? Color.appText : .red)
                .padding(.vertical, 8)
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if let transaction = transactionListPreviewData.first {
                TransactionRow(transaction: transaction)
                    .previewLayout(.sizeThatFits)
                    .padding()

                TransactionRow(transaction: transaction)
                    .preferredColorScheme(.dark)
                    .previewLayout(.sizeThatFits)
                    .padding()
            } else {
                Text("No preview data available")
            }
        }
    }
}
