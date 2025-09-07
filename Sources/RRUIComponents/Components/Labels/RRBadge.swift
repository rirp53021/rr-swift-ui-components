import SwiftUI

/// A badge/chip component for displaying labels, counts, or status indicators
public struct RRBadge: View {
    public enum Style {
        case filled
        case outlined
        case soft
    }
    
    public enum Size {
        case small
        case medium
        case large
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
        size: Size = .medium,
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
    }
    
    // MARK: - Computed Properties
    
    private var spacing: CGFloat {
        switch size {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
    
    private var textFont: Font {
        switch size {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .body
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .body
        }
    }
    
    private var fontWeight: Font.Weight {
        switch style {
        case .filled: return .semibold
        case .outlined: return .medium
        case .soft: return .medium
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return 6
        case .medium: return 8
        case .large: return 12
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
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
}

// MARK: - Convenience Initializers

public extension RRBadge {
    /// Creates a filled badge
    static func filled(
        _ text: String,
        color: Color = .primary,
        size: Size = .medium,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .filled, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates an outlined badge
    static func outlined(
        _ text: String,
        color: Color = .primary,
        size: Size = .medium,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .outlined, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates a soft badge
    static func soft(
        _ text: String,
        color: Color = .primary,
        size: Size = .medium,
        icon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge(text, style: .soft, size: size, color: color, icon: icon, onTap: onTap)
    }
    
    /// Creates a count badge
    static func count(
        _ count: Int,
        color: Color = .primary,
        size: Size = .small,
        onTap: (() -> Void)? = nil
    ) -> RRBadge {
        RRBadge("\(count)", style: .filled, size: size, color: color, onTap: onTap)
    }
    
    /// Creates a status badge
    static func status(
        _ text: String,
        status: Color,
        size: Size = .medium,
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
                RRBadge.filled("Small", size: .small)
                RRBadge.filled("Medium", size: .medium)
                RRBadge.filled("Large", size: .large)
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
