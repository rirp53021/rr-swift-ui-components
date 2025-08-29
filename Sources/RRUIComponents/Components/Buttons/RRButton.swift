import SwiftUI

/// A customizable button component with different styles and states
public struct RRButton: View {
    /// The button style
    public enum Style {
        case primary
        case secondary
        case outline
        case ghost
        case danger
        case success
    }
    
    /// The button size
    public enum Size {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 56
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 24
            }
        }
        
        var fontSize: Font {
            switch self {
            case .small: return .caption
            case .medium: return .body
            case .large: return .title3
            }
        }
    }
    
    /// The button's title
    public let title: String
    /// The button's icon (optional)
    public let icon: Image?
    /// The button's style
    public let style: Style
    /// The button's size
    public let size: Size
    /// Whether the button is disabled
    public let isDisabled: Bool
    /// Whether the button is loading
    public let isLoading: Bool
    /// The action to perform when tapped
    public let action: () -> Void
    
    /// Creates a new button
    /// - Parameters:
    ///   - title: The button's title
    ///   - icon: The button's icon (optional)
    ///   - style: The button's style
    ///   - size: The button's size
    ///   - isDisabled: Whether the button is disabled
    ///   - isLoading: Whether the button is loading
    ///   - action: The action to perform when tapped
    public init(
        title: String,
        icon: Image? = nil,
        style: Style = .primary,
        size: Size = .medium,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                } else if let icon = icon {
                    icon
                        .font(.system(size: 16))
                        .foregroundColor(textColor)
                }
                
                Text(title)
                    .font(size.fontSize)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
            }
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(8)
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
        .scaleEffect(isLoading ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isLoading)
    }
    
    // MARK: - Private Properties
    @Environment(\.themeManager) private var themeManager
    
    private var backgroundColor: Color {
        if isDisabled {
            return themeManager.colorScheme.neutral.border
        }
        
        switch style {
        case .primary:
            return themeManager.colorScheme.primary.main
        case .secondary:
            return themeManager.colorScheme.secondary.main
        case .outline:
            return .clear
        case .ghost:
            return .clear
        case .danger:
            return themeManager.colorScheme.semantic.error
        case .success:
            return themeManager.colorScheme.semantic.success
        }
    }
    
    private var textColor: Color {
        if isDisabled {
            return themeManager.colorScheme.neutral.textSecondary
        }
        
        switch style {
        case .primary, .secondary, .danger, .success:
            return themeManager.colorScheme.primary.contrast
        case .outline, .ghost:
            return themeManager.colorScheme.primary.main
        }
    }
    
    private var borderColor: Color {
        if isDisabled {
            return themeManager.colorScheme.neutral.border
        }
        
        switch style {
        case .outline:
            return themeManager.colorScheme.primary.main
        case .ghost:
            return .clear
        default:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return 1.5
        default:
            return 0
        }
    }
}

// MARK: - Convenience Initializers
public extension RRButton {
    /// Creates a primary button
    /// - Parameters:
    ///   - title: The button's title
    ///   - icon: The button's icon (optional)
    ///   - size: The button's size
    ///   - isDisabled: Whether the button is disabled
    ///   - isLoading: Whether the button is loading
    ///   - action: The action to perform when tapped
    static func primary(
        title: String,
        icon: Image? = nil,
        size: Size = .medium,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> RRButton {
        RRButton(
            title: title,
            icon: icon,
            style: .primary,
            size: size,
            isDisabled: isDisabled,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Creates a secondary button
    /// - Parameters:
    ///   - title: The button's title
    ///   - icon: Image? = nil,
    ///   - size: The button's size
    ///   - isDisabled: Whether the button is disabled
    ///   - isLoading: Whether the button is loading
    ///   - action: The action to perform when tapped
    static func secondary(
        title: String,
        icon: Image? = nil,
        size: Size = .medium,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> RRButton {
        RRButton(
            title: title,
            icon: icon,
            style: .secondary,
            size: size,
            isDisabled: isDisabled,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Creates an outline button
    /// - Parameters:
    ///   - title: The button's title
    ///   - icon: The button's icon (optional)
    ///   - size: The button's size
    ///   - isDisabled: Whether the button is disabled
    ///   - isLoading: Whether the button is loading
    ///   - action: The action to perform when tapped
    static func outline(
        title: String,
        icon: Image? = nil,
        size: Size = .medium,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> RRButton {
        RRButton(
            title: title,
            icon: icon,
            style: .outline,
            size: size,
            isDisabled: isDisabled,
            isLoading: isLoading,
            action: action
        )
    }
}

// MARK: - Preview
#if DEBUG
struct RRButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RRButton.primary(title: "Primary Button") {}
            RRButton.secondary(title: "Secondary Button") {}
            RRButton.outline(title: "Outline Button") {}
            RRButton(title: "Danger Button", style: .danger) {}
            RRButton(title: "Success Button", style: .success) {}
            RRButton(title: "Disabled Button", isDisabled: true) {}
            RRButton(title: "Loading Button", isLoading: true) {}
        }
        .padding()
        .themeManager(.preview)
    }
}
#endif
