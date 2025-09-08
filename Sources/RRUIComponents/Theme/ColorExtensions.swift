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

// MARK: - CSS Color Names

/// Enum representing standard CSS color names with their RGB values
public enum CSSColorName: String, CaseIterable {
    case aliceblue = "aliceblue"
    case antiquewhite = "antiquewhite"
    case aqua = "aqua"
    case aquamarine = "aquamarine"
    case azure = "azure"
    case beige = "beige"
    case bisque = "bisque"
    case black = "black"
    case blanchedalmond = "blanchedalmond"
    case blue = "blue"
    case blueviolet = "blueviolet"
    case brown = "brown"
    case burlywood = "burlywood"
    case cadetblue = "cadetblue"
    case chartreuse = "chartreuse"
    case chocolate = "chocolate"
    case coral = "coral"
    case cornflowerblue = "cornflowerblue"
    case cornsilk = "cornsilk"
    case crimson = "crimson"
    case cyan = "cyan"
    case darkblue = "darkblue"
    case darkcyan = "darkcyan"
    case darkgoldenrod = "darkgoldenrod"
    case darkgray = "darkgray"
    case darkgreen = "darkgreen"
    case darkkhaki = "darkkhaki"
    case darkmagenta = "darkmagenta"
    case darkolivegreen = "darkolivegreen"
    case darkorange = "darkorange"
    case darkorchid = "darkorchid"
    case darkred = "darkred"
    case darksalmon = "darksalmon"
    case darkseagreen = "darkseagreen"
    case darkslateblue = "darkslateblue"
    case darkslategray = "darkslategray"
    case darkturquoise = "darkturquoise"
    case darkviolet = "darkviolet"
    case deeppink = "deeppink"
    case deepskyblue = "deepskyblue"
    case dimgray = "dimgray"
    case dodgerblue = "dodgerblue"
    case firebrick = "firebrick"
    case floralwhite = "floralwhite"
    case forestgreen = "forestgreen"
    case fuchsia = "fuchsia"
    case gainsboro = "gainsboro"
    case ghostwhite = "ghostwhite"
    case gold = "gold"
    case goldenrod = "goldenrod"
    case gray = "gray"
    case green = "green"
    case greenyellow = "greenyellow"
    case honeydew = "honeydew"
    case hotpink = "hotpink"
    case indianred = "indianred"
    case indigo = "indigo"
    case ivory = "ivory"
    case khaki = "khaki"
    case lavender = "lavender"
    case lavenderblush = "lavenderblush"
    case lawngreen = "lawngreen"
    case lemonchiffon = "lemonchiffon"
    case lightblue = "lightblue"
    case lightcoral = "lightcoral"
    case lightcyan = "lightcyan"
    case lightgoldenrodyellow = "lightgoldenrodyellow"
    case lightgreen = "lightgreen"
    case lightgrey = "lightgrey"
    case lightpink = "lightpink"
    case lightsalmon = "lightsalmon"
    case lightseagreen = "lightseagreen"
    case lightskyblue = "lightskyblue"
    case lightslategray = "lightslategray"
    case lightsteelblue = "lightsteelblue"
    case lightyellow = "lightyellow"
    case lime = "lime"
    case limegreen = "limegreen"
    case linen = "linen"
    case magenta = "magenta"
    case maroon = "maroon"
    case mediumaquamarine = "mediumaquamarine"
    case mediumblue = "mediumblue"
    case mediumorchid = "mediumorchid"
    case mediumpurple = "mediumpurple"
    case mediumseagreen = "mediumseagreen"
    case mediumslateblue = "mediumslateblue"
    case mediumspringgreen = "mediumspringgreen"
    case mediumturquoise = "mediumturquoise"
    case mediumvioletred = "mediumvioletred"
    case midnightblue = "midnightblue"
    case mintcream = "mintcream"
    case mistyrose = "mistyrose"
    case moccasin = "moccasin"
    case navajowhite = "navajowhite"
    case navy = "navy"
    case oldlace = "oldlace"
    case olive = "olive"
    case olivedrab = "olivedrab"
    case orange = "orange"
    case orangered = "orangered"
    case orchid = "orchid"
    case palegoldenrod = "palegoldenrod"
    case palegreen = "palegreen"
    case paleturquoise = "paleturquoise"
    case palevioletred = "palevioletred"
    case papayawhip = "papayawhip"
    case peachpuff = "peachpuff"
    case peru = "peru"
    case pink = "pink"
    case plum = "plum"
    case powderblue = "powderblue"
    case purple = "purple"
    case red = "red"
    case rosybrown = "rosybrown"
    case royalblue = "royalblue"
    case saddlebrown = "saddlebrown"
    case salmon = "salmon"
    case sandybrown = "sandybrown"
    case seagreen = "seagreen"
    case seashell = "seashell"
    case sienna = "sienna"
    case silver = "silver"
    case skyblue = "skyblue"
    case slateblue = "slateblue"
    case slategray = "slategray"
    case snow = "snow"
    case springgreen = "springgreen"
    case steelblue = "steelblue"
    case tan = "tan"
    case teal = "teal"
    case thistle = "thistle"
    case tomato = "tomato"
    case turquoise = "turquoise"
    case violet = "violet"
    case wheat = "wheat"
    case white = "white"
    case whitesmoke = "whitesmoke"
    case yellow = "yellow"
    case yellowgreen = "yellowgreen"
    
    /// Returns the RRColor for this CSS color name
    public var color: RRColor {
        switch self {
        case .aliceblue: return RRColor(r: 240, g: 248, b: 255)
        case .antiquewhite: return RRColor(r: 250, g: 235, b: 215)
        case .aqua: return RRColor(r: 0, g: 255, b: 255)
        case .aquamarine: return RRColor(r: 127, g: 255, b: 212)
        case .azure: return RRColor(r: 240, g: 255, b: 255)
        case .beige: return RRColor(r: 245, g: 245, b: 220)
        case .bisque: return RRColor(r: 255, g: 228, b: 196)
        case .black: return RRColor(r: 0, g: 0, b: 0)
        case .blanchedalmond: return RRColor(r: 255, g: 235, b: 205)
        case .blue: return RRColor(r: 0, g: 0, b: 255)
        case .blueviolet: return RRColor(r: 138, g: 43, b: 226)
        case .brown: return RRColor(r: 165, g: 42, b: 42)
        case .burlywood: return RRColor(r: 222, g: 184, b: 135)
        case .cadetblue: return RRColor(r: 95, g: 158, b: 160)
        case .chartreuse: return RRColor(r: 127, g: 255, b: 0)
        case .chocolate: return RRColor(r: 210, g: 105, b: 30)
        case .coral: return RRColor(r: 255, g: 127, b: 80)
        case .cornflowerblue: return RRColor(r: 100, g: 149, b: 237)
        case .cornsilk: return RRColor(r: 255, g: 248, b: 220)
        case .crimson: return RRColor(r: 220, g: 20, b: 60)
        case .cyan: return RRColor(r: 0, g: 255, b: 255)
        case .darkblue: return RRColor(r: 0, g: 0, b: 139)
        case .darkcyan: return RRColor(r: 0, g: 139, b: 139)
        case .darkgoldenrod: return RRColor(r: 184, g: 134, b: 11)
        case .darkgray: return RRColor(r: 169, g: 169, b: 169)
        case .darkgreen: return RRColor(r: 0, g: 100, b: 0)
        case .darkkhaki: return RRColor(r: 189, g: 183, b: 107)
        case .darkmagenta: return RRColor(r: 139, g: 0, b: 139)
        case .darkolivegreen: return RRColor(r: 85, g: 107, b: 47)
        case .darkorange: return RRColor(r: 255, g: 140, b: 0)
        case .darkorchid: return RRColor(r: 153, g: 50, b: 204)
        case .darkred: return RRColor(r: 139, g: 0, b: 0)
        case .darksalmon: return RRColor(r: 233, g: 150, b: 122)
        case .darkseagreen: return RRColor(r: 143, g: 188, b: 143)
        case .darkslateblue: return RRColor(r: 72, g: 61, b: 139)
        case .darkslategray: return RRColor(r: 47, g: 79, b: 79)
        case .darkturquoise: return RRColor(r: 0, g: 206, b: 209)
        case .darkviolet: return RRColor(r: 148, g: 0, b: 211)
        case .deeppink: return RRColor(r: 255, g: 20, b: 147)
        case .deepskyblue: return RRColor(r: 0, g: 191, b: 255)
        case .dimgray: return RRColor(r: 105, g: 105, b: 105)
        case .dodgerblue: return RRColor(r: 30, g: 144, b: 255)
        case .firebrick: return RRColor(r: 178, g: 34, b: 34)
        case .floralwhite: return RRColor(r: 255, g: 250, b: 240)
        case .forestgreen: return RRColor(r: 34, g: 139, b: 34)
        case .fuchsia: return RRColor(r: 255, g: 0, b: 255)
        case .gainsboro: return RRColor(r: 220, g: 220, b: 220)
        case .ghostwhite: return RRColor(r: 248, g: 248, b: 255)
        case .gold: return RRColor(r: 255, g: 215, b: 0)
        case .goldenrod: return RRColor(r: 218, g: 165, b: 32)
        case .gray: return RRColor(r: 128, g: 128, b: 128)
        case .green: return RRColor(r: 0, g: 128, b: 0)
        case .greenyellow: return RRColor(r: 173, g: 255, b: 47)
        case .honeydew: return RRColor(r: 240, g: 255, b: 240)
        case .hotpink: return RRColor(r: 255, g: 105, b: 180)
        case .indianred: return RRColor(r: 205, g: 92, b: 92)
        case .indigo: return RRColor(r: 75, g: 0, b: 130)
        case .ivory: return RRColor(r: 255, g: 255, b: 240)
        case .khaki: return RRColor(r: 240, g: 230, b: 140)
        case .lavender: return RRColor(r: 230, g: 230, b: 250)
        case .lavenderblush: return RRColor(r: 255, g: 240, b: 245)
        case .lawngreen: return RRColor(r: 124, g: 252, b: 0)
        case .lemonchiffon: return RRColor(r: 255, g: 250, b: 205)
        case .lightblue: return RRColor(r: 173, g: 216, b: 230)
        case .lightcoral: return RRColor(r: 240, g: 128, b: 128)
        case .lightcyan: return RRColor(r: 224, g: 255, b: 255)
        case .lightgoldenrodyellow: return RRColor(r: 250, g: 250, b: 210)
        case .lightgreen: return RRColor(r: 144, g: 238, b: 144)
        case .lightgrey: return RRColor(r: 211, g: 211, b: 211)
        case .lightpink: return RRColor(r: 255, g: 182, b: 193)
        case .lightsalmon: return RRColor(r: 255, g: 160, b: 122)
        case .lightseagreen: return RRColor(r: 32, g: 178, b: 170)
        case .lightskyblue: return RRColor(r: 135, g: 206, b: 250)
        case .lightslategray: return RRColor(r: 119, g: 136, b: 153)
        case .lightsteelblue: return RRColor(r: 176, g: 196, b: 222)
        case .lightyellow: return RRColor(r: 255, g: 255, b: 224)
        case .lime: return RRColor(r: 0, g: 255, b: 0)
        case .limegreen: return RRColor(r: 50, g: 205, b: 50)
        case .linen: return RRColor(r: 250, g: 240, b: 230)
        case .magenta: return RRColor(r: 255, g: 0, b: 255)
        case .maroon: return RRColor(r: 128, g: 0, b: 0)
        case .mediumaquamarine: return RRColor(r: 102, g: 205, b: 170)
        case .mediumblue: return RRColor(r: 0, g: 0, b: 205)
        case .mediumorchid: return RRColor(r: 186, g: 85, b: 211)
        case .mediumpurple: return RRColor(r: 147, g: 112, b: 219)
        case .mediumseagreen: return RRColor(r: 60, g: 179, b: 113)
        case .mediumslateblue: return RRColor(r: 123, g: 104, b: 238)
        case .mediumspringgreen: return RRColor(r: 0, g: 250, b: 154)
        case .mediumturquoise: return RRColor(r: 72, g: 209, b: 204)
        case .mediumvioletred: return RRColor(r: 199, g: 21, b: 133)
        case .midnightblue: return RRColor(r: 25, g: 25, b: 112)
        case .mintcream: return RRColor(r: 245, g: 255, b: 250)
        case .mistyrose: return RRColor(r: 255, g: 228, b: 225)
        case .moccasin: return RRColor(r: 255, g: 228, b: 181)
        case .navajowhite: return RRColor(r: 255, g: 222, b: 173)
        case .navy: return RRColor(r: 0, g: 0, b: 128)
        case .oldlace: return RRColor(r: 253, g: 245, b: 230)
        case .olive: return RRColor(r: 128, g: 128, b: 0)
        case .olivedrab: return RRColor(r: 107, g: 142, b: 35)
        case .orange: return RRColor(r: 255, g: 165, b: 0)
        case .orangered: return RRColor(r: 255, g: 69, b: 0)
        case .orchid: return RRColor(r: 218, g: 112, b: 214)
        case .palegoldenrod: return RRColor(r: 238, g: 232, b: 170)
        case .palegreen: return RRColor(r: 152, g: 251, b: 152)
        case .paleturquoise: return RRColor(r: 175, g: 238, b: 238)
        case .palevioletred: return RRColor(r: 219, g: 112, b: 147)
        case .papayawhip: return RRColor(r: 255, g: 239, b: 213)
        case .peachpuff: return RRColor(r: 255, g: 218, b: 185)
        case .peru: return RRColor(r: 205, g: 133, b: 63)
        case .pink: return RRColor(r: 255, g: 192, b: 203)
        case .plum: return RRColor(r: 221, g: 160, b: 221)
        case .powderblue: return RRColor(r: 176, g: 224, b: 230)
        case .purple: return RRColor(r: 128, g: 0, b: 128)
        case .red: return RRColor(r: 255, g: 0, b: 0)
        case .rosybrown: return RRColor(r: 188, g: 143, b: 143)
        case .royalblue: return RRColor(r: 65, g: 105, b: 225)
        case .saddlebrown: return RRColor(r: 139, g: 69, b: 19)
        case .salmon: return RRColor(r: 250, g: 128, b: 114)
        case .sandybrown: return RRColor(r: 244, g: 164, b: 96)
        case .seagreen: return RRColor(r: 46, g: 139, b: 87)
        case .seashell: return RRColor(r: 255, g: 245, b: 238)
        case .sienna: return RRColor(r: 160, g: 82, b: 45)
        case .silver: return RRColor(r: 192, g: 192, b: 192)
        case .skyblue: return RRColor(r: 135, g: 206, b: 235)
        case .slateblue: return RRColor(r: 106, g: 90, b: 205)
        case .slategray: return RRColor(r: 112, g: 128, b: 144)
        case .snow: return RRColor(r: 255, g: 250, b: 250)
        case .springgreen: return RRColor(r: 0, g: 255, b: 127)
        case .steelblue: return RRColor(r: 70, g: 130, b: 180)
        case .tan: return RRColor(r: 210, g: 180, b: 140)
        case .teal: return RRColor(r: 0, g: 128, b: 128)
        case .thistle: return RRColor(r: 216, g: 191, b: 216)
        case .tomato: return RRColor(r: 255, g: 99, b: 71)
        case .turquoise: return RRColor(r: 64, g: 224, b: 208)
        case .violet: return RRColor(r: 238, g: 130, b: 238)
        case .wheat: return RRColor(r: 245, g: 222, b: 179)
        case .white: return RRColor(r: 255, g: 255, b: 255)
        case .whitesmoke: return RRColor(r: 245, g: 245, b: 245)
        case .yellow: return RRColor(r: 255, g: 255, b: 0)
        case .yellowgreen: return RRColor(r: 154, g: 205, b: 50)
        }
    }
}

// MARK: - Color Utilities

public extension RRColor {
    
    /// Creates a color from a CSS color name
    /// - Parameter name: The CSS color name
    /// - Returns: A color object if the name is valid, nil otherwise
    static func fromCSSName(_ name: String) -> RRColor? {
        guard let cssColorName = CSSColorName(rawValue: name.lowercased()) else {
            return nil
        }
        return cssColorName.color
    }
    
    /// Creates a color from a CSS color name enum case
    /// - Parameter cssColorName: The CSS color name enum case
    /// - Returns: The corresponding RRColor
    static func fromCSSName(_ cssColorName: CSSColorName) -> RRColor {
        return cssColorName.color
    }
}
