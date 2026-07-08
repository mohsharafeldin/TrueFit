//
//  OrderStatusTimeline.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderStatusTimeline: View {
    let currentStatus: OrderStatus
    private let steps = ["Placed", "Processing", "Shipped", "Delivered"]
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            HStack(spacing: 0) {
                ForEach(0..<steps.count, id: \.self) { index in
                    let step = steps[index]
                    let isActive = isStepActive(step: step)
                    let isLast = index == steps.count - 1
                    
                    HStack(spacing: 0) {
                        // Icon Circle
                        ZStack {
                            Circle()
                                .fill(isActive ? Color.brandPrimary : Color.trueFitBackground)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle().stroke(isActive ? Color.clear : Color.borderColor, lineWidth: 1)
                                )
                            
                            Image(systemName: getIcon(for: step, isActive: isActive))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(isActive ? .white : .textTertiary)
                        }
                        
                        // Connecting Line
                        if !isLast {
                            Rectangle()
                                .fill(isActive && isLineActive(step: step) ? Color.brandPrimary : Color.borderColor)
                                .frame(height: 2)
                        }
                    }
                }
            }
            
            // Labels
            HStack {
                ForEach(steps, id: \.self) { step in
                    Text(step)
                        .trueFitTextStyle(.caption2)
                        .fontWeight(isStepActive(step: step) ? .semibold : .regular)
                        .foregroundColor(isStepActive(step: step) ? .textPrimary : .textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
    
    private func isStepActive(step: String) -> Bool {
        if currentStatus == .cancelled { return false }
        let currentIndex = steps.firstIndex(of: currentStatus.rawValue) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex <= currentIndex
    }
    
    private func isLineActive(step: String) -> Bool {
        if currentStatus == .cancelled { return false }
        let currentIndex = steps.firstIndex(of: currentStatus.rawValue) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        return stepIndex < currentIndex
    }
    
    private func getIcon(for step: String, isActive: Bool) -> String {
        guard isActive else { return "circle.fill" }
        switch step {
        case "Placed": return "bag.fill"
        case "Processing": return "gearshape.fill"
        case "Shipped": return "box.truck.fill"
        case "Delivered": return "checkmark"
        default: return "circle.fill"
        }
    }
}

struct OrderStatusTimeline_Previews: PreviewProvider {
    static var previews: some View {

        OrderStatusTimeline(currentStatus: .shipped)
            .padding()

    }
}
