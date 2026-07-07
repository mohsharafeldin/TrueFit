//
//  AddressView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 04/07/2026.
//

import SwiftUI

struct AddressView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appRouter: AppRouter
    @StateObject private var viewModel: AddressViewModel

    @State private var showActionSheet = false
    @State private var isMenuPressed = false
    @State private var selectedAddress: Address?



    init(viewModel: AddressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
                            appRouter.navigate(to: .addNewAddress)
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

                        // MARK: - Content states

                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)

                        } else if viewModel.addresses.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "mappin.slash")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.textTertiary)

                                Text("No saved addresses yet")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.top, 60)

                        } else {
                            ForEach(viewModel.addresses) { address in
                                addressCard(for: address)
                            }
                        }
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
                            if let address = selectedAddress {
                                appRouter.navigate(to: .editAddress(address: address))
                            }
                        },
                        onDelete: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showActionSheet = false
                            }
                            if let address = selectedAddress {
                                Task { await viewModel.removeAddress(addressId: address.id) }
                            }
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
        .onAppear {
            Task { await viewModel.loadAddresses() }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }

    }

    // MARK: - Address Card

    @ViewBuilder
    private func addressCard(for address: Address) -> some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.surface)
                            .frame(width: 26, height: 26)
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.brandPrimary)
                    }

                    Text(address.city)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                Button(action: {
                    selectedAddress = address
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
                        .rotationEffect(.degrees(isMenuPressed && selectedAddress?.id == address.id ? 90 : 0))
                        .scaleEffect(isMenuPressed && selectedAddress?.id == address.id ? 1.2 : 1.0)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.brandPrimary.opacity(0.08))

            Text("\(address.address1), \(address.city), \(address.province), \(address.country) \(address.zip)")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.surface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 0.5)
        )
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {

        AddressView(
            viewModel: PreviewMocks.makeAddressViewModel()
        )
        .environmentObject(AppRouter())

    }
}
