//
//  FavoritesHeaderView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import SwiftUI

struct FavoritesHeaderView: View {
    let count: Int
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("My Wishlist")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text("\(count) items saved")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 22))
                .foregroundColor(.statusWishlistActive)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.md)
        .background(Color.surface)
    }
}
