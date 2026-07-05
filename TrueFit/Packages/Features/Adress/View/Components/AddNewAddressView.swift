//
//  AddNewAddressView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 04/07/2026.
//

import SwiftUI
import MapKit

struct AddNewAddressView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.6154, longitude: 46.7089),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
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
                
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(.textTertiary)
                    
                    TextField("Search for your building, area...", text: $searchText)
                        .font(.system(size: 15))
                        .foregroundColor(.textPrimary)
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
                        // TODO: Recenter map on current location
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
                            
                            Text("Al Amal District, Al Wadi Al Jadid")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        // TODO: Confirm and proceed to address details
                    }) {
                        Text("Confirm location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.brandPrimary)
                            .cornerRadius(14)
                    }
                }
                .padding(20)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -4)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AddNewAddressView()
}
