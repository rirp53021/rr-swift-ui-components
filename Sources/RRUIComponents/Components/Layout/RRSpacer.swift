import SwiftUI

/// A flexible spacer component with customizable sizing and behavior
public struct RRSpacer: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let style: SpacerStyle
    private let minLength: CGFloat?
    private let maxLength: CGFloat?
    private let color: Color?
    private let showVisual: Bool
    
    // MARK: - Initialization
    
    /// Creates a spacer with the specified style and configuration
    /// - Parameters:
    ///   - style: The spacer style
    ///   - minLength: The minimum length of the spacer
    ///   - maxLength: The maximum length of the spacer
    ///   - color: Optional background color for visual spacer
    ///   - showVisual: Whether to show a visual representation of the spacer
    public init(
        style: SpacerStyle = .default,
        minLength: CGFloat? = nil,
        maxLength: CGFloat? = nil,
        color: Color? = nil,
        showVisual: Bool = false
    ) {
        self.style = style
        self.minLength = minLength
        self.maxLength = maxLength
        self.color = color
        self.showVisual = showVisual
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if showVisual {
                visualSpacer
            } else {
                invisibleSpacer
            }
        }
    }
    
    // MARK: - Invisible Spacer
    
    private var invisibleSpacer: some View {
        Spacer(minLength: effectiveMinLength)
            .frame(maxWidth: maxLength, maxHeight: maxLength)
    }
    
    // MARK: - Visual Spacer
    
    private var visualSpacer: some View {
        Rectangle()
            .fill(visualColor)
            .frame(
                minWidth: effectiveMinLength,
                maxWidth: maxLength,
                minHeight: effectiveMinLength,
                maxHeight: maxLength
            )
            .opacity(0.3)
    }
    
    // MARK: - Computed Properties
    
    private var effectiveMinLength: CGFloat {
        if let minLength = minLength {
            return minLength
        }
        
        switch style {
        case .default:
            return 0
        case .xs:
            return DesignTokens.Spacing.xs
        case .sm:
            return DesignTokens.Spacing.sm
        case .md:
            return DesignTokens.Spacing.md
        case .lg:
            return DesignTokens.Spacing.lg
        case .xl:
            return DesignTokens.Spacing.xl
        case .xxl:
            return DesignTokens.Spacing.xxl
        case .flexible:
            return 0
        case .fixed(let length):
            return length
        }
    }
    
    private var visualColor: Color {
        if let color = color {
            return color
        }
        
        return theme.colors.primary.opacity(0.2)
    }
}

// MARK: - Spacer Style

public enum SpacerStyle {
    case `default`
    case xs
    case sm
    case md
    case lg
    case xl
    case xxl
    case flexible
    case fixed(CGFloat)
}

// MARK: - Spacer Extensions

public extension RRSpacer {
    
    /// Creates a horizontal spacer
    static func horizontal(_ style: SpacerStyle = .default) -> RRSpacer {
        RRSpacer(style: style)
    }
    
    /// Creates a vertical spacer
    static func vertical(_ style: SpacerStyle = .default) -> RRSpacer {
        RRSpacer(style: style)
    }
    
    /// Creates a flexible spacer that expands to fill available space
    static func flexible() -> RRSpacer {
        RRSpacer(style: .flexible)
    }
    
    /// Creates a fixed-size spacer
    static func fixed(_ length: CGFloat) -> RRSpacer {
        RRSpacer(style: .fixed(length))
    }
    
    /// Creates a visual spacer for debugging layouts
    static func visual(_ style: SpacerStyle = .default, color: Color? = nil) -> RRSpacer {
        RRSpacer(style: style, color: color, showVisual: true)
    }
}

// MARK: - Spacer Group

public struct RRSpacerGroup: View {
    
    private let style: SpacerStyle
    private let count: Int
    private let direction: SpacerDirection
    private let showVisual: Bool
    
    public init(
        style: SpacerStyle = .default,
        count: Int = 1,
        direction: SpacerDirection = .horizontal,
        showVisual: Bool = false
    ) {
        self.style = style
        self.count = count
        self.direction = direction
        self.showVisual = showVisual
    }
    
    public var body: some View {
        Group {
            if direction == .horizontal {
                HStack(spacing: 0) {
                    ForEach(0..<count, id: \.self) { _ in
                        RRSpacer(style: style, showVisual: showVisual)
                    }
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(0..<count, id: \.self) { _ in
                        RRSpacer(style: style, showVisual: showVisual)
                    }
                }
            }
        }
    }
}

// MARK: - Spacer Direction

public enum SpacerDirection {
    case horizontal
    case vertical
}

// MARK: - Previews

#if DEBUG
struct RRSpacer_Previews: PreviewProvider {
    static var previews: some View {
        RRSpacerPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRSpacer Examples")
    }
}

private struct RRSpacerPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Spacer Examples")
            
            // Basic spacers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Spacers", style: .subtitle, weight: .semibold)
                
                HStack {
                    RRLabel("Left", style: .body)
                    RRSpacer()
                    RRLabel("Right", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
                
                VStack {
                    RRLabel("Top", style: .body)
                    RRSpacer()
                    RRLabel("Bottom", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
            }
            
            // Sized spacers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Sized Spacers", style: .subtitle, weight: .semibold)
                
                HStack {
                    RRLabel("XS", style: .body)
                    RRSpacer(style: .xs)
                    RRLabel("Small", style: .body)
                    RRSpacer(style: .sm)
                    RRLabel("Medium", style: .body)
                    RRSpacer(style: .md)
                    RRLabel("Large", style: .body)
                    RRSpacer(style: .lg)
                    RRLabel("XL", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
            }
            
            // Visual spacers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Visual Spacers (Debug)", style: .subtitle, weight: .semibold)
                
                HStack {
                    RRLabel("Left", style: .body)
                    RRSpacer.visual(.md, color: theme.colors.primary)
                    RRLabel("Right", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
                
                VStack {
                    RRLabel("Top", style: .body)
                    RRSpacer.visual(.lg, color: theme.colors.secondary)
                    RRLabel("Bottom", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
            }
            
            // Spacer groups
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Spacer Groups", style: .subtitle, weight: .semibold)
                
                HStack {
                    RRLabel("Start", style: .body)
                    RRSpacerGroup(style: .md, count: 3, direction: .horizontal)
                    RRLabel("End", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
                
                VStack {
                    RRLabel("Start", style: .body)
                    RRSpacerGroup(style: .sm, count: 2, direction: .vertical)
                    RRLabel("End", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
            }
            
            // Fixed spacers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Fixed Spacers", style: .subtitle, weight: .semibold)
                
                HStack {
                    RRLabel("Left", style: .body)
                    RRSpacer.fixed(50)
                    RRLabel("Right", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
                
                VStack {
                    RRLabel("Top", style: .body)
                    RRSpacer.fixed(30)
                    RRLabel("Bottom", style: .body)
                }
                .background(theme.colors.surfaceVariant)
                .padding(DesignTokens.Spacing.sm)
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
