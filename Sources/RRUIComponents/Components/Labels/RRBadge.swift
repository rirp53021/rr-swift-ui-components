import SwiftUI

/// A badge/chip component for displaying labels, counts, or status indicators
public struct RRBadge: View {
    public enum Style {
        case filled
        case outlined
        case soft
    }
    
    public enum Size {
        case xs
        case sm
        case md
        case lg
        case xl
        
        var height: CGFloat {
            switch self {
            case .xs: return DesignTokens.ComponentSize.badgeHeightXS
            case .sm: return DesignTokens.ComponentSize.badgeHeightSM
            case .md: return DesignTokens.ComponentSize.badgeHeightMD
            case .lg: return DesignTokens.ComponentSize.badgeHeightLG
            case .xl: return DesignTokens.ComponentSize.badgeHeightXL
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .xs: return DesignTokens.Spacing.xs
            case .sm: return DesignTokens.Spacing.sm
            case .md: return DesignTokens.Spacing.md
            case .lg: return DesignTokens.Spacing.lg
            case .xl: return DesignTokens.Spacing.xl
            }
        }
        
        var font: Font {
            switch self {
            case .xs: return DesignTokens.Typography.labelSmall
            case .sm: return DesignTokens.Typography.labelMedium
            case .md: return DesignTokens.Typography.bodySmall
            case .lg: return DesignTokens.Typography.bodyMedium
            case .xl: return DesignTokens.Typography.titleSmall
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .xs: return 8
            case .sm: return 10
            case .md: return 12
            case .lg: return 14
            case .xl: return 16
            }
        }
    }
    
    public enum Color {
        case primary
        case secondary
        case success
        case warning
        case error
        case info
        case neutral
    }
    
    private let text: String
    private let style: Style
    private let size: Size
    private let color: Color
    private let icon: Image?
    private let onTap: (() -> Void)?
    
    public init(
        _ text: String,
        style: Style = .filled,
        size: Size = .md,
        color: Color = .primary,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.style = style
        self.size = size
        self.color = color
        self.icon = icon
        self.onTap = onTap
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            if let icon = icon {
                icon
                    .font(iconFont)
                    .foregroundColor(iconColor)
            }
            
            Text(text)
                .font(textFont)
                .fontWeight(fontWeight)
                .foregroundColor(textColor)
                .dynamicTypeSize(.large) // Support Dynamic Type
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onTapGesture {
            onTap?()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "")
        .accessibilityAddTraits(accessibilityTraits)
        .minimumTouchTarget() // Ensure WCAG touch target compliance
        .keyboardNavigation(
            config: onTap != nil ? .button : NavigationConfig(isEnabled: false),
            onActivate: { onTap?() },
            onCancel: { /* Badge doesn't have cancel action */ }
        )
        .keyboardNavigationAccessibility(config: onTap != nil ? .button : NavigationConfig(isEnabled: false))
    }
    
    // MARK: - Computed Properties
    
    private var spacing: CGFloat {
        return DesignTokens.Spacing.xs
    }
    
    private var textFont: Font {
        return size.font
    }
    
    private var iconFont: Font {
        return .system(size: size.iconSize)
    }
    
    private var fontWeight: Font.Weight {
        switch style {
        case .filled: return .semibold
        case .outlined: return .medium
        case .soft: return .medium
        }
    }
    
    private var horizontalPadding: CGFloat {
        return size.horizontalPadding
    }
    
    private var verticalPadding: CGFloat {
        return DesignTokens.Spacing.xs
    }
    
    private var cornerRadius: CGFloat {
        return DesignTokens.BorderRadius.badge
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .filled, .soft: return 0
        case .outlined: return 1
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: SwiftUI.Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        switch style {
        case .filled:
            return badgeColor(scheme: scheme)
        case .outlined:
            return SwiftUI.Color.clear
        case .soft:
            return badgeColor(scheme: scheme).opacity(0.1)
        }
    }
    
    private var textColor: SwiftUI.Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        switch style {
        case .filled:
            return .white
        case .outlined, .soft:
            return badgeColor(scheme: scheme)
        }
    }
    
    private var iconColor: SwiftUI.Color {
        return textColor
    }
    
    private var borderColor: SwiftUI.Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        switch style {
        case .filled, .soft:
            return SwiftUI.Color.clear
        case .outlined:
            return badgeColor(scheme: scheme)
        }
    }
    
    private func badgeColor(scheme: RRColorScheme) -> SwiftUI.Color {
        switch color {
        case .primary: return scheme.primary
        case .secondary: return scheme.secondary
        case .success: return scheme.semantic.success
        case .warning: return scheme.semantic.warning
        case .error: return scheme.semantic.error
        case .info: return scheme.semantic.info
        case .neutral: return scheme.neutral.textSecondary
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        var label = text
        
        if icon != nil {
            label += ", with icon"
        }
        
        switch color {
        case .primary:
            label += ", primary badge"
        case .secondary:
            label += ", secondary badge"
        case .success:
            label += ", success badge"
        case .warning:
            label += ", warning badge"
        case .error:
            label += ", error badge"
        case .info:
            label += ", info badge"
        case .neutral:
            label += ", neutral badge"
        }
        
        return label
    }
    
    private var accessibilityHint: String? {
        guard onTap != nil else { return nil }
        return "Double tap to activate"
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = []
        
        if onTap != nil {
            traits = [.isButton]
        }
        
        return traits
    }
    
    // MARK: - WCAG Compliance
    
    /// Validate WCAG color contrast compliance for this badge
    /// - Returns: The WCAG compliance status
    public func validateWCAGCompliance() -> WCAGCompliance {
        return AccessibilityUtils.wcagCompliance(
            foreground: textColor,
            background: backgroundColor
        )
    }
    
    /// Check if this badge meets WCAG AA contrast requirements
    /// - Returns: True if the badge meets WCAG AA requirements
    public func meetsWCAGAA() -> Bool {
        return AccessibilityUtils.meetsWCAGContrast(
            foreground: textColor,
            background: backgroundColor,
            level: .AA
        )
    }
}

// MARK: - Convenience Initializers

public extension RRBadge {
    /// Creates a filled badge
    static func filled(
        _ text: String,
        color: Color = .primary,
        size: Size = .md,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .filled, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates an outlined badge
    static func outlined(
        _ text: String,
        color: Color = .primary,
        size: Size = .md,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .outlined, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates a soft badge
    static func soft(
        _ text: String,
        color: Color = .primary,
        size: Size = .md,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .soft, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates a count badge
    static func count(
        _ count: Int,
        color: Color = .primary,
        size: Size = .xs,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge("\(count)", style: .filled, size: size, color: color, onTap: onTap)
    }
    
    /// Creates a status badge
    static func status(
        _ text: String,
        status: Color,
        size: Size = .md,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .filled, size: size, color: status, onTap: onTap)
    }
}

// MARK: - Preview

#if DEBUG
struct RRBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Different styles
            HStack(spacing: 8) {
                RRBadge.filled("Filled")
                RRBadge.outlined("Outlined")
                RRBadge.soft("Soft")
            }
            
            // Different colors
            HStack(spacing: 8) {
                RRBadge.filled("Primary", color: .primary)
                RRBadge.filled("Success", color: .success)
                RRBadge.filled("Warning", color: .warning)
                RRBadge.filled("Error", color: .error)
                RRBadge.filled("Info", color: .info)
            }
            
            // Different sizes
            HStack(spacing: 8) {
                RRBadge.filled("XS", size: .xs)
                RRBadge.filled("SM", size: .sm)
                RRBadge.filled("MD", size: .md)
                RRBadge.filled("LG", size: .lg)
                RRBadge.filled("XL", size: .xl)
            }
            
            // With icons
            HStack(spacing: 8) {
                RRBadge.filled("With Icon", icon: Image(systemName: "star"))
                RRBadge.outlined("Outlined", icon: Image(systemName: "heart"))
                RRBadge.soft("Soft", icon: Image(systemName: "checkmark"))
            }
            
            // Count badges
            HStack(spacing: 8) {
                RRBadge.count(5)
                RRBadge.count(99)
                RRBadge.count(999)
            }
            
            // Status badges
            HStack(spacing: 8) {
                RRBadge.status("Active", status: .success)
                RRBadge.status("Pending", status: .warning)
                RRBadge.status("Inactive", status: .error)
            }
        }
        .padding()
        .previewDisplayName("RRBadge")
    }
}
#endif
