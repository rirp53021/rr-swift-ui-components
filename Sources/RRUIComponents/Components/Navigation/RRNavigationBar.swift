// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Navigation Bar Style

public enum NavigationBarStyle {
    case standard
    case large
    case compact
}

// MARK: - RRNavigationBar

public struct RRNavigationBar: View {
    private let title: String
    private let style: NavigationBarStyle
    private let leadingButton: (() -> AnyView)?
    private let trailingButton: (() -> AnyView)?
    private let onLeadingButtonTap: () -> Void
    private let onTrailingButtonTap: () -> Void
    
    public init(
        title: String,
        style: NavigationBarStyle = .standard,
        leadingButton: (() -> AnyView)? = nil,
        trailingButton: (() -> AnyView)? = nil,
        onLeadingButtonTap: @escaping () -> Void = {},
        onTrailingButtonTap: @escaping () -> Void = {}
    ) {
        self.title = title
        self.style = style
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.onLeadingButtonTap = onLeadingButtonTap
        self.onTrailingButtonTap = onTrailingButtonTap
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                if let leadingButton = leadingButton {
                    Button(action: onLeadingButtonTap) {
                        leadingButton()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Spacer()
                        .frame(width: 44)
                }
                
                Spacer()
                
                Text(title)
                    .font(style == .large ? .largeTitle : .headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                Spacer()
                
                if let trailingButton = trailingButton {
                    Button(action: onTrailingButtonTap) {
                        trailingButton()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Spacer()
                        .frame(width: 44)
                }
            }
            .padding(.horizontal, RRSpacing.md)
            .padding(.vertical, RRSpacing.sm)
            .background(Color.primary)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        }
    }
}

// MARK: - Action Button View

public struct ActionButtonView: View {
    private let icon: String
    private let action: () -> Void
    
    public init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Navigation Bar Styles")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRNavigationBar(
                    title: "Standard Title",
                    style: .standard,
                    leadingButton: {
                        AnyView(ActionButtonView(icon: "chevron.left") {})
                    },
                    trailingButton: {
                        AnyView(ActionButtonView(icon: "ellipsis") {})
                    }
                )
                
                RRNavigationBar(
                    title: "Large Title",
                    style: .large,
                    leadingButton: {
                        AnyView(ActionButtonView(icon: "chevron.left") {})
                    },
                    trailingButton: {
                        AnyView(ActionButtonView(icon: "ellipsis") {})
                    }
                )
                
                RRNavigationBar(
                    title: "Compact Title",
                    style: .compact,
                    leadingButton: {
                        AnyView(ActionButtonView(icon: "chevron.left") {})
                    },
                    trailingButton: {
                        AnyView(ActionButtonView(icon: "ellipsis") {})
                    }
                )
            }
        }
        .padding()
    }
}
#endif
