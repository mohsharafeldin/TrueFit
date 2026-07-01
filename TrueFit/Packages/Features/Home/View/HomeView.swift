//
//  HomeView.swift
//  TrueFit
//
//  Created by mohamed sharaf on 27/06/2026.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    
                    TabSelectionView()
                    
                    BannerView()
                    
                    VStack(spacing: 16) {
                        SectionHeaderView(title: "New Arrivals 🔥", actionTitle: "See All")
                        ProductGridView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 100)
            }
            
            
            CustomBottomTabBar()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, Jonathan")
                    .font(.system(size: 16, weight: .bold))
                Text("Let's go shopping")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.title3)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
    }
}

// MARK: - Tab Selection View
struct TabSelectionView: View {
    var body: some View {
        HStack(spacing: 40) {
            VStack(spacing: 8) {
                Text("Home")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: 40, height: 3)
                    .cornerRadius(1.5)
            }
            
            VStack(spacing: 8) {
                Text("Category")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 40, height: 3)
            }
            
            Spacer()
        }
    }
}

// MARK: - Banner View
struct BannerView: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6))
                
                
                GeometryReader { geo in
                    Circle()
                        .fill(Color.purple.opacity(0.3))
                        .frame(width: 150, height: 150)
                        .offset(x: -50, y: geo.size.height / 2)
                }
                .clipped()
                
                HStack {
                    VStack(alignment: .center, spacing: 8) {
                        Text("24% off shipping today\non bag purchases")
                            .font(.system(size: 16, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text("By Kutuku Store")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    Image("bag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding(.trailing, 10)
                }
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            
            HStack(spacing: 6) {
                Circle().fill(Color.purple).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
            }
        }
    }
}

// MARK: - Section Header View
struct SectionHeaderView: View {
    let title: String
    let actionTitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            Spacer()
            Text(actionTitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.purple)
        }
    }
}

// MARK: - Product Grid & Model
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let price: String
    let image: String
}

struct ProductGridView: View {
    let products = [
        Product(name: "The Mirac Jiz", brand: "Lisa Robber", price: "$195.00", image: "bag1"),
        Product(name: "Meriza Kiles", brand: "Gazuna Resika", price: "$143.45", image: "bag2"),
        Product(name: "Placeholder", brand: "Brand", price: "$100.00", image: "bag3"),
        Product(name: "Placeholder", brand: "Brand", price: "$100.00", image: "bag4")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(products) { product in
                ProductCard(product: product)
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                // Product Image
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 160)
                    .overlay(
                        Image(product.image) // Replace with your image
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Favorite Button
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            VStack(spacing: 4) {
                Text(product.name)
                    .font(.system(size: 15, weight: .bold))
                
                Text(product.brand)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(product.price)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.top, 2)
            }
        }
    }
}

// MARK: - Custom Bottom Tab Bar
struct CustomBottomTabBar: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                TabBarItem(icon: "house.fill", title: "Home", isSelected: true)
                Spacer()
                TabBarItem(icon: "shippingbox", title: "My Order", isSelected: false)
                Spacer()
                TabBarItem(icon: "heart", title: "Favorite", isSelected: false)
                Spacer()
                TabBarItem(icon: "person", title: "My Profile", isSelected: false)
            }
            .padding(.horizontal, 30)
            .padding(.top, 16)
            .padding(.bottom, 34) 
            .background(Color.white)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .purple : .gray)
            
            Text(title)
                .font(.system(size: 10, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .purple : .gray)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
