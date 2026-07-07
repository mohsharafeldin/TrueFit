//
//  OrderStatusTabs.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderStatusTabs: View {
    @Binding var selectedStatus: OrderStatus
    @Namespace private var tabAnimation
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    Button(action: {
                        withAnimation(TrueFitMotion.springSnappy) {
                            selectedStatus = status
                        }
                    }) {
                        Text(status.rawValue)
                            .trueFitTextStyle(.subheadline)
                            .fontWeight(selectedStatus == status ? .semibold : .regular)
                            .foregroundColor(selectedStatus == status ? .white : .textSecondary)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                ZStack {
                                    if selectedStatus == status {
                                        RoundedRectangle.trueFit(Radius.pill)
                                            .fill(Color.brandPrimary)
                                            .matchedGeometryEffect(id: "statusTab", in: tabAnimation)
                                    } else {
                                        RoundedRectangle.trueFit(Radius.pill)
                                            .fill(Color.surface)
                                            .overlay(
                                                RoundedRectangle.trueFit(Radius.pill)
                                                    .stroke(Color.borderColor, lineWidth: 1)
                                            )
                                    }
                                }
                            )
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

#Preview {
    OrderStatusTabs(selectedStatus: .constant(.all))
        .padding(.vertical)
        .background(Color.trueFitBackground)
}
