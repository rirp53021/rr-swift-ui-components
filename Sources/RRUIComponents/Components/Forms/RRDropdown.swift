import SwiftUI

/// A customizable dropdown/picker component
public struct RRDropdown<Item: Hashable>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var selectedItem: Item?
    @State private var isExpanded = false
    @State private var searchText = ""
    
    private let items: [Item]
    private let itemLabel: (Item) -> String
    private let itemIcon: ((Item) -> Image)?
    private let placeholder: String
    private let onSelectionChange: ((Item) -> Void)?
    private let style: DropdownStyle
    private let searchable: Bool
    
    public init(
        items: [Item],
        selectedItem: Binding<Item?>,
        itemLabel: @escaping (Item) -> String,
        itemIcon: ((Item) -> Image)? = nil,
        placeholder: String = "Select an option",
        style: DropdownStyle = .default,
        searchable: Bool = false,
        onSelectionChange: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self._selectedItem = selectedItem
        self.itemLabel = itemLabel
        self.itemIcon = itemIcon
        self.placeholder = placeholder
        self.style = style
        self.searchable = searchable
        self.onSelectionChange = onSelectionChange
    }
    
    private var displayText: String {
        if let selected = selectedItem {
            return itemLabel(selected)
        }
        return placeholder
    }
    
    private var filteredItems: [Item] {
        if searchable && !searchText.isEmpty {
            return items.filter { itemLabel($0).localizedCaseInsensitiveContains(searchText) }
        }
        return items
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            dropdownButton
            if isExpanded {
                dropdownList
            }
        }
    }
    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                if let selected = selectedItem, let icon = itemIcon {
                    icon(selected)
                        .foregroundColor(theme.colors.primaryText)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeSM))
                }
                
                RRLabel(
                    displayText,
                    style: .body,
                    weight: .medium,
                    customColor: selectedItem != nil ? theme.colors.primaryText : theme.colors.secondaryText
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(theme.colors.onSurfaceVariant)
                    .font(.system(size: DesignTokens.ComponentSize.iconSizeXS, weight: .medium))
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(DesignTokens.Animation.dropdownToggle, value: isExpanded)
            }
            .padding(.horizontal, DesignTokens.Spacing.inputPadding)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(theme.colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.input)
                    .stroke(theme.colors.outline, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.input))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dropdownList: some View {
        VStack(spacing: 0) {
            if searchable {
                searchField
            }
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredItems, id: \.self) { item in
                        dropdownItem(item)
                        
                        if item != filteredItems.last {
                            Divider()
                                .background(theme.colors.outline)
                        }
                    }
                }
            }
            .frame(maxHeight: style.maxListHeight)
        }
        .background(theme.colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.input)
                .stroke(theme.colors.outline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.input))
        .shadow(
            color: DesignTokens.Elevation.dropdown.color,
            radius: DesignTokens.Elevation.dropdown.radius,
            x: DesignTokens.Elevation.dropdown.x,
            y: DesignTokens.Elevation.dropdown.y
        )
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.colors.onSurfaceVariant)
                .font(.system(size: DesignTokens.ComponentSize.iconSizeXS))
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(style.font)
        }
        .padding(.horizontal, DesignTokens.Spacing.inputPadding)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(theme.colors.surfaceVariant)
    }
    
    private func dropdownItem(_ item: Item) -> some View {
        Button(action: {
            selectedItem = item
            onSelectionChange?(item)
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded = false
            }
        }) {
            HStack {
                if let icon = itemIcon {
                    icon(item)
                        .foregroundColor(theme.colors.primaryText)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeSM))
                }
                
                RRLabel(
                    itemLabel(item),
                    style: .body,
                    weight: .medium,
                    customColor: theme.colors.primaryText
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if selectedItem == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(theme.colors.primary)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeXS, weight: .medium))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.inputPadding)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(selectedItem == item ? theme.colors.primary.opacity(0.1) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Dropdown Style

public struct DropdownStyle {
    public let backgroundColor: Color
    public let textColor: Color
    public let placeholderColor: Color
    public let borderColor: Color
    public let accentColor: Color
    public let iconColor: Color
    public let searchIconColor: Color
    public let searchBackgroundColor: Color
    public let selectedBackgroundColor: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let maxListHeight: CGFloat
    
    public init(
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        placeholderColor: Color? = nil,
        borderColor: Color? = nil,
        accentColor: Color? = nil,
        iconColor: Color? = nil,
        searchIconColor: Color? = nil,
        searchBackgroundColor: Color? = nil,
        selectedBackgroundColor: Color? = nil,
        font: Font = DesignTokens.Typography.bodyMedium,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.input,
        borderWidth: CGFloat = 1,
        horizontalPadding: CGFloat = DesignTokens.Spacing.inputPadding,
        verticalPadding: CGFloat = DesignTokens.Spacing.sm,
        maxListHeight: CGFloat = 200,
        theme: Theme? = nil
    ) {
        let theme = theme ?? Theme.light
        
        self.backgroundColor = backgroundColor ?? theme.colors.surface
        self.textColor = textColor ?? theme.colors.primaryText
        self.placeholderColor = placeholderColor ?? theme.colors.secondaryText
        self.borderColor = borderColor ?? theme.colors.outline
        self.accentColor = accentColor ?? theme.colors.primary
        self.iconColor = iconColor ?? theme.colors.onSurfaceVariant
        self.searchIconColor = searchIconColor ?? theme.colors.onSurfaceVariant
        self.searchBackgroundColor = searchBackgroundColor ?? theme.colors.surfaceVariant
        self.selectedBackgroundColor = selectedBackgroundColor ?? theme.colors.primary.opacity(0.1)
        self.font = font
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.maxListHeight = maxListHeight
    }
    
    public static let `default` = DropdownStyle()
}

// MARK: - Previews

struct RRDropdown_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Dropdown Styles", style: .title, weight: .bold, color: .primary)
            
            // Basic dropdown
            RRDropdown(
                items: ["Option 1", "Option 2", "Option 3"],
                selectedItem: .constant("Option 1"),
                itemLabel: { $0 },
                placeholder: "Select an option"
            )
            
            // Dropdown with icons
            RRDropdown(
                items: ["Apple", "Banana", "Orange"],
                selectedItem: .constant(nil),
                itemLabel: { $0 },
                itemIcon: { item in
                    Image(systemName: "fruit")
                },
                placeholder: "Choose a fruit"
            )
            
            // Searchable dropdown
            RRDropdown(
                items: ["Red", "Green", "Blue", "Yellow", "Purple"],
                selectedItem: .constant(nil),
                itemLabel: { $0 },
                placeholder: "Pick a color",
                searchable: true
            )
        }
        .padding(DesignTokens.Spacing.componentPadding)
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRDropdown")
    }
}