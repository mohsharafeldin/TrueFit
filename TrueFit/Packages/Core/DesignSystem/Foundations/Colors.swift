//
//  Colors.swift
//  TrueFit Design System
//
//  TrueFit Color Tokens
//  All colors are backed by the Asset Catalog (Colors.xcassets)
//  and automatically adapt between Light and Dark mode.
//
//  Naming: color.{group}.{role} — e.g. Color.brandPrimary, Color.textSecondary
//

import SwiftUI

// MARK: - Brand Colors

public extension Color {

    /// Electric royal blue — splash background, primary CTA, selected chip, links
    /// Light: #1E3FE5 · Dark: #5B7CFF
    static let brandPrimary = Color("BrandPrimary")

    /// Pressed/active state of brand primary
    /// Light: #162FB3 · Dark: #4A6AE6
    static let brandPrimaryPressed = Color("BrandPrimaryPressed")

    /// Lime/chartreuse green — secondary CTA, price badge, promo arc, FAB
    /// Light: #A6E92D · Dark: #B9F23C
    ///
    /// ⚠️ RULE: Lime is a background accent. Never pair with white foreground text.
    /// Always use `textPrimary` (dark navy) on lime surfaces.
    static let brandSecondary = Color("BrandSecondary")

    /// Pressed/active state of brand secondary (lime)
    /// Light: #8FC922 · Dark: #A0D630
    static let brandSecondaryPressed = Color("BrandSecondaryPressed")
}

// MARK: - Surface & Background Colors

public extension Color {

    /// Card fills, sheets, product image frames
    /// Light: #FFFFFF · Dark: #161A3D
    static let surface = Color("Surface")

    /// Screen background
    /// Light: #F6F7FB · Dark: #0E1130
    static let trueFitBackground = Color("Background")

    /// Card fill (identical to surface in most cases, separate token for flexibility)
    /// Light: #FFFFFF · Dark: #1B2050
    static let cardFill = Color("CardFill")

    /// Card/input hairline borders
    /// Light: #E7E9F2 · Dark: #2A2F5C
    static let borderColor = Color("BorderColor")

    /// Modal scrim / bottom sheet backdrop
    /// Light: #0B0F24 @ 50% · Dark: #000000 @ 60%
    static let overlayColor = Color("OverlayColor")
}

// MARK: - Text Colors

public extension Color {

    /// Headlines, product titles, prices
    /// Light: #14213D · Dark: #F5F6FA
    static let textPrimary = Color("TextPrimary")

    /// Descriptions, labels
    /// Light: #6B7280 · Dark: #B3B7D1
    static let textSecondary = Color("TextSecondary")

    /// Placeholder, meta text
    /// Light: #9CA3AF · Dark: #7E83A8
    static let textTertiary = Color("TextTertiary")

    /// Disabled buttons/chips
    /// Light: #C7CAD4 · Dark: #3A3F66
    static let disabledColor = Color("DisabledColor")
}

// MARK: - Semantic Colors

public extension Color {

    /// Order confirmed, payment success
    /// #34C759
    static let semanticSuccess = Color("SemanticSuccess")

    /// Low stock, address issue
    /// #FFB020
    static let semanticWarning = Color("SemanticWarning")

    /// Errors, remove-from-cart, active wishlist heart
    /// #FF3B30
    static let semanticDanger = Color("SemanticDanger")

    /// Informational banners
    /// #4DA3FF
    static let semanticInfo = Color("SemanticInfo")
}

// MARK: - Status / Merchandising Colors

public extension Color {

    /// "New Arrival" badge — #4DA3FF
    static let statusNew = Color("StatusNew")

    /// "Sale / % Off" ribbon — #FF5A5F
    static let statusSale = Color("StatusSale")

    /// "Bestseller" badge — #E8B400
    static let statusBestseller = Color("StatusBestseller")

    /// Availability dot/label (ties to brand lime = positive) — #A6E92D
    static let statusInStock = Color("StatusInStock")

    /// "Only 3 left" — #FF8A3D
    static let statusLimitedStock = Color("StatusLimitedStock")

    /// Greyed badge + greyed product card — #9CA3AF
    static let statusOutOfStock = Color("StatusOutOfStock")

    /// Filled heart — #FF3B30
    static let statusWishlistActive = Color("StatusWishlistActive")

    /// Star rating glyph — #FFC107
    static let statusRating = Color("StatusRating")
}

// MARK: - Category Accent Colors

public extension Color {

    /// Apparel (teal) — #2EC4B6
    static let categoryApparel = Color("CategoryApparel")

    /// Accessories (purple) — #8B5CF6
    static let categoryAccessories = Color("CategoryAccessories")

    /// Toys (gold) — #FFD23F
    static let categoryToys = Color("CategoryToys")

    /// Grooming (pink) — #FF6FA5
    static let categoryGrooming = Color("CategoryGrooming")

    /// Food & Treats (warm brown) — #C68B59
    static let categoryFood = Color("CategoryFood")
}

// MARK: - Shadow Colors

public extension Color {

    /// Neutral shadow color for elevation — #0F1233
    static let shadowColor = Color("ShadowColor")

    /// Brand-tinted shadow for hero/floating cards — #1E3FE5
    static let floatingShadow = Color("FloatingShadow")
}
