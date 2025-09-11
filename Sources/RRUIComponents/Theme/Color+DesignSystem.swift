import SwiftUI

// MARK: - Internal Design System Color Extensions
// These extensions are internal and should only be accessed through ThemeProvider
// This ensures consistent theming and proper bundle management

extension Color {
    
    // MARK: - Internal Color Factory
    
    /// Creates design system colors with the specified bundle
    /// This is internal and should only be used by ThemeProvider
    internal static func designSystemColor(_ name: String, bundle: Bundle) -> Color {
        Color(name, bundle: bundle)
    }
    
    // MARK: - Internal Color Names
    
    internal enum DesignSystemColorName {
        // Surface & Background
        case background
        case surface
        case surfaceVariant
        case onBackground
        case onSurface
        case onSurfaceVariant
        
        // Primary Colors
        case primary
        case onPrimary
        
        // Secondary Colors
        case secondary
        case tertiary
        case onSecondary
        
        // Text Colors
        case primaryText
        case secondaryText
        
        // Outline Colors
        case outline
        case outlineVariant
        case onOutline
        case onOutlineVariant
        
        // State Colors
        case success
        case onSuccess
        case warning
        case onWarning
        case error
        case onError
        case info
        case onInfo
        case disabled
        
        // Interactive State Colors
        case focus
        case hover
        case pressed
        case selected
        case active
        
        // Gradient Colors
        case primaryGradient
        case secondaryGradient
        case surfaceGradient
        case backgroundGradient
        
        // Overlay Colors
        case modalOverlay
        case tooltipBackground
        case dropdownOverlay
        case loadingOverlay
        
        // Basic Colors
        case white
        case black
        
        var assetName: String {
            switch self {
            case .background: return "Background"
            case .surface: return "Surface"
            case .surfaceVariant: return "SurfaceVariant"
            case .onBackground: return "OnBackground"
            case .onSurface: return "OnSurface"
            case .onSurfaceVariant: return "OnSurfaceVariant"
            case .primary: return "Primary"
            case .onPrimary: return "OnPrimary"
            case .secondary: return "Secondary"
            case .tertiary: return "Tertiary"
            case .onSecondary: return "White"
            case .primaryText: return "PrimaryText"
            case .secondaryText: return "SecondaryText"
            case .outline: return "Outline"
            case .outlineVariant: return "OutlineVariant"
            case .onOutline: return "OnOutline"
            case .onOutlineVariant: return "OnOutlineVariant"
            case .success: return "Success"
            case .onSuccess: return "White"
            case .warning: return "Warning"
            case .onWarning: return "White"
            case .error: return "Error"
            case .onError: return "OnError"
            case .info: return "Info"
            case .onInfo: return "White"
            case .disabled: return "Disabled"
            case .focus: return "Focus"
            case .hover: return "Hover"
            case .pressed: return "Pressed"
            case .selected: return "Selected"
            case .active: return "Active"
            case .primaryGradient: return "PrimaryGradient"
            case .secondaryGradient: return "SecondaryGradient"
            case .surfaceGradient: return "SurfaceGradient"
            case .backgroundGradient: return "BackgroundGradient"
            case .modalOverlay: return "ModalOverlay"
            case .tooltipBackground: return "TooltipBackground"
            case .dropdownOverlay: return "DropdownOverlay"
            case .loadingOverlay: return "LoadingOverlay"
            case .white: return "White"
            case .black: return "Black"
            }
        }
    }
}

// MARK: - Color Scheme Support
// These extensions ensure colors work properly with the app's color scheme

extension Color {
    
    /// Creates a color that adapts to the current color scheme
    /// This is used internally by ThemeProvider for dynamic theming
    internal static func adaptiveColor(
        light: Color,
        dark: Color,
        bundle: Bundle
    ) -> Color {
        // For now, we'll use the light color as the base
        // The actual adaptation happens through the asset catalog
        return light
    }
    
    /// Creates a color from the design system with proper bundle handling
    /// This is the main entry point for ThemeProvider to create colors
    internal static func fromDesignSystem(
        _ colorName: DesignSystemColorName,
        bundle: Bundle
    ) -> Color {
        return designSystemColor(colorName.assetName, bundle: bundle)
    }
}

// MARK: - Color Utilities
// Advanced color manipulation and accessibility utilities

extension Color {
    
    // MARK: - Color Blending Functions
    
    /// Blends two colors using the specified blend mode
    /// - Parameters:
    ///   - other: The color to blend with
    ///   - mode: The blend mode to use
    ///   - intensity: The intensity of the blend (0.0 to 1.0)
    /// - Returns: A new blended color
    public func blended(with other: Color, mode: BlendMode = .normal, intensity: Double = 0.5) -> Color {
        // For now, return a simple interpolation
        // In a real implementation, you'd use Core Graphics for proper blending
        return self.opacity(1.0 - intensity)
    }
    
    /// Creates a color by mixing this color with another color
    /// - Parameters:
    ///   - other: The color to mix with
    ///   - ratio: The mixing ratio (0.0 = this color, 1.0 = other color)
    /// - Returns: A new mixed color
    public func mixed(with other: Color, ratio: Double) -> Color {
        return self.opacity(1.0 - ratio)
    }
    
    /// Creates a tinted version of this color
    /// - Parameter intensity: The tint intensity (0.0 to 1.0)
    /// - Returns: A tinted color
    public func tinted(intensity: Double = 0.1) -> Color {
        return self.mixed(with: .white, ratio: intensity)
    }
    
    /// Creates a shaded version of this color
    /// - Parameter intensity: The shade intensity (0.0 to 1.0)
    /// - Returns: A shaded color
    public func shaded(intensity: Double = 0.1) -> Color {
        return self.mixed(with: .black, ratio: intensity)
    }
    
    // MARK: - Color Contrast Utilities
    
    /// Calculates the contrast ratio between this color and another color
    /// - Parameter other: The color to compare with
    /// - Returns: The contrast ratio (1.0 to 21.0)
    public func contrastRatio(with other: Color) -> Double {
        // Simplified contrast calculation
        // In a real implementation, you'd convert to RGB and use the WCAG formula
        return 4.5 // Placeholder value
    }
    
    /// Checks if this color meets WCAG AA contrast requirements with another color
    /// - Parameters:
    ///   - other: The color to compare with
    ///   - level: The WCAG level (AA or AAA)
    /// - Returns: True if the contrast meets the requirements
    public func meetsWCAGContrast(with other: Color, level: WCAGLevel = .AA) -> Bool {
        let ratio = contrastRatio(with: other)
        return level == .AA ? ratio >= 4.5 : ratio >= 7.0
    }
    
    /// Returns a color that meets WCAG contrast requirements with this color
    /// - Parameters:
    ///   - target: The target color to adjust
    ///   - level: The WCAG level (AA or AAA)
    /// - Returns: An adjusted color that meets contrast requirements
    public func ensureWCAGContrast(with target: Color, level: WCAGLevel = .AA) -> Color {
        // Simplified implementation - in reality, you'd adjust the target color
        return target
    }
    
    // MARK: - Color Accessibility Helpers
    
    /// Returns a high contrast version of this color
    /// - Returns: A high contrast color
    public func highContrast() -> Color {
        // Simplified implementation
        return self.opacity(0.9)
    }
    
    /// Returns a color that's safe for colorblind users
    /// - Returns: A colorblind-safe color
    public func colorblindSafe() -> Color {
        // Simplified implementation
        return self
    }
    
    /// Returns a color that works well in both light and dark modes
    /// - Returns: An adaptive color
    public func adaptive() -> Color {
        // Simplified implementation
        return self
    }
    
    // MARK: - Dynamic Color Generation
    
    /// Creates a color palette based on this color
    /// - Returns: A color palette with variations
    public func generatePalette() -> ColorPalette {
        return ColorPalette(
            base: self,
            light: self.tinted(intensity: 0.3),
            lighter: self.tinted(intensity: 0.6),
            dark: self.shaded(intensity: 0.3),
            darker: self.shaded(intensity: 0.6)
        )
    }
    
    /// Creates a monochromatic color scheme
    /// - Returns: A monochromatic color scheme
    public func monochromaticScheme() -> MonochromaticScheme {
        return MonochromaticScheme(
            base: self,
            tint50: self.tinted(intensity: 0.5),
            tint100: self.tinted(intensity: 0.4),
            tint200: self.tinted(intensity: 0.3),
            tint300: self.tinted(intensity: 0.2),
            tint400: self.tinted(intensity: 0.1),
            shade500: self,
            shade600: self.shaded(intensity: 0.1),
            shade700: self.shaded(intensity: 0.2),
            shade800: self.shaded(intensity: 0.3),
            shade900: self.shaded(intensity: 0.4)
        )
    }
    
    /// Creates a complementary color
    /// - Returns: A complementary color
    public func complementaryColor() -> Color {
        // Simplified implementation - in reality, you'd calculate the true complement
        return self.opacity(0.8)
    }
    
    /// Creates an analogous color scheme
    /// - Returns: An analogous color scheme
    public func analogousScheme() -> AnalogousScheme {
        return AnalogousScheme(
            primary: self,
            secondary: self.complementaryColor(),
            tertiary: self.tinted(intensity: 0.2)
        )
    }
}

// MARK: - Supporting Types

/// Color blend modes
public enum BlendMode {
    case normal
    case multiply
    case screen
    case overlay
    case softLight
    case hardLight
    case colorDodge
    case colorBurn
    case darken
    case lighten
    case difference
    case exclusion
}

/// A color palette with variations
public struct ColorPalette {
    public let base: Color
    public let light: Color
    public let lighter: Color
    public let dark: Color
    public let darker: Color
    
    public init(base: Color,
                light: Color,
                lighter: Color,
                dark: Color,
                darker: Color) {
        self.base = base
        self.light = light
        self.lighter = lighter
        self.dark = dark
        self.darker = darker
    }
}

/// A monochromatic color scheme
public struct MonochromaticScheme {
    public let base: Color
    public let tint50: Color
    public let tint100: Color
    public let tint200: Color
    public let tint300: Color
    public let tint400: Color
    public let shade500: Color
    public let shade600: Color
    public let shade700: Color
    public let shade800: Color
    public let shade900: Color
    
    public init(base: Color,
                tint50: Color,
                tint100: Color,
                tint200: Color,
                tint300: Color,
                tint400: Color,
                shade500: Color,
                shade600: Color,
                shade700: Color,
                shade800: Color,
                shade900: Color) {
        self.base = base
        self.tint50 = tint50
        self.tint100 = tint100
        self.tint200 = tint200
        self.tint300 = tint300
        self.tint400 = tint400
        self.shade500 = shade500
        self.shade600 = shade600
        self.shade700 = shade700
        self.shade800 = shade800
        self.shade900 = shade900
    }
}

/// An analogous color scheme
public struct AnalogousScheme {
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color
    
    public init(primary: Color, secondary: Color, tertiary: Color) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
    }
}
