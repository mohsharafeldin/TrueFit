//
//  AddressDetailsFormView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct AddressDetailsFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var addressViewModel: AddressViewModel

    @State private var address1: String
    @State private var city: String
    @State private var province: String
    @State private var country: String
    @State private var zip: String

    /// nil means this is a new address (create); non-nil means editing an existing one (update)
    private let editingAddressId: String?
    private let onSaved: (() -> Void)?

    init(
        addressViewModel: AddressViewModel,
        prefill: (address1: String, city: String, province: String, country: String, zip: String),
        editingAddressId: String? = nil,
        onSaved: (() -> Void)? = nil
    ) {
        self.addressViewModel = addressViewModel
        self._address1 = State(initialValue: prefill.address1)
        self._city = State(initialValue: prefill.city)
        self._province = State(initialValue: prefill.province)
        self._country = State(initialValue: prefill.country)
        self._zip = State(initialValue: prefill.zip)
        self.editingAddressId = editingAddressId
        self.onSaved = onSaved
    }

    private var isSaveDisabled: Bool {
        address1.trimmingCharacters(in: .whitespaces).isEmpty ||
        city.trimmingCharacters(in: .whitespaces).isEmpty ||
        country.trimmingCharacters(in: .whitespaces).isEmpty
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
                    formField(title: "Address", text: $address1, placeholder: "Street, building, apartment")
                    formField(title: "City", text: $city, placeholder: "City")
                    formField(title: "Province / State", text: $province, placeholder: "Province or state")
                    formField(title: "Country", text: $country, placeholder: "Country")
                    formField(title: "ZIP / Postal code", text: $zip, placeholder: "ZIP code")
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
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )
        } else {
            await addressViewModel.addAddress(
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )
        }

        if addressViewModel.errorMessage == nil {
            onSaved?()
            dismiss()
        }
    }
}

//#Preview {
//    AddressDetailsFormView(
//        addressViewModel: AddressViewModel(
//            authManager: AuthManager(),
//            getAddresses: GetAddressesUseCase(repository: PreviewAddressRepository()),
//            createAddress: CreateAddressUseCase(repository: PreviewAddressRepository()),
//            updateAddress: UpdateAddressUseCase(repository: PreviewAddressRepository()),
//            deleteAddress: DeleteAddressUseCase(repository: PreviewAddressRepository())
//        ),
//        prefill: (address1: "123 Main St", city: "Cairo", province: "Cairo", country: "Egypt", zip: "11511")
//    )
//}
