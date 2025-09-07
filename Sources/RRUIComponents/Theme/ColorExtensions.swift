// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Color Extensions

#if canImport(UIKit)
public typealias RRColor = UIColor
#elseif canImport(AppKit)
public typealias RRColor = NSColor
#endif

public extension RRColor {
    
    /// Creates a color from a hex string
    /// - Parameter hex: The hex string (e.g., "#FF0000", "FF0000", "#FF0000FF")
    /// - Returns: A color object if the hex string is valid, nil otherwise
    convenience init?(hex: String) {
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
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    /// Creates a color from RGB values
    /// - Parameters:
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    ///   - a: Alpha component (0-255, defaults to 255)
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    /// Creates a color from RGB values as floats
    /// - Parameters:
    ///   - r: Red component (0.0-1.0)
    ///   - g: Green component (0.0-1.0)
    ///   - b: Blue component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Creates a color from HSB values
    /// - Parameters:
    ///   - h: Hue component (0.0-1.0)
    ///   - s: Saturation component (0.0-1.0)
    ///   - b: Brightness component (0.0-1.0)
    ///   - a: Alpha component (0.0-1.0, defaults to 1.0)
    convenience init(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /// Returns the hex string representation of the color
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
    
    /// Returns the hex string representation of the color with alpha
    var hexStringWithAlpha: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgba = Int(a * 255) << 24 | Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
        
        return String(format: "#%08x", rgba)
    }
    
    /// Returns the RGB components of the color
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (red: r, green: g, blue: b, alpha: a)
    }
    
    /// Returns the HSB components of the color
    var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /// Returns a color with the specified alpha value
    /// - Parameter alpha: The new alpha value (0.0-1.0)
    /// - Returns: A new color with the specified alpha
    func withAlpha(_ alpha: CGFloat) -> RRColor {
        return withAlphaComponent(alpha)
    }
    
    /// Returns a color with the specified brightness
    /// - Parameter brightness: The new brightness value (0.0-1.0)
    /// - Returns: A new color with the specified brightness
    func withBrightness(_ brightness: CGFloat) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return RRColor(h: h, s: s, b: brightness, a: a)
    }
    
    /// Returns a color with the specified saturation
    /// - Parameter saturation: The new saturation value (0.0-1.0)
    /// - Returns: A new color with the specified saturation
    func withSaturation(_ saturation: CGFloat) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return RRColor(h: h, s: saturation, b: b, a: a)
    }
    
    /// Returns a color with the specified hue
    /// - Parameter hue: The new hue value (0.0-1.0)
    /// - Returns: A new color with the specified hue
    func withHue(_ hue: CGFloat) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return RRColor(h: hue, s: s, b: b, a: a)
    }
    
    /// Returns a lighter version of the color
    /// - Parameter amount: The amount to lighten (0.0-1.0)
    /// - Returns: A lighter color
    func lighter(by amount: CGFloat = 0.2) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newBrightness = min(1.0, b + amount)
        return RRColor(h: h, s: s, b: newBrightness, a: a)
    }
    
    /// Returns a darker version of the color
    /// - Parameter amount: The amount to darken (0.0-1.0)
    /// - Returns: A darker color
    func darker(by amount: CGFloat = 0.2) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newBrightness = max(0.0, b - amount)
        return RRColor(h: h, s: s, b: newBrightness, a: a)
    }
    
    /// Returns a more saturated version of the color
    /// - Parameter amount: The amount to saturate (0.0-1.0)
    /// - Returns: A more saturated color
    func moreSaturated(by amount: CGFloat = 0.2) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newSaturation = min(1.0, s + amount)
        return RRColor(h: h, s: newSaturation, b: b, a: a)
    }
    
    /// Returns a less saturated version of the color
    /// - Parameter amount: The amount to desaturate (0.0-1.0)
    /// - Returns: A less saturated color
    func lessSaturated(by amount: CGFloat = 0.2) -> RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newSaturation = max(0.0, s - amount)
        return RRColor(h: h, s: newSaturation, b: b, a: a)
    }
    
    /// Returns the complementary color
    var complementary: RRColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let newHue = (h + 0.5).truncatingRemainder(dividingBy: 1.0)
        return RRColor(h: newHue, s: s, b: b, a: a)
    }
    
    /// Returns true if the color is dark (useful for determining text color)
    var isDark: Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness < 0.5
    }
    
    /// Returns true if the color is light (useful for determining text color)
    var isLight: Bool {
        return !isDark
    }
    
    /// Returns the appropriate text color (black or white) for this background color
    var textColor: RRColor {
        return isDark ? .white : .black
    }
    
    /// Blends this color with another color
    /// - Parameters:
    ///   - other: The other color to blend with
    ///   - ratio: The blending ratio (0.0 = this color, 1.0 = other color)
    /// - Returns: A blended color
    func blended(with other: RRColor, ratio: CGFloat) -> RRColor {
        let thisComponents = rgbComponents
        let otherComponents = other.rgbComponents
        
        let newRed = thisComponents.red * (1 - ratio) + otherComponents.red * ratio
        let newGreen = thisComponents.green * (1 - ratio) + otherComponents.green * ratio
        let newBlue = thisComponents.blue * (1 - ratio) + otherComponents.blue * ratio
        let newAlpha = thisComponents.alpha * (1 - ratio) + otherComponents.alpha * ratio
        
        return RRColor(r: newRed, g: newGreen, b: newBlue, a: newAlpha)
    }
}

// MARK: - Color Presets

public extension RRColor {
    
    // System colors are available directly from RRColor (UIColor/NSColor)
    // No need to redefine them here to avoid circular references
    
    /// Semantic colors
    static let success = RRColor.systemGreen
    static let warning = RRColor.systemYellow
    static let error = RRColor.systemRed
    static let info = RRColor.systemBlue
    
    /// Common color palette
    static let primary = RRColor.systemBlue
    static let secondary = RRColor.systemGray
    static let accent = RRColor.systemOrange
    static let highlight = RRColor.systemYellow
}

// MARK: - Color Utilities

public extension RRColor {
    
    /// Creates a color from a CSS color name
    /// - Parameter name: The CSS color name
    /// - Returns: A color object if the name is valid, nil otherwise
    static func fromCSSName(_ name: String) -> RRColor? {
        let colorNames: [String: RRColor] = [
            "aliceblue": RRColor(r: 240, g: 248, b: 255),
            "antiquewhite": RRColor(r: 250, g: 235, b: 215),
            "aqua": RRColor(r: 0, g: 255, b: 255),
            "aquamarine": RRColor(r: 127, g: 255, b: 212),
            "azure": RRColor(r: 240, g: 255, b: 255),
            "beige": RRColor(r: 245, g: 245, b: 220),
            "bisque": RRColor(r: 255, g: 228, b: 196),
            "black": RRColor(r: 0, g: 0, b: 0),
            "blanchedalmond": RRColor(r: 255, g: 235, b: 205),
            "blue": RRColor(r: 0, g: 0, b: 255),
            "blueviolet": RRColor(r: 138, g: 43, b: 226),
            "brown": RRColor(r: 165, g: 42, b: 42),
            "burlywood": RRColor(r: 222, g: 184, b: 135),
            "cadetblue": RRColor(r: 95, g: 158, b: 160),
            "chartreuse": RRColor(r: 127, g: 255, b: 0),
            "chocolate": RRColor(r: 210, g: 105, b: 30),
            "coral": RRColor(r: 255, g: 127, b: 80),
            "cornflowerblue": RRColor(r: 100, g: 149, b: 237),
            "cornsilk": RRColor(r: 255, g: 248, b: 220),
            "crimson": RRColor(r: 220, g: 20, b: 60),
            "cyan": RRColor(r: 0, g: 255, b: 255),
            "darkblue": RRColor(r: 0, g: 0, b: 139),
            "darkcyan": RRColor(r: 0, g: 139, b: 139),
            "darkgoldenrod": RRColor(r: 184, g: 134, b: 11),
            "darkgray": RRColor(r: 169, g: 169, b: 169),
            "darkgreen": RRColor(r: 0, g: 100, b: 0),
            "darkkhaki": RRColor(r: 189, g: 183, b: 107),
            "darkmagenta": RRColor(r: 139, g: 0, b: 139),
            "darkolivegreen": RRColor(r: 85, g: 107, b: 47),
            "darkorange": RRColor(r: 255, g: 140, b: 0),
            "darkorchid": RRColor(r: 153, g: 50, b: 204),
            "darkred": RRColor(r: 139, g: 0, b: 0),
            "darksalmon": RRColor(r: 233, g: 150, b: 122),
            "darkseagreen": RRColor(r: 143, g: 188, b: 143),
            "darkslateblue": RRColor(r: 72, g: 61, b: 139),
            "darkslategray": RRColor(r: 47, g: 79, b: 79),
            "darkturquoise": RRColor(r: 0, g: 206, b: 209),
            "darkviolet": RRColor(r: 148, g: 0, b: 211),
            "deeppink": RRColor(r: 255, g: 20, b: 147),
            "deepskyblue": RRColor(r: 0, g: 191, b: 255),
            "dimgray": RRColor(r: 105, g: 105, b: 105),
            "dodgerblue": RRColor(r: 30, g: 144, b: 255),
            "firebrick": RRColor(r: 178, g: 34, b: 34),
            "floralwhite": RRColor(r: 255, g: 250, b: 240),
            "forestgreen": RRColor(r: 34, g: 139, b: 34),
            "fuchsia": RRColor(r: 255, g: 0, b: 255),
            "gainsboro": RRColor(r: 220, g: 220, b: 220),
            "ghostwhite": RRColor(r: 248, g: 248, b: 255),
            "gold": RRColor(r: 255, g: 215, b: 0),
            "goldenrod": RRColor(r: 218, g: 165, b: 32),
            "gray": RRColor(r: 128, g: 128, b: 128),
            "green": RRColor(r: 0, g: 128, b: 0),
            "greenyellow": RRColor(r: 173, g: 255, b: 47),
            "honeydew": RRColor(r: 240, g: 255, b: 240),
            "hotpink": RRColor(r: 255, g: 105, b: 180),
            "indianred": RRColor(r: 205, g: 92, b: 92),
            "indigo": RRColor(r: 75, g: 0, b: 130),
            "ivory": RRColor(r: 255, g: 255, b: 240),
            "khaki": RRColor(r: 240, g: 230, b: 140),
            "lavender": RRColor(r: 230, g: 230, b: 250),
            "lavenderblush": RRColor(r: 255, g: 240, b: 245),
            "lawngreen": RRColor(r: 124, g: 252, b: 0),
            "lemonchiffon": RRColor(r: 255, g: 250, b: 205),
            "lightblue": RRColor(r: 173, g: 216, b: 230),
            "lightcoral": RRColor(r: 240, g: 128, b: 128),
            "lightcyan": RRColor(r: 224, g: 255, b: 255),
            "lightgoldenrodyellow": RRColor(r: 250, g: 250, b: 210),
            "lightgreen": RRColor(r: 144, g: 238, b: 144),
            "lightgrey": RRColor(r: 211, g: 211, b: 211),
            "lightpink": RRColor(r: 255, g: 182, b: 193),
            "lightsalmon": RRColor(r: 255, g: 160, b: 122),
            "lightseagreen": RRColor(r: 32, g: 178, b: 170),
            "lightskyblue": RRColor(r: 135, g: 206, b: 250),
            "lightslategray": RRColor(r: 119, g: 136, b: 153),
            "lightsteelblue": RRColor(r: 176, g: 196, b: 222),
            "lightyellow": RRColor(r: 255, g: 255, b: 224),
            "lime": RRColor(r: 0, g: 255, b: 0),
            "limegreen": RRColor(r: 50, g: 205, b: 50),
            "linen": RRColor(r: 250, g: 240, b: 230),
            "magenta": RRColor(r: 255, g: 0, b: 255),
            "maroon": RRColor(r: 128, g: 0, b: 0),
            "mediumaquamarine": RRColor(r: 102, g: 205, b: 170),
            "mediumblue": RRColor(r: 0, g: 0, b: 205),
            "mediumorchid": RRColor(r: 186, g: 85, b: 211),
            "mediumpurple": RRColor(r: 147, g: 112, b: 219),
            "mediumseagreen": RRColor(r: 60, g: 179, b: 113),
            "mediumslateblue": RRColor(r: 123, g: 104, b: 238),
            "mediumspringgreen": RRColor(r: 0, g: 250, b: 154),
            "mediumturquoise": RRColor(r: 72, g: 209, b: 204),
            "mediumvioletred": RRColor(r: 199, g: 21, b: 133),
            "midnightblue": RRColor(r: 25, g: 25, b: 112),
            "mintcream": RRColor(r: 245, g: 255, b: 250),
            "mistyrose": RRColor(r: 255, g: 228, b: 225),
            "moccasin": RRColor(r: 255, g: 228, b: 181),
            "navajowhite": RRColor(r: 255, g: 222, b: 173),
            "navy": RRColor(r: 0, g: 0, b: 128),
            "oldlace": RRColor(r: 253, g: 245, b: 230),
            "olive": RRColor(r: 128, g: 128, b: 0),
            "olivedrab": RRColor(r: 107, g: 142, b: 35),
            "orange": RRColor(r: 255, g: 165, b: 0),
            "orangered": RRColor(r: 255, g: 69, b: 0),
            "orchid": RRColor(r: 218, g: 112, b: 214),
            "palegoldenrod": RRColor(r: 238, g: 232, b: 170),
            "palegreen": RRColor(r: 152, g: 251, b: 152),
            "paleturquoise": RRColor(r: 175, g: 238, b: 238),
            "palevioletred": RRColor(r: 219, g: 112, b: 147),
            "papayawhip": RRColor(r: 255, g: 239, b: 213),
            "peachpuff": RRColor(r: 255, g: 218, b: 185),
            "peru": RRColor(r: 205, g: 133, b: 63),
            "pink": RRColor(r: 255, g: 192, b: 203),
            "plum": RRColor(r: 221, g: 160, b: 221),
            "powderblue": RRColor(r: 176, g: 224, b: 230),
            "purple": RRColor(r: 128, g: 0, b: 128),
            "red": RRColor(r: 255, g: 0, b: 0),
            "rosybrown": RRColor(r: 188, g: 143, b: 143),
            "royalblue": RRColor(r: 65, g: 105, b: 225),
            "saddlebrown": RRColor(r: 139, g: 69, b: 19),
            "salmon": RRColor(r: 250, g: 128, b: 114),
            "sandybrown": RRColor(r: 244, g: 164, b: 96),
            "seagreen": RRColor(r: 46, g: 139, b: 87),
            "seashell": RRColor(r: 255, g: 245, b: 238),
            "sienna": RRColor(r: 160, g: 82, b: 45),
            "silver": RRColor(r: 192, g: 192, b: 192),
            "skyblue": RRColor(r: 135, g: 206, b: 235),
            "slateblue": RRColor(r: 106, g: 90, b: 205),
            "slategray": RRColor(r: 112, g: 128, b: 144),
            "snow": RRColor(r: 255, g: 250, b: 250),
            "springgreen": RRColor(r: 0, g: 255, b: 127),
            "steelblue": RRColor(r: 70, g: 130, b: 180),
            "tan": RRColor(r: 210, g: 180, b: 140),
            "teal": RRColor(r: 0, g: 128, b: 128),
            "thistle": RRColor(r: 216, g: 191, b: 216),
            "tomato": RRColor(r: 255, g: 99, b: 71),
            "turquoise": RRColor(r: 64, g: 224, b: 208),
            "violet": RRColor(r: 238, g: 130, b: 238),
            "wheat": RRColor(r: 245, g: 222, b: 179),
            "white": RRColor(r: 255, g: 255, b: 255),
            "whitesmoke": RRColor(r: 245, g: 245, b: 245),
            "yellow": RRColor(r: 255, g: 255, b: 0),
            "yellowgreen": RRColor(r: 154, g: 205, b: 50)
        ]
        
        return colorNames[name.lowercased()]
    }
}
