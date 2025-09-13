import SwiftUI

/// A customizable context menu component for displaying contextual actions
public struct RRContextMenu<Content: View, MenuItems: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let menuItems: MenuItems
    private let style: ContextMenuStyle
    private let showPreview: Bool
    private let preview: AnyView?
    
    // MARK: - Initialization
    
    /// Creates a context menu with the specified content and menu items
    /// - Parameters:
    ///   - style: The context menu style
    ///   - showPreview: Whether to show a preview when the menu is opened
    ///   - preview: Optional custom preview content
    ///   - content: The content that triggers the context menu
    ///   - menuItems: The menu items to display
    public init(
        style: ContextMenuStyle = .default,
        showPreview: Bool = false,
        preview: AnyView? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder menuItems: () -> MenuItems
    ) {
        self.content = content()
        self.menuItems = menuItems()
        self.style = style
        self.showPreview = showPreview
        self.preview = preview
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .contextMenu {
                if showPreview, let preview = preview {
                    preview
                        .frame(maxWidth: 200, maxHeight: 150)
                        .background(style.previewBackground)
                        .cornerRadius(style.previewCornerRadius)
                }
                
                menuItems
            }
    }
}

// MARK: - Context Menu Style
@MainActor
public struct ContextMenuStyle {
    public let previewBackground: Color
    public let previewCornerRadius: CGFloat
    
    public init(
        previewBackground: Color? = nil,
        previewCornerRadius: CGFloat = DesignTokens.BorderRadius.sm
    ) {
        self.previewBackground = previewBackground ?? Color.gray.opacity(0.1)
        self.previewCornerRadius = previewCornerRadius
    }
    
    public static let `default` = ContextMenuStyle()
    public static let light = ContextMenuStyle(
        previewBackground: Color.white
    )
    public static let dark = ContextMenuStyle(
        previewBackground: Color.black.opacity(0.8)
    )
}

// MARK: - Context Menu Item

public struct RRContextMenuItem: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let title: String
    private let icon: String?
    private let action: () -> Void
    private let isDestructive: Bool
    private let isDisabled: Bool
    
    public init(
        _ title: String,
        icon: String? = nil,
        isDestructive: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .frame(width: 16, height: 16)
                }
                
                RRLabel(title, style: .body, customColor: textColor)
                
                Spacer()
            }
        }
        .disabled(isDisabled)
        .foregroundColor(textColor)
    }
    
    private var textColor: Color {
        if isDisabled {
            return theme.colors.outline
        } else if isDestructive {
            return theme.colors.error
        } else {
            return theme.colors.onSurface
        }
    }
    
    private var iconColor: Color {
        if isDisabled {
            return theme.colors.outline
        } else if isDestructive {
            return theme.colors.error
        } else {
            return theme.colors.primary
        }
    }
}

// MARK: - Context Menu Separator

public struct RRContextMenuSeparator: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    public init() {}
    
    public var body: some View {
        Divider()
            .background(theme.colors.outlineVariant)
    }
}

// MARK: - Context Menu Group

public struct RRContextMenuGroup<Content: View>: View {
    
    private let content: Content
    private let title: String?
    
    public init(
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        Group {
            if let title = title {
                Menu(title) {
                    content
                }
            } else {
                content
            }
        }
    }
}

// MARK: - Context Menu Extensions

public extension RRContextMenu {
    
    /// Creates a context menu with a preview
    static func withPreview<Preview: View>(
        style: ContextMenuStyle = .default,
        @ViewBuilder preview: () -> Preview,
        @ViewBuilder content: () -> Content,
        @ViewBuilder menuItems: () -> MenuItems
    ) -> RRContextMenu<Content, MenuItems> {
        RRContextMenu(
            style: style,
            showPreview: true,
            preview: AnyView(preview()),
            content: content,
            menuItems: menuItems
        )
    }
    
}

// MARK: - Previews

#if DEBUG
struct RRContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        RRContextMenuPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRContextMenu Examples")
    }
}

private struct RRContextMenuPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Context Menu Examples")
            
            // Basic context menus
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Context Menus", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRContextMenu {
                        RRButton("Right-click me", style: .primary) {}
                    } menuItems: {
                        RRContextMenuItem("Edit", icon: "pencil", action: {})
                        RRContextMenuItem("Duplicate", icon: "doc.on.doc", action: {})
                        RRContextMenuSeparator()
                        RRContextMenuItem("Delete", icon: "trash", isDestructive: true, action: {})
                    }
                    
                    RRContextMenu {
                        RRButton("Long-press me", style: .secondary) {}
                    } menuItems: {
                        RRContextMenuItem("View Details", icon: "eye", action: {})
                        RRContextMenuItem("Add to Favorites", icon: "heart", action: {})
                        RRContextMenuSeparator()
                        RRContextMenuItem("Share", icon: "square.and.arrow.up", action: {})
                        RRContextMenuItem("Report", icon: "flag", action: {})
                    }
                }
            }
            
            // Context menus with previews
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Context Menus with Previews", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRContextMenu.withPreview {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                                RRAvatar(
                                    image: nil,
                                    size: .md,
                                    style: .circle
                                )
                            } else {
                                Circle()
                                    .fill(theme.colors.primary)
                                    .frame(width: 40, height: 40)
                            }
                            RRLabel("John Doe", style: .caption, weight: .semibold)
                            RRLabel("Software Engineer", style: .caption, color: .secondary)
                        }
                        .padding(DesignTokens.Spacing.sm)
                    } content: {
                        RRButton("User Profile", style: .primary) {}
                    } menuItems: {
                        RRContextMenuItem("View Profile", icon: "person", action: {})
                        RRContextMenuItem("Send Message", icon: "message", action: {})
                        RRContextMenuItem("Add to Team", icon: "person.badge.plus", action: {})
                        RRContextMenuSeparator()
                        RRContextMenuItem("Block User", icon: "person.crop.circle.badge.minus", isDestructive: true, action: {})
                    }
                    
                    RRContextMenu.withPreview {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            Image(systemName: "doc.text")
                                .font(.largeTitle)
                                .foregroundColor(theme.colors.primary)
                            RRLabel("Document.pdf", style: .caption, weight: .semibold)
                            RRLabel("2.4 MB", style: .caption, color: .secondary)
                        }
                        .padding(DesignTokens.Spacing.sm)
                    } content: {
                        RRButton("Document", style: .secondary) {}
                    } menuItems: {
                        RRContextMenuItem("Open", icon: "doc", action: {})
                        RRContextMenuItem("Download", icon: "arrow.down.circle", action: {})
                        RRContextMenuItem("Rename", icon: "pencil", action: {})
                        RRContextMenuSeparator()
                        RRContextMenuItem("Move to Trash", icon: "trash", isDestructive: true, action: {})
                    }
                }
            }
            
            
            // Context menu groups
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Context Menu Groups", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRContextMenu {
                        RRButton("Grouped Menu", style: .primary) {}
                    } menuItems: {
                        RRContextMenuGroup(title: "Edit") {
                            RRContextMenuItem("Cut", icon: "scissors", action: {})
                            RRContextMenuItem("Copy", icon: "doc.on.doc", action: {})
                            RRContextMenuItem("Paste", icon: "doc.on.clipboard", action: {})
                        }
                        
                        RRContextMenuGroup(title: "View") {
                            RRContextMenuItem("Zoom In", icon: "plus.magnifyingglass", action: {})
                            RRContextMenuItem("Zoom Out", icon: "minus.magnifyingglass", action: {})
                            RRContextMenuItem("Reset Zoom", icon: "1.magnifyingglass", action: {})
                        }
                        
                        RRContextMenuSeparator()
                        
                        RRContextMenuItem("Settings", icon: "gear", action: {})
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
