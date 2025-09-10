// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Button Style

public enum RRButtonStyle {
    case primary
    case secondary
    case destructive
    case outline
    case ghost
}

// MARK: - Button Size

public enum RRButtonSize {
    case xs
    case sm
    case md
    case lg
    case xl
    
    var height: CGFloat {
        switch self {
        case .xs: return DesignTokens.ComponentSize.buttonHeightXS
        case .sm: return DesignTokens.ComponentSize.buttonHeightSM
        case .md: return DesignTokens.ComponentSize.buttonHeightMD
        case .lg: return DesignTokens.ComponentSize.buttonHeightLG
        case .xl: return DesignTokens.ComponentSize.buttonHeightXL
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
        case .xs: return DesignTokens.Typography.labelSmall
        case .sm: return DesignTokens.Typography.labelMedium
        case .md: return DesignTokens.Typography.labelLarge
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

// MARK: - RRButton

public struct RRButton<Label: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private let action: () -> Void
    private let label: () -> Label
    private let style: RRButtonStyle
    private let size: RRButtonSize
    private let isEnabled: Bool
    private let isLoading: Bool
    private let enableLogging: Bool
    
    public init(
        _ title: String,
        style: RRButtonStyle = .primary,
        size: RRButtonSize = .md,
        textColor: SwiftUI.Color? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        enableLogging: Bool = false,
        action: @escaping () -> Void
    ) where Label == RRLabel {
        self.action = action
        self.label = { RRLabel(title, style: .body, weight: .medium, customColor: textColor ?? .white) }
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.enableLogging = enableLogging
    }
    
    public init(
        style: RRButtonStyle = .primary,
        size: RRButtonSize = .md,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        enableLogging: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.label = label
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.enableLogging = enableLogging
    }
    
    public var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(foregroundColor)
                        } else {
                            label()
                        }
            }
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.button)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            .cornerRadius(DesignTokens.BorderRadius.button)
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(DesignTokens.Animation.buttonPress, value: isEnabled)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(accessibilityTraits)
        .minimumTouchTarget() // Ensure WCAG touch target compliance
        .keyboardNavigation(
            config: .button,
            onActivate: { action() },
            onCancel: { /* Button doesn't have cancel action */ }
        )
        .keyboardNavigationAccessibility(config: .button)
    }
    
    private var backgroundColor: Color {
        let theme = themeProvider.currentTheme
        
        if !isEnabled {
            return theme.colors.disabled
        }
        
        switch style {
        case .primary:
            return theme.colors.primary
        case .secondary:
            return theme.colors.secondary
        case .destructive:
            return theme.colors.error
        case .outline:
            return theme.colors.surface
        case .ghost:
            return theme.colors.surface
        }
    }
    
    private var foregroundColor: Color {
        let theme = themeProvider.currentTheme
        
        if !isEnabled {
            return theme.colors.onSurface
        }
        
        switch style {
        case .primary:
            return theme.colors.onPrimary
        case .secondary:
            return theme.colors.onSurface
        case .destructive:
            return theme.colors.onError
        case .outline:
            return theme.colors.primary
        case .ghost:
            return theme.colors.primary
        }
    }
    
    private var borderColor: Color {
        let theme = themeProvider.currentTheme
        
        if !isEnabled {
            return theme.colors.disabled
        }
        
        switch style {
        case .primary, .secondary, .destructive:
            return Color.clear
        case .outline:
            return theme.colors.outline
        case .ghost:
            return theme.colors.outlineVariant
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .secondary, .destructive:
            return 0
        case .outline:
            return 1
        case .ghost:
            return 1
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        if isLoading {
            return "Loading"
        }
        
        // For now, return a generic button label
        // In a real implementation, you might want to pass the label text explicitly
        return "Button"
    }
    
    private var accessibilityHint: String {
        if !isEnabled {
            return "Button is disabled"
        }
        
        if isLoading {
            return "Button is loading, please wait"
        }
        
        switch style {
        case .primary:
            return "Primary action button"
        case .secondary:
            return "Secondary action button"
        case .destructive:
            return "Destructive action button"
        case .outline:
            return "Outlined action button"
        case .ghost:
            return "Ghost action button"
        }
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = [.isButton]
        
        if isLoading {
            _ = traits.insert(.updatesFrequently)
        }
        
        return traits
    }
    
    // MARK: - WCAG Compliance
    
    /// Validate WCAG color contrast compliance for this button
    /// - Returns: The WCAG compliance status
    public func validateWCAGCompliance() -> WCAGCompliance {
        return AccessibilityUtils.wcagCompliance(
            foreground: foregroundColor,
            background: backgroundColor
        )
    }
    
    /// Check if this button meets WCAG AA contrast requirements
    /// - Returns: True if the button meets WCAG AA requirements
    public func meetsWCAGAA() -> Bool {
        return AccessibilityUtils.meetsWCAGContrast(
            foreground: foregroundColor,
            background: backgroundColor,
            level: .AA
        )
    }
}

// MARK: - Preview

#if DEBUG
struct RRButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 8) {
                    Text("Button Styles - Light Mode")
                        .font(.headline)
                    
                    VStack(spacing: 4) {
                        RRButton("Primary Button", style: .primary, action: { })
                        RRButton("Secondary Button", style: .secondary, action: { })
                        RRButton("Destructive Button", style: .destructive, action: { })
                        RRButton("Outline Button", style: .outline, action: { })
                        RRButton("Ghost Button", style: .ghost, action: { })
                    }
                    
                    Text("Button Sizes")
                        .font(.headline)
                    
                    VStack(spacing: 4) {
                        RRButton("XS Button", size: .xs, action: { })
                        RRButton("SM Button", size: .sm, action: { })
                        RRButton("MD Button", size: .md, action: { })
                        RRButton("LG Button", size: .lg, action: { })
                        RRButton("XL Button", size: .xl, action: { })
                    }
                    
                    Text("Button States")
                        .font(.headline)
                    
                    VStack(spacing: 4) {
                        RRButton("Enabled Button", action: { })
                        RRButton("Disabled Button", isEnabled: false, action: { })
                        RRButton("Loading Button", isLoading: true, action: { })
                    }
                    
                    Text("Custom Text Colors")
                        .font(.headline)
                    
                    VStack(spacing: 4) {
                        RRButton("Blue Text", textColor: .blue, action: { })
                        RRButton("Green Text", textColor: .green, action: { })
                        RRButton("Purple Text", textColor: .purple, action: { })
                        RRButton("Design System White", textColor: .white, action: { })
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            .adaptiveThemeProvider(ThemeProvider())
        }
    }
}
#endif
