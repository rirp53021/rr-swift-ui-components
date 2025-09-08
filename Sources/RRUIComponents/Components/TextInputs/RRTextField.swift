import SwiftUI

/// A comprehensive text field component with validation states and styling
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct RRTextField: View {
    public enum Style {
        case standard
        case secure
        case multiline
    }
    
    public enum ValidationState {
        case none
        case success
        case warning
        case error
    }
    
    public enum Size {
        case xs
        case sm
        case md
        case lg
        case xl
        
        var height: CGFloat {
            switch self {
            case .xs: return DesignTokens.ComponentSize.inputHeightXS
            case .sm: return DesignTokens.ComponentSize.inputHeightSM
            case .md: return DesignTokens.ComponentSize.inputHeightMD
            case .lg: return DesignTokens.ComponentSize.inputHeightLG
            case .xl: return DesignTokens.ComponentSize.inputHeightXL
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .xs: return DesignTokens.Spacing.sm
            case .sm: return DesignTokens.Spacing.md
            case .md: return DesignTokens.Spacing.lg
            case .lg: return DesignTokens.Spacing.xl
            case .xl: return DesignTokens.Spacing.xxl
            }
        }
        
        var font: Font {
            switch self {
            case .xs: return DesignTokens.Typography.bodySmall
            case .sm: return DesignTokens.Typography.bodyMedium
            case .md: return DesignTokens.Typography.bodyLarge
            case .lg: return DesignTokens.Typography.titleSmall
            case .xl: return DesignTokens.Typography.titleMedium
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .xs: return DesignTokens.ComponentSize.iconSizeSM
            case .sm: return DesignTokens.ComponentSize.iconSizeMD
            case .md: return DesignTokens.ComponentSize.iconSizeMD
            case .lg: return DesignTokens.ComponentSize.iconSizeLG
            case .xl: return DesignTokens.ComponentSize.iconSizeXL
            }
        }
    }
    
    @Binding private var text: String
    private let placeholder: String
    private let style: Style
    private let validationState: ValidationState
    private let size: Size
    private let isDisabled: Bool
    private let helperText: String?
    private let errorText: String?
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    
    public init(
        _ placeholder: String,
        text: Binding<String>,
        style: Style = .standard,
        validationState: ValidationState = .none,
        size: Size = .md,
        isDisabled: Bool = false,
        helperText: String? = nil,
        errorText: String? = nil,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.validationState = validationState
        self.size = size
        self.isDisabled = isDisabled
        self.helperText = helperText
        self.errorText = errorText
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                if let leadingIcon = leadingIcon {
                    leadingIcon
                        .font(iconFont)
                        .foregroundColor(iconColor)
                }
                
                Group {
                    switch style {
                    case .standard:
                        TextField(placeholder, text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
                    case .secure:
                        SecureField(placeholder, text: $text, onCommit: onCommit)
                    case .multiline:
                        TextField(placeholder, text: $text, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                .font(textFont)
                .foregroundColor(textColor)
                .dynamicTypeSize(.large) // Support Dynamic Type
                .disabled(isDisabled)
                
                if let trailingIcon = trailingIcon {
                    trailingIcon
                        .font(iconFont)
                        .foregroundColor(iconColor)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            
            // Helper text or error text
            if let errorText = errorText, validationState == .error {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(errorColor)
                    .dynamicTypeSize(.large) // Support Dynamic Type
            } else if let helperText = helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(helperTextColor)
                    .dynamicTypeSize(.large) // Support Dynamic Type
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityValue(accessibilityValue ?? "")
        .accessibilityAddTraits(accessibilityTraits)
        .minimumTouchTarget() // Ensure WCAG touch target compliance
        .keyboardNavigation(
            config: .textField,
            onActivate: { onCommit() },
            onCancel: { /* Text field doesn't have cancel action */ },
            onMovement: { action in
                switch action {
                case .moveToNext:
                    // Move to next field (handled by system)
                    break
                case .moveToPrevious:
                    // Move to previous field (handled by system)
                    break
                default:
                    break
                }
            }
        )
        .keyboardNavigationAccessibility(config: .textField)
    }
    
    // MARK: - Computed Properties
    
    private var textFont: Font {
        return size.font
    }
    
    private var iconFont: Font {
        return .system(size: size.iconSize)
    }
    
    private var horizontalPadding: CGFloat {
        return size.horizontalPadding
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .xs: return 4
        case .sm: return 6
        case .md: return 8
        case .lg: return 10
        case .xl: return 12
        }
    }
    
    private var cornerRadius: CGFloat {
        return DesignTokens.BorderRadius.textField
    }
    
    private var borderWidth: CGFloat {
        switch validationState {
        case .none: return 1
        case .success, .warning, .error: return 2
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        if isDisabled {
            return scheme.neutral.surface
        } else {
            return scheme.neutral.background
        }
    }
    
    private var textColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        if isDisabled {
            return scheme.neutral.textSecondary
        } else {
            return scheme.neutral.text
        }
    }
    
    private var iconColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        if isDisabled {
            return scheme.neutral.textSecondary
        } else {
            return scheme.neutral.textSecondary
        }
    }
    
    private var borderColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        if isDisabled {
            return scheme.neutral.border
        }
        
        switch validationState {
        case .none: return scheme.neutral.border
        case .success: return scheme.semantic.success
        case .warning: return scheme.semantic.warning
        case .error: return scheme.semantic.error
        }
    }
    
    private var helperTextColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        return scheme.neutral.textSecondary
    }
    
    private var errorColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        return scheme.semantic.error
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        var label = placeholder
        
        if leadingIcon != nil {
            label += ", with icon"
        }
        
        return label
    }
    
    private var accessibilityHint: String {
        var hint = ""
        
        if isDisabled {
            hint += "Field is disabled. "
        }
        
        switch validationState {
        case .none:
            break
        case .success:
            hint += "Input is valid. "
        case .warning:
            hint += "Input has a warning. "
        case .error:
            hint += "Input has an error. "
        }
        
        if let helperText = helperText {
            hint += helperText
        } else if let errorText = errorText, validationState == .error {
            hint += errorText
        }
        
        return hint.isEmpty ? "" : hint
    }
    
    private var accessibilityValue: String? {
        return text.isEmpty ? nil : text
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = [.isKeyboardKey]
        
        switch validationState {
        case .error:
            _ = traits.insert(.updatesFrequently)
        case .success:
            break
        case .warning:
            break
        case .none:
            break
        }
        
        return traits
    }
    
    // MARK: - WCAG Compliance
    
    /// Validate WCAG color contrast compliance for this text field
    /// - Returns: The WCAG compliance status
    public func validateWCAGCompliance() -> WCAGCompliance {
        return AccessibilityUtils.wcagCompliance(
            foreground: textColor,
            background: backgroundColor
        )
    }
    
    /// Check if this text field meets WCAG AA contrast requirements
    /// - Returns: True if the text field meets WCAG AA requirements
    public func meetsWCAGAA() -> Bool {
        return AccessibilityUtils.meetsWCAGContrast(
            foreground: textColor,
            background: backgroundColor,
            level: .AA
        )
    }
}

// MARK: - Convenience Initializers

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension RRTextField {
    /// Creates a standard text field
    static func standard(
        _ placeholder: String,
        text: Binding<String>,
        size: Size = .md,
        isDisabled: Bool = false,
        helperText: String? = nil,
        errorText: String? = nil,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil
    ) -> RRTextField {
        RRTextField(
            placeholder,
            text: text,
            style: .standard,
            size: size,
            isDisabled: isDisabled,
            helperText: helperText,
            errorText: errorText,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon
        )
    }
    
    /// Creates a secure text field for passwords
    static func secure(
        _ placeholder: String,
        text: Binding<String>,
        size: Size = .md,
        isDisabled: Bool = false,
        helperText: String? = nil,
        errorText: String? = nil,
        leadingIcon: Image? = nil
    ) -> RRTextField {
        RRTextField(
            placeholder,
            text: text,
            style: .secure,
            size: size,
            isDisabled: isDisabled,
            helperText: helperText,
            errorText: errorText,
            leadingIcon: leadingIcon
        )
    }
    
    /// Creates a multiline text field
    static func multiline(
        _ placeholder: String,
        text: Binding<String>,
        size: Size = .md,
        isDisabled: Bool = false,
        helperText: String? = nil,
        errorText: String? = nil,
        leadingIcon: Image? = nil
    ) -> RRTextField {
        RRTextField(
            placeholder,
            text: text,
            style: .multiline,
            size: size,
            isDisabled: isDisabled,
            helperText: helperText,
            errorText: errorText,
            leadingIcon: leadingIcon
        )
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct RRTextField_Previews: PreviewProvider {
    @State private static var text1 = ""
    @State private static var text2 = ""
    @State private static var text3 = ""
    @State private static var text4 = ""
    @State private static var text5 = ""
    @State private static var text6 = ""
    
    static var previews: some View {
        VStack(spacing: 20) {
            // Standard text fields
            RRTextField.standard(
                "Enter your name",
                text: $text1,
                helperText: "This is helper text"
            )
            
            // With icons
            RRTextField.standard(
                "Search",
                text: $text2,
                leadingIcon: Image(systemName: "magnifyingglass"),
                trailingIcon: Image(systemName: "xmark.circle.fill")
            )
            
            // Validation states
            RRTextField.standard(
                "Success state",
                text: $text3,
                helperText: "This field is valid"
            )
            
            RRTextField.standard(
                "Error state",
                text: $text4,
                errorText: "This field has an error"
            )
            
            // Secure field
            RRTextField.secure(
                "Password",
                text: $text5,
                leadingIcon: Image(systemName: "lock")
            )
            
            // Multiline
            RRTextField.multiline(
                "Enter your message",
                text: $text6,
                helperText: "Enter a detailed message"
            )
            
            // Different sizes
            VStack {
                RRTextField.standard("Extra Small", text: .constant(""), size: .xs)
                RRTextField.standard("Small", text: .constant(""), size: .sm)
                RRTextField.standard("Medium", text: .constant(""), size: .md)
                RRTextField.standard("Large", text: .constant(""), size: .lg)
                RRTextField.standard("Extra Large", text: .constant(""), size: .xl)
            }
        }
        .padding()
        .previewDisplayName("RRTextField")
    }
}
#endif
