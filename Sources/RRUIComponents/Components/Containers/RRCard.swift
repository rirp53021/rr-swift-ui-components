import SwiftUI

/// A reusable card component with customizable styling and content slots
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCard<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let style: CardStyle
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowOffset: CGSize
    private let shadowColor: Color
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    
    // MARK: - Initialization
    
    public init(
        style: CardStyle = .standard,
        padding: EdgeInsets = RRSpacing.paddingMD,
        cornerRadius: CGFloat? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        shadowColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius ?? style.cornerRadius
        self.shadowRadius = shadowRadius ?? style.shadowRadius
        self.shadowOffset = shadowOffset ?? style.shadowOffset
        self.shadowColor = shadowColor ?? style.shadowColor
        self.backgroundColor = backgroundColor ?? style.backgroundColor
        self.borderColor = borderColor ?? style.borderColor
        self.borderWidth = borderWidth ?? style.borderWidth
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}

// MARK: - Card Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRCard {
    enum CardStyle {
        case standard
        case elevated
        case outlined
        case filled
        case flat
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard, .elevated, .filled:
                return 12
            case .outlined, .flat:
                return 8
            }
        }
        
        var shadowRadius: CGFloat {
            switch self {
            case .standard:
                return 4
            case .elevated:
                return 8
            case .outlined, .filled, .flat:
                return 0
            }
        }
        
        var shadowOffset: CGSize {
            switch self {
            case .standard:
                return CGSize(width: 0, height: 2)
            case .elevated:
                return CGSize(width: 0, height: 4)
            case .outlined, .filled, .flat:
                return CGSize(width: 0, height: 0)
            }
        }
        
        var shadowColor: Color {
            switch self {
            case .standard, .elevated:
                return Color.black.opacity(0.1)
            case .outlined, .filled, .flat:
                return Color.clear
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .standard, .elevated, .flat:
                return Color(.systemBackground)
            case .outlined:
                return Color.clear
            case .filled:
                return Color(.secondarySystemBackground)
            }
        }
        
        var borderColor: Color {
            switch self {
            case .standard, .elevated, .filled, .flat:
                return Color.clear
            case .outlined:
                return Color(.separator)
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .standard, .elevated, .filled, .flat:
                return 0
            case .outlined:
                return 1
            }
        }
    }
}

// MARK: - Card with Header/Footer

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCardWithSlots<Header: View, Content: View, Footer: View>: View {
    private let header: Header?
    private let content: Content
    private let footer: Footer?
    private let style: RRCard<Content>.CardStyle
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowOffset: CGSize
    private let shadowColor: Color
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    
    public init(
        style: RRCard<Content>.CardStyle = .standard,
        padding: EdgeInsets = RRSpacing.paddingMD,
        cornerRadius: CGFloat? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        shadowColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        header: (() -> Header)? = nil,
        @ViewBuilder content: () -> Content,
        footer: (() -> Footer)? = nil
    ) {
        self.header = header?()
        self.content = content()
        self.footer = footer?()
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius ?? style.cornerRadius
        self.shadowRadius = shadowRadius ?? style.shadowRadius
        self.shadowOffset = shadowOffset ?? style.shadowOffset
        self.shadowColor = shadowColor ?? style.shadowColor
        self.backgroundColor = backgroundColor ?? style.backgroundColor
        self.borderColor = borderColor ?? style.borderColor
        self.borderWidth = borderWidth ?? style.borderWidth
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header = header {
                header
                    .padding(.horizontal, padding.leading)
                    .padding(.top, padding.top)
            }
            
            content
                .padding(.horizontal, padding.leading)
                .padding(.vertical, header != nil || footer != nil ? RRSpacing.sm : padding.top)
            
            if let footer = footer {
                footer
                    .padding(.horizontal, padding.leading)
                    .padding(.bottom, padding.bottom)
            }
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: shadowOffset.width,
            y: shadowOffset.height
        )
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: RRSpacing.lg) {
                // Basic cards
                VStack(spacing: RRSpacing.md) {
                    Text("Basic Cards")
                        .font(.headline)
                    
                    RRCard {
                        VStack(alignment: .leading, spacing: RRSpacing.sm) {
                            Text("Standard Card")
                                .font(.headline)
                            Text("This is a standard card with default styling.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    RRCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: RRSpacing.sm) {
                            Text("Elevated Card")
                                .font(.headline)
                            Text("This card has a more prominent shadow.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    RRCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: RRSpacing.sm) {
                            Text("Outlined Card")
                                .font(.headline)
                            Text("This card has a border instead of shadow.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Card with slots
                VStack(spacing: RRSpacing.md) {
                    Text("Cards with Header/Footer")
                        .font(.headline)
                    
                    RRCardWithSlots(
                        header: {
                            HStack {
                                Text("Header")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.secondary)
                            }
                        },
                        content: {
                            VStack(alignment: .leading, spacing: RRSpacing.sm) {
                                Text("Card Content")
                                    .font(.subheadline)
                                Text("This card has both header and footer sections.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        },
                        footer: {
                            HStack {
                                Button("Cancel") { }
                                    .foregroundColor(.secondary)
                                Spacer()
                                Button("Save") { }
                                    .foregroundColor(.blue)
                            }
                        }
                    )
                }
            }
            .padding(RRSpacing.paddingMD)
        }
        .previewDisplayName("RRCard Examples")
    }
}
#endif