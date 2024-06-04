//
//  PremiumView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 04.06.24.
//

import SwiftUI

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "crown.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)

                Text("Unlock Premium Features")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Upgrade to our premium plan and enjoy an ad-free experience, exclusive book recommendations, and advanced reading statistics.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                VStack(spacing: 16) {
                    PremiumOptionView(title: "Annual Plan", price: "17.99", period: "One-Time Payment")
                    PremiumOptionView(title: "Monthly Plan", price: "1.99", period: "Per Month")
                }

                Spacer()

                Button(action: {
                    // Handle premium purchase
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }

                Button("Restore Purchase", action: {
                    // Handle restore purchase
                })
                .padding(.top, 8)

                Button("Close", action: {
                    dismiss()
                })
                .padding(.top, 16)
            }
            .padding()
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PremiumOptionView: View {
    let title: String
    let price: String
    let period: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(period)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("$\(price)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color("CellBackgroundColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 3)
        )
    }
}


#Preview {
    PremiumView()
}
