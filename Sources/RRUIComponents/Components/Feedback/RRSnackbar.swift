// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Combine
import Foundation

// MARK: - Snackbar Style

public enum SnackbarStyle {
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

// MARK: - RRSnackbar

public struct RRSnackbar<Content: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let style: SnackbarStyle
    private let duration: TimeInterval
    private let isPresented: Binding<Bool>
    private let onDismiss: (() -> Void)?
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    public init(
        _ style: SnackbarStyle,
        duration: TimeInterval = 3.0,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.duration = duration
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    public var body: some View {
        if isPresented.wrappedValue {
            VStack {
                Spacer()
                
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: style.icon)
                        .foregroundColor(style.color(theme: theme))
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeLG))
                    
                    content
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
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
                    color: DesignTokens.Elevation.level3.color,
                    radius: DesignTokens.Elevation.level3.radius,
                    x: DesignTokens.Elevation.level3.x,
                    y: DesignTokens.Elevation.level3.y
                )
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            isDragging = false
                            if value.translation.height > DesignTokens.ComponentSize.buttonHeightLG {
                                dismiss()
                            } else {
                                withAnimation(DesignTokens.Animation.spring) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .onAppear {
                    if duration > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            if !isDragging {
                                dismiss()
                            }
                        }
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(DesignTokens.Animation.spring, value: isPresented.wrappedValue)
        }
    }
    
    private func dismiss() {
        withAnimation(DesignTokens.Animation.spring) {
            isPresented.wrappedValue = false
        }
        onDismiss?()
    }
}

// MARK: - Snackbar Manager

public class RRSnackbarManager: ObservableObject {
    public static let shared = RRSnackbarManager()
    
    @Published public var isPresented = false
    @Published public var currentSnackbar: AnyView?
    
    private init() {}
    
    public func show<Content: View>(
        _ style: SnackbarStyle,
        duration: TimeInterval = 3.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        currentSnackbar = AnyView(
            RRSnackbar(style, duration: duration, isPresented: .constant(true)) {
                content()
            }
        )
        isPresented = true
    }
    
    public func showSuccess(_ message: String, duration: TimeInterval = 3.0) {
        show(.success, duration: duration) {
            RRLabel(message, style: .body, weight: .medium, color: .primary)
        }
    }
    
    public func showError(_ message: String, duration: TimeInterval = 3.0) {
        show(.error, duration: duration) {
            RRLabel(message, style: .body, weight: .medium, color: .primary)
        }
    }
    
    public func showWarning(_ message: String, duration: TimeInterval = 3.0) {
        show(.warning, duration: duration) {
            RRLabel(message, style: .body, weight: .medium, color: .primary)
        }
    }
    
    public func showInfo(_ message: String, duration: TimeInterval = 3.0) {
        show(.info, duration: duration) {
            RRLabel(message, style: .body, weight: .medium, color: .primary)
        }
    }
    
    public func dismiss() {
        isPresented = false
    }
}

// MARK: - Preview

#if DEBUG
struct RRSnackbar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Snackbar Styles", style: .title, weight: .bold, color: .primary)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                RRSnackbar(.success, isPresented: .constant(true)) {
                    RRLabel("Success message", style: .body, weight: .medium, color: .primary)
                }
                
                RRSnackbar(.error, isPresented: .constant(true)) {
                    RRLabel("Error message", style: .body, weight: .medium, color: .primary)
                }
                
                RRSnackbar(.warning, isPresented: .constant(true)) {
                    RRLabel("Warning message", style: .body, weight: .medium, color: .primary)
                }
                
                RRSnackbar(.info, isPresented: .constant(true)) {
                    RRLabel("Info message", style: .body, weight: .medium, color: .primary)
                }
            }
        }
        .padding(DesignTokens.Spacing.componentPadding)
        .themeProvider(ThemeProvider())
    }
}
#endif
