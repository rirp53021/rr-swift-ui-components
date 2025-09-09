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
    
    var color: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
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
                
                HStack(spacing: RRSpacing.sm) {
                    Image(systemName: style.icon)
                        .foregroundColor(style.color)
                        .font(.title3)
                    
                    content
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .padding(RRSpacing.md)
                .background(Color.primary)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            isDragging = false
                            if value.translation.height > 50 {
                                dismiss()
                            } else {
                                withAnimation(.spring()) {
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
            .padding(RRSpacing.md)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(), value: isPresented.wrappedValue)
        }
    }
    
    private func dismiss() {
        withAnimation(.spring()) {
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
            Text(message)
                .foregroundColor(.primary)
        }
    }
    
    public func showError(_ message: String, duration: TimeInterval = 3.0) {
        show(.error, duration: duration) {
            Text(message)
                .foregroundColor(.primary)
        }
    }
    
    public func showWarning(_ message: String, duration: TimeInterval = 3.0) {
        show(.warning, duration: duration) {
            Text(message)
                .foregroundColor(.primary)
        }
    }
    
    public func showInfo(_ message: String, duration: TimeInterval = 3.0) {
        show(.info, duration: duration) {
            Text(message)
                .foregroundColor(.primary)
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
        VStack(spacing: 20) {
            Text("Snackbar Styles")
                .font(.headline)
            
            VStack(spacing: 10) {
                RRSnackbar(.success, isPresented: .constant(true)) {
                    Text("Success message")
                        .foregroundColor(.primary)
                }
                
                RRSnackbar(.error, isPresented: .constant(true)) {
                    Text("Error message")
                        .foregroundColor(.primary)
                }
                
                RRSnackbar(.warning, isPresented: .constant(true)) {
                    Text("Warning message")
                        .foregroundColor(.primary)
                }
                
                RRSnackbar(.info, isPresented: .constant(true)) {
                    Text("Info message")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
    }
}
#endif
