import SwiftUI

/// A customizable dropdown/picker component
public struct RRDropdown<Item: Hashable>: View {
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
                        .foregroundColor(style.textColor)
                        .font(.system(size: 16))
                }
                
                Text(displayText)
                    .foregroundColor(selectedItem != nil ? style.textColor : style.placeholderColor)
                    .font(style.font)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(style.iconColor)
                    .font(.system(size: 12, weight: .medium))
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
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
                                .background(style.borderColor)
                        }
                    }
                }
            }
            .frame(maxHeight: style.maxListHeight)
        }
        .background(style.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(style.searchIconColor)
                .font(.system(size: 14))
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(style.font)
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, 8)
        .background(style.searchBackgroundColor)
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
                        .foregroundColor(style.textColor)
                        .font(.system(size: 16))
                }
                
                Text(itemLabel(item))
                    .foregroundColor(style.textColor)
                    .font(style.font)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if selectedItem == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(style.accentColor)
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .background(selectedItem == item ? style.selectedBackgroundColor : Color.clear)
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
        backgroundColor: Color = .white,
        textColor: Color = .primary,
        placeholderColor: Color = .secondary,
        borderColor: Color = .gray.opacity(0.3),
        accentColor: Color = .blue,
        iconColor: Color = .secondary,
        searchIconColor: Color = .secondary,
        searchBackgroundColor: Color = .gray.opacity(0.1),
        selectedBackgroundColor: Color = .blue.opacity(0.1),
        font: Font = .body,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 1,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 10,
        maxListHeight: CGFloat = 200
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.borderColor = borderColor
        self.accentColor = accentColor
        self.iconColor = iconColor
        self.searchIconColor = searchIconColor
        self.searchBackgroundColor = searchBackgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
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
        VStack(spacing: 20) {
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
        .padding()
        .previewDisplayName("RRDropdown")
    }
}