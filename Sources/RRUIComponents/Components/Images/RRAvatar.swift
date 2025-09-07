import SwiftUI

/// An avatar component with image, initials fallback, and various styles
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct RRAvatar: View {
    public enum Size {
        case small
        case medium
        case large
        case extraLarge
        
        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 48
            case .large: return 64
            case .extraLarge: return 96
            }
        }
    }
    
    public enum Style {
        case circle
        case rounded
        case square
    }
    
    private let image: Image?
    private let initials: String?
    private let size: Size
    private let style: Style
    private let backgroundColor: Color?
    private let borderColor: Color?
    private let borderWidth: CGFloat
    
    public init(
        image: Image? = nil,
        initials: String? = nil,
        size: Size = .medium,
        style: Style = .circle,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) {
        self.image = image
        self.initials = initials
        self.size = size
        self.style = style
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    public var body: some View {
        ZStack {
            // Background
            backgroundShape
                .fill(avatarBackgroundColor)
            
            // Content
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(contentShape)
            } else if let initials = initials, !initials.isEmpty {
                Text(initials)
                    .font(initialsFont)
                    .fontWeight(.semibold)
                    .foregroundColor(initialsColor)
            } else {
                // Default icon when no image or initials
                Image(systemName: "person.fill")
                    .font(iconFont)
                    .foregroundColor(iconColor)
            }
        }
        .frame(width: size.dimension, height: size.dimension)
        .overlay(
            backgroundShape
                .stroke(borderColor ?? Color.clear, lineWidth: borderWidth)
        )
        .clipShape(backgroundShape)
    }
    
    // MARK: - Computed Properties
    
    private var backgroundShape: AnyShape {
        switch style {
        case .circle:
            return AnyShape(Circle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: size.dimension * 0.2))
        case .square:
            return AnyShape(RoundedRectangle(cornerRadius: size.dimension * 0.1))
        }
    }
    
    private var contentShape: AnyShape {
        switch style {
        case .circle:
            return AnyShape(Circle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: size.dimension * 0.2))
        case .square:
            return AnyShape(RoundedRectangle(cornerRadius: size.dimension * 0.1))
        }
    }
    
    private var initialsFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        case .extraLarge: return .title
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        case .extraLarge: return .title
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var avatarBackgroundColor: Color {
        if let backgroundColor = backgroundColor {
            return backgroundColor
        }
        
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        return scheme.primary
    }
    
    private var initialsColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        return .white
    }
    
    private var iconColor: Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        return scheme.neutral.textSecondary
    }
}

// MARK: - Convenience Initializers

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension RRAvatar {
    /// Creates an avatar with an image
    static func image(
        _ image: Image,
        size: Size = .medium,
        style: Style = .circle,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) -> RRAvatar {
        RRAvatar(
            image: image,
            size: size,
            style: style,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
    
    /// Creates an avatar with initials
    static func initials(
        _ initials: String,
        size: Size = .medium,
        style: Style = .circle,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) -> RRAvatar {
        RRAvatar(
            initials: initials,
            size: size,
            style: style,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
    
    /// Creates an avatar with a name (extracts initials automatically)
    static func name(
        _ name: String,
        size: Size = .medium,
        style: Style = .circle,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) -> RRAvatar {
        let initials = extractInitials(from: name)
        return RRAvatar(
            initials: initials,
            size: size,
            style: style,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
    
    /// Creates a placeholder avatar
    static func placeholder(
        size: Size = .medium,
        style: Style = .circle,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0
    ) -> RRAvatar {
        RRAvatar(
            size: size,
            style: style,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
}

// MARK: - Helper Functions

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private extension RRAvatar {
    static func extractInitials(from name: String) -> String {
        let components = name.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        switch components.count {
        case 0:
            return ""
        case 1:
            return String(components[0].prefix(2)).uppercased()
        default:
            let firstInitial = String(components[0].prefix(1))
            let lastInitial = String(components[components.count - 1].prefix(1))
            return (firstInitial + lastInitial).uppercased()
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct RRAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Different sizes
            HStack(spacing: 16) {
                RRAvatar.initials("AB", size: .small)
                RRAvatar.initials("AB", size: .medium)
                RRAvatar.initials("AB", size: .large)
                RRAvatar.initials("AB", size: .extraLarge)
            }
            
            // Different styles
            HStack(spacing: 16) {
                RRAvatar.initials("AB", style: .circle)
                RRAvatar.initials("AB", style: .rounded)
                RRAvatar.initials("AB", style: .square)
            }
            
            // With names (auto-extract initials)
            HStack(spacing: 16) {
                RRAvatar.name("John Doe")
                RRAvatar.name("Jane Smith")
                RRAvatar.name("Bob")
            }
            
            // With custom colors
            HStack(spacing: 16) {
                RRAvatar.initials("AB", backgroundColor: .blue)
                RRAvatar.initials("CD", backgroundColor: .green)
                RRAvatar.initials("EF", backgroundColor: .orange)
            }
            
            // With borders
            HStack(spacing: 16) {
                RRAvatar.initials("AB", borderColor: .blue, borderWidth: 2)
                RRAvatar.initials("CD", borderColor: .green, borderWidth: 2)
                RRAvatar.initials("EF", borderColor: .orange, borderWidth: 2)
            }
            
            // Placeholder avatars
            HStack(spacing: 16) {
                RRAvatar.placeholder()
                RRAvatar.placeholder(size: .large)
                RRAvatar.placeholder(style: .rounded)
            }
        }
        .padding()
        .previewDisplayName("RRAvatar")
    }
}
#endif
