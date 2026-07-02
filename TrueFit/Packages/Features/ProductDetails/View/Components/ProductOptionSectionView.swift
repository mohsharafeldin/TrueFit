//
//  ProductOptionSectionView.swift
//  TrueFit
//
//  Created by Mona Zarea on 02/07/2026.
//

import SwiftUI


struct ProductOptionSectionView: View {
    let option: ProductOption
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(option.name)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(option.values, id: \.self) { value in
                        
                        let isSelected = viewModel.selectedOptions[option.name] == value
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectOption(name: option.name, value: value)
                            }
                        }) {
                            if option.name.lowercased().contains("color") || option.name.lowercased().contains("colour") {
                                Circle()
                                    .fill(colorFromString(value))
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Circle()
                                            .stroke(isSelected ? Color.textPrimary : Color.borderColor,
                                                    lineWidth: isSelected ? 2.5 : 1)
                                    )
                                    .overlay(
                                        isSelected ? Image(systemName: "checkmark").foregroundColor(.white).font(.system(size: 14, weight: .bold)) : nil
                                    )
                                    .shadow(color: isSelected ? Color.black.opacity(0.3) : .clear, radius: 2)
                                
                            } else {
                                Text(value)
                                    .trueFitTextStyle(.callout)
                                    .fontWeight(isSelected ? .bold : .regular)
                                    .foregroundColor(isSelected ? .surface : .textPrimary)
                                    .padding(.horizontal, Spacing.lg)
                                    .padding(.vertical, Spacing.sm)
                                    .background(isSelected ? Color.brandPrimary : Color.surface)
                                    .clipShape(RoundedRectangle.trueFit(Radius.md))
                                    .overlay(
                                        RoundedRectangle.trueFit(Radius.md)
                                            .stroke(isSelected ? Color.clear : Color.borderColor, lineWidth: 1)
                                    )
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "black": return .black
        case "blue": return .brandPrimary
        case "green": return .brandSecondary
        case "white": return .white
        case "gray", "grey": return .gray
        case "brown": return .brown
        default: return .disabledColor
        }
    }
}
