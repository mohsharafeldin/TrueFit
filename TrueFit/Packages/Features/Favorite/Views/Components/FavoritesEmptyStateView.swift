//
//  FavoritesEmptyStateView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import SwiftUI

struct FavoritesEmptyStateView: View {
    
    let isSearching: Bool
    var isGuest: Bool = false
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.statusWishlistActive.opacity(0.08))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(isGuest ? .gray : .statusWishlistActive)
            }
            
            VStack(spacing: Spacing.sm) {
                Text(isGuest ? "Login Required" : (isSearching ? "No Results" : "No Favorites Yet!"))
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text(isGuest ? "Please log in to view and save your favorite items." : (isSearching ? "We couldn't find anything matching your search." : "Tap the heart icon on products you love to save them here for later."))
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxxl)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
