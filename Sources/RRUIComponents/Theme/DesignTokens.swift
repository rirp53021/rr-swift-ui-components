// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Design Tokens

/// Centralized design tokens for consistent theming across all components
/// 
/// Note: Colors are now handled by Color+DesignSystem.swift extensions
/// which read directly from Colors.xcassets for better app integration.
public struct DesignTokens {
    
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
    @MainActor
    public struct Elevation {
        public static let level0 = Shadow(color: .clear, radius: 0, x: 0, y: 0)
        public static let level1 = Shadow(color: Color(r: 0, g: 0, b: 0, a: 0.05), radius: 1, x: 0, y: 1)
        public static let level2 = Shadow(color: Color(r: 0, g: 0, b: 0, a: 0.1), radius: 3, x: 0, y: 1)
        public static let level3 = Shadow(color: Color(r: 0, g: 0, b: 0, a: 0.1), radius: 6, x: 0, y: 3)
        public static let level4 = Shadow(color: Color(r: 0, g: 0, b: 0, a: 0.1), radius: 8, x: 0, y: 4)
        public static let level5 = Shadow(color: Color(r: 0, g: 0, b: 0, a: 0.15), radius: 12, x: 0, y: 6)
        
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
    
    // MARK: - Transition Tokens
    
    /// Transition design tokens for consistent motion design
    public struct Transition {
        // Fade transitions
        public static let fadeIn = SwiftUI.Animation.easeIn(duration: 0.2)
        public static let fadeOut = SwiftUI.Animation.easeOut(duration: 0.15)
        
        // Slide transitions
        public static let slideIn = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let slideOut = SwiftUI.Animation.easeIn(duration: 0.25)
        public static let slideInFromTop = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let slideInFromBottom = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let slideInFromLeft = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let slideInFromRight = SwiftUI.Animation.easeOut(duration: 0.3)
        
        // Scale transitions
        public static let scaleIn = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.8)
        public static let scaleOut = SwiftUI.Animation.easeIn(duration: 0.2)
        public static let scaleInBounce = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
        
        // Rotation transitions
        public static let rotateIn = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let rotateOut = SwiftUI.Animation.easeIn(duration: 0.25)
        
        // Combined transitions
        public static let slideAndFadeIn = SwiftUI.Animation.easeOut(duration: 0.3)
        public static let slideAndFadeOut = SwiftUI.Animation.easeIn(duration: 0.25)
        public static let scaleAndFadeIn = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.8)
        public static let scaleAndFadeOut = SwiftUI.Animation.easeIn(duration: 0.2)
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
    
    // MARK: - Z-Index Tokens
    
    /// Z-Index design tokens for consistent layer ordering
    public struct ZIndex {
        public static let modal: CGFloat = 1000
        public static let dropdown: CGFloat = 100
        public static let tooltip: CGFloat = 200
        public static let floating: CGFloat = 50
        public static let overlay: CGFloat = 500
        public static let navigation: CGFloat = 300
        public static let content: CGFloat = 1
        public static let background: CGFloat = 0
    }
    
    // MARK: - Layout Tokens
    
    /// Layout design tokens for consistent grid and flexbox-like properties
    public struct Layout {
        // Grid System
        public static let gridColumns: Int = 12
        public static let gridGap: CGFloat = 16
        public static let gridGapSmall: CGFloat = 8
        public static let gridGapLarge: CGFloat = 24
        
        // Container Max Widths
        public static let containerMaxWidth: CGFloat = 1200
        public static let containerMaxWidthSmall: CGFloat = 768
        public static let containerMaxWidthMedium: CGFloat = 1024
        public static let containerMaxWidthLarge: CGFloat = 1440
        
        // Flexbox-like Properties
        public static let flexGrow: CGFloat = 1
        public static let flexShrink: CGFloat = 1
        public static let flexBasis: CGFloat = 0
        
        // Alignment
        public static let alignStart: Alignment = .leading
        public static let alignCenter: Alignment = .center
        public static let alignEnd: Alignment = .trailing
        public static let alignStretch: Alignment = .center
        
        // Justification
        public static let justifyStart: HorizontalAlignment = .leading
        public static let justifyCenter: HorizontalAlignment = .center
        public static let justifyEnd: HorizontalAlignment = .trailing
        public static let justifySpaceBetween: HorizontalAlignment = .center
        public static let justifySpaceAround: HorizontalAlignment = .center
        public static let justifySpaceEvenly: HorizontalAlignment = .center
        
        // Content Distribution
        public static let contentStart: VerticalAlignment = .top
        public static let contentCenter: VerticalAlignment = .center
        public static let contentEnd: VerticalAlignment = .bottom
        public static let contentStretch: VerticalAlignment = .center
        
        // Layout Directions
        public static let directionRow: Axis = .horizontal
        public static let directionColumn: Axis = .vertical
        
        // Wrap Behavior
        public static let wrapNoWrap: Bool = false
        public static let wrapWrap: Bool = true
        public static let wrapWrapReverse: Bool = true
        
        // Overflow
        public static let overflowVisible: Bool = false
        public static let overflowHidden: Bool = true
        public static let overflowScroll: Bool = true
        
        // Position
        public static let positionRelative: Bool = false
        public static let positionAbsolute: Bool = true
        public static let positionFixed: Bool = true
        public static let positionSticky: Bool = true
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
@MainActor public struct Shadow: Equatable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
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
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
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
