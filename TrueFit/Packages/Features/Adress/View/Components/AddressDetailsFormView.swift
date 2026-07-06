//
//  AddressDetailsFormView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct AddressDetailsFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var addressViewModel: AddressViewModel

    @State private var address: Address

    private let editingAddressId: String?

    init(
        addressViewModel: AddressViewModel,
        address: Address,
        editingAddressId: String? = nil
    ) {
        self.addressViewModel = addressViewModel
        self._address = State(initialValue: address)
        self.editingAddressId = editingAddressId
    }

    private var isSaveDisabled: Bool {
        address.address1.trimmingCharacters(in: .whitespaces).isEmpty ||
        address.city.trimmingCharacters(in: .whitespaces).isEmpty ||
        address.country.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            // Nav Bar
            ZStack {
                Text(editingAddressId == nil ? "Confirm address" : "Edit address")
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
                Rectangle().fill(Color.borderColor).frame(height: 0.5),
                alignment: .bottom
            )

            ScrollView {
                VStack(spacing: 14) {
                    formField(title: "Address", text: $address.address1, placeholder: "Street, building, apartment")
                    formField(title: "City", text: $address.city, placeholder: "City")
                    formField(title: "Province / State", text: $address.province, placeholder: "Province or state")
                    formField(title: "Country", text: $address.country, placeholder: "Country")
                    formField(title: "ZIP / Postal code", text: $address.zip, placeholder: "ZIP code")
                }
                .padding(16)
            }

            Button(action: {
                Task { await save() }
            }) {
                if addressViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                } else {
                    Text(editingAddressId == nil ? "Save address" : "Save changes")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(isSaveDisabled ? Color.brandPrimary.opacity(0.4) : Color.brandPrimary)
            .cornerRadius(14)
            .disabled(isSaveDisabled || addressViewModel.isLoading)
            .padding(16)
        }
        .background(Color.trueFitBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert("Error", isPresented: .constant(addressViewModel.errorMessage != nil)) {
            Button("OK") { addressViewModel.errorMessage = nil }
        } message: {
            Text(addressViewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func formField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textSecondary)

            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.surface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderColor, lineWidth: 0.5)
                )
        }
    }

    private func save() async {
        if let editingAddressId {
            await addressViewModel.editAddress(
                addressId: editingAddressId,
                address1: address.address1,
                country: address.country,
                province: address.province,
                city: address.city,
                zip: address.zip
            )
        } else {
            await addressViewModel.addAddress(
                address1: address.address1,
                country: address.country,
                province: address.province,
                city: address.city,
                zip: address.zip
            )
        }

        if addressViewModel.errorMessage == nil {
            appRouter.pop(count: editingAddressId == nil ? 2 : 1)
        }
    }
}
