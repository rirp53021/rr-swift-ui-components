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
    case small
    case medium
    case large
    
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: RRSpacing.xs, leading: RRSpacing.sm, bottom: RRSpacing.xs, trailing: RRSpacing.sm)
        case .medium:
            return EdgeInsets(top: RRSpacing.sm, leading: RRSpacing.md, bottom: RRSpacing.sm, trailing: RRSpacing.md)
        case .large:
            return EdgeInsets(top: RRSpacing.md, leading: RRSpacing.lg, bottom: RRSpacing.md, trailing: RRSpacing.lg)
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        }
    }
}

// MARK: - RRButton

public struct RRButton<Label: View>: View {
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
        size: RRButtonSize = .medium,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        enableLogging: Bool = false,
        action: @escaping () -> Void
    ) where Label == Text {
        self.action = action
        self.label = { Text(title) }
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.enableLogging = enableLogging
    }
    
    public init(
        style: RRButtonStyle = .primary,
        size: RRButtonSize = .medium,
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
            HStack(spacing: RRSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    label()
                        .font(size.font)
                }
            }
            .padding(size.padding)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(8)
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private var backgroundColor: Color {
        if !isEnabled {
            return Color.gray.opacity(0.3)
        }
        
        switch style {
        case .primary:
            return Color.blue
        case .secondary:
            return Color.gray.opacity(0.2)
        case .destructive:
            return Color.red
        case .outline:
            return Color.clear
        case .ghost:
            return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        if !isEnabled {
            return Color.gray
        }
        
        switch style {
        case .primary:
            return Color.white
        case .secondary:
            return Color.primary
        case .destructive:
            return Color.white
        case .outline:
            return Color.blue
        case .ghost:
            return Color.blue
        }
    }
    
    private var borderColor: Color {
        if !isEnabled {
            return Color.gray.opacity(0.3)
        }
        
        switch style {
        case .primary, .secondary, .destructive, .ghost:
            return Color.clear
        case .outline:
            return Color.blue
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .secondary, .destructive, .ghost:
            return 0
        case .outline:
            return 1
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Button Styles")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRButton("Primary Button", style: .primary, action: { })
                RRButton("Secondary Button", style: .secondary, action: { })
                RRButton("Destructive Button", style: .destructive, action: { })
                RRButton("Outline Button", style: .outline, action: { })
                RRButton("Ghost Button", style: .ghost, action: { })
            }
            
            Text("Button Sizes")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRButton("Small Button", size: .small, action: { })
                RRButton("Medium Button", size: .medium, action: { })
                RRButton("Large Button", size: .large, action: { })
            }
            
            Text("Button States")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRButton("Enabled Button", action: { })
                RRButton("Disabled Button", isEnabled: false, action: { })
                RRButton("Loading Button", isLoading: true, action: { })
            }
        }
        .padding()
    }
}
#endif
