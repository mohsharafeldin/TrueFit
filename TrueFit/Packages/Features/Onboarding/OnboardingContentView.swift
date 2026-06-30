//
//  OnboardingContentView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 29/06/2026.
//

import SwiftUI

struct OnboardingContentView: View {
    var index: Int = 1
    //var title: String = ""
    //var desc: String = ""
    //var img = "onBoradingOne"
    var onComplete: () -> Void
    
    @State private var currentIndex = 1
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Shop Trends", desc: "Discover the latest fashion trends.", img: "onBoradingOne"),
        OnboardingPage(title: "Easy Pay", desc: "Safe and secure payments.", img: "onboarding2"),
        OnboardingPage(title: "Save Your Favorites", desc: "Browse thousands of premium products curated just for you.", img: "onboarding3")
        ]
    var body: some View {
        let currentPage = pages[currentIndex - 1]
        let skipBtn = { onComplete() }
        let nextBtn = {
            if currentIndex < 3 {
                withAnimation { currentIndex += 1 }
            } else {
                onComplete()
            }
        }
        GeometryReader { geo in
            ZStack {
                Image(currentPage.img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [.clear, .clear, .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        Button("Skip", action: skipBtn)
                            .foregroundColor(.white).bold().font(.title3)
                    }
                    .padding()
                    .padding(.top, 24)

                    Spacer()

                    HStack(alignment: .bottom, spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(currentPage.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)

                            Text(currentPage.desc)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)

                            switch currentIndex {
                            case 1:
                                ViewIndex(
                                    firstRectColor: .green,
                                    secondRectColor: .gray,
                                    thirdRectColor: .gray,
                                    firstRectW: 40,
                                    secondRectW: 20,
                                    thirdRectW: 20
                                )
                            case 2:
                                ViewIndex(
                                    firstRectColor: .gray,
                                    secondRectColor: .green,
                                    thirdRectColor: .gray,
                                    firstRectW: 20,
                                    secondRectW: 40,
                                    thirdRectW: 20
                                )
                            default:
                                ViewIndex(
                                    firstRectColor: .gray,
                                    secondRectColor: .gray,
                                    thirdRectColor: .green,
                                    firstRectW: 20,
                                    secondRectW: 20,
                                    thirdRectW: 40
                                )
                            }
                        }

                        Spacer()

                        Button(action: nextBtn) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 48, height: 48)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .padding(.bottom, 12)
                    .compositingGroup()
                    
                }
            }.shadow(color: .black.opacity(0.9), radius: 16, x: 0, y: 10)
        }
        .ignoresSafeArea()
    }
}

struct ViewIndex: View {
    var firstRectColor: Color = .gray
    var secondRectColor: Color = .gray
    var thirdRectColor: Color = .gray
    var rectHeight: CGFloat = 5
    var firstRectW: CGFloat = 8
    var secondRectW: CGFloat = 8
    var thirdRectW: CGFloat = 8

    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(firstRectColor)
                .frame(width: firstRectW, height: rectHeight)
                .cornerRadius(25)

            Rectangle()
                .fill(secondRectColor)
                .frame(width: secondRectW, height: rectHeight)
                .cornerRadius(25)

            Rectangle()
                .fill(thirdRectColor)
                .frame(width: thirdRectW, height: rectHeight)
                .cornerRadius(25)
        }
    }
}
struct OnboardingPage {
    let title: String
    let desc: String
    let img: String
}

//#Preview {
//    OnboardingContentView()
//}
