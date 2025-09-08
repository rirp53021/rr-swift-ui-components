//
//  AccessibilityUtils.swift
//  RRUIComponents
//
//  Created by RRUIComponents on 2025-09-07.
//

import SwiftUI

/// Utility functions for accessibility compliance and validation
public struct AccessibilityUtils {
    
    // MARK: - WCAG Color Contrast
    
    /// Calculate the relative luminance of a color
    /// - Parameter color: The color to calculate luminance for
    /// - Returns: The relative luminance value (0.0 to 1.0)
    public static func relativeLuminance(_ color: Color) -> Double {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Convert to linear RGB
        let r = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let g = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let b = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)
        
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    /// Calculate the contrast ratio between two colors
    /// - Parameters:
    ///   - foreground: The foreground color
    ///   - background: The background color
    /// - Returns: The contrast ratio (1.0 to 21.0)
    public static func contrastRatio(foreground: Color, background: Color) -> Double {
        let l1 = relativeLuminance(foreground)
        let l2 = relativeLuminance(background)
        
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    /// Check if two colors meet WCAG AA contrast requirements
    /// - Parameters:
    ///   - foreground: The foreground color
    ///   - background: The background color
    ///   - level: The WCAG level to check against
    /// - Returns: True if the contrast meets the requirements
    public static func meetsWCAGContrast(
        foreground: Color,
        background: Color,
        level: WCAGLevel = .AA
    ) -> Bool {
        let ratio = contrastRatio(foreground: foreground, background: background)
        return ratio >= level.minimumContrastRatio
    }
    
    /// Get the WCAG compliance status for a color pair
    /// - Parameters:
    ///   - foreground: The foreground color
    ///   - background: The background color
    /// - Returns: The WCAG compliance status
    public static func wcagCompliance(
        foreground: Color,
        background: Color
    ) -> WCAGCompliance {
        let ratio = contrastRatio(foreground: foreground, background: background)
        
        if ratio >= WCAGLevel.AAA.minimumContrastRatio {
            return .AAA
        } else if ratio >= WCAGLevel.AA.minimumContrastRatio {
            return .AA
        } else if ratio >= WCAGLevel.AALarge.minimumContrastRatio {
            return .AALarge
        } else {
            return .fail
        }
    }
    
    /// Find the best accessible color for text on a given background
    /// - Parameters:
    ///   - background: The background color
    ///   - options: Available text color options
    ///   - level: The minimum WCAG level required
    /// - Returns: The best accessible color option, or nil if none meet requirements
    public static func bestAccessibleColor(
        for background: Color,
        from options: [Color],
        minimumLevel: WCAGLevel = .AA
    ) -> Color? {
        return options.first { color in
            meetsWCAGContrast(foreground: color, background: background, level: minimumLevel)
        }
    }
    
    // MARK: - Dynamic Type Support
    
    /// Check if a font size supports Dynamic Type
    /// - Parameter font: The font to check
    /// - Returns: True if the font supports Dynamic Type
    public static func supportsDynamicType(_ font: Font) -> Bool {
        // Most system fonts support Dynamic Type by default
        // Custom fonts may need special handling
        return true
    }
    
    /// Get the recommended minimum touch target size
    /// - Returns: The minimum recommended touch target size in points
    public static var minimumTouchTargetSize: CGFloat {
        return 44.0 // Apple's recommended minimum
    }
    
    /// Check if a view meets minimum touch target requirements
    /// - Parameters:
    ///   - width: The view width
    ///   - height: The view height
    /// - Returns: True if the view meets minimum touch target requirements
    public static func meetsMinimumTouchTarget(width: CGFloat, height: CGFloat) -> Bool {
        return min(width, height) >= minimumTouchTargetSize
    }
}

// MARK: - WCAG Levels

/// WCAG compliance levels
public enum WCAGLevel {
    case AA
    case AALarge
    case AAA
    
    var minimumContrastRatio: Double {
        switch self {
        case .AA:
            return 4.5
        case .AALarge:
            return 3.0
        case .AAA:
            return 7.0
        }
    }
}

/// WCAG compliance status
public enum WCAGCompliance {
    case AAA
    case AA
    case AALarge
    case fail
    
    var description: String {
        switch self {
        case .AAA:
            return "WCAG AAA Compliant"
        case .AA:
            return "WCAG AA Compliant"
        case .AALarge:
            return "WCAG AA Large Text Compliant"
        case .fail:
            return "WCAG Non-Compliant"
        }
    }
    
    var isCompliant: Bool {
        return self != .fail
    }
}

// MARK: - Accessibility Modifiers

/// View extension for accessibility utilities
public extension View {
    
    /// Ensure the view meets minimum touch target requirements
    /// - Returns: A view with minimum touch target size
    func minimumTouchTarget() -> some View {
        self.frame(minWidth: AccessibilityUtils.minimumTouchTargetSize,
                  minHeight: AccessibilityUtils.minimumTouchTargetSize)
    }
    
    /// Add WCAG contrast validation to a view
    /// - Parameters:
    ///   - foreground: The foreground color
    ///   - background: The background color
    ///   - level: The minimum WCAG level required
    /// - Returns: A view with contrast validation
    func wcagContrastValidation(
        foreground: Color,
        background: Color,
        minimumLevel: WCAGLevel = .AA
    ) -> some View {
        self.overlay(
            Group {
                if !AccessibilityUtils.meetsWCAGContrast(
                    foreground: foreground,
                    background: background,
                    level: minimumLevel
                ) {
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .overlay(
                            Text("⚠️ Low Contrast")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(4)
                        )
                }
            }
        )
    }
}
