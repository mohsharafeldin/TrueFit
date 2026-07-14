//
//  OrderEmptyStateView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderEmptyStateView: View {
    let status: OrderStatus
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.08))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "box.truck")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: Spacing.sm) {
                Text(titleMessage)
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text(bodyMessage)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxxl)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var titleMessage: String {
        status == .all ? "No Orders Yet" : "No \(status.rawValue) Orders"
    }
    
    private var bodyMessage: String {
        status == .all
        ? "You haven't placed any orders yet. Explore our collections and find something you love!"
        : "You don't have any orders currently in \(status.rawValue.lowercased()) status."
    }
}

struct OrderEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {

        OrderEmptyStateView(status: .all)

    }
}
