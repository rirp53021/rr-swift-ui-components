// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Theme Provider

/// SwiftUI environment-based theme provider for consistent theming across the app
public class ThemeProvider: ObservableObject {
    @Published public var currentTheme: Theme = .light
    @Published public var colorScheme: ColorScheme = .light
    
    public init(theme: Theme = .light) {
        self.currentTheme = theme
        self.colorScheme = theme.colorScheme
    }
    
    /// Switch to a different theme
    public func setTheme(_ theme: Theme) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.currentTheme = theme
            self.colorScheme = theme.colorScheme
        }
    }
    
    /// Toggle between light and dark themes
    public func toggleTheme() {
        let newTheme: Theme = currentTheme == .light ? .dark : .light
        setTheme(newTheme)
    }
}

// MARK: - Theme Definition

/// Comprehensive theme definition with all design tokens
public struct Theme: Equatable {
    public let name: String
    public let colorScheme: ColorScheme
    public let colors: ThemeColors
    public let typography: ThemeTypography
    public let spacing: ThemeSpacing
    public let elevation: ThemeElevation
    public let borderRadius: ThemeBorderRadius
    public let animation: ThemeAnimation
    public let componentSize: ThemeComponentSize
    
    public init(
        name: String,
        colorScheme: ColorScheme,
        colors: ThemeColors,
        typography: ThemeTypography = .default,
        spacing: ThemeSpacing = .default,
        elevation: ThemeElevation = .default,
        borderRadius: ThemeBorderRadius = .default,
        animation: ThemeAnimation = .default,
        componentSize: ThemeComponentSize = .default
    ) {
        self.name = name
        self.colorScheme = colorScheme
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.elevation = elevation
        self.borderRadius = borderRadius
        self.animation = animation
        self.componentSize = componentSize
    }
    
    // MARK: - Predefined Themes
    
    public static let light = Theme(
        name: "Light",
        colorScheme: .light,
        colors: .light
    )
    
    public static let dark = Theme(
        name: "Dark",
        colorScheme: .dark,
        colors: .dark
    )
    
    public static let highContrast = Theme(
        name: "High Contrast",
        colorScheme: .light,
        colors: .highContrast
    )
}

// MARK: - Theme Colors

public struct ThemeColors: Equatable {
    // Primary Colors
    public let primary: RRColor
    public let primaryVariant: RRColor
    public let onPrimary: RRColor
    
    // Secondary Colors
    public let secondary: RRColor
    public let secondaryVariant: RRColor
    public let onSecondary: RRColor
    
    // Background Colors
    public let background: RRColor
    public let surface: RRColor
    public let surfaceVariant: RRColor
    public let onBackground: RRColor
    public let onSurface: RRColor
    public let onSurfaceVariant: RRColor
    
    // Outline Colors
    public let outline: RRColor
    public let outlineVariant: RRColor
    public let onOutline: RRColor
    public let onOutlineVariant: RRColor
    
    // State Colors
    public let success: RRColor
    public let onSuccess: RRColor
    public let warning: RRColor
    public let onWarning: RRColor
    public let error: RRColor
    public let onError: RRColor
    public let info: RRColor
    public let onInfo: RRColor
    
    // Neutral Colors
    public let neutral50: RRColor
    public let neutral100: RRColor
    public let neutral200: RRColor
    public let neutral300: RRColor
    public let neutral400: RRColor
    public let neutral500: RRColor
    public let neutral600: RRColor
    public let neutral700: RRColor
    public let neutral800: RRColor
    public let neutral900: RRColor
    
    public init(
        primary: RRColor,
        primaryVariant: RRColor,
        onPrimary: RRColor,
        secondary: RRColor,
        secondaryVariant: RRColor,
        onSecondary: RRColor,
        background: RRColor,
        surface: RRColor,
        surfaceVariant: RRColor,
        onBackground: RRColor,
        onSurface: RRColor,
        onSurfaceVariant: RRColor,
        outline: RRColor,
        outlineVariant: RRColor,
        onOutline: RRColor,
        onOutlineVariant: RRColor,
        success: RRColor,
        onSuccess: RRColor,
        warning: RRColor,
        onWarning: RRColor,
        error: RRColor,
        onError: RRColor,
        info: RRColor,
        onInfo: RRColor,
        neutral50: RRColor,
        neutral100: RRColor,
        neutral200: RRColor,
        neutral300: RRColor,
        neutral400: RRColor,
        neutral500: RRColor,
        neutral600: RRColor,
        neutral700: RRColor,
        neutral800: RRColor,
        neutral900: RRColor
    ) {
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.onSecondary = onSecondary
        self.background = background
        self.surface = surface
        self.surfaceVariant = surfaceVariant
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.onSurfaceVariant = onSurfaceVariant
        self.outline = outline
        self.outlineVariant = outlineVariant
        self.onOutline = onOutline
        self.onOutlineVariant = onOutlineVariant
        self.success = success
        self.onSuccess = onSuccess
        self.warning = warning
        self.onWarning = onWarning
        self.error = error
        self.onError = onError
        self.info = info
        self.onInfo = onInfo
        self.neutral50 = neutral50
        self.neutral100 = neutral100
        self.neutral200 = neutral200
        self.neutral300 = neutral300
        self.neutral400 = neutral400
        self.neutral500 = neutral500
        self.neutral600 = neutral600
        self.neutral700 = neutral700
        self.neutral800 = neutral800
        self.neutral900 = neutral900
    }
    
    // MARK: - Predefined Color Schemes
    
    public static let light = ThemeColors(
        primary: DesignTokens.Colors.primary500,
        primaryVariant: DesignTokens.Colors.primary700,
        onPrimary: .white,
        secondary: DesignTokens.Colors.secondary500,
        secondaryVariant: DesignTokens.Colors.secondary700,
        onSecondary: .white,
        background: DesignTokens.Colors.background,
        surface: DesignTokens.Colors.surface,
        surfaceVariant: DesignTokens.Colors.surfaceVariant,
        onBackground: DesignTokens.Colors.onBackground,
        onSurface: DesignTokens.Colors.onSurface,
        onSurfaceVariant: DesignTokens.Colors.onSurfaceVariant,
        outline: DesignTokens.Colors.outline,
        outlineVariant: DesignTokens.Colors.outlineVariant,
        onOutline: DesignTokens.Colors.onOutline,
        onOutlineVariant: DesignTokens.Colors.onOutlineVariant,
        success: DesignTokens.Colors.success500,
        onSuccess: .white,
        warning: DesignTokens.Colors.warning500,
        onWarning: .white,
        error: DesignTokens.Colors.error500,
        onError: .white,
        info: DesignTokens.Colors.info500,
        onInfo: .white,
        neutral50: DesignTokens.Colors.neutral50,
        neutral100: DesignTokens.Colors.neutral100,
        neutral200: DesignTokens.Colors.neutral200,
        neutral300: DesignTokens.Colors.neutral300,
        neutral400: DesignTokens.Colors.neutral400,
        neutral500: DesignTokens.Colors.neutral500,
        neutral600: DesignTokens.Colors.neutral600,
        neutral700: DesignTokens.Colors.neutral700,
        neutral800: DesignTokens.Colors.neutral800,
        neutral900: DesignTokens.Colors.neutral900
    )
    
    public static let dark = ThemeColors(
        primary: DesignTokens.Colors.primary400,
        primaryVariant: DesignTokens.Colors.primary200,
        onPrimary: DesignTokens.Colors.neutral900,
        secondary: DesignTokens.Colors.secondary400,
        secondaryVariant: DesignTokens.Colors.secondary200,
        onSecondary: DesignTokens.Colors.neutral900,
        background: DesignTokens.Colors.neutral900,
        surface: DesignTokens.Colors.neutral800,
        surfaceVariant: DesignTokens.Colors.neutral700,
        onBackground: DesignTokens.Colors.neutral50,
        onSurface: DesignTokens.Colors.neutral50,
        onSurfaceVariant: DesignTokens.Colors.neutral200,
        outline: DesignTokens.Colors.neutral600,
        outlineVariant: DesignTokens.Colors.neutral700,
        onOutline: DesignTokens.Colors.neutral300,
        onOutlineVariant: DesignTokens.Colors.neutral400,
        success: DesignTokens.Colors.success400,
        onSuccess: DesignTokens.Colors.neutral900,
        warning: DesignTokens.Colors.warning400,
        onWarning: DesignTokens.Colors.neutral900,
        error: DesignTokens.Colors.error400,
        onError: DesignTokens.Colors.neutral900,
        info: DesignTokens.Colors.info400,
        onInfo: DesignTokens.Colors.neutral900,
        neutral50: DesignTokens.Colors.neutral900,
        neutral100: DesignTokens.Colors.neutral800,
        neutral200: DesignTokens.Colors.neutral700,
        neutral300: DesignTokens.Colors.neutral600,
        neutral400: DesignTokens.Colors.neutral500,
        neutral500: DesignTokens.Colors.neutral400,
        neutral600: DesignTokens.Colors.neutral300,
        neutral700: DesignTokens.Colors.neutral200,
        neutral800: DesignTokens.Colors.neutral100,
        neutral900: DesignTokens.Colors.neutral50
    )
    
    public static let highContrast = ThemeColors(
        primary: RRColor(r: 0, g: 0, b: 0),
        primaryVariant: RRColor(r: 0, g: 0, b: 0),
        onPrimary: .white,
        secondary: RRColor(r: 0, g: 0, b: 0),
        secondaryVariant: RRColor(r: 0, g: 0, b: 0),
        onSecondary: .white,
        background: .white,
        surface: .white,
        surfaceVariant: RRColor(r: 240, g: 240, b: 240),
        onBackground: .black,
        onSurface: .black,
        onSurfaceVariant: .black,
        outline: .black,
        outlineVariant: RRColor(r: 100, g: 100, b: 100),
        onOutline: .white,
        onOutlineVariant: .white,
        success: .green,
        onSuccess: .white,
        warning: .orange,
        onWarning: .black,
        error: .red,
        onError: .white,
        info: .blue,
        onInfo: .white,
        neutral50: .white,
        neutral100: RRColor(r: 240, g: 240, b: 240),
        neutral200: RRColor(r: 200, g: 200, b: 200),
        neutral300: RRColor(r: 160, g: 160, b: 160),
        neutral400: RRColor(r: 120, g: 120, b: 120),
        neutral500: RRColor(r: 80, g: 80, b: 80),
        neutral600: RRColor(r: 60, g: 60, b: 60),
        neutral700: RRColor(r: 40, g: 40, b: 40),
        neutral800: RRColor(r: 20, g: 20, b: 20),
        neutral900: .black
    )
}

// MARK: - Theme Typography

public struct ThemeTypography: Equatable {
    public let displayLarge: Font
    public let displayMedium: Font
    public let displaySmall: Font
    public let headlineLarge: Font
    public let headlineMedium: Font
    public let headlineSmall: Font
    public let titleLarge: Font
    public let titleMedium: Font
    public let titleSmall: Font
    public let bodyLarge: Font
    public let bodyMedium: Font
    public let bodySmall: Font
    public let labelLarge: Font
    public let labelMedium: Font
    public let labelSmall: Font
    
    public init(
        displayLarge: Font = DesignTokens.Typography.displayLarge,
        displayMedium: Font = DesignTokens.Typography.displayMedium,
        displaySmall: Font = DesignTokens.Typography.displaySmall,
        headlineLarge: Font = DesignTokens.Typography.headlineLarge,
        headlineMedium: Font = DesignTokens.Typography.headlineMedium,
        headlineSmall: Font = DesignTokens.Typography.headlineSmall,
        titleLarge: Font = DesignTokens.Typography.titleLarge,
        titleMedium: Font = DesignTokens.Typography.titleMedium,
        titleSmall: Font = DesignTokens.Typography.titleSmall,
        bodyLarge: Font = DesignTokens.Typography.bodyLarge,
        bodyMedium: Font = DesignTokens.Typography.bodyMedium,
        bodySmall: Font = DesignTokens.Typography.bodySmall,
        labelLarge: Font = DesignTokens.Typography.labelLarge,
        labelMedium: Font = DesignTokens.Typography.labelMedium,
        labelSmall: Font = DesignTokens.Typography.labelSmall
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
    }
    
    public static let `default` = ThemeTypography()
}

// MARK: - Theme Spacing

public struct ThemeSpacing: Equatable {
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat
    
    public init(
        xs: CGFloat = DesignTokens.Spacing.xs,
        sm: CGFloat = DesignTokens.Spacing.sm,
        md: CGFloat = DesignTokens.Spacing.md,
        lg: CGFloat = DesignTokens.Spacing.lg,
        xl: CGFloat = DesignTokens.Spacing.xl,
        xxl: CGFloat = DesignTokens.Spacing.xxl,
        xxxl: CGFloat = DesignTokens.Spacing.xxxl
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
    }
    
    public static let `default` = ThemeSpacing()
}

// MARK: - Theme Elevation

public struct ThemeElevation: Equatable {
    public let level0: Shadow
    public let level1: Shadow
    public let level2: Shadow
    public let level3: Shadow
    public let level4: Shadow
    public let level5: Shadow
    
    public init(
        level0: Shadow = DesignTokens.Elevation.level0,
        level1: Shadow = DesignTokens.Elevation.level1,
        level2: Shadow = DesignTokens.Elevation.level2,
        level3: Shadow = DesignTokens.Elevation.level3,
        level4: Shadow = DesignTokens.Elevation.level4,
        level5: Shadow = DesignTokens.Elevation.level5
    ) {
        self.level0 = level0
        self.level1 = level1
        self.level2 = level2
        self.level3 = level3
        self.level4 = level4
        self.level5 = level5
    }
    
    public static let `default` = ThemeElevation()
}

// MARK: - Theme Border Radius

public struct ThemeBorderRadius: Equatable {
    public let none: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let full: CGFloat
    
    public init(
        none: CGFloat = DesignTokens.BorderRadius.none,
        xs: CGFloat = DesignTokens.BorderRadius.xs,
        sm: CGFloat = DesignTokens.BorderRadius.sm,
        md: CGFloat = DesignTokens.BorderRadius.md,
        lg: CGFloat = DesignTokens.BorderRadius.lg,
        xl: CGFloat = DesignTokens.BorderRadius.xl,
        xxl: CGFloat = DesignTokens.BorderRadius.xxl,
        full: CGFloat = DesignTokens.BorderRadius.full
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.full = full
    }
    
    public static let `default` = ThemeBorderRadius()
}

// MARK: - Theme Animation

public struct ThemeAnimation: Equatable {
    public let durationFast: Double
    public let durationNormal: Double
    public let durationSlow: Double
    public let durationSlower: Double
    
    public init(
        durationFast: Double = DesignTokens.Animation.durationFast,
        durationNormal: Double = DesignTokens.Animation.durationNormal,
        durationSlow: Double = DesignTokens.Animation.durationSlow,
        durationSlower: Double = DesignTokens.Animation.durationSlower
    ) {
        self.durationFast = durationFast
        self.durationNormal = durationNormal
        self.durationSlow = durationSlow
        self.durationSlower = durationSlower
    }
    
    public static let `default` = ThemeAnimation()
}

// MARK: - Theme Component Size

public struct ThemeComponentSize: Equatable {
    public let buttonHeightXS: CGFloat
    public let buttonHeightSM: CGFloat
    public let buttonHeightMD: CGFloat
    public let buttonHeightLG: CGFloat
    public let buttonHeightXL: CGFloat
    
    public init(
        buttonHeightXS: CGFloat = DesignTokens.ComponentSize.buttonHeightXS,
        buttonHeightSM: CGFloat = DesignTokens.ComponentSize.buttonHeightSM,
        buttonHeightMD: CGFloat = DesignTokens.ComponentSize.buttonHeightMD,
        buttonHeightLG: CGFloat = DesignTokens.ComponentSize.buttonHeightLG,
        buttonHeightXL: CGFloat = DesignTokens.ComponentSize.buttonHeightXL
    ) {
        self.buttonHeightXS = buttonHeightXS
        self.buttonHeightSM = buttonHeightSM
        self.buttonHeightMD = buttonHeightMD
        self.buttonHeightLG = buttonHeightLG
        self.buttonHeightXL = buttonHeightXL
    }
    
    public static let `default` = ThemeComponentSize()
}

// MARK: - Theme Environment

private struct ThemeProviderKey: EnvironmentKey {
    static let defaultValue = ThemeProvider(theme: .light)
}

public extension EnvironmentValues {
    var themeProvider: ThemeProvider {
        get { self[ThemeProviderKey.self] }
        set { self[ThemeProviderKey.self] = newValue }
    }
}

// MARK: - Theme View Modifiers

public extension View {
    /// Apply theme provider to the view hierarchy
    func themeProvider(_ provider: ThemeProvider) -> some View {
        self.environment(\.themeProvider, provider)
    }
    
    /// Get current theme from environment
    func withTheme<Content: View>(@ViewBuilder content: @escaping (Theme) -> Content) -> some View {
        self.environmentObject(ThemeProvider())
            .overlay(
                EnvironmentReader { themeProvider in
                    content(themeProvider.currentTheme)
                }
            )
    }
}

// MARK: - Environment Reader

private struct EnvironmentReader<Content: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    let content: (ThemeProvider) -> Content
    
    var body: some View {
        content(themeProvider)
    }
}
