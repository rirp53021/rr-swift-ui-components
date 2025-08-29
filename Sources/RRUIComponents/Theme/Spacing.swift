import SwiftUI

/// Represents the spacing system for UI components
public struct Spacing {
    /// The current spacing value
    public let value: CGFloat
    
    /// Extra small spacing (4pt)
    public static let xs: CGFloat = 4
    /// Small spacing (8pt)
    public static let sm: CGFloat = 8
    /// Medium spacing (16pt)
    public static let md: CGFloat = 16
    /// Large spacing (24pt)
    public static let lg: CGFloat = 24
    /// Extra large spacing (32pt)
    public static let xl: CGFloat = 32
    /// Double extra large spacing (48pt)
    public static let xxl: CGFloat = 48
    /// Triple extra large spacing (64pt)
    public static let xxxl: CGFloat = 64
    
    /// Creates a new spacing value
    /// - Parameter value: The spacing value in points
    public init(_ value: CGFloat) {
        self.value = value
    }
    
    /// Convenience accessors for common spacing values
    public var xs: CGFloat { Self.xs }
    public var sm: CGFloat { Self.sm }
    public var md: CGFloat { Self.md }
    public var lg: CGFloat { Self.lg }
    public var xl: CGFloat { Self.xl }
    public var xxl: CGFloat { Self.xxl }
    public var xxxl: CGFloat { Self.xxxl }
}

// MARK: - Spacing Modifiers
public extension View {
    /// Applies extra small padding
    func paddingXS() -> some View {
        self.padding(.all, Spacing.xs)
    }
    
    /// Applies small padding
    func paddingSM() -> some View {
        self.padding(.all, Spacing.sm)
    }
    
    /// Applies medium padding
    func paddingMD() -> some View {
        self.padding(.all, Spacing.md)
    }
    
    /// Applies large padding
    func paddingLG() -> some View {
        self.padding(.all, Spacing.lg)
    }
    
    /// Applies extra large padding
    func paddingXL() -> some View {
        self.padding(.all, Spacing.xl)
    }
    
    /// Applies double extra large padding
    func paddingXXL() -> some View {
        self.padding(.all, Spacing.xxl)
    }
    
    /// Applies triple extra large padding
    func paddingXXXL() -> some View {
        self.padding(.all, Spacing.xxxl)
    }
    
    /// Applies horizontal padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingHorizontal(_ spacing: CGFloat) -> some View {
        self.padding(.horizontal, spacing)
    }
    
    /// Applies vertical padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingVertical(_ spacing: CGFloat) -> some View {
        self.padding(.vertical, spacing)
    }
    
    /// Applies top padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingTop(_ spacing: CGFloat) -> some View {
        self.padding(.top, spacing)
    }
    
    /// Applies bottom padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingBottom(_ spacing: CGFloat) -> some View {
        self.padding(.bottom, spacing)
    }
    
    /// Applies leading padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingLeading(_ spacing: CGFloat) -> some View {
        self.padding(.leading, spacing)
    }
    
    /// Applies trailing padding with specified spacing
    /// - Parameter spacing: The spacing value to apply
    func paddingTrailing(_ spacing: CGFloat) -> some View {
        self.padding(.trailing, spacing)
    }
}

// MARK: - Spacing Extensions
public extension EdgeInsets {
    /// Creates edge insets with consistent spacing
    /// - Parameter spacing: The spacing value to apply to all edges
    init(spacing: CGFloat) {
        self.init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
    
    /// Creates edge insets with horizontal and vertical spacing
    /// - Parameters:
    ///   - horizontal: The horizontal spacing value
    ///   - vertical: The vertical spacing value
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}

// MARK: - Common Spacing Combinations
public extension Spacing {
    /// Standard content padding (16pt)
    static let content: CGFloat = md
    /// Standard section padding (24pt)
    static let section: CGFloat = lg
    /// Standard screen padding (16pt)
    static let screen: CGFloat = md
    /// Standard card padding (16pt)
    static let card: CGFloat = md
    /// Standard button padding (12pt)
    static let button: CGFloat = 12
    /// Standard input padding (12pt)
    static let input: CGFloat = 12
}
