//
//  OrderImagesOverlapView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderImagesOverlapView: View {
    let imageURLs: [URL?]
    let totalItems: Int
    private let maxImagesToShow = 3
    private let imageSize: CGFloat = 46
    
    var body: some View {
        HStack(spacing: -Spacing.sm) {
            ForEach(0..<min(imageURLs.count, maxImagesToShow), id: \.self) { index in
                AsyncImage(url: imageURLs[index]) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.surface
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .foregroundColor(.textTertiary.opacity(0.5))
                            )
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.surface, lineWidth: 2))
                .zIndex(Double(maxImagesToShow - index))
            }
            
            // +X More Indicator
            if totalItems > maxImagesToShow {
                ZStack {
                    Circle()
                        .fill(Color.surface)
                        .frame(width: imageSize, height: imageSize)
                        .overlay(Circle().stroke(Color.borderColor, lineWidth: 1))
                    
                    Text("+\(totalItems - maxImagesToShow)")
                        .trueFitTextStyle(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.textSecondary)
                }
                .zIndex(0)
            }
        }
    }
}

#Preview {
    OrderImagesOverlapView(imageURLs: [URL(string: "https://example.com/1"), URL(string: "https://example.com/2")], totalItems: 2)
}

