// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Design Tokens

/// Centralized design tokens for consistent theming across all components
public struct DesignTokens {
    
    // MARK: - Color Tokens
    
    /// Color design tokens for consistent color usage
    public struct Colors {
        // Primary Colors
        public static let primary50 = RRColor(r: 240, g: 248, b: 255)
        public static let primary100 = RRColor(r: 219, g: 234, b: 254)
        public static let primary200 = RRColor(r: 191, g: 219, b: 254)
        public static let primary300 = RRColor(r: 147, g: 197, b: 253)
        public static let primary400 = RRColor(r: 96, g: 165, b: 250)
        public static let primary500 = RRColor(r: 59, g: 130, b: 246)
        public static let primary600 = RRColor(r: 37, g: 99, b: 235)
        public static let primary700 = RRColor(r: 29, g: 78, b: 216)
        public static let primary800 = RRColor(r: 30, g: 64, b: 175)
        public static let primary900 = RRColor(r: 30, g: 58, b: 138)
        
        // Secondary Colors
        public static let secondary50 = RRColor(r: 250, g: 250, b: 250)
        public static let secondary100 = RRColor(r: 244, g: 244, b: 245)
        public static let secondary200 = RRColor(r: 228, g: 228, b: 231)
        public static let secondary300 = RRColor(r: 212, g: 212, b: 216)
        public static let secondary400 = RRColor(r: 161, g: 161, b: 170)
        public static let secondary500 = RRColor(r: 113, g: 113, b: 122)
        public static let secondary600 = RRColor(r: 82, g: 82, b: 91)
        public static let secondary700 = RRColor(r: 63, g: 63, b: 70)
        public static let secondary800 = RRColor(r: 39, g: 39, b: 42)
        public static let secondary900 = RRColor(r: 24, g: 24, b: 27)
        
        // Neutral Colors
        public static let neutral50 = RRColor(r: 250, g: 250, b: 250)
        public static let neutral100 = RRColor(r: 245, g: 245, b: 245)
        public static let neutral200 = RRColor(r: 229, g: 229, b: 229)
        public static let neutral300 = RRColor(r: 212, g: 212, b: 212)
        public static let neutral400 = RRColor(r: 163, g: 163, b: 163)
        public static let neutral500 = RRColor(r: 115, g: 115, b: 115)
        public static let neutral600 = RRColor(r: 82, g: 82, b: 82)
        public static let neutral700 = RRColor(r: 64, g: 64, b: 64)
        public static let neutral800 = RRColor(r: 38, g: 38, b: 38)
        public static let neutral900 = RRColor(r: 23, g: 23, b: 23)
        
        // Success Colors
        public static let success50 = RRColor(r: 240, g: 253, b: 244)
        public static let success100 = RRColor(r: 220, g: 252, b: 231)
        public static let success200 = RRColor(r: 187, g: 247, b: 208)
        public static let success300 = RRColor(r: 134, g: 239, b: 172)
        public static let success400 = RRColor(r: 74, g: 222, b: 128)
        public static let success500 = RRColor(r: 34, g: 197, b: 94)
        public static let success600 = RRColor(r: 22, g: 163, b: 74)
        public static let success700 = RRColor(r: 21, g: 128, b: 61)
        public static let success800 = RRColor(r: 22, g: 101, b: 52)
        public static let success900 = RRColor(r: 20, g: 83, b: 45)
        
        // Warning Colors
        public static let warning50 = RRColor(r: 255, g: 251, b: 235)
        public static let warning100 = RRColor(r: 254, g: 243, b: 199)
        public static let warning200 = RRColor(r: 253, g: 230, b: 138)
        public static let warning300 = RRColor(r: 252, g: 211, b: 77)
        public static let warning400 = RRColor(r: 251, g: 191, b: 36)
        public static let warning500 = RRColor(r: 245, g: 158, b: 11)
        public static let warning600 = RRColor(r: 217, g: 119, b: 6)
        public static let warning700 = RRColor(r: 180, g: 83, b: 9)
        public static let warning800 = RRColor(r: 146, g: 64, b: 14)
        public static let warning900 = RRColor(r: 120, g: 53, b: 15)
        
        // Error Colors
        public static let error50 = RRColor(r: 254, g: 242, b: 242)
        public static let error100 = RRColor(r: 254, g: 226, b: 226)
        public static let error200 = RRColor(r: 254, g: 202, b: 202)
        public static let error300 = RRColor(r: 252, g: 165, b: 165)
        public static let error400 = RRColor(r: 248, g: 113, b: 113)
        public static let error500 = RRColor(r: 239, g: 68, b: 68)
        public static let error600 = RRColor(r: 220, g: 38, b: 38)
        public static let error700 = RRColor(r: 185, g: 28, b: 28)
        public static let error800 = RRColor(r: 153, g: 27, b: 27)
        public static let error900 = RRColor(r: 127, g: 29, b: 29)
        
        // Info Colors
        public static let info50 = RRColor(r: 239, g: 246, b: 255)
        public static let info100 = RRColor(r: 219, g: 234, b: 254)
        public static let info200 = RRColor(r: 191, g: 219, b: 254)
        public static let info300 = RRColor(r: 147, g: 197, b: 253)
        public static let info400 = RRColor(r: 96, g: 165, b: 250)
        public static let info500 = RRColor(r: 59, g: 130, b: 246)
        public static let info600 = RRColor(r: 37, g: 99, b: 235)
        public static let info700 = RRColor(r: 29, g: 78, b: 216)
        public static let info800 = RRColor(r: 30, g: 64, b: 175)
        public static let info900 = RRColor(r: 30, g: 58, b: 138)
        
        // Semantic Colors
        public static let background = RRColor(r: 255, g: 255, b: 255)
        public static let surface = RRColor(r: 255, g: 255, b: 255)
        public static let surfaceVariant = RRColor(r: 248, g: 250, b: 252)
        public static let outline = RRColor(r: 226, g: 232, b: 240)
        public static let outlineVariant = RRColor(r: 241, g: 245, b: 249)
        public static let onBackground = RRColor(r: 15, g: 23, b: 42)
        public static let onSurface = RRColor(r: 15, g: 23, b: 42)
        public static let onSurfaceVariant = RRColor(r: 71, g: 85, b: 105)
        public static let onOutline = RRColor(r: 100, g: 116, b: 139)
        public static let onOutlineVariant = RRColor(r: 148, g: 163, b: 184)
    }
    
    // MARK: - Typography Tokens
    
    /// Typography design tokens for consistent text styling
    public struct Typography {
        // Font Families
        public static let fontFamilyPrimary = "SF Pro Display"
        public static let fontFamilySecondary = "SF Pro Text"
        public static let fontFamilyMono = "SF Mono"
        
        // Font Weights
        public static let weightThin: Font.Weight = .thin
        public static let weightLight: Font.Weight = .light
        public static let weightRegular: Font.Weight = .regular
        public static let weightMedium: Font.Weight = .medium
        public static let weightSemibold: Font.Weight = .semibold
        public static let weightBold: Font.Weight = .bold
        public static let weightHeavy: Font.Weight = .heavy
        public static let weightBlack: Font.Weight = .black
        
        // Display Styles
        public static let displayLarge = Font.system(size: 57, weight: .regular, design: .default)
        public static let displayMedium = Font.system(size: 45, weight: .regular, design: .default)
        public static let displaySmall = Font.system(size: 36, weight: .regular, design: .default)
        
        // Headline Styles
        public static let headlineLarge = Font.system(size: 32, weight: .semibold, design: .default)
        public static let headlineMedium = Font.system(size: 28, weight: .semibold, design: .default)
        public static let headlineSmall = Font.system(size: 24, weight: .semibold, design: .default)
        
        // Title Styles
        public static let titleLarge = Font.system(size: 22, weight: .medium, design: .default)
        public static let titleMedium = Font.system(size: 16, weight: .medium, design: .default)
        public static let titleSmall = Font.system(size: 14, weight: .medium, design: .default)
        
        // Body Styles
        public static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
        public static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
        public static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
        
        // Label Styles
        public static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
        public static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
        public static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
        
        // Line Heights
        public static let lineHeightTight: CGFloat = 1.2
        public static let lineHeightNormal: CGFloat = 1.4
        public static let lineHeightRelaxed: CGFloat = 1.6
        public static let lineHeightLoose: CGFloat = 1.8
        
        // Letter Spacing
        public static let letterSpacingTight: CGFloat = -0.5
        public static let letterSpacingNormal: CGFloat = 0
        public static let letterSpacingWide: CGFloat = 0.5
        public static let letterSpacingWider: CGFloat = 1.0
    }
    
    // MARK: - Spacing Tokens
    
    /// Spacing design tokens for consistent layout spacing
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
        public static let xxxl: CGFloat = 64
        
        // Component-specific spacing
        public static let componentPadding: CGFloat = 16
        public static let componentMargin: CGFloat = 8
        public static let sectionSpacing: CGFloat = 32
        public static let listItemSpacing: CGFloat = 12
        public static let formFieldSpacing: CGFloat = 16
        public static let buttonPadding: CGFloat = 12
        public static let inputPadding: CGFloat = 12
    }
    
    // MARK: - Elevation Tokens
    
    /// Elevation design tokens for consistent shadow and depth
    public struct Elevation {
        public static let level0 = Shadow(color: .clear, radius: 0, x: 0, y: 0)
        public static let level1 = Shadow(color: RRColor(r: 0, g: 0, b: 0, a: 0.05), radius: 1, x: 0, y: 1)
        public static let level2 = Shadow(color: RRColor(r: 0, g: 0, b: 0, a: 0.1), radius: 3, x: 0, y: 1)
        public static let level3 = Shadow(color: RRColor(r: 0, g: 0, b: 0, a: 0.1), radius: 6, x: 0, y: 3)
        public static let level4 = Shadow(color: RRColor(r: 0, g: 0, b: 0, a: 0.1), radius: 8, x: 0, y: 4)
        public static let level5 = Shadow(color: RRColor(r: 0, g: 0, b: 0, a: 0.15), radius: 12, x: 0, y: 6)
        
        // Component-specific elevations
        public static let card = level2
        public static let modal = level5
        public static let dropdown = level3
        public static let tooltip = level2
        public static let floating = level4
    }
    
    // MARK: - Border Radius Tokens
    
    /// Border radius design tokens for consistent corner rounding
    public struct BorderRadius {
        public static let none: CGFloat = 0
        public static let xs: CGFloat = 2
        public static let sm: CGFloat = 4
        public static let md: CGFloat = 8
        public static let lg: CGFloat = 12
        public static let xl: CGFloat = 16
        public static let xxl: CGFloat = 24
        public static let full: CGFloat = 9999
        
        // Component-specific border radius
        public static let button = md
        public static let card = lg
        public static let input = sm
        public static let textField = sm
        public static let badge = full
        public static let avatar = full
        public static let modal = xl
    }
    
    // MARK: - Animation Tokens
    
    /// Animation design tokens for consistent motion design
    public struct Animation {
        // Duration
        public static let durationFast: Double = 0.15
        public static let durationNormal: Double = 0.25
        public static let durationSlow: Double = 0.35
        public static let durationSlower: Double = 0.5
        
        // Easing
        public static let easeIn = SwiftUI.Animation.easeIn(duration: durationNormal)
        public static let easeOut = SwiftUI.Animation.easeOut(duration: durationNormal)
        public static let easeInOut = SwiftUI.Animation.easeInOut(duration: durationNormal)
        public static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.8)
        
        // Component-specific animations
        public static let buttonPress = SwiftUI.Animation.easeInOut(duration: durationFast)
        public static let modalPresent = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
        public static let dropdownToggle = SwiftUI.Animation.easeInOut(duration: durationNormal)
        public static let loadingSpinner = SwiftUI.Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
    }
    
    // MARK: - Component Size Tokens
    
    /// Component size design tokens for consistent component sizing
    public struct ComponentSize {
        // Button Sizes
        public static let buttonHeightXS: CGFloat = 28
        public static let buttonHeightSM: CGFloat = 32
        public static let buttonHeightMD: CGFloat = 40
        public static let buttonHeightLG: CGFloat = 48
        public static let buttonHeightXL: CGFloat = 56
        
        // Input Sizes
        public static let inputHeightXS: CGFloat = 32
        public static let inputHeightSM: CGFloat = 36
        public static let inputHeightMD: CGFloat = 40
        public static let inputHeightLG: CGFloat = 48
        public static let inputHeightXL: CGFloat = 56
        
        // Avatar Sizes
        public static let avatarSizeXS: CGFloat = 24
        public static let avatarSizeSM: CGFloat = 32
        public static let avatarSizeMD: CGFloat = 40
        public static let avatarSizeLG: CGFloat = 48
        public static let avatarSizeXL: CGFloat = 64
        public static let avatarSizeXXL: CGFloat = 80
        
        // Badge Sizes
        public static let badgeHeightXS: CGFloat = 16
        public static let badgeHeightSM: CGFloat = 20
        public static let badgeHeightMD: CGFloat = 24
        public static let badgeHeightLG: CGFloat = 28
        public static let badgeHeightXL: CGFloat = 32
        
        // Icon Sizes
        public static let iconSizeXS: CGFloat = 12
        public static let iconSizeSM: CGFloat = 16
        public static let iconSizeMD: CGFloat = 20
        public static let iconSizeLG: CGFloat = 24
        public static let iconSizeXL: CGFloat = 32
        
        // Toggle Sizes
        public static let toggleWidth: CGFloat = 50
        public static let toggleHeight: CGFloat = 30
        public static let toggleThumbSize: CGFloat = 26
        public static let toggleWidthSmall: CGFloat = 40
        public static let toggleHeightSmall: CGFloat = 20
        public static let toggleThumbSizeSmall: CGFloat = 16
    }
    
    // MARK: - Breakpoint Tokens
    
    /// Breakpoint design tokens for responsive design
    public struct Breakpoints {
        public static let mobile: CGFloat = 0
        public static let tablet: CGFloat = 768
        public static let desktop: CGFloat = 1024
        public static let wide: CGFloat = 1440
        
        public static func isMobile(_ width: CGFloat) -> Bool {
            return width < tablet
        }
        
        public static func isTablet(_ width: CGFloat) -> Bool {
            return width >= tablet && width < desktop
        }
        
        public static func isDesktop(_ width: CGFloat) -> Bool {
            return width >= desktop
        }
    }
}

// MARK: - Shadow Helper

/// Helper struct for shadow definitions
public struct Shadow: Equatable {
    public let color: RRColor
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: RRColor, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - Design Token Extensions

public extension View {
    /// Apply elevation shadow to a view
    func elevation(_ shadow: Shadow) -> some View {
        self.shadow(color: Color(shadow.color), radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    /// Apply consistent padding using design tokens
    func designPadding(_ spacing: CGFloat) -> some View {
        self.padding(spacing)
    }
    
    /// Apply consistent corner radius using design tokens
    func designCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius)
    }
}
