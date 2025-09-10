// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - SwiftUI.Color Extensions

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
    
    /// Creates a color from RGB values
    /// - Parameters:
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    ///   - a: Alpha component (0-255, defaults to 255)
    init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }
    
    /// Creates a color from RGB values as doubles
    /// - Parameters:
    ///   - r: Red component (0.0-1.0)
    ///   - g: Green component (0.0-1.0)
    ///   - b: Blue component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    /// Creates a color from HSB values
    /// - Parameters:
    ///   - h: Hue component (0.0-1.0)
    ///   - s: Saturation component (0.0-1.0)
    ///   - b: Brightness component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    init(h: Double, s: Double, b: Double, a: Double = 1.0) {
        self.init(hue: h, saturation: s, brightness: b, opacity: a)
    }
    
    /// Returns the hex string representation of the color
    var hexString: String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        
        return String(format: "#%06x", rgb)
        #else
        // Fallback for macOS
        return "#000000"
        #endif
    }
    
    /// Returns the hex string representation of the color with alpha
    var hexStringWithAlpha: String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgba = Int(a * 255) << 24 | Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        
        return String(format: "#%08x", rgba)
        #else
        // Fallback for macOS
        return "#00000000"
        #endif
    }
    
    /// Returns true if the color is dark (useful for determining text color)
    var isDark: Bool {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness < 0.5
        #else
        // Fallback for macOS
        return false
        #endif
    }
    
    /// Returns true if the color is light (useful for determining text color)
    var isLight: Bool {
        return !isDark
    }
    
    /// Returns the appropriate text color (black or white) for this background color
    var textColor: Color {
        return isDark ? .white : .black
    }
    
    /// Returns a color with the specified alpha value
    /// - Parameter alpha: The new alpha value (0.0-1.0)
    /// - Returns: A new color with the specified alpha
    func withAlpha(_ alpha: Double) -> Color {
        return self.opacity(alpha)
    }
    
    /// Returns a lighter version of the color
    /// - Parameter amount: The amount to lighten (0.0-1.0)
    /// - Returns: A lighter color
    func lighter(by amount: Double = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newBrightness = min(1.0, b + amount)
        return Color(h: Double(h), s: Double(s), b: Double(newBrightness), a: Double(a))
        #else
        return self
        #endif
    }
    
    /// Returns a darker version of the color
    /// - Parameter amount: The amount to darken (0.0-1.0)
    /// - Returns: A darker color
    func darker(by amount: Double = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newBrightness = max(0.0, b - amount)
        return Color(h: Double(h), s: Double(s), b: Double(newBrightness), a: Double(a))
        #else
        return self
        #endif
    }
    
    /// Returns a more saturated version of the color
    /// - Parameter amount: The amount to saturate (0.0-1.0)
    /// - Returns: A more saturated color
    func moreSaturated(by amount: Double = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newSaturation = min(1.0, s + amount)
        return Color(h: Double(h), s: Double(newSaturation), b: Double(b), a: Double(a))
        #else
        return self
        #endif
    }
    
    /// Returns a less saturated version of the color
    /// - Parameter amount: The amount to desaturate (0.0-1.0)
    /// - Returns: A less saturated color
    func lessSaturated(by amount: Double = 0.2) -> Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newSaturation = max(0.0, s - amount)
        return Color(h: Double(h), s: Double(newSaturation), b: Double(b), a: Double(a))
        #else
        return self
        #endif
    }
    
    /// Returns the complementary color
    var complementary: Color {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newHue = (h + 0.5).truncatingRemainder(dividingBy: 1.0)
        return Color(h: Double(newHue), s: Double(s), b: Double(b), a: Double(a))
        #else
        return self
        #endif
    }
    
    /// Blends this color with another color
    /// - Parameters:
    ///   - other: The other color to blend with
    ///   - ratio: The blending ratio (0.0 = this color, 1.0 = other color)
    /// - Returns: A blended color
    func blended(with other: Color, ratio: Double) -> Color {
        #if canImport(UIKit)
        let thisColor = UIColor(self)
        let otherColor = UIColor(other)
        
        var thisR: CGFloat = 0, thisG: CGFloat = 0, thisB: CGFloat = 0, thisA: CGFloat = 0
        var otherR: CGFloat = 0, otherG: CGFloat = 0, otherB: CGFloat = 0, otherA: CGFloat = 0
        
        thisColor.getRed(&thisR, green: &thisG, blue: &thisB, alpha: &thisA)
        otherColor.getRed(&otherR, green: &otherG, blue: &otherB, alpha: &otherA)
        
        let newRed = thisR * (1 - ratio) + otherR * ratio
        let newGreen = thisG * (1 - ratio) + otherG * ratio
        let newBlue = thisB * (1 - ratio) + otherB * ratio
        let newAlpha = thisA * (1 - ratio) + otherA * ratio
        
        return Color(red: newRed, green: newGreen, blue: newBlue, opacity: newAlpha)
        #else
        return self
        #endif
    }
}

// MARK: - Color Presets

public extension Color {
    
    /// Semantic colors - Use Color+DesignSystem.swift for design system colors
    // static let success = Color.green
    // static let warning = Color.yellow
    // static let error = Color.red
    // static let info = Color.blue
    
    /// Common color palette - Use Color+DesignSystem.swift for design system colors
    // static let primary = Color.blue
    // static let secondary = Color.gray
    // static let accent = Color.orange
    // static let highlight = Color.yellow
}

// MARK: - CSS Color Names

public extension Color {
    
    /// Creates a color from a CSS color name
    /// - Parameter name: The CSS color name
    /// - Returns: A color object if the name is valid, nil otherwise
    static func fromCSSName(_ name: String) -> Color? {
        let colorNames: [String: Color] = [
            "aliceblue": Color(r: 240, g: 248, b: 255),
            "antiquewhite": Color(r: 250, g: 235, b: 215),
            "aqua": Color(r: 0, g: 255, b: 255),
            "aquamarine": Color(r: 127, g: 255, b: 212),
            "azure": Color(r: 240, g: 255, b: 255),
            "beige": Color(r: 245, g: 245, b: 220),
            "bisque": Color(r: 255, g: 228, b: 196),
            "black": Color(r: 0, g: 0, b: 0),
            "blanchedalmond": Color(r: 255, g: 235, b: 205),
            "blue": Color(r: 0, g: 0, b: 255),
            "blueviolet": Color(r: 138, g: 43, b: 226),
            "brown": Color(r: 165, g: 42, b: 42),
            "burlywood": Color(r: 222, g: 184, b: 135),
            "cadetblue": Color(r: 95, g: 158, b: 160),
            "chartreuse": Color(r: 127, g: 255, b: 0),
            "chocolate": Color(r: 210, g: 105, b: 30),
            "coral": Color(r: 255, g: 127, b: 80),
            "cornflowerblue": Color(r: 100, g: 149, b: 237),
            "cornsilk": Color(r: 255, g: 248, b: 220),
            "crimson": Color(r: 220, g: 20, b: 60),
            "cyan": Color(r: 0, g: 255, b: 255),
            "darkblue": Color(r: 0, g: 0, b: 139),
            "darkcyan": Color(r: 0, g: 139, b: 139),
            "darkgoldenrod": Color(r: 184, g: 134, b: 11),
            "darkgray": Color(r: 169, g: 169, b: 169),
            "darkgreen": Color(r: 0, g: 100, b: 0),
            "darkkhaki": Color(r: 189, g: 183, b: 107),
            "darkmagenta": Color(r: 139, g: 0, b: 139),
            "darkolivegreen": Color(r: 85, g: 107, b: 47),
            "darkorange": Color(r: 255, g: 140, b: 0),
            "darkorchid": Color(r: 153, g: 50, b: 204),
            "darkred": Color(r: 139, g: 0, b: 0),
            "darksalmon": Color(r: 233, g: 150, b: 122),
            "darkseagreen": Color(r: 143, g: 188, b: 143),
            "darkslateblue": Color(r: 72, g: 61, b: 139),
            "darkslategray": Color(r: 47, g: 79, b: 79),
            "darkturquoise": Color(r: 0, g: 206, b: 209),
            "darkviolet": Color(r: 148, g: 0, b: 211),
            "deeppink": Color(r: 255, g: 20, b: 147),
            "deepskyblue": Color(r: 0, g: 191, b: 255),
            "dimgray": Color(r: 105, g: 105, b: 105),
            "dodgerblue": Color(r: 30, g: 144, b: 255),
            "firebrick": Color(r: 178, g: 34, b: 34),
            "floralwhite": Color(r: 255, g: 250, b: 240),
            "forestgreen": Color(r: 34, g: 139, b: 34),
            "fuchsia": Color(r: 255, g: 0, b: 255),
            "gainsboro": Color(r: 220, g: 220, b: 220),
            "ghostwhite": Color(r: 248, g: 248, b: 255),
            "gold": Color(r: 255, g: 215, b: 0),
            "goldenrod": Color(r: 218, g: 165, b: 32),
            "gray": Color(r: 128, g: 128, b: 128),
            "green": Color(r: 0, g: 128, b: 0),
            "greenyellow": Color(r: 173, g: 255, b: 47),
            "honeydew": Color(r: 240, g: 255, b: 240),
            "hotpink": Color(r: 255, g: 105, b: 180),
            "indianred": Color(r: 205, g: 92, b: 92),
            "indigo": Color(r: 75, g: 0, b: 130),
            "ivory": Color(r: 255, g: 255, b: 240),
            "khaki": Color(r: 240, g: 230, b: 140),
            "lavender": Color(r: 230, g: 230, b: 250),
            "lavenderblush": Color(r: 255, g: 240, b: 245),
            "lawngreen": Color(r: 124, g: 252, b: 0),
            "lemonchiffon": Color(r: 255, g: 250, b: 205),
            "lightblue": Color(r: 173, g: 216, b: 230),
            "lightcoral": Color(r: 240, g: 128, b: 128),
            "lightcyan": Color(r: 224, g: 255, b: 255),
            "lightgoldenrodyellow": Color(r: 250, g: 250, b: 210),
            "lightgreen": Color(r: 144, g: 238, b: 144),
            "lightgrey": Color(r: 211, g: 211, b: 211),
            "lightpink": Color(r: 255, g: 182, b: 193),
            "lightsalmon": Color(r: 255, g: 160, b: 122),
            "lightseagreen": Color(r: 32, g: 178, b: 170),
            "lightskyblue": Color(r: 135, g: 206, b: 250),
            "lightslategray": Color(r: 119, g: 136, b: 153),
            "lightsteelblue": Color(r: 176, g: 196, b: 222),
            "lightyellow": Color(r: 255, g: 255, b: 224),
            "lime": Color(r: 0, g: 255, b: 0),
            "limegreen": Color(r: 50, g: 205, b: 50),
            "linen": Color(r: 250, g: 240, b: 230),
            "magenta": Color(r: 255, g: 0, b: 255),
            "maroon": Color(r: 128, g: 0, b: 0),
            "mediumaquamarine": Color(r: 102, g: 205, b: 170),
            "mediumblue": Color(r: 0, g: 0, b: 205),
            "mediumorchid": Color(r: 186, g: 85, b: 211),
            "mediumpurple": Color(r: 147, g: 112, b: 219),
            "mediumseagreen": Color(r: 60, g: 179, b: 113),
            "mediumslateblue": Color(r: 123, g: 104, b: 238),
            "mediumspringgreen": Color(r: 0, g: 250, b: 154),
            "mediumturquoise": Color(r: 72, g: 209, b: 204),
            "mediumvioletred": Color(r: 199, g: 21, b: 133),
            "midnightblue": Color(r: 25, g: 25, b: 112),
            "mintcream": Color(r: 245, g: 255, b: 250),
            "mistyrose": Color(r: 255, g: 228, b: 225),
            "moccasin": Color(r: 255, g: 228, b: 181),
            "navajowhite": Color(r: 255, g: 222, b: 173),
            "navy": Color(r: 0, g: 0, b: 128),
            "oldlace": Color(r: 253, g: 245, b: 230),
            "olive": Color(r: 128, g: 128, b: 0),
            "olivedrab": Color(r: 107, g: 142, b: 35),
            "orange": Color(r: 255, g: 165, b: 0),
            "orangered": Color(r: 255, g: 69, b: 0),
            "orchid": Color(r: 218, g: 112, b: 214),
            "palegoldenrod": Color(r: 238, g: 232, b: 170),
            "palegreen": Color(r: 152, g: 251, b: 152),
            "paleturquoise": Color(r: 175, g: 238, b: 238),
            "palevioletred": Color(r: 219, g: 112, b: 147),
            "papayawhip": Color(r: 255, g: 239, b: 213),
            "peachpuff": Color(r: 255, g: 218, b: 185),
            "peru": Color(r: 205, g: 133, b: 63),
            "pink": Color(r: 255, g: 192, b: 203),
            "plum": Color(r: 221, g: 160, b: 221),
            "powderblue": Color(r: 176, g: 224, b: 230),
            "purple": Color(r: 128, g: 0, b: 128),
            "red": Color(r: 255, g: 0, b: 0),
            "rosybrown": Color(r: 188, g: 143, b: 143),
            "royalblue": Color(r: 65, g: 105, b: 225),
            "saddlebrown": Color(r: 139, g: 69, b: 19),
            "salmon": Color(r: 250, g: 128, b: 114),
            "sandybrown": Color(r: 244, g: 164, b: 96),
            "seagreen": Color(r: 46, g: 139, b: 87),
            "seashell": Color(r: 255, g: 245, b: 238),
            "sienna": Color(r: 160, g: 82, b: 45),
            "silver": Color(r: 192, g: 192, b: 192),
            "skyblue": Color(r: 135, g: 206, b: 235),
            "slateblue": Color(r: 106, g: 90, b: 205),
            "slategray": Color(r: 112, g: 128, b: 144),
            "snow": Color(r: 255, g: 250, b: 250),
            "springgreen": Color(r: 0, g: 255, b: 127),
            "steelblue": Color(r: 70, g: 130, b: 180),
            "tan": Color(r: 210, g: 180, b: 140),
            "teal": Color(r: 0, g: 128, b: 128),
            "thistle": Color(r: 216, g: 191, b: 216),
            "tomato": Color(r: 255, g: 99, b: 71),
            "turquoise": Color(r: 64, g: 224, b: 208),
            "violet": Color(r: 238, g: 130, b: 238),
            "wheat": Color(r: 245, g: 222, b: 179),
            "white": Color(r: 255, g: 255, b: 255),
            "whitesmoke": Color(r: 245, g: 245, b: 245),
            "yellow": Color(r: 255, g: 255, b: 0),
            "yellowgreen": Color(r: 154, g: 205, b: 50)
        ]
        
        return colorNames[name.lowercased()]
    }
}
