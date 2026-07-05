//
//  AddressView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 04/07/2026.
//

import SwiftUI

struct AddressView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showActionSheet = false
    @State private var isMenuPressed = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                // Nav Bar
                ZStack {
                    Text("Address Book")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.surface)
                .overlay(
                    Rectangle()
                        .fill(Color.borderColor)
                        .frame(height: 0.5),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // Add new address
                        Button(action: {
                            // TODO: Navigate to add address flow
                        }) {
                            HStack {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Add new address")
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .foregroundColor(.brandPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textTertiary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.surface)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.borderColor, lineWidth: 0.5)
                            )
                        }
                        
                        // Address card (static for now — will come from API later)
                        VStack(spacing: 0) {
                            HStack {
                                HStack(spacing: 8) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.surface)
                                            .frame(width: 26, height: 26)
                                        Image(systemName: "house.fill")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.brandPrimary)
                                    }
                                    
                                    Text("Home")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.textPrimary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                        isMenuPressed = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                            isMenuPressed = false
                                        }
                                    }
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        showActionSheet = true
                                    }
                                }) {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.textSecondary)
                                        .rotationEffect(.degrees(isMenuPressed ? 90 : 0))
                                        .scaleEffect(isMenuPressed ? 1.2 : 1.0)
                                        .frame(width: 32, height: 32)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.brandPrimary.opacity(0.08))
                            
                            Text("مركز الخارجة حي الامل عمارة 16 شقة 3, عمارة 16, بجانب ملعب الامل او السجل المدني, محافظة الوادي الجديد - مصر")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.trailing)
                                .environment(\.layoutDirection, .rightToLeft)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .background(Color.surface)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.borderColor, lineWidth: 0.5)
                        )
                    }
                    .padding(16)
                }
            }
            .background(Color.trueFitBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            
            // Custom animated action sheet
            if showActionSheet {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showActionSheet = false
                        }
                    }
                
                VStack {
                    Spacer()
                    CustomActionSheet(
                        onEdit: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showActionSheet = false
                            }
                            // TODO: Navigate to edit address
                        },
                        onShare: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showActionSheet = false
                            }
                            // TODO: Trigger share sheet
                        },
                        onCancel: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showActionSheet = false
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}

#Preview {
    AddressView()
}
