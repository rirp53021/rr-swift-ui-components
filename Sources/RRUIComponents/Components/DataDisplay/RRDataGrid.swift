import SwiftUI

/// A customizable data grid component for displaying data in a grid format
public struct RRDataGrid<Data: RandomAccessCollection, ItemContent: View>: View where Data.Element: Identifiable {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let data: Data
    private let itemContent: (Data.Element) -> ItemContent
    private let style: DataGridStyle
    private let header: DataGridHeader?
    private let footer: DataGridFooter?
    private let selection: Binding<Set<Data.Element.ID>>?
    private let onItemTap: ((Data.Element) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a data grid with the specified data and item content
    /// - Parameters:
    ///   - data: The data to display
    ///   - style: The grid style
    ///   - header: Optional grid header
    ///   - footer: Optional grid footer
    ///   - selection: Optional selection binding
    ///   - onItemTap: Optional item tap handler
    ///   - itemContent: The item content builder
    public init(
        _ data: Data,
        style: DataGridStyle = .default,
        header: DataGridHeader? = nil,
        footer: DataGridFooter? = nil,
        selection: Binding<Set<Data.Element.ID>>? = nil,
        onItemTap: ((Data.Element) -> Void)? = nil,
        @ViewBuilder itemContent: @escaping (Data.Element) -> ItemContent
    ) {
        self.data = data
        self.style = style
        self.header = header
        self.footer = footer
        self.selection = selection
        self.onItemTap = onItemTap
        self.itemContent = itemContent
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
            
            // Grid content
            ScrollView(.vertical, showsIndicators: style.showScrollIndicators) {
                LazyVGrid(
                    columns: style.columns,
                    spacing: style.spacing
                ) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        DataGridItem(
                            item: item,
                            index: index,
                            style: style,
                            isSelected: selection?.wrappedValue.contains(item.id) ?? false,
                            onTap: onItemTap
                        ) {
                            itemContent(item)
                        }
                    }
                }
                .padding(style.padding)
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

// MARK: - Data Grid Item

private struct DataGridItem<Item: Identifiable, Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let item: Item
    let index: Int
    let style: DataGridStyle
    let isSelected: Bool
    let onTap: ((Item) -> Void)?
    let content: Content
    
    init(
        item: Item,
        index: Int,
        style: DataGridStyle,
        isSelected: Bool,
        onTap: ((Item) -> Void)?,
        @ViewBuilder content: () -> Content
    ) {
        self.item = item
        self.index = index
        self.style = style
        self.isSelected = isSelected
        self.onTap = onTap
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(style.itemPadding)
            .background(
                Group {
                    if isSelected {
                        theme.colors.selected
                    } else {
                        theme.colors.surface
                    }
                }
            )
            .cornerRadius(style.itemCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style.itemCornerRadius)
                    .stroke(
                        isSelected ? theme.colors.primary : theme.colors.outlineVariant,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .onTapGesture {
                onTap?(item)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Data Grid Header

public struct DataGridHeader: View {
    
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

// MARK: - Data Grid Footer

public struct DataGridFooter: View {
    
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

// MARK: - Data Grid Style
@MainActor
public struct DataGridStyle {
    public let columns: [SwiftUI.GridItem]
    public let spacing: CGFloat
    public let padding: CGFloat
    public let itemPadding: CGFloat
    public let itemCornerRadius: CGFloat
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let maxHeight: CGFloat?
    public let showScrollIndicators: Bool
    
    public init(
        columns: [SwiftUI.GridItem] = Array(repeating: SwiftUI.GridItem(.flexible()), count: 3),
        spacing: CGFloat = DesignTokens.Spacing.md,
        padding: CGFloat = DesignTokens.Spacing.md,
        itemPadding: CGFloat = DesignTokens.Spacing.sm,
        itemCornerRadius: CGFloat = DesignTokens.BorderRadius.sm,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        borderWidth: CGFloat = 1,
        maxHeight: CGFloat? = nil,
        showScrollIndicators: Bool = true
    ) {
        self.columns = columns
        self.spacing = spacing
        self.padding = padding
        self.itemPadding = itemPadding
        self.itemCornerRadius = itemCornerRadius
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.maxHeight = maxHeight
        self.showScrollIndicators = showScrollIndicators
    }
    
    public static let `default` = DataGridStyle()
    public static let compact = DataGridStyle(
        columns: Array(repeating: SwiftUI.GridItem(.flexible()), count: 4),
        spacing: DesignTokens.Spacing.sm,
        padding: DesignTokens.Spacing.sm,
        itemPadding: DesignTokens.Spacing.xs
    )
    public static let spacious = DataGridStyle(
        columns: Array(repeating: SwiftUI.GridItem(.flexible()), count: 2),
        spacing: DesignTokens.Spacing.lg,
        padding: DesignTokens.Spacing.lg,
        itemPadding: DesignTokens.Spacing.md
    )
    public static let singleColumn = DataGridStyle(
        columns: [SwiftUI.GridItem(.flexible())],
        spacing: DesignTokens.Spacing.md
    )
    public static let twoColumns = DataGridStyle(
        columns: Array(repeating: SwiftUI.GridItem(.flexible()), count: 2)
    )
    public static let threeColumns = DataGridStyle(
        columns: Array(repeating: SwiftUI.GridItem(.flexible()), count: 3)
    )
    public static let fourColumns = DataGridStyle(
        columns: Array(repeating: SwiftUI.GridItem(.flexible()), count: 4)
    )
}

// MARK: - Grid Item Content

public struct GridItemContent<Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let title: String?
    private let subtitle: String?
    private let icon: String?
    private let alignment: Alignment
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        icon: String? = nil,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.alignment = alignment
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: DesignTokens.Spacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(theme.colors.primary)
            }
            
            content
            
            if let title = title {
                RRLabel(title, style: .body, weight: .medium, alignment: .center)
            }
            
            if let subtitle = subtitle {
                RRLabel(subtitle, style: .caption, color: .secondary, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

// MARK: - Previews

#if DEBUG
struct RRDataGrid_Previews: PreviewProvider {
    static var previews: some View {
        RRDataGridPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRDataGrid Examples")
    }
}

private struct RRDataGridPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedItems: Set<UUID> = []
    
    private let sampleData = [
        GridItemData(id: UUID(), title: "Item 1", subtitle: "Description 1", icon: "star.fill"),
        GridItemData(id: UUID(), title: "Item 2", subtitle: "Description 2", icon: "heart.fill"),
        GridItemData(id: UUID(), title: "Item 3", subtitle: "Description 3", icon: "bookmark.fill"),
        GridItemData(id: UUID(), title: "Item 4", subtitle: "Description 4", icon: "flag.fill"),
        GridItemData(id: UUID(), title: "Item 5", subtitle: "Description 5", icon: "tag.fill"),
        GridItemData(id: UUID(), title: "Item 6", subtitle: "Description 6", icon: "star.fill"),
        GridItemData(id: UUID(), title: "Item 7", subtitle: "Description 7", icon: "heart.fill"),
        GridItemData(id: UUID(), title: "Item 8", subtitle: "Description 8", icon: "bookmark.fill")
    ]
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Data Grid Examples")
            
            // Basic grid
            RRDataGrid(
                sampleData,
                style: .default,
                header: DataGridHeader {
                    HStack {
                        RRLabel("Grid Items", style: .subtitle, weight: .semibold)
                        Spacer()
                        RRLabel("\(sampleData.count) items", style: .caption, color: .secondary)
                    }
                },
                footer: DataGridFooter {
                    HStack {
                        RRLabel("End of grid", style: .caption, color: .secondary)
                        Spacer()
                    }
                }
            ) { item in
                GridItemContent(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon
                ) {
                    // Custom content can go here
                }
            }
            .frame(maxHeight: 300)
            
            // Compact grid with selection
            RRDataGrid(
                sampleData,
                style: .compact,
                selection: $selectedItems
            ) { item in
                GridItemContent(
                    title: item.title,
                    icon: item.icon
                ) {
                    // Custom content can go here
                }
            }
            .frame(maxHeight: 200)
            
            // Two column grid
            RRDataGrid(
                sampleData,
                style: .twoColumns
            ) { item in
                GridItemContent(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon
                ) {
                    // Custom content can go here
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

private struct GridItemData: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
}
#endif
