// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Nested Color Structures

public struct NeutralColors {
    public let text: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let background: Color
    public let surface: Color
    public let border: Color
    public let divider: Color
    
    public init(
        text: Color,
        textSecondary: Color,
        textTertiary: Color,
        background: Color,
        surface: Color,
        border: Color,
        divider: Color
    ) {
        self.text = text
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.background = background
        self.surface = surface
        self.border = border
        self.divider = divider
    }
}

public struct SemanticColors {
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color
    
    public init(
        success: Color,
        warning: Color,
        error: Color,
        info: Color
    ) {
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

// MARK: - Color Scheme

public struct RRColorScheme {
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let error: Color
    public let warning: Color
    public let success: Color
    public let info: Color
    public let text: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let border: Color
    public let divider: Color
    
    // Nested structures for better organization
    public let neutral: NeutralColors
    public let semantic: SemanticColors
    
    public init(
        primary: Color,
        secondary: Color,
        accent: Color,
        background: Color,
        surface: Color,
        error: Color,
        warning: Color,
        success: Color,
        info: Color,
        text: Color,
        textSecondary: Color,
        textTertiary: Color,
        border: Color,
        divider: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.error = error
        self.warning = warning
        self.success = success
        self.info = info
        self.text = text
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.border = border
        self.divider = divider
        
        // Initialize nested structures
        self.neutral = NeutralColors(
            text: text,
            textSecondary: textSecondary,
            textTertiary: textTertiary,
            background: background,
            surface: surface,
            border: border,
            divider: divider
        )
        
        self.semantic = SemanticColors(
            success: success,
            warning: warning,
            error: error,
            info: info
        )
    }
}

// MARK: - Default Color Schemes

public extension RRColorScheme {
    
    /// Light color scheme
    static let light = RRColorScheme(
        primary: Color.blue,
        secondary: Color.gray,
        accent: Color.orange,
        background: Color.white,
        surface: Color.gray.opacity(0.1),
        error: Color.red,
        warning: Color.orange,
        success: Color.green,
        info: Color.blue,
        text: Color.primary,
        textSecondary: Color.secondary,
        textTertiary: Color.gray.opacity(0.6),
        border: Color.gray.opacity(0.3),
        divider: Color.gray.opacity(0.2)
    )
    
    /// Dark color scheme
    static let dark = RRColorScheme(
        primary: Color.blue,
        secondary: Color.gray,
        accent: Color.orange,
        background: Color.black,
        surface: Color.gray.opacity(0.2),
        error: Color.red,
        warning: Color.orange,
        success: Color.green,
        info: Color.blue,
        text: Color.primary,
        textSecondary: Color.secondary,
        textTertiary: Color.gray.opacity(0.6),
        border: Color.gray.opacity(0.3),
        divider: Color.gray.opacity(0.2)
    )
    
    /// Material color scheme
    static let material = RRColorScheme(
        primary: Color.blue,
        secondary: Color.gray,
        accent: Color.orange,
        background: Color.primary,
        surface: Color.secondary,
        error: Color.red,
        warning: Color.yellow,
        success: Color.green,
        info: Color.blue,
        text: Color.primary,
        textSecondary: Color.secondary,
        textTertiary: Color.gray.opacity(0.6),
        border: Color.gray.opacity(0.3),
        divider: Color.gray.opacity(0.2)
    )
    
    /// Custom color scheme with CSS colors
    static let custom = RRColorScheme(
        primary: Color(hex: "#007AFF") ?? Color.blue,
        secondary: Color(hex: "#8E8E93") ?? Color.gray,
        accent: Color(hex: "#FF9500") ?? Color.orange,
        background: Color(hex: "#FFFFFF") ?? Color.white,
        surface: Color(hex: "#F2F2F7") ?? Color.gray.opacity(0.1),
        error: Color(hex: "#FF3B30") ?? Color.red,
        warning: Color(hex: "#FF9500") ?? Color.orange,
        success: Color(hex: "#34C759") ?? Color.green,
        info: Color(hex: "#007AFF") ?? Color.blue,
        text: Color(hex: "#000000") ?? Color.primary,
        textSecondary: Color(hex: "#8E8E93") ?? Color.secondary,
        textTertiary: Color(hex: "#C7C7CC") ?? Color.gray.opacity(0.6),
        border: Color(hex: "#D1D1D6") ?? Color.gray.opacity(0.3),
        divider: Color(hex: "#E5E5EA") ?? Color.gray.opacity(0.2)
    )
}

// MARK: - Color Extensions for Hex Support

public extension Color {
    /// Creates a color from a hex string
    /// - Parameter hex: The hex string (e.g., "#FF0000", "FF0000", "#FF0000FF")
    /// - Returns: A color object if the hex string is valid, nil otherwise
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
