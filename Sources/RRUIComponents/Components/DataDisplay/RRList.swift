import SwiftUI

/// An enhanced list component with customizable styling and interactions
public struct RRList<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    private let style: ListStyle
    private let header: ListHeader?
    private let footer: ListFooter?
    private let selection: Binding<Set<Data.Element.ID>>?
    private let onRowTap: ((Data.Element) -> Void)?
    private let onRowSwipe: ((Data.Element, SwipeAction) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a list with the specified data and row content
    /// - Parameters:
    ///   - data: The data to display
    ///   - style: The list style
    ///   - header: Optional list header
    ///   - footer: Optional list footer
    ///   - selection: Optional selection binding
    ///   - onRowTap: Optional row tap handler
    ///   - onRowSwipe: Optional row swipe handler
    ///   - rowContent: The row content builder
    public init(
        _ data: Data,
        style: ListStyle = .default,
        header: ListHeader? = nil,
        footer: ListFooter? = nil,
        selection: Binding<Set<Data.Element.ID>>? = nil,
        onRowTap: ((Data.Element) -> Void)? = nil,
        onRowSwipe: ((Data.Element, SwipeAction) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.data = data
        self.style = style
        self.header = header
        self.footer = footer
        self.selection = selection
        self.onRowTap = onRowTap
        self.onRowSwipe = onRowSwipe
        self.rowContent = rowContent
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            if let header = header {
                header
                    .background(theme.colors.surfaceVariant)
                    .overlay(
                        Rectangle()
                            .fill(theme.colors.outline)
                            .frame(height: 1),
                        alignment: .bottom
                    )
            }
            
            // List content
            ScrollView(.vertical, showsIndicators: style.showScrollIndicators) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        ListRow(
                            item: item,
                            index: index,
                            style: style,
                            isSelected: selection?.wrappedValue.contains(item.id) ?? false,
                            onTap: onRowTap,
                            onSwipe: onRowSwipe
                        ) {
                            rowContent(item)
                        }
                    }
                }
            }
            .frame(maxHeight: style.maxHeight)
            
            // Footer
            if let footer = footer {
                footer
                    .background(theme.colors.surfaceVariant)
                    .overlay(
                        Rectangle()
                            .fill(theme.colors.outline)
                            .frame(height: 1),
                        alignment: .top
                    )
            }
        }
        .background(theme.colors.surface)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(theme.colors.outline, lineWidth: style.borderWidth)
        )
    }
}

// MARK: - List Row

private struct ListRow<Item: Identifiable, Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let item: Item
    let index: Int
    let style: ListStyle
    let isSelected: Bool
    let onTap: ((Item) -> Void)?
    let onSwipe: ((Item, SwipeAction) -> Void)?
    let content: Content
    
    init(
        item: Item,
        index: Int,
        style: ListStyle,
        isSelected: Bool,
        onTap: ((Item) -> Void)?,
        onSwipe: ((Item, SwipeAction) -> Void)?,
        @ViewBuilder content: () -> Content
    ) {
        self.item = item
        self.index = index
        self.style = style
        self.isSelected = isSelected
        self.onTap = onTap
        self.onSwipe = onSwipe
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            content
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .background(
            Group {
                if isSelected {
                    theme.colors.selected
                } else if index % 2 == 0 {
                    theme.colors.surface
                } else {
                    theme.colors.surfaceVariant
                }
            }
        )
        .overlay(
            Rectangle()
                .fill(theme.colors.outlineVariant)
                .frame(height: 1),
            alignment: .bottom
        )
        .onTapGesture {
            onTap?(item)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if let onSwipe = onSwipe {
                Button("Delete", role: .destructive) {
                    onSwipe(item, .delete)
                }
                
                Button("Edit") {
                    onSwipe(item, .edit)
                }
                .tint(theme.colors.primary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - List Header

public struct ListHeader: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: AnyView
    
    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    public var body: some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
    }
}

// MARK: - List Footer

public struct ListFooter: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: AnyView
    
    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    public var body: some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
    }
}

// MARK: - List Style
@MainActor
public struct ListStyle {
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let maxHeight: CGFloat?
    public let showScrollIndicators: Bool
    public let showDividers: Bool
    
    public init(
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        borderWidth: CGFloat = 1,
        horizontalPadding: CGFloat = DesignTokens.Spacing.md,
        verticalPadding: CGFloat = DesignTokens.Spacing.sm,
        maxHeight: CGFloat? = nil,
        showScrollIndicators: Bool = true,
        showDividers: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.maxHeight = maxHeight
        self.showScrollIndicators = showScrollIndicators
        self.showDividers = showDividers
    }
    
    public static let `default` = ListStyle()
    public static let compact = ListStyle(
        horizontalPadding: DesignTokens.Spacing.sm,
        verticalPadding: DesignTokens.Spacing.xs
    )
    public static let spacious = ListStyle(
        horizontalPadding: DesignTokens.Spacing.lg,
        verticalPadding: DesignTokens.Spacing.md
    )
    public static let card = ListStyle(
        cornerRadius: DesignTokens.BorderRadius.lg,
        borderWidth: 0,
        showDividers: false
    )
}

// MARK: - Swipe Action

public enum SwipeAction {
    case delete
    case edit
    case archive
    case share
    case custom(String)
}

// MARK: - List Item

public struct ListItem<Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let leading: AnyView?
    private let trailing: AnyView?
    private let alignment: VerticalAlignment
    
    public init(
        alignment: VerticalAlignment = .center,
        @ViewBuilder leading: () -> AnyView? = { nil },
        @ViewBuilder trailing: () -> AnyView? = { nil },
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.leading = leading()
        self.trailing = trailing()
        self.alignment = alignment
    }
    
    public var body: some View {
        HStack(alignment: alignment, spacing: DesignTokens.Spacing.md) {
            if let leading = leading {
                leading
            }
            
            content
            
            Spacer()
            
            if let trailing = trailing {
                trailing
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct RRList_Previews: PreviewProvider {
    static var previews: some View {
        RRListPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRList Examples")
    }
}

private struct RRListPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedItems: Set<UUID> = []
    
    private let sampleData = [
        ListItemData(id: UUID(), title: "First Item", subtitle: "This is the first item", icon: "star.fill"),
        ListItemData(id: UUID(), title: "Second Item", subtitle: "This is the second item", icon: "heart.fill"),
        ListItemData(id: UUID(), title: "Third Item", subtitle: "This is the third item", icon: "bookmark.fill"),
        ListItemData(id: UUID(), title: "Fourth Item", subtitle: "This is the fourth item", icon: "flag.fill"),
        ListItemData(id: UUID(), title: "Fifth Item", subtitle: "This is the fifth item", icon: "tag.fill")
    ]
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("List Examples")
            
            // Basic list
            RRList(
                sampleData,
                style: .default,
                header: ListHeader {
                    HStack {
                        RRLabel("Items", style: .subtitle, weight: .semibold)
                        Spacer()
                        RRLabel("\(sampleData.count) items", style: .caption, color: .secondary)
                    }
                },
                footer: ListFooter {
                    HStack {
                        RRLabel("End of list", style: .caption, color: .secondary)
                        Spacer()
                    }
                }
            ) { item in
                ListItem(
                    leading: {
                        AnyView(
                            Image(systemName: item.icon)
                                .foregroundColor(theme.colors.primary)
                                .frame(width: 24, height: 24)
                        )
                    },
                    trailing: {
                        AnyView(
                            Image(systemName: "chevron.right")
                                .foregroundColor(theme.colors.outline)
                                .font(.caption)
                        )
                    }
                ) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        RRLabel(item.title, style: .body, weight: .medium)
                        RRLabel(item.subtitle, style: .caption, color: .secondary)
                    }
                }
            }
            .frame(maxHeight: 300)
            
            // Card style list
            RRList(
                sampleData,
                style: .card,
                selection: $selectedItems
            ) { item in
                ListItem(
                    leading: {
                        AnyView(
                            Image(systemName: item.icon)
                                .foregroundColor(theme.colors.primary)
                                .frame(width: 24, height: 24)
                        )
                    }
                ) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        RRLabel(item.title, style: .body, weight: .medium)
                        RRLabel(item.subtitle, style: .caption, color: .secondary)
                    }
                }
            }
            .frame(maxHeight: 200)
            
            // Selection info
            if !selectedItems.isEmpty {
                RRLabel("Selected: \(selectedItems.count) items", style: .caption, color: .secondary)
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}

private struct ListItemData: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
}
#endif
