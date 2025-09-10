import SwiftUI

// MARK: - Design System Color Extensions
// This extension provides access to all colors defined in Colors.xcassets
// Each color automatically supports light and dark mode variants

extension Color {
    
    // MARK: - Bundle Helper
    
    private static var bundle: Bundle {
        Bundle(for: BundleToken.self)
    }
    
    // MARK: - Semantic Colors (Surface & Background)
    
    /// Background color for the app
    public static let background = Color("Background", bundle: bundle)
    
    /// Surface color for cards, sheets, and elevated content
    public static let surface = Color("Surface", bundle: bundle)
    
    /// Variant surface color for subtle backgrounds
    public static let surfaceVariant = Color("SurfaceVariant", bundle: bundle)
    
    /// Secondary color (Zoro green)
    public static let secondary = Color("Secondary", bundle: bundle)
    
    /// Tertiary color (Sanji yellow)
    public static let tertiary = Color("Tertiary", bundle: bundle)
    
    /// Text color for content on surface backgrounds
    public static let onSurface = Color("OnSurface", bundle: bundle)
    
    /// Secondary text color for content on surface backgrounds
    public static let onSurfaceVariant = Color("OnSurfaceVariant", bundle: bundle)
    
    /// Text color for content on background
    public static let onBackground = Color("OnBackground", bundle: bundle)
    
    // MARK: - Text Colors
    
    /// Primary text color for main content
    public static let primaryText = Color("PrimaryText", bundle: bundle)
    
    /// Secondary text color for supporting content
    public static let secondaryText = Color("SecondaryText", bundle: bundle)
    
    // MARK: - Outline Colors
    
    /// Primary outline color for borders and dividers
    public static let outline = Color("Outline", bundle: bundle)
    
    /// Variant outline color for subtle borders
    public static let outlineVariant = Color("OutlineVariant", bundle: bundle)
    
    /// Text color for content on outline backgrounds
    public static let onOutline = Color("OnOutline", bundle: bundle)
    
    /// Text color for content on outline variant backgrounds
    public static let onOutlineVariant = Color("OnOutlineVariant", bundle: bundle)
    
    // MARK: - Brand Colors
    
    /// Primary brand color
    public static let primary = Color("Primary", bundle: bundle)
    
    /// Text color for content on primary backgrounds
    public static let onPrimary = Color("OnPrimary", bundle: bundle)
    
    /// Text color for content on error backgrounds
    public static let onError = Color("OnError", bundle: bundle)
    
    // MARK: - Semantic State Colors
    
    /// Success state color
    public static let success = Color("Success", bundle: bundle)
    
    /// Error state color
    public static let error = Color("Error", bundle: bundle)
    
    /// Warning state color
    public static let warning = Color("Warning", bundle: bundle)
    
    /// Info state color
    public static let info = Color("Info", bundle: bundle)
    
    // MARK: - Basic Colors
    
    /// Pure white color
    public static let white = Color("White", bundle: bundle)
    
    /// Pure black color
    public static let black = Color("Black", bundle: bundle)
    
    // MARK: - Character-Inspired Colors
    
    /// Disabled gray color (Brook)
    public static let disabled = Color("Disabled", bundle: bundle)
}

// MARK: - Bundle Token

private final class BundleToken {}

// MARK: - Color Scheme Support
// These extensions ensure colors work properly with the app's color scheme

extension Color {
    
    /// Returns the appropriate color based on the current color scheme
    /// This ensures the library respects the app's color configuration
    public func adaptive(for colorScheme: ColorScheme) -> Color {
        // SwiftUI automatically handles light/dark mode variants from Colors.xcassets
        // This method can be used for additional custom logic if needed
        return self
    }
    
    /// Returns a color that adapts to the current environment
    public func adaptive() -> Color {
        // SwiftUI's Color automatically adapts based on the environment
        return self
    }
}

