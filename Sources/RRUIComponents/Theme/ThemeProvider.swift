// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Bundle Helper

private final class BundleToken {}

public extension Bundle {
    static let uiComponents = Bundle(for: BundleToken.self)
}

// MARK: - Theme Color Scheme
@MainActor
public enum ThemeColorScheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case highContrast = "highContrast"
}

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
@MainActor public class ThemeProvider: ObservableObject {
    @Published public var currentTheme: Theme = .light
    @Published public var colorScheme: SwiftUI.ColorScheme = .light
    private let bundle: Bundle
    
    public init(theme: Theme = .light, bundle: Bundle = .uiComponents) {
        self.bundle = bundle
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
@MainActor public struct Theme: Equatable {
    public let name: String
    public let colorScheme: ThemeColorScheme
    public let colors: ThemeColors
    public let typography: ThemeTypography
    public let spacing: ThemeSpacing
    public let elevation: ThemeElevation
    public let borderRadius: ThemeBorderRadius
    public let animation: ThemeAnimation
    public let componentSize: ThemeComponentSize
    
    public init(
        name: String,
        colorScheme: ThemeColorScheme,
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
    
    /// Creates a theme with the specified bundle for colors
    public static func create(
        name: String,
        colorScheme: ThemeColorScheme,
        bundle: Bundle = .uiComponents,
        typography: ThemeTypography = .default,
        spacing: ThemeSpacing = .default,
        elevation: ThemeElevation = .default,
        borderRadius: ThemeBorderRadius = .default,
        animation: ThemeAnimation = .default,
        componentSize: ThemeComponentSize = .default
    ) -> Theme {
        let colors: ThemeColors
        switch colorScheme {
        case .light:
            colors = ThemeColors(bundle: bundle)
        case .dark:
            colors = ThemeColors.dark(bundle: bundle)
        case .highContrast:
            colors = ThemeColors.highContrast(bundle: bundle)
        }
        
        return Theme(
            name: name,
            colorScheme: colorScheme,
            colors: colors,
            typography: typography,
            spacing: spacing,
            elevation: elevation,
            borderRadius: borderRadius,
            animation: animation,
            componentSize: componentSize
        )
    }
    
    // MARK: - Predefined Themes
    
    public static let light = Theme.create(name: "Light", colorScheme: .light)
    
    public static let dark = Theme.create(name: "Dark", colorScheme: .dark)
    
    public static let highContrast = Theme.create(name: "High Contrast", colorScheme: .highContrast)
}

// MARK: - Theme Colors
@MainActor
public struct ThemeColors: Equatable {
    // MARK: - Bundle Helper
    private let bundle: Bundle
    
    // Primary Colors
    public let primary: Color
    public let primaryVariant: Color
    public let onPrimary: Color
    
    // Secondary Colors
    public let secondary: Color
    public let secondaryVariant: Color
    public let onSecondary: Color
    
    // Tertiary Colors
    public let tertiary: Color
    
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
    public let disabled: Color
    
    // Interactive State Colors
    public let focus: Color
    public let hover: Color
    public let pressed: Color
    public let selected: Color
    public let active: Color
    
    // Gradient Colors
    public let primaryGradient: Color
    public let secondaryGradient: Color
    public let surfaceGradient: Color
    public let backgroundGradient: Color
    
    // Overlay Colors
    public let modalOverlay: Color
    public let tooltipBackground: Color
    public let dropdownOverlay: Color
    public let loadingOverlay: Color
    
    // Text Colors
    public let primaryText: Color
    public let secondaryText: Color
    
    // Basic Colors
    public let white: Color
    public let black: Color
    
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
        bundle: Bundle = .uiComponents,
        primary: Color,
        primaryVariant: Color,
        onPrimary: Color,
        secondary: Color,
        secondaryVariant: Color,
        onSecondary: Color,
        tertiary: Color,
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
        disabled: Color,
        focus: Color,
        hover: Color,
        pressed: Color,
        selected: Color,
        active: Color,
        primaryGradient: Color,
        secondaryGradient: Color,
        surfaceGradient: Color,
        backgroundGradient: Color,
        modalOverlay: Color,
        tooltipBackground: Color,
        dropdownOverlay: Color,
        loadingOverlay: Color,
        primaryText: Color,
        secondaryText: Color,
        white: Color,
        black: Color,
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
        self.bundle = bundle
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.onSecondary = onSecondary
        self.tertiary = tertiary
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
        self.disabled = disabled
        self.focus = focus
        self.hover = hover
        self.pressed = pressed
        self.selected = selected
        self.active = active
        self.primaryGradient = primaryGradient
        self.secondaryGradient = secondaryGradient
        self.surfaceGradient = surfaceGradient
        self.backgroundGradient = backgroundGradient
        self.modalOverlay = modalOverlay
        self.tooltipBackground = tooltipBackground
        self.dropdownOverlay = dropdownOverlay
        self.loadingOverlay = loadingOverlay
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.white = white
        self.black = black
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
    
    // MARK: - Convenience Initializer
    
    /// Creates ThemeColors from asset catalog names using the specified bundle
    public init(bundle: Bundle = .uiComponents) {
        self.bundle = bundle
        
        // Primary Colors
        self.primary = Color.fromDesignSystem(.primary, bundle: bundle)
        self.primaryVariant = Color.fromDesignSystem(.primary, bundle: bundle)
        self.onPrimary = Color.fromDesignSystem(.onPrimary, bundle: bundle)
        
        // Secondary Colors
        self.secondary = Color.fromDesignSystem(.secondary, bundle: bundle)
        self.secondaryVariant = Color.fromDesignSystem(.secondary, bundle: bundle)
        self.onSecondary = Color.fromDesignSystem(.onSecondary, bundle: bundle)
        
        // Tertiary Colors
        self.tertiary = Color.fromDesignSystem(.tertiary, bundle: bundle)
        
        // Background Colors
        self.background = Color.fromDesignSystem(.background, bundle: bundle)
        self.surface = Color.fromDesignSystem(.surface, bundle: bundle)
        self.surfaceVariant = Color.fromDesignSystem(.surfaceVariant, bundle: bundle)
        self.onBackground = Color.fromDesignSystem(.onBackground, bundle: bundle)
        self.onSurface = Color.fromDesignSystem(.onSurface, bundle: bundle)
        self.onSurfaceVariant = Color.fromDesignSystem(.onSurfaceVariant, bundle: bundle)
        
        // Outline Colors
        self.outline = Color.fromDesignSystem(.outline, bundle: bundle)
        self.outlineVariant = Color.fromDesignSystem(.outlineVariant, bundle: bundle)
        self.onOutline = Color.fromDesignSystem(.onOutline, bundle: bundle)
        self.onOutlineVariant = Color.fromDesignSystem(.onOutlineVariant, bundle: bundle)
        
        // State Colors
        self.success = Color.fromDesignSystem(.success, bundle: bundle)
        self.onSuccess = Color.fromDesignSystem(.onSuccess, bundle: bundle)
        self.warning = Color.fromDesignSystem(.warning, bundle: bundle)
        self.onWarning = Color.fromDesignSystem(.onWarning, bundle: bundle)
        self.error = Color.fromDesignSystem(.error, bundle: bundle)
        self.onError = Color.fromDesignSystem(.onError, bundle: bundle)
        self.info = Color.fromDesignSystem(.info, bundle: bundle)
        self.onInfo = Color.fromDesignSystem(.onInfo, bundle: bundle)
        self.disabled = Color.fromDesignSystem(.disabled, bundle: bundle)
        
        // Interactive State Colors
        self.focus = Color.fromDesignSystem(.focus, bundle: bundle)
        self.hover = Color.fromDesignSystem(.hover, bundle: bundle)
        self.pressed = Color.fromDesignSystem(.pressed, bundle: bundle)
        self.selected = Color.fromDesignSystem(.selected, bundle: bundle)
        self.active = Color.fromDesignSystem(.active, bundle: bundle)
        
        // Gradient Colors
        self.primaryGradient = Color.fromDesignSystem(.primaryGradient, bundle: bundle)
        self.secondaryGradient = Color.fromDesignSystem(.secondaryGradient, bundle: bundle)
        self.surfaceGradient = Color.fromDesignSystem(.surfaceGradient, bundle: bundle)
        self.backgroundGradient = Color.fromDesignSystem(.backgroundGradient, bundle: bundle)
        
        // Overlay Colors
        self.modalOverlay = Color.fromDesignSystem(.modalOverlay, bundle: bundle)
        self.tooltipBackground = Color.fromDesignSystem(.tooltipBackground, bundle: bundle)
        self.dropdownOverlay = Color.fromDesignSystem(.dropdownOverlay, bundle: bundle)
        self.loadingOverlay = Color.fromDesignSystem(.loadingOverlay, bundle: bundle)
        
        // Text Colors
        self.primaryText = Color.fromDesignSystem(.primaryText, bundle: bundle)
        self.secondaryText = Color.fromDesignSystem(.secondaryText, bundle: bundle)
        
        // Basic Colors
        self.white = Color.fromDesignSystem(.white, bundle: bundle)
        self.black = Color.fromDesignSystem(.black, bundle: bundle)
        
        // Neutral Colors (mapped to existing design system colors)
        self.neutral50 = Color.fromDesignSystem(.surfaceVariant, bundle: bundle)
        self.neutral100 = Color.fromDesignSystem(.surfaceVariant, bundle: bundle)
        self.neutral200 = Color.fromDesignSystem(.outlineVariant, bundle: bundle)
        self.neutral300 = Color.fromDesignSystem(.outlineVariant, bundle: bundle)
        self.neutral400 = Color.fromDesignSystem(.outline, bundle: bundle)
        self.neutral500 = Color.fromDesignSystem(.outline, bundle: bundle)
        self.neutral600 = Color.fromDesignSystem(.onSurfaceVariant, bundle: bundle)
        self.neutral700 = Color.fromDesignSystem(.onSurfaceVariant, bundle: bundle)
        self.neutral800 = Color.fromDesignSystem(.onSurface, bundle: bundle)
        self.neutral900 = Color.fromDesignSystem(.onSurface, bundle: bundle)
    }
    
    // MARK: - Theme-Specific Initializers
    
    /// Creates a dark theme variation with appropriate color mappings
    public static func dark(bundle: Bundle = .uiComponents) -> ThemeColors {
        var colors = ThemeColors(bundle: bundle)
        // Override specific colors for dark theme
        colors = ThemeColors(
            bundle: bundle,
            primary: colors.primary,
            primaryVariant: colors.primaryVariant,
            onPrimary: colors.onPrimary,
            secondary: colors.secondary,
            secondaryVariant: colors.secondaryVariant,
            onSecondary: colors.onSurface, // Different for dark theme
            tertiary: colors.tertiary,
            background: colors.background,
            surface: colors.surface,
            surfaceVariant: colors.surfaceVariant,
            onBackground: colors.onBackground,
            onSurface: colors.onSurface,
            onSurfaceVariant: colors.onSurfaceVariant,
            outline: colors.outline,
            outlineVariant: colors.outlineVariant,
            onOutline: colors.onOutline,
            onOutlineVariant: colors.onOutlineVariant,
            success: colors.success,
            onSuccess: colors.onSurface, // Different for dark theme
            warning: colors.warning,
            onWarning: colors.onSurface, // Different for dark theme
            error: colors.error,
            onError: colors.onError,
            info: colors.info,
            onInfo: colors.onSurface, // Different for dark theme
            disabled: colors.disabled,
            focus: colors.focus,
            hover: colors.hover,
            pressed: colors.pressed,
            selected: colors.selected,
            active: colors.active,
            primaryGradient: colors.primaryGradient,
            secondaryGradient: colors.secondaryGradient,
            surfaceGradient: colors.surfaceGradient,
            backgroundGradient: colors.backgroundGradient,
            modalOverlay: colors.modalOverlay,
            tooltipBackground: colors.tooltipBackground,
            dropdownOverlay: colors.dropdownOverlay,
            loadingOverlay: colors.loadingOverlay,
            primaryText: colors.primaryText,
            secondaryText: colors.secondaryText,
            white: colors.white,
            black: colors.black,
            neutral50: colors.background, // Different for dark theme
            neutral100: colors.surface, // Different for dark theme
            neutral200: colors.surfaceVariant, // Different for dark theme
            neutral300: colors.outlineVariant,
            neutral400: colors.outline,
            neutral500: colors.outline,
            neutral600: colors.onSurfaceVariant,
            neutral700: colors.onSurfaceVariant,
            neutral800: colors.onSurface,
            neutral900: colors.onSurface
        )
        return colors
    }
    
    /// Creates a high contrast theme variation with appropriate color mappings
    public static func highContrast(bundle: Bundle = .uiComponents) -> ThemeColors {
        let baseColors = ThemeColors(bundle: bundle)
        return ThemeColors(
            bundle: bundle,
            primary: baseColors.black,
            primaryVariant: baseColors.black,
            onPrimary: baseColors.white,
            secondary: baseColors.black,
            secondaryVariant: baseColors.black,
            onSecondary: baseColors.white,
            tertiary: baseColors.black,
            background: baseColors.white,
            surface: baseColors.white,
            surfaceVariant: baseColors.surfaceVariant,
            onBackground: baseColors.black,
            onSurface: baseColors.black,
            onSurfaceVariant: baseColors.black,
            outline: baseColors.black,
            outlineVariant: baseColors.outlineVariant,
            onOutline: baseColors.white,
            onOutlineVariant: baseColors.white,
            success: baseColors.success,
            onSuccess: baseColors.white,
            warning: baseColors.warning,
            onWarning: baseColors.black,
            error: baseColors.error,
            onError: baseColors.white,
            info: baseColors.info,
            onInfo: baseColors.white,
            disabled: baseColors.disabled,
            focus: baseColors.focus,
            hover: baseColors.hover,
            pressed: baseColors.pressed,
            selected: baseColors.selected,
            active: baseColors.active,
            primaryGradient: baseColors.primaryGradient,
            secondaryGradient: baseColors.secondaryGradient,
            surfaceGradient: baseColors.surfaceGradient,
            backgroundGradient: baseColors.backgroundGradient,
            modalOverlay: baseColors.modalOverlay,
            tooltipBackground: baseColors.tooltipBackground,
            dropdownOverlay: baseColors.dropdownOverlay,
            loadingOverlay: baseColors.loadingOverlay,
            primaryText: baseColors.black,
            secondaryText: baseColors.secondaryText,
            white: baseColors.white,
            black: baseColors.black,
            neutral50: baseColors.white,
            neutral100: baseColors.surfaceVariant,
            neutral200: baseColors.outlineVariant,
            neutral300: baseColors.outlineVariant,
            neutral400: baseColors.outline,
            neutral500: baseColors.outline,
            neutral600: baseColors.onSurfaceVariant,
            neutral700: baseColors.onSurfaceVariant,
            neutral800: baseColors.onSurface,
            neutral900: baseColors.black
        )
    }
    
    // MARK: - Predefined Color Schemes
    
    @MainActor
    public static let light = ThemeColors()
    
    @MainActor
    public static let dark = ThemeColors.dark()
    
    @MainActor
    public static let highContrast = ThemeColors.highContrast()
}

// MARK: - Theme Typography
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeTypography()
}

// MARK: - Theme Spacing
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeSpacing()
}

// MARK: - Theme Elevation
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeElevation()
}

// MARK: - Theme Border Radius
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeBorderRadius()
}

// MARK: - Theme Animation
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeAnimation()
}

// MARK: - Theme Component Size
@MainActor
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
    
    @MainActor
    public static let `default` = ThemeComponentSize()
}

// MARK: - Theme Environment
@MainActor
private struct ThemeProviderKey: @preconcurrency EnvironmentKey {
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
        self.environmentObject(ThemeProvider(theme: .light))
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
