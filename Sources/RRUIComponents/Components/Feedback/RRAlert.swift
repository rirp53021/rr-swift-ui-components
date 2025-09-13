// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Alert Style
@MainActor
public enum AlertStyle {
    case success
    case error
    case warning
    case info
    
    func color(theme: Theme) -> Color {
        switch self {
        case .success: return theme.colors.success
        case .error: return theme.colors.error
        case .warning: return theme.colors.warning
        case .info: return theme.colors.info
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

// MARK: - RRAlert

public struct RRAlert<Content: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let style: AlertStyle
    private let isPresented: Binding<Bool>
    
    public init(
        _ style: AlertStyle,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.isPresented = isPresented
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundColor(style.color(theme: theme))
                    .font(.system(size: DesignTokens.ComponentSize.iconSizeLG))
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    content
                }
                
                Spacer()
                
                Button(action: {
                    isPresented.wrappedValue = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(theme.colors.onSurfaceVariant)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeXS))
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(theme.colors.surface)
            .cornerRadius(DesignTokens.BorderRadius.lg)
            .shadow(
                color: DesignTokens.Elevation.level2.color,
                radius: DesignTokens.Elevation.level2.radius,
                x: DesignTokens.Elevation.level2.x,
                y: DesignTokens.Elevation.level2.y
            )
        }
        .padding(DesignTokens.Spacing.md)
    }
}

// MARK: - Alert Presets

public struct RRSuccessAlert: View {
    private let title: String
    private let message: String?
    private let isPresented: Binding<Bool>
    
    public init(
        title: String,
        message: String? = nil,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.isPresented = isPresented
    }
    
    public var body: some View {
        RRAlert(.success, isPresented: isPresented) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                RRLabel(title, style: .subtitle, weight: .bold, color: .primary)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                if let message = message {
                    RRLabel(message, style: .body, weight: .regular, color: .secondary)
                        .dynamicTypeSize(.large) // Support Dynamic Type
                }
            }
        }
    }
}

public struct RRErrorAlert: View {
    private let title: String
    private let message: String?
    private let isPresented: Binding<Bool>
    
    public init(
        title: String,
        message: String? = nil,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.isPresented = isPresented
    }
    
    public var body: some View {
        RRAlert(.error, isPresented: isPresented) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                RRLabel(title, style: .subtitle, weight: .bold, color: .primary)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                if let message = message {
                    RRLabel(message, style: .body, weight: .regular, color: .secondary)
                        .dynamicTypeSize(.large) // Support Dynamic Type
                }
            }
        }
    }
}

public struct RRWarningAlert: View {
    private let title: String
    private let message: String?
    private let isPresented: Binding<Bool>
    
    public init(
        title: String,
        message: String? = nil,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.isPresented = isPresented
    }
    
    public var body: some View {
        RRAlert(.warning, isPresented: isPresented) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                RRLabel(title, style: .subtitle, weight: .bold, color: .primary)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                if let message = message {
                    RRLabel(message, style: .body, weight: .regular, color: .primary)
                        .dynamicTypeSize(.large) // Support Dynamic Type
                }
            }
        }
    }
}

public struct RRInfoAlert: View {
    private let title: String
    private let message: String?
    private let isPresented: Binding<Bool>
    
    public init(
        title: String,
        message: String? = nil,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.isPresented = isPresented
    }
    
    public var body: some View {
        RRAlert(.info, isPresented: isPresented) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                RRLabel(title, style: .subtitle, weight: .bold, color: .primary)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                if let message = message {
                    RRLabel(message, style: .body, weight: .regular, color: .secondary)
                        .dynamicTypeSize(.large) // Support Dynamic Type
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRAlert_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Alert Styles", style: .subtitle, weight: .bold, color: .primary)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                RRSuccessAlert(
                    title: "Success!",
                    message: "Your action was completed successfully.",
                    isPresented: .constant(true)
                )
                
                RRErrorAlert(
                    title: "Error",
                    message: "Something went wrong. Please try again.",
                    isPresented: .constant(true)
                )
                
                RRWarningAlert(
                    title: "Warning",
                    message: "Please review your input before proceeding.",
                    isPresented: .constant(true)
                )
                
                RRInfoAlert(
                    title: "Information",
                    message: "Here's some helpful information for you.",
                    isPresented: .constant(true)
                )
            }
        }
        .padding(DesignTokens.Spacing.componentPadding)
        .themeProvider(ThemeProvider())
    }
}
#endif
