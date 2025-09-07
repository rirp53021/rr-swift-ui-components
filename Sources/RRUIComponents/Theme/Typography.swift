// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Typography System

public struct Typography {
    public static let largeTitle = Font.largeTitle
    public static let title = Font.title
    public static let title2 = Font.title2
    public static let title3 = Font.title3
    public static let headline = Font.headline
    public static let body = Font.body
    public static let callout = Font.callout
    public static let subheadline = Font.subheadline
    public static let footnote = Font.footnote
    public static let caption = Font.caption
    public static let caption2 = Font.caption2
}

// MARK: - Text Extensions

public extension Text {
    
    // MARK: - Currency Formatting
    
    /// Creates a text view with formatted currency
    /// - Parameters:
    ///   - amount: The amount to format
    ///   - currencyCode: The currency code (e.g., "USD", "EUR")
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted currency
    static func currency(_ amount: Double, currencyCode: String = "USD", locale: Locale = .current) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        
        if let formattedString = formatter.string(from: NSNumber(value: amount)) {
            return Text(formattedString)
        } else {
            return Text("\(amount)")
        }
    }
    
    /// Creates a text view with formatted currency
    /// - Parameters:
    ///   - amount: The amount to format
    ///   - currencyCode: The currency code (e.g., "USD", "EUR")
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted currency
    static func currency(_ amount: Int, currencyCode: String = "USD", locale: Locale = .current) -> Text {
        return currency(Double(amount), currencyCode: currencyCode, locale: locale)
    }
    
    // MARK: - Percentage Formatting
    
    /// Creates a text view with formatted percentage
    /// - Parameters:
    ///   - value: The percentage value (0.0-1.0)
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted percentage
    static func percentage(_ value: Double, locale: Locale = .current) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return Text(formattedString)
        } else {
            return Text("\(Int(value * 100))%")
        }
    }
    
    // MARK: - Number Formatting
    
    /// Creates a text view with formatted number
    /// - Parameters:
    ///   - value: The number to format
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted number
    static func number(_ value: Double, locale: Locale = .current) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return Text(formattedString)
        } else {
            return Text("\(value)")
        }
    }
    
    /// Creates a text view with formatted number
    /// - Parameters:
    ///   - value: The number to format
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted number
    static func number(_ value: Int, locale: Locale = .current) -> Text {
        return number(Double(value), locale: locale)
    }
    
    /// Creates a text view with compact number formatting
    /// - Parameters:
    ///   - value: The number to format
    ///   - locale: The locale for formatting
    /// - Returns: A text view with compact formatted number
    static func compactNumber(_ value: Double, locale: Locale = .current) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 1
        
        if value >= 1_000_000 {
            formatter.positiveSuffix = "M"
            formatter.negativeSuffix = "M"
            let formattedValue = value / 1_000_000
            if let formattedString = formatter.string(from: NSNumber(value: formattedValue)) {
                return Text(formattedString)
            }
        } else if value >= 1_000 {
            formatter.positiveSuffix = "K"
            formatter.negativeSuffix = "K"
            let formattedValue = value / 1_000
            if let formattedString = formatter.string(from: NSNumber(value: formattedValue)) {
                return Text(formattedString)
            }
        }
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return Text(formattedString)
        } else {
            return Text("\(value)")
        }
    }
    
    /// Creates a text view with compact number formatting
    /// - Parameters:
    ///   - value: The number to format
    ///   - locale: The locale for formatting
    /// - Returns: A text view with compact formatted number
    static func compactNumber(_ value: Int, locale: Locale = .current) -> Text {
        return compactNumber(Double(value), locale: locale)
    }
    
    // MARK: - Date Formatting
    
    /// Creates a text view with formatted date
    /// - Parameters:
    ///   - date: The date to format
    ///   - style: The date style
    ///   - locale: The locale for formatting
    /// - Returns: A text view with formatted date
    static func date(_ date: Date, style: DateFormatter.Style, locale: Locale = .current) -> Text {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.locale = locale
        
        return Text(formatter.string(from: date))
    }
    
    /// Creates a text view with relative date formatting
    /// - Parameters:
    ///   - date: The date to format
    ///   - locale: The locale for formatting
    /// - Returns: A text view with relative formatted date
    static func relativeDate(_ date: Date, locale: Locale = .current) -> Text {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = locale
        
        return Text(formatter.localizedString(for: date, relativeTo: Date()))
    }
}
