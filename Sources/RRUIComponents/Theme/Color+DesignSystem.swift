import SwiftUI

// MARK: - Design System Color Extensions
// This extension provides access to all colors defined in Colors.xcassets
// Each color automatically supports light and dark mode variants

extension Color {
    
    // MARK: - Semantic Colors (Surface & Background)
    
    /// Background color for the app
    public static let background = Color("Background")
    
    /// Surface color for cards, sheets, and elevated content
    public static let surface = Color("Surface")
    
    /// Variant surface color for subtle backgrounds
    public static let surfaceVariant = Color("SurfaceVariant")
    
    /// Text color for content on surface backgrounds
    public static let onSurface = Color("OnSurface")
    
    /// Secondary text color for content on surface backgrounds
    public static let onSurfaceVariant = Color("OnSurfaceVariant")
    
    /// Text color for content on background
    public static let onBackground = Color("OnBackground")
    
    // MARK: - Outline Colors
    
    /// Primary outline color for borders and dividers
    public static let outline = Color("Outline")
    
    /// Variant outline color for subtle borders
    public static let outlineVariant = Color("OutlineVariant")
    
    /// Text color for content on outline backgrounds
    public static let onOutline = Color("OnOutline")
    
    /// Text color for content on outline variant backgrounds
    public static let onOutlineVariant = Color("OnOutlineVariant")
    
    // MARK: - Brand Colors
    
    /// Primary brand color
    public static let primary = Color("Primary")
    
    /// Text color for content on primary backgrounds
    public static let onPrimary = Color("OnPrimary")
    
    // MARK: - Semantic State Colors
    
    /// Success state color
    public static let success = Color("Success")
    
    /// Error state color
    public static let error = Color("Error")
    
    /// Warning state color
    public static let warning = Color("Warning")
    
    /// Info state color
    public static let info = Color("Info")
}

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

