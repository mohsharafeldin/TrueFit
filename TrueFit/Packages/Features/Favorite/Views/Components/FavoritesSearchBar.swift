//
//  FavoritesSearchBar.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import SwiftUI

struct FavoritesSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textTertiary)
            
            TextField("Search inside favorites...", text: $text)
                .trueFitTextStyle(.body)
                .foregroundColor(.textPrimary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.md))
        .overlay(
            RoundedRectangle.trueFit(Radius.md)
                .stroke(Color.textTertiary.opacity(0.15), lineWidth: 1)
        )
    }
}
