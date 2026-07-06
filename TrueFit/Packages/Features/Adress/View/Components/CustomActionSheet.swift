//
//  CustomActionSheet.swift
//  TrueFit
//
//  Created by AndrewMagdy on 04/07/2026.
//

import SwiftUI

struct CustomActionSheet: View {
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Button(action: onEdit) {
                    Text("Edit")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                
                Divider()
                    .background(Color.borderColor)
                
                Button(action: onDelete) {
                    Text("Delete")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.surface)
            .cornerRadius(14)
            
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(Color.surface)
            .cornerRadius(14)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    CustomActionSheet(onEdit: {}, onDelete: {}, onCancel: {})
}
