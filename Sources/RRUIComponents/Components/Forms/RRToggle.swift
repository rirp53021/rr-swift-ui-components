// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Toggle Style

public enum ToggleStyle {
    case standard
    case custom
    case toggleSwitch
}

// MARK: - RRToggle

public struct RRToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let style: ToggleStyle
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        style: ToggleStyle = .standard,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.style = style
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            if let title = title {
                Text(title)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(Color(DesignTokens.Colors.neutral900))
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Button(action: {
                isOn.toggle()
                onToggle(isOn)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.lg)
                        .fill(isOn ? Color(DesignTokens.Colors.primary600) : Color(DesignTokens.Colors.neutral300))
                        .frame(width: DesignTokens.ComponentSize.toggleWidth, height: DesignTokens.ComponentSize.toggleHeight)
                    
                    Circle()
                        .fill(Color(DesignTokens.Colors.neutral50))
                        .frame(width: DesignTokens.ComponentSize.toggleThumbSize, height: DesignTokens.ComponentSize.toggleThumbSize)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.spring(response: DesignTokens.Animation.durationNormal), value: isOn)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Custom Toggle

public struct RRCustomToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            if let title = title {
                Text(title)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(Color(DesignTokens.Colors.neutral900))
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Button(action: {
                isOn.toggle()
                onToggle(isOn)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm)
                        .fill(isOn ? Color(DesignTokens.Colors.primary600) : Color(DesignTokens.Colors.neutral300))
                        .frame(width: DesignTokens.ComponentSize.toggleWidthSmall, height: DesignTokens.ComponentSize.toggleHeightSmall)
                    
                    Circle()
                        .fill(Color(DesignTokens.Colors.neutral50))
                        .frame(width: DesignTokens.ComponentSize.toggleThumbSizeSmall, height: DesignTokens.ComponentSize.toggleThumbSizeSmall)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.spring(response: DesignTokens.Animation.durationNormal), value: isOn)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .keyboardNavigation(
            config: .button,
            onActivate: {
                isOn.toggle()
                onToggle(isOn)
            }
        )
        .keyboardNavigationAccessibility(config: .button)
    }
}

// MARK: - Switch Toggle

public struct RRSwitchToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            if let title = title {
                Text(title)
                    .font(DesignTokens.Typography.bodyMedium)
                    .foregroundColor(Color(DesignTokens.Colors.neutral900))
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { newValue in
                    onToggle(newValue)
                }
        }
        .keyboardNavigation(
            config: .button,
            onActivate: {
                isOn.toggle()
                onToggle(isOn)
            }
        )
        .keyboardNavigationAccessibility(config: .button)
    }
}

// MARK: - Preview

#if DEBUG
struct RRToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Toggle Styles")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 15) {
                RRToggle(isOn: .constant(true), title: "Standard Toggle")
                RRCustomToggle(isOn: .constant(false), title: "Custom Toggle")
                RRSwitchToggle(isOn: .constant(true), title: "Switch Toggle")
            }
        }
        .padding()
    }
}
#endif
