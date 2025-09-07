import SwiftUI

/// A reusable empty state component with illustration, text, and action button
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RREmptyState<Action: View>: View {
    // MARK: - Properties
    
    private let illustration: Image?
    private let title: String
    private let subtitle: String?
    private let action: Action?
    private let style: EmptyStateStyle
    private let spacing: CGFloat
    private let padding: EdgeInsets
    private let backgroundColor: Color?
    
    // MARK: - Initialization
    
    public init(
        illustration: Image? = nil,
        title: String,
        subtitle: String? = nil,
        style: EmptyStateStyle = .standard,
        spacing: CGFloat = 24,
        padding: EdgeInsets = EdgeInsets(top: 40, leading: 32, bottom: 40, trailing: 32),
        backgroundColor: Color? = nil,
        action: (() -> Action)? = nil
    ) {
        self.illustration = illustration
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.action = action?()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: spacing) {
            // Illustration
            if let illustration = illustration {
                illustration
                    .foregroundColor(style.illustrationColor)
                    .font(.system(size: style.illustrationSize))
                    .frame(width: style.illustrationSize, height: style.illustrationSize)
            } else {
                defaultIllustration
            }
            
            // Content
            VStack(spacing: 8) {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(style.subtitleFont)
                        .foregroundColor(style.subtitleColor)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Action
            if let action = action {
                action
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(style.cornerRadius)
    }
    
    // MARK: - Default Illustration
    
    private var defaultIllustration: some View {
        Image(systemName: style.defaultIcon)
            .foregroundColor(style.illustrationColor)
            .font(.system(size: style.illustrationSize))
            .frame(width: style.illustrationSize, height: style.illustrationSize)
    }
}

// MARK: - Empty State Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RREmptyState {
    enum EmptyStateStyle {
        case standard
        case compact
        case prominent
        case minimal
        
        var titleFont: Font {
            switch self {
            case .standard, .compact:
                return .title2
            case .prominent:
                return .largeTitle
            case .minimal:
                return .headline
            }
        }
        
        var subtitleFont: Font {
            switch self {
            case .standard, .compact, .prominent:
                return .body
            case .minimal:
                return .caption
            }
        }
        
        var titleColor: Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return .primary
            }
        }
        
        var subtitleColor: Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return .secondary
            }
        }
        
        var illustrationColor: Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return .secondary
            }
        }
        
        var illustrationSize: CGFloat {
            switch self {
            case .standard:
                return 80
            case .compact:
                return 60
            case .prominent:
                return 120
            case .minimal:
                return 40
            }
        }
        
        var defaultIcon: String {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return "tray"
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard, .compact, .prominent:
                return 12
            case .minimal:
                return 8
            }
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RREmptyState where Action == EmptyView {
    init(
        illustration: Image? = nil,
        title: String,
        subtitle: String? = nil,
        style: EmptyStateStyle = .standard,
        spacing: CGFloat = 24,
        padding: EdgeInsets = EdgeInsets(top: 40, leading: 32, bottom: 40, trailing: 32),
        backgroundColor: Color? = nil
    ) {
        self.init(
            illustration: illustration,
            title: title,
            subtitle: subtitle,
            style: style,
            spacing: spacing,
            padding: padding,
            backgroundColor: backgroundColor,
            action: nil
        )
    }
}


// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RREmptyState_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Standard empty state
                VStack(spacing: 16) {
                    Text("Standard Empty State")
                        .font(.headline)
                    
                    RREmptyState(
                        illustration: Image(systemName: "tray"),
                        title: "No Items",
                        subtitle: "There are no items to display at the moment.",
                        style: .standard
                    ) {
                        Button("Add Item") {
                            print("Add item tapped")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                
                // Predefined empty states
                VStack(spacing: 16) {
                    Text("Predefined Empty States")
                        .font(.headline)
                    
                    RREmptyState(
                        illustration: Image(systemName: "tray"),
                        title: "No Data",
                        subtitle: "There's nothing to show here yet.",
                        style: .standard
                    ) {
                        Button("Refresh") {
                            print("Refresh tapped")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    
                    RREmptyState(
                        illustration: Image(systemName: "magnifyingglass"),
                        title: "No Results",
                        subtitle: "Try adjusting your search terms.",
                        style: .standard
                    ) {
                        Button("Clear Search") {
                            print("Clear search tapped")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    RREmptyState(
                        illustration: Image(systemName: "wifi.slash"),
                        title: "Connection Error",
                        subtitle: "Check your internet connection and try again.",
                        style: .standard
                    ) {
                        Button("Retry") {
                            print("Retry tapped")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
                
                // Different styles
                VStack(spacing: 16) {
                    Text("Different Styles")
                        .font(.headline)
                    
                    RREmptyState(
                        title: "Compact Style",
                        subtitle: "This is a compact empty state.",
                        style: .compact
                    )
                    
                    RREmptyState(
                        title: "Prominent Style",
                        subtitle: "This is a prominent empty state with larger text.",
                        style: .prominent
                    )
                    
                    RREmptyState(
                        title: "Minimal Style",
                        subtitle: "This is a minimal empty state.",
                        style: .minimal
                    )
                }
                
                // Custom empty state
                VStack(spacing: 16) {
                    Text("Custom Empty State")
                        .font(.headline)
                    
                    RREmptyState(
                        illustration: Image(systemName: "star.fill"),
                        title: "Custom State",
                        subtitle: "This is a custom empty state with a star icon.",
                        style: .standard,
                        backgroundColor: Color(.systemGray6)
                    ) {
                        HStack(spacing: 12) {
                            Button("Cancel") {
                                print("Cancel tapped")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray5))
                            .cornerRadius(6)
                            
                            Button("Continue") {
                                print("Continue tapped")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                    }
                }
            }
            .padding()
        }
        .previewDisplayName("RREmptyState Examples")
    }
}
#endif
