// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Theme Provider

/// SwiftUI environment-based theme provider for consistent theming across the app
/// 
/// This ThemeProvider guarantees that components use the colors configured in the app's Colors.xcassets.
/// The Color extensions automatically read from the asset catalog, ensuring that:
/// - Light and dark mode variants are properly applied
/// - App-specific brand colors are respected
/// - The library integrates seamlessly with the app's design system
/// 
/// Usage: Components should always use @Environment(\.themeProvider) and theme.colors.xxx
/// instead of direct Color references to ensure proper theming.
public class ThemeProvider: ObservableObject {
    @Published public var currentTheme: Theme = .light
    @Published public var colorScheme: SwiftUI.ColorScheme = .light
    
    public init(theme: Theme = .light) {
        self.currentTheme = theme
        self.colorScheme = theme.colorScheme == .light ? .light : .dark
    }
    
    /// Switch to a different theme
    public func setTheme(_ theme: Theme) {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.currentTheme = theme
            self.colorScheme = theme.colorScheme == .light ? .light : .dark
        }
    }
    
    /// Toggle between light and dark themes
    public func toggleTheme() {
        let newTheme: Theme = currentTheme.name == "Light" ? .dark : .light
        setTheme(newTheme)
    }
    
    /// Update theme based on system color scheme
    public func updateForSystemColorScheme(_ systemColorScheme: SwiftUI.ColorScheme) {
        self.colorScheme = systemColorScheme
        
        // Always update the theme to match system color scheme
        let newTheme: Theme = systemColorScheme == .light ? .light : .dark
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
    public let primary: Color
    public let primaryVariant: Color
    public let onPrimary: Color
    
    // Secondary Colors
    public let secondary: Color
    public let secondaryVariant: Color
    public let onSecondary: Color
    
    // Background Colors
    public let background: Color
    public let surface: Color
    public let surfaceVariant: Color
    public let onBackground: Color
    public let onSurface: Color
    public let onSurfaceVariant: Color
    
    // Outline Colors
    public let outline: Color
    public let outlineVariant: Color
    public let onOutline: Color
    public let onOutlineVariant: Color
    
    // State Colors
    public let success: Color
    public let onSuccess: Color
    public let warning: Color
    public let onWarning: Color
    public let error: Color
    public let onError: Color
    public let info: Color
    public let onInfo: Color
    
    // Neutral Colors
    public let neutral50: Color
    public let neutral100: Color
    public let neutral200: Color
    public let neutral300: Color
    public let neutral400: Color
    public let neutral500: Color
    public let neutral600: Color
    public let neutral700: Color
    public let neutral800: Color
    public let neutral900: Color
    
    public init(
        primary: Color,
        primaryVariant: Color,
        onPrimary: Color,
        secondary: Color,
        secondaryVariant: Color,
        onSecondary: Color,
        background: Color,
        surface: Color,
        surfaceVariant: Color,
        onBackground: Color,
        onSurface: Color,
        onSurfaceVariant: Color,
        outline: Color,
        outlineVariant: Color,
        onOutline: Color,
        onOutlineVariant: Color,
        success: Color,
        onSuccess: Color,
        warning: Color,
        onWarning: Color,
        error: Color,
        onError: Color,
        info: Color,
        onInfo: Color,
        neutral50: Color,
        neutral100: Color,
        neutral200: Color,
        neutral300: Color,
        neutral400: Color,
        neutral500: Color,
        neutral600: Color,
        neutral700: Color,
        neutral800: Color,
        neutral900: Color
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
        primary: .primary,
        primaryVariant: .primary,
        onPrimary: .onPrimary,
        secondary: .primary,
        secondaryVariant: .primary,
        onSecondary: .white,
        background: .background,
        surface: .surface,
        surfaceVariant: .surfaceVariant,
        onBackground: .onBackground,
        onSurface: .onSurface,
        onSurfaceVariant: .onSurfaceVariant,
        outline: .outline,
        outlineVariant: .outlineVariant,
        onOutline: .onOutline,
        onOutlineVariant: .onOutlineVariant,
        success: .success,
        onSuccess: .white,
        warning: .warning,
        onWarning: .white,
        error: .error,
        onError: .white,
        info: .info,
        onInfo: .white,
        neutral50: .surfaceVariant,
        neutral100: .surfaceVariant,
        neutral200: .outlineVariant,
        neutral300: .outlineVariant,
        neutral400: .outline,
        neutral500: .outline,
        neutral600: .onSurfaceVariant,
        neutral700: .onSurfaceVariant,
        neutral800: .onSurface,
        neutral900: .onSurface
    )
    
    public static let dark = ThemeColors(
        primary: .primary,
        primaryVariant: .primary,
        onPrimary: .onPrimary,
        secondary: .primary,
        secondaryVariant: .primary,
        onSecondary: .onSurface,
        background: .background,
        surface: .surface,
        surfaceVariant: .surfaceVariant,
        onBackground: .onBackground,
        onSurface: .onSurface,
        onSurfaceVariant: .onSurfaceVariant,
        outline: .outline,
        outlineVariant: .outlineVariant,
        onOutline: .onOutline,
        onOutlineVariant: .onOutlineVariant,
        success: .success,
        onSuccess: .onSurface,
        warning: .warning,
        onWarning: .onSurface,
        error: .error,
        onError: .onSurface,
        info: .info,
        onInfo: .onSurface,
        neutral50: .background,
        neutral100: .surface,
        neutral200: .surfaceVariant,
        neutral300: .outlineVariant,
        neutral400: .outline,
        neutral500: .outline,
        neutral600: .onSurfaceVariant,
        neutral700: .onSurfaceVariant,
        neutral800: .onSurface,
        neutral900: .onSurface
    )
    
    public static let highContrast = ThemeColors(
        primary: .black,
        primaryVariant: .black,
        onPrimary: .white,
        secondary: .black,
        secondaryVariant: .black,
        onSecondary: .white,
        background: .white,
        surface: .white,
        surfaceVariant: Color(r: 240, g: 240, b: 240),
        onBackground: .black,
        onSurface: .black,
        onSurfaceVariant: .black,
        outline: .black,
        outlineVariant: Color(r: 100, g: 100, b: 100),
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
        neutral100: Color(r: 240, g: 240, b: 240),
        neutral200: Color(r: 200, g: 200, b: 200),
        neutral300: Color(r: 160, g: 160, b: 160),
        neutral400: Color(r: 120, g: 120, b: 120),
        neutral500: Color(r: 80, g: 80, b: 80),
        neutral600: Color(r: 60, g: 60, b: 60),
        neutral700: Color(r: 40, g: 40, b: 40),
        neutral800: Color(r: 20, g: 20, b: 20),
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
    
    /// Apply theme provider that automatically responds to system color scheme changes
    func adaptiveThemeProvider(_ provider: ThemeProvider) -> some View {
        self.environment(\.themeProvider, provider)
            .background(
                SystemColorSchemeDetector(themeProvider: provider)
            )
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

// MARK: - System Color Scheme Detector

private struct SystemColorSchemeDetector: View {
    @Environment(\.colorScheme) private var colorScheme
    let themeProvider: ThemeProvider
    
    var body: some View {
        Color.clear
            .onAppear {
                // Update theme based on current system color scheme
                themeProvider.updateForSystemColorScheme(colorScheme)
            }
            .onChange(of: colorScheme) { newColorScheme in
                themeProvider.updateForSystemColorScheme(newColorScheme)
            }
    }
}
