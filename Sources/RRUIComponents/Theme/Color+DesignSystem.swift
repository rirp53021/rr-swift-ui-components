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
