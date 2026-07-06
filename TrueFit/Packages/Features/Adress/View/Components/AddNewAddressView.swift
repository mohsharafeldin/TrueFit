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

    // Location
    @StateObject private var locationManager = LocationManager()

    // Search
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @FocusState private var searchFieldFocused: Bool

    // Map
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.6154, longitude: 46.7089),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    // Address resolution
    @State private var selectedLocationText: String = "Move the map to select a location"
    @State private var isResolvingAddress = false
    @State private var resolvedAddress: (address1: String, city: String, province: String, country: String, zip: String)?

    init(addressViewModel: AddressViewModel) {
        self.addressViewModel = addressViewModel
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {

            // ── Layer 1: Full-screen map ──────────────────────────────────
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
                // Tap anywhere on map to dismiss keyboard & results
                .onTapGesture {
                    dismissSearch()
                }

            // ── Layer 2: Centre pin ───────────────────────────────────────
            VStack(spacing: 0) {
                Spacer()
                Image(systemName: "mappin")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.brandPrimary)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                Circle()
                    .fill(Color.black.opacity(0.18))
                    .frame(width: 8, height: 4)
                Spacer()
            }
            .allowsHitTesting(false)      // pass touches through to the map

            // ── Layer 3: Nav bar + Search bar (fixed at top) ──────────────
            VStack(spacing: 0) {
                navBar
                    .background(Color.surface.opacity(0.95))

                searchBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.surface.opacity(0.95))

                // Search results dropdown — only visible when results exist
                if !searchResults.isEmpty {
                    searchDropdown
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                        .background(Color.surface.opacity(0.98))
                        .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 6)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.18), value: searchResults.isEmpty)

            // ── Layer 4: Floating location button (above confirm sheet) ────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: goToCurrentLocation) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.brandPrimary)
                            .frame(width: 46, height: 46)
                            .background(Color.surface)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 150)   // sits above the confirm sheet
            }

            // ── Layer 5: Bottom confirm sheet ─────────────────────────────
            VStack {
                Spacer()
                confirmSheet
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
                    prefill: resolvedAddress,
                    onSaved: { dismiss() }
                )
            }
        }
        .onReceive(locationManager.$lastLocation) { coord in
            guard let coord else { return }
            withAnimation(.easeInOut(duration: 0.5)) {
                region = MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }

    // MARK: - Sub-views

    private var navBar: some View {
        ZStack {
            Text("Add new address")
                .font(.system(size: 17, weight: .semibold))
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
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            // Leading icon — acts as a clear button when focused
            Image(systemName: searchFieldFocused && !searchText.isEmpty
                  ? "xmark.circle.fill"
                  : "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.textTertiary)
                .onTapGesture { dismissSearch() }

            TextField("Search for your building, area...", text: $searchText)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
                .focused($searchFieldFocused)
                .submitLabel(.search)
                .onChange(of: searchText) { query in
                    if query.trimmingCharacters(in: .whitespaces).isEmpty {
                        searchResults = []
                    } else {
                        performSearch(query: query)
                    }
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var searchDropdown: some View {
        VStack(spacing: 0) {
            ForEach(searchResults, id: \.self) { item in
                Button(action: { selectResult(item) }) {
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.brandPrimary)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name ?? "")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)

                            if let subtitle = item.placemark.title,
                               subtitle != item.name,
                               !subtitle.isEmpty {
                                Text(subtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(.textSecondary)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 11)
                    .background(Color.surface)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if item != searchResults.last {
                    Divider()
                        .padding(.leading, 56)
                }
            }
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderColor, lineWidth: 0.5)
        )
    }

    private var confirmSheet: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.brandPrimary)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Selected location")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)

                    if isResolvingAddress {
                        ProgressView()
                            .scaleEffect(0.8)
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
                dismissSearch()
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
        .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: -4)
    }

    // MARK: - Helpers

    private func dismissSearch() {
        searchText = ""
        searchResults = []
        searchFieldFocused = false
    }

    // MARK: - Current Location

    private func goToCurrentLocation() {
        locationManager.requestLocation()
    }

    // MARK: - Search

    private func performSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region

        MKLocalSearch(request: request).start { response, _ in
            guard let response else { return }
            DispatchQueue.main.async {
                searchResults = Array(response.mapItems.prefix(6))
            }
        }
    }

    private func selectResult(_ item: MKMapItem) {
        let coord = item.placemark.coordinate
        withAnimation(.easeInOut(duration: 0.4)) {
            region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }

        let placemark = item.placemark
        let address1 = [placemark.subThoroughfare, placemark.thoroughfare]
            .compactMap { $0 }.joined(separator: " ")
        let city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
        let country = placemark.country ?? ""

        selectedLocationText = [item.name ?? address1, city, country]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")

        dismissSearch()
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
