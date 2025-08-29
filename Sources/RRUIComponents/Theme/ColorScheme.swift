import SwiftUI

/// Represents a color scheme for the UI components
public struct RRColorScheme {
    /// Primary colors used throughout the UI
    public let primary: PrimaryColors
    /// Secondary colors for accents and highlights
    public let secondary: SecondaryColors
    /// Semantic colors for different states
    public let semantic: SemanticColors
    /// Neutral colors for backgrounds and text
    public let neutral: NeutralColors
    
    /// Creates a new color scheme
    /// - Parameters:
    ///   - primary: Primary color palette
    ///   - secondary: Secondary color palette
    ///   - semantic: Semantic color palette
    ///   - neutral: Neutral color palette
    public init(
        primary: PrimaryColors,
        secondary: SecondaryColors,
        semantic: SemanticColors,
        neutral: NeutralColors
    ) {
        self.primary = primary
        self.secondary = secondary
        self.semantic = semantic
        self.neutral = neutral
    }
}

// MARK: - Primary Colors
public struct PrimaryColors {
    public let main: Color
    public let light: Color
    public let dark: Color
    public let contrast: Color
    
    public init(
        main: Color,
        light: Color,
        dark: Color,
        contrast: Color
    ) {
        self.main = main
        self.light = light
        self.dark = dark
        self.contrast = contrast
    }
}

// MARK: - Secondary Colors
public struct SecondaryColors {
    public let main: Color
    public let light: Color
    public let dark: Color
    public let contrast: Color
    
    public init(
        main: Color,
        light: Color,
        dark: Color,
        contrast: Color
    ) {
        self.main = main
        self.light = light
        self.dark = dark
        self.contrast = contrast
    }
}

// MARK: - Semantic Colors
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

// MARK: - Neutral Colors
public struct NeutralColors {
    public let background: Color
    public let surface: Color
    public let text: Color
    public let textSecondary: Color
    public let border: Color
    public let divider: Color
    
    public init(
        background: Color,
        surface: Color,
        text: Color,
        textSecondary: Color,
        border: Color,
        divider: Color
    ) {
        self.background = background
        self.surface = surface
        self.text = text
        self.textSecondary = textSecondary
        self.border = border
        self.divider = divider
    }
}

// MARK: - Default Color Schemes
public extension RRColorScheme {
    /// Default light color scheme
    static let light = RRColorScheme(
        primary: PrimaryColors(
            main: Color(red: 0.2, green: 0.4, blue: 0.8),
            light: Color(red: 0.4, green: 0.6, blue: 0.9),
            dark: Color(red: 0.1, green: 0.3, blue: 0.7),
            contrast: .white
        ),
        secondary: SecondaryColors(
            main: Color(red: 0.8, green: 0.6, blue: 0.2),
            light: Color(red: 0.9, green: 0.8, blue: 0.4),
            dark: Color(red: 0.7, green: 0.5, blue: 0.1),
            contrast: .white
        ),
        semantic: SemanticColors(
            success: Color(red: 0.2, green: 0.7, blue: 0.3),
            warning: Color(red: 0.9, green: 0.7, blue: 0.2),
            error: Color(red: 0.9, green: 0.3, blue: 0.3),
            info: Color(red: 0.2, green: 0.6, blue: 0.9)
        ),
        neutral: NeutralColors(
            background: .white,
            surface: Color(red: 0.98, green: 0.98, blue: 0.98),
            text: Color(red: 0.1, green: 0.1, blue: 0.1),
            textSecondary: Color(red: 0.4, green: 0.4, blue: 0.4),
            border: Color(red: 0.9, green: 0.9, blue: 0.9),
            divider: Color(red: 0.8, green: 0.8, blue: 0.8)
        )
    )
    
    /// Default dark color scheme
    static let dark = RRColorScheme(
        primary: PrimaryColors(
            main: Color(red: 0.4, green: 0.6, blue: 0.9),
            light: Color(red: 0.6, green: 0.8, blue: 1.0),
            dark: Color(red: 0.2, green: 0.4, blue: 0.7),
            contrast: .black
        ),
        secondary: SecondaryColors(
            main: Color(red: 0.9, green: 0.7, blue: 0.3),
            light: Color(red: 1.0, green: 0.9, blue: 0.5),
            dark: Color(red: 0.8, green: 0.6, blue: 0.2),
            contrast: .black
        ),
        semantic: SemanticColors(
            success: Color(red: 0.3, green: 0.8, blue: 0.4),
            warning: Color(red: 1.0, green: 0.8, blue: 0.3),
            error: Color(red: 1.0, green: 0.4, blue: 0.4),
            info: Color(red: 0.3, green: 0.7, blue: 1.0)
        ),
        neutral: NeutralColors(
            background: Color(red: 0.1, green: 0.1, blue: 0.1),
            surface: Color(red: 0.15, green: 0.15, blue: 0.15),
            text: Color(red: 0.9, green: 0.9, blue: 0.9),
            textSecondary: Color(red: 0.6, green: 0.6, blue: 0.6),
            border: Color(red: 0.2, green: 0.2, blue: 0.2),
            divider: Color(red: 0.3, green: 0.3, blue: 0.3)
        )
    )
}
