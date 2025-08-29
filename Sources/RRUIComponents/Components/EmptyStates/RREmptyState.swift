import SwiftUI

/// A customizable empty state component for when there's no content to display
public struct RREmptyState: View {
    /// The empty state style
    public enum Style: Equatable {
        case info
        case warning
        case error
        case success
        case custom(Color)
        
        public static func == (lhs: Style, rhs: Style) -> Bool {
            switch (lhs, rhs) {
            case (.info, .info), (.warning, .warning), (.error, .error), (.success, .success):
                return true
            case (.custom(let lhsColor), .custom(let rhsColor)):
                return lhsColor == rhsColor
            default:
                return false
            }
        }
    }
    
    /// The empty state size
    public enum Size {
        case small
        case medium
        case large
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 48
            case .medium: return 64
            case .large: return 80
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            }
        }
    }
    
    /// The icon to display
    public let icon: Image?
    /// The title text
    public let title: String
    /// The subtitle text (optional)
    public let subtitle: String?
    /// The primary action button (optional)
    public let primaryAction: RRButton?
    /// The secondary action button (optional)
    public let secondaryAction: RRButton?
    /// The style of the empty state
    public let style: Style
    /// The size of the empty state
    public let size: Size
    
    /// Creates a new empty state
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    ///   - style: The style of the empty state
    ///   - size: The size of the empty state
    public init(
        icon: Image? = nil,
        title: String,
        subtitle: String? = nil,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil,
        style: Style = .info,
        size: Size = .medium
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.style = style
        self.size = size
    }
    
    public var body: some View {
        VStack(spacing: size.spacing) {
            // Icon
            if let icon = icon {
                icon
                    .font(.system(size: size.iconSize))
                    .foregroundColor(iconColor)
                    .frame(width: size.iconSize, height: size.iconSize)
            }
            
            // Title
            Text(title)
                .font(size == .small ? .headline : .title2)
                .fontWeight(.semibold)
                .foregroundColor(titleColor)
                .multilineTextAlignment(.center)
            
            // Subtitle
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(size == .small ? .body : .body)
                    .foregroundColor(subtitleColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }
            
            // Actions
            if primaryAction != nil || secondaryAction != nil {
                VStack(spacing: Spacing.sm) {
                    if let primaryAction = primaryAction {
                        primaryAction
                    }
                    
                    if let secondaryAction = secondaryAction {
                        secondaryAction
                    }
                }
                .padding(.top, Spacing.sm)
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
    
    // MARK: - Private Properties
    @Environment(\.themeManager) private var themeManager
    
    private var iconColor: Color {
        switch style {
        case .info:
            return themeManager.colorScheme.semantic.info
        case .warning:
            return themeManager.colorScheme.semantic.warning
        case .error:
            return themeManager.colorScheme.semantic.error
        case .success:
            return themeManager.colorScheme.semantic.success
        case .custom(let color):
            return color
        }
    }
    
    private var titleColor: Color {
        themeManager.colorScheme.neutral.text
    }
    
    private var subtitleColor: Color {
        themeManager.colorScheme.neutral.textSecondary
    }
    
    private var backgroundColor: Color {
        themeManager.colorScheme.neutral.background
    }
}

// MARK: - Convenience Initializers
public extension RREmptyState {
    /// Creates an info empty state
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    ///   - size: The size of the empty state
    static func info(
        icon: Image? = nil,
        title: String,
        subtitle: String? = nil,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil,
        size: Size = .medium
    ) -> RREmptyState {
        RREmptyState(
            icon: icon,
            title: title,
            subtitle: subtitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .info,
            size: size
        )
    }
    
    /// Creates a warning empty state
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    ///   - size: The size of the empty state
    static func warning(
        icon: Image? = nil,
        title: String,
        subtitle: String? = nil,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil,
        size: Size = .medium
    ) -> RREmptyState {
        RREmptyState(
            icon: icon,
            title: title,
            subtitle: subtitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .warning,
            size: size
        )
    }
    
    /// Creates an error empty state
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    ///   - size: The size of the empty state
    static func error(
        icon: Image? = nil,
        title: String,
        subtitle: String? = nil,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil,
        size: Size = .medium
    ) -> RREmptyState {
        RREmptyState(
            icon: icon,
            title: title,
            subtitle: subtitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .error,
            size: size
        )
    }
    
    /// Creates a success empty state
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    ///   - size: The size of the empty state
    static func success(
        icon: Image? = nil,
        title: String,
        subtitle: String? = nil,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil,
        size: Size = .medium
    ) -> RREmptyState {
        RREmptyState(
            icon: icon,
            title: title,
            subtitle: subtitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .success,
            size: size
        )
    }
}

// MARK: - Common Empty States
public extension RREmptyState {
    /// Empty state for no search results
    /// - Parameters:
    ///   - query: The search query that returned no results
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    static func noSearchResults(
        query: String,
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil
    ) -> RREmptyState {
        RREmptyState(
            icon: Image(systemName: "magnifyingglass"),
            title: "No results found",
            subtitle: "No results found for \"\(query)\". Try adjusting your search terms.",
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .info
        )
    }
    
    /// Empty state for no internet connection
    /// - Parameters:
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    static func noInternet(
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil
    ) -> RREmptyState {
        RREmptyState(
            icon: Image(systemName: "wifi.slash"),
            title: "No Internet Connection",
            subtitle: "Please check your connection and try again.",
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .warning
        )
    }
    
    /// Empty state for empty list
    /// - Parameters:
    ///   - title: The title text
    ///   - subtitle: The subtitle text (optional)
    ///   - primaryAction: The primary action button (optional)
    ///   - secondaryAction: The secondary action button (optional)
    static func emptyList(
        title: String = "No Items",
        subtitle: String? = "There are no items to display at the moment.",
        primaryAction: RRButton? = nil,
        secondaryAction: RRButton? = nil
    ) -> RREmptyState {
        RREmptyState(
            icon: Image(systemName: "tray"),
            title: title,
            subtitle: subtitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            style: .info
        )
    }
}

// MARK: - Preview
#if DEBUG
struct RREmptyState_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                RREmptyState.info(
                    icon: Image(systemName: "info.circle"),
                    title: "No Data Available",
                    subtitle: "There's no data to display at the moment. Check back later or try refreshing.",
                    primaryAction: RRButton.primary(title: "Refresh") {},
                    secondaryAction: RRButton.outline(title: "Help") {}
                )
                
                RREmptyState.noSearchResults(
                    query: "example",
                    primaryAction: RRButton.primary(title: "Clear Search") {},
                    secondaryAction: RRButton.outline(title: "Browse All") {}
                )
                
                RREmptyState.noInternet(
                    primaryAction: RRButton.primary(title: "Retry") {},
                    secondaryAction: RRButton.outline(title: "Settings") {}
                )
            }
            .padding()
        }
        .themeManager(.preview)
    }
}
#endif
