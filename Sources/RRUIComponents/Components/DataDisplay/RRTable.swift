import SwiftUI

/// A customizable table component for displaying tabular data
public struct RRTable<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    private let style: TableStyle
    private let header: TableHeader?
    private let footer: TableFooter?
    private let selection: Binding<Set<Data.Element.ID>>?
    private let onRowTap: ((Data.Element) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a table with the specified data and row content
    /// - Parameters:
    ///   - data: The data to display
    ///   - style: The table style
    ///   - header: Optional table header
    ///   - footer: Optional table footer
    ///   - selection: Optional selection binding
    ///   - onRowTap: Optional row tap handler
    ///   - rowContent: The row content builder
    public init(
        _ data: Data,
        style: TableStyle = .default,
        header: TableHeader? = nil,
        footer: TableFooter? = nil,
        selection: Binding<Set<Data.Element.ID>>? = nil,
        onRowTap: ((Data.Element) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.data = data
        self.style = style
        self.header = header
        self.footer = footer
        self.selection = selection
        self.onRowTap = onRowTap
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
            
            // Table content
            ScrollView(.vertical, showsIndicators: style.showScrollIndicators) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        TableRow(
                            item: item,
                            index: index,
                            style: style,
                            isSelected: selection?.wrappedValue.contains(item.id) ?? false,
                            onTap: onRowTap
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

// MARK: - Table Row

private struct TableRow<Item: Identifiable, Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let item: Item
    let index: Int
    let style: TableStyle
    let isSelected: Bool
    let onTap: ((Item) -> Void)?
    let content: Content
    
    init(
        item: Item,
        index: Int,
        style: TableStyle,
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
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Table Header

public struct TableHeader: View {
    
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

// MARK: - Table Footer

public struct TableFooter: View {
    
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

// MARK: - Table Style

public struct TableStyle {
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let maxHeight: CGFloat?
    public let showScrollIndicators: Bool
    
    public init(
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        borderWidth: CGFloat = 1,
        horizontalPadding: CGFloat = DesignTokens.Spacing.md,
        verticalPadding: CGFloat = DesignTokens.Spacing.sm,
        maxHeight: CGFloat? = nil,
        showScrollIndicators: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.maxHeight = maxHeight
        self.showScrollIndicators = showScrollIndicators
    }
    
    public static let `default` = TableStyle()
    public static let compact = TableStyle(
        horizontalPadding: DesignTokens.Spacing.sm,
        verticalPadding: DesignTokens.Spacing.xs
    )
    public static let spacious = TableStyle(
        horizontalPadding: DesignTokens.Spacing.lg,
        verticalPadding: DesignTokens.Spacing.md
    )
}

// MARK: - Table Column

public struct TableColumn<Content: View>: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let alignment: HorizontalAlignment
    private let width: CGFloat?
    
    public init(
        alignment: HorizontalAlignment = .leading,
        width: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.alignment = alignment
        self.width = width
    }
    
    public var body: some View {
        content
            .frame(maxWidth: width, alignment: .init(horizontal: alignment, vertical: .center))
    }
}

// MARK: - Previews

#if DEBUG
struct RRTable_Previews: PreviewProvider {
    static var previews: some View {
        RRTablePreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRTable Examples")
    }
}

private struct RRTablePreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedItems: Set<UUID> = []
    
    private let sampleData = [
        TableItem(id: UUID(), name: "John Doe", email: "john@example.com", role: "Developer"),
        TableItem(id: UUID(), name: "Jane Smith", email: "jane@example.com", role: "Designer"),
        TableItem(id: UUID(), name: "Bob Johnson", email: "bob@example.com", role: "Manager"),
        TableItem(id: UUID(), name: "Alice Brown", email: "alice@example.com", role: "Developer"),
        TableItem(id: UUID(), name: "Charlie Wilson", email: "charlie@example.com", role: "Designer")
    ]
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Table Examples")
            
            // Basic table
            RRTable(
                sampleData,
                style: .default,
                header: TableHeader {
                    HStack {
                        RRLabel("Name", style: .subtitle, weight: .semibold)
                        Spacer()
                        RRLabel("Email", style: .subtitle, weight: .semibold)
                        Spacer()
                        RRLabel("Role", style: .subtitle, weight: .semibold)
                    }
                },
                footer: TableFooter {
                    HStack {
                        RRLabel("Total: \(sampleData.count) items", style: .caption, color: .secondary)
                        Spacer()
                    }
                }
            ) { item in
                HStack {
                    RRLabel(item.name, style: .body, weight: .medium)
                    Spacer()
                    RRLabel(item.email, style: .body, color: .secondary)
                    Spacer()
                    RRLabel(item.role, style: .body)
                }
            }
            .frame(maxHeight: 300)
            
            // Compact table with selection
            RRTable(
                sampleData,
                style: .compact,
                header: TableHeader {
                    HStack {
                        RRLabel("Name", style: .subtitle, weight: .semibold)
                        Spacer()
                        RRLabel("Role", style: .subtitle, weight: .semibold)
                    }
                },
                selection: $selectedItems
            ) { item in
                HStack {
                    RRLabel(item.name, style: .body, weight: .medium)
                    Spacer()
                    RRLabel(item.role, style: .body, color: .secondary)
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

private struct TableItem: Identifiable {
    let id: UUID
    let name: String
    let email: String
    let role: String
}
#endif
