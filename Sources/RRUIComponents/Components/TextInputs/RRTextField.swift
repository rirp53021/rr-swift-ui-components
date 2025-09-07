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
        case small
        case medium
        case large
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
        size: Size = .medium,
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
            } else if let helperText = helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(helperTextColor)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var textFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: return 6
        case .medium: return 10
        case .large: return 14
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
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
}

// MARK: - Convenience Initializers

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension RRTextField {
    /// Creates a standard text field
    static func standard(
        _ placeholder: String,
        text: Binding<String>,
        size: Size = .medium,
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
        size: Size = .medium,
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
        size: Size = .medium,
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
            HStack {
                RRTextField.standard("Small", text: .constant(""), size: .small)
                RRTextField.standard("Medium", text: .constant(""), size: .medium)
                RRTextField.standard("Large", text: .constant(""), size: .large)
            }
        }
        .padding()
        .previewDisplayName("RRTextField")
    }
}
#endif
