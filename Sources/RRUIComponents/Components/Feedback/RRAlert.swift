// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Alert Style

public enum AlertStyle {
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

// MARK: - RRAlert

public struct RRAlert<Content: View>: View {
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
        VStack(spacing: RRSpacing.md) {
            HStack {
                Image(systemName: style.icon)
                    .foregroundColor(style.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: RRSpacing.xs) {
                    content
                }
                
                Spacer()
                
                Button(action: {
                    isPresented.wrappedValue = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(RRSpacing.md)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(RRSpacing.md)
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
            VStack(alignment: .leading, spacing: RRSpacing.xs) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let message = message {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
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
            VStack(alignment: .leading, spacing: RRSpacing.xs) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let message = message {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
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
            VStack(alignment: .leading, spacing: RRSpacing.xs) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let message = message {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
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
            VStack(alignment: .leading, spacing: RRSpacing.xs) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let message = message {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRAlert_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Alert Styles")
                .font(.headline)
            
            VStack(spacing: 10) {
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
        .padding()
    }
}
#endif
