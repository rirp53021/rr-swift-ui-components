// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import RRFoundation

// MARK: - SwiftUI.Color Extensions

public extension Color {
    
    /// Creates a color from a hex string using RRFoundation utilities
    /// - Parameter hex: The hex string (e.g., "#FF0000", "FF0000", "#FF0000FF")
    /// - Returns: A color object if the hex string is valid, nil otherwise
    init?(hex: String) {
        guard let rrColor = RRColor(hex: hex) else { return nil }
        self.init(rrColor)
    }
    
    /// Creates a color from RGB values using RRFoundation utilities
    /// - Parameters:
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    ///   - a: Alpha component (0-255, defaults to 255)
    /// - Returns: A color object
    init(r: Int, g: Int, b: Int, a: Int = 255) {
        let rrColor = RRColor(r: r, g: g, b: b, a: a)
        self.init(rrColor)
    }
    
    /// Creates a color from RGB values as doubles using RRFoundation utilities
    /// - Parameters:
    ///   - r: Red component (0.0-1.0)
    ///   - g: Green component (0.0-1.0)
    ///   - b: Blue component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    /// - Returns: A color object
    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        let rrColor = RRColor(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), a: CGFloat(a))
        self.init(rrColor)
    }
    
    /// Creates a color from HSB values using RRFoundation utilities
    /// - Parameters:
    ///   - h: Hue component (0.0-1.0)
    ///   - s: Saturation component (0.0-1.0)
    ///   - b: Brightness component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    /// - Returns: A color object
    init(h: Double, s: Double, b: Double, a: Double = 1.0) {
        let rrColor = RRColor(h: CGFloat(h), s: CGFloat(s), b: CGFloat(b), a: CGFloat(a))
        self.init(rrColor)
    }
    
    /// Returns the hex string representation of the color using RRFoundation utilities
    var hexString: String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        return uiColor.hexString
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        // Convert to RGB color space first to avoid catalog color issues
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return "#000000" }
        return rgbColor.hexString
        #else
        return "#000000"
        #endif
    }
    
    /// Returns the hex string representation of the color with alpha using RRFoundation utilities
    var hexStringWithAlpha: String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        return uiColor.hexStringWithAlpha
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        // Convert to RGB color space first to avoid catalog color issues
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return "#00000000" }
        return rgbColor.hexStringWithAlpha
        #else
        return "#00000000"
        #endif
    }
    
    /// Returns true if the color is dark using RRFoundation utilities
    var isDark: Bool {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        return uiColor.isDark
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        // Convert to RGB color space first to avoid catalog color issues
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return false }
        return rgbColor.isDark
        #else
        return false
        #endif
    }
    
    /// Returns true if the color is light using RRFoundation utilities
    var isLight: Bool {
        return !isDark
    }
    
    /// Returns the appropriate text color (black or white) for this background color using RRFoundation utilities
    var textColor: Color {
        return isDark ? .white : .black
    }
    
    /// Returns a color with the specified alpha value
    /// - Parameter alpha: The new alpha value (0.0-1.0)
    /// - Returns: A new color with the specified alpha
    func withAlpha(_ alpha: Double) -> Color {
        return self.opacity(alpha)
    }
    
    /// Returns a lighter version of the color using RRFoundation utilities
    /// - Parameter amount: The amount to lighten (0.0-1.0)
    /// - Returns: A lighter color
    func lighter(by amount: CGFloat = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        let lighterColor = uiColor.lighter(by: amount)
        return Color(lighterColor)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return self }
        let lighterColor = rgbColor.lighter(by: amount)
        return Color(lighterColor)
        #else
        return self
        #endif
    }
    
    /// Returns a darker version of the color using RRFoundation utilities
    /// - Parameter amount: The amount to darken (0.0-1.0)
    /// - Returns: A darker color
    func darker(by amount: CGFloat = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        let darkerColor = uiColor.darker(by: amount)
        return Color(darkerColor)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return self }
        let darkerColor = rgbColor.darker(by: amount)
        return Color(darkerColor)
        #else
        return self
        #endif
    }
    
    /// Returns a more saturated version of the color using RRFoundation utilities
    /// - Parameter amount: The amount to saturate (0.0-1.0)
    /// - Returns: A more saturated color
    func moreSaturated(by amount: CGFloat = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        let saturatedColor = uiColor.moreSaturated(by: amount)
        return Color(saturatedColor)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return self }
        let saturatedColor = rgbColor.moreSaturated(by: amount)
        return Color(saturatedColor)
        #else
        return self
        #endif
    }
    
    /// Returns a less saturated version of the color using RRFoundation utilities
    /// - Parameter amount: The amount to desaturate (0.0-1.0)
    /// - Returns: A less saturated color
    func lessSaturated(by amount: CGFloat = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        let desaturatedColor = uiColor.lessSaturated(by: amount)
        return Color(desaturatedColor)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return self }
        let desaturatedColor = rgbColor.lessSaturated(by: amount)
        return Color(desaturatedColor)
        #else
        return self
        #endif
    }
    
    /// Returns the complementary color using RRFoundation utilities
    var complementary: Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        let complementaryColor = uiColor.complementary
        return Color(complementaryColor)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else { return self }
        let complementaryColor = rgbColor.complementary
        return Color(complementaryColor)
        #else
        return self
        #endif
    }
    
    /// Blends this color with another color using RRFoundation utilities
    /// - Parameters:
    ///   - other: The other color to blend with
    ///   - ratio: The blending ratio (0.0 = this color, 1.0 = other color)
    /// - Returns: A blended color
    func blended(with other: Color, ratio: CGFloat) -> Color {
        #if canImport(UIKit)
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(other)
        let blendedColor = uiColor1.blended(with: uiColor2, ratio: ratio)
        return Color(blendedColor)
        #elseif canImport(AppKit)
        let nsColor1 = NSColor(self)
        let nsColor2 = NSColor(other)
        guard let rgbColor1 = nsColor1.usingColorSpace(.sRGB),
              let rgbColor2 = nsColor2.usingColorSpace(.sRGB) else { return self }
        let blendedColor = rgbColor1.blended(with: rgbColor2, ratio: ratio)
        return Color(blendedColor)
        #else
        return self
        #endif
    }
}