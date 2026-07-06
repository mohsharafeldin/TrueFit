//
//  AddNewAddressView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 04/07/2026.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddNewAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToDetails = false
    @ObservedObject var addressViewModel: AddressViewModel
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.6154, longitude: 46.7089),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @State private var selectedLocationText: String = "Move the map to select a location"
    @State private var isResolvingAddress = false
    @State private var resolvedAddress: (address1: String, city: String, province: String, country: String, zip: String)?

    // Explicit init: this is the one property that must come from the
    // caller (AddressView passes its own `viewModel` here), so both
    // screens observe and mutate the same `addresses` array. Every other
    // property keeps its own default, so nothing else needs to change here.
    init(addressViewModel: AddressViewModel) {
        self.addressViewModel = addressViewModel
    }

    var body: some View {
        ZStack {

            // Map (full screen)
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()

            // Fixed center pin overlay
            VStack(spacing: 0) {
                Image(systemName: "mappin")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.brandPrimary)
                    .offset(y: -16)

                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 8, height: 4)
                    .offset(y: -14)
            }

            VStack(spacing: 0) {

                // Nav Bar
                ZStack {
                    Text("Add new address")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.textPrimary)

                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .frame(width: 36, height: 36)
                                .background(Color.surface)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Search bar (not functional yet — coming in a later step)
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(.textTertiary)

                    TextField("Search for your building, area...", text: $searchText)
                        .font(.system(size: 15))
                        .foregroundColor(.textPrimary)
                        .disabled(true)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.surface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderColor, lineWidth: 0.5)
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)

                Spacer()

                // Current location button
                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: recenter map on current location
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.brandPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.surface)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 16)
            }

            // Bottom confirm sheet
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 10) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.brandPrimary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Selected location")
                                .font(.system(size: 12))
                                .foregroundColor(.textTertiary)

                            if isResolvingAddress {
                                ProgressView()
                                    .scaleEffect(0.7)
                            } else {
                                Text(selectedLocationText)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()
                    }

                    Button(action: {
                        Task { await confirmLocation() }
                    }) {
                        Text("Confirm location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brandPrimary)
                            .cornerRadius(14)
                    }
                    .disabled(isResolvingAddress)
                }
                .padding(20)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -4)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDetails) {
            if let resolvedAddress {
                // Same ViewModel instance flows all the way through: map ->
                // details form -> save -> back to AddressView's list, which
                // is observing this exact object, so the new address shows
                // up immediately with no extra reload needed.
                AddressDetailsFormView(
                    addressViewModel: addressViewModel,
                    prefill: resolvedAddress
                )
            }
        }
    }

    // MARK: - Reverse Geocoding

    private func confirmLocation() async {
        isResolvingAddress = true

        let center = region.center
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)

            guard let placemark = placemarks.first else {
                selectedLocationText = "Unable to determine address for this location"
                isResolvingAddress = false
                return
            }

            let address1 = [placemark.subThoroughfare, placemark.thoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
            let city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
            let province = placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            let zip = placemark.postalCode ?? ""

            resolvedAddress = (address1: address1, city: city, province: province, country: country, zip: zip)
            selectedLocationText = [address1, city, province, country]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")

            // Reverse geocoding is frequently slightly wrong or missing unit/
            // floor/building info, so we never persist directly from here —
            // we only ever hand off a draft to the editable details form.
            navigateToDetails = true

        } catch {
            selectedLocationText = "Could not resolve address. Please try again."
        }

        isResolvingAddress = false
    }

}

//#Preview {
//    AddNewAddressView(
//        addressViewModel: AddressViewModel(
//            authManager: AuthManager(),
//            getAddresses: GetAddressesUseCase(repository: PreviewAddressRepository()),
//            createAddress: CreateAddressUseCase(repository: PreviewAddressRepository()),
//            updateAddress: UpdateAddressUseCase(repository: PreviewAddressRepository()),
//            deleteAddress: DeleteAddressUseCase(repository: PreviewAddressRepository())
//        )
//    )
//}
