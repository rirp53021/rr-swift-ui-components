# Containers - RRUIComponents

## Overview

Container components provide structure and organization for content. The RRUIComponents library includes flexible container components for cards, grids, and list items.

## Components

- `RRCard` - Card container
- `RRGridView` - Grid layout
- `RRRowItem` - List row item

## RRCard

A card container component for organizing content with consistent styling and theming.

### Basic Usage

```swift
RRCard {
    VStack {
        RRLabel("Card Title")
            .style(.headline)
        RRLabel("Card content goes here")
            .style(.body)
    }
}
```

### Initialization

```swift
RRCard(content: () -> AnyView)
RRCard(header: AnyView?, content: () -> AnyView, footer: AnyView?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `content` | `() -> AnyView` | Main card content |
| `header` | `AnyView?` | Optional header content |
| `footer` | `AnyView?` | Optional footer content |

### Examples

#### Basic Card
```swift
RRCard {
    VStack(alignment: .leading, spacing: 12) {
        RRLabel("Product Name")
            .style(.headline)
        
        RRLabel("Product description goes here")
            .style(.body)
            .foregroundColor(.secondary)
        
        HStack {
            RRLabel("$99.99")
                .style(.title)
                .foregroundColor(.primary)
            
            Spacer()
            
            RRButton("Add to Cart") {
                addToCart()
            }
            .style(.primary)
            .size(.small)
        }
    }
    .padding()
}
```

#### Card with Header
```swift
RRCard {
    VStack {
        RRLabel("Card content")
    }
} header: {
    HStack {
        RRLabel("Header Title")
            .style(.headline)
        
        Spacer()
        
        Button("More") {
            showMore()
        }
        .style(.ghost)
    }
    .padding()
    .background(.surface)
}
```

#### Card with Footer
```swift
RRCard {
    VStack {
        RRLabel("Card content")
    }
} footer: {
    HStack {
        RRButton("Cancel") {
            dismiss()
        }
        .style(.ghost)
        
        Spacer()
        
        RRButton("Save") {
            save()
        }
        .style(.primary)
    }
    .padding()
    .background(.surface)
}
```

#### Card with Header and Footer
```swift
RRCard {
    VStack(alignment: .leading, spacing: 16) {
        RRLabel("Settings")
            .style(.headline)
        
        VStack(spacing: 12) {
            RRToggle("Notifications", isOn: $notificationsEnabled)
            RRToggle("Dark Mode", isOn: $darkModeEnabled)
            RRToggle("Auto-save", isOn: $autoSaveEnabled)
        }
    }
    .padding()
} header: {
    HStack {
        RRLabel("Preferences")
            .style(.title)
        
        Spacer()
        
        Button("Reset") {
            resetSettings()
        }
        .style(.ghost)
    }
    .padding()
    .background(.surface)
} footer: {
    HStack {
        RRButton("Cancel") {
            dismiss()
        }
        .style(.ghost)
        
        Spacer()
        
        RRButton("Apply") {
            applySettings()
        }
        .style(.primary)
    }
    .padding()
    .background(.surface)
}
```

#### Interactive Card
```swift
@State private var isSelected = false

RRCard {
    VStack {
        RRLabel("Selectable Card")
            .style(.headline)
        RRLabel("Tap to select")
            .style(.caption)
    }
    .padding()
}
.onTapGesture {
    withAnimation {
        isSelected.toggle()
    }
}
.background(isSelected ? .primary.opacity(0.1) : .surface)
.border(isSelected ? .primary : .clear, width: 2)
.cornerRadius(12)
```

#### Card with Image
```swift
RRCard {
    VStack(spacing: 0) {
        RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
            .frame(height: 200)
            .clipped()
        
        VStack(alignment: .leading, spacing: 8) {
            RRLabel("Image Title")
                .style(.headline)
            
            RRLabel("Image description")
                .style(.body)
                .foregroundColor(.secondary)
            
            HStack {
                RRBadge("New")
                    .style(.success)
                
                Spacer()
                
                RRLabel("2 min read")
                    .style(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
```

### Customization

#### Custom Styling
```swift
RRCard {
    RRLabel("Custom Card")
}
.background(.blue.opacity(0.1))
.border(.blue, width: 1)
.cornerRadius(16)
.shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
```

#### Different Sizes
```swift
// Small card
RRCard {
    RRLabel("Small")
}
.padding(.small)

// Medium card (default)
RRCard {
    RRLabel("Medium")
}
.padding(.medium)

// Large card
RRCard {
    RRLabel("Large")
}
.padding(.large)
```

## RRGridView

A flexible grid layout component for organizing content in a grid format.

### Basic Usage

```swift
RRGridView(columns: 2, spacing: 16) {
    ForEach(items) { item in
        RRCard {
            RRLabel(item.title)
        }
    }
}
```

### Initialization

```swift
RRGridView(columns: Int, spacing: CGFloat, content: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `columns` | `Int` | Number of columns |
| `spacing` | `CGFloat` | Spacing between items |
| `content` | `() -> AnyView` | Grid content |

### Examples

#### Basic Grid
```swift
RRGridView(columns: 2, spacing: 16) {
    ForEach(0..<6) { index in
        RRCard {
            VStack {
                RRLabel("Item \(index + 1)")
                    .style(.headline)
                RRLabel("Description")
                    .style(.body)
            }
            .padding()
        }
    }
}
```

#### Responsive Grid
```swift
struct ResponsiveGridView: View {
    @State private var columns = 2
    
    var body: some View {
        RRGridView(columns: columns, spacing: 16) {
            ForEach(items) { item in
                ItemCardView(item: item)
            }
        }
        .onAppear {
            updateColumns()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            updateColumns()
        }
    }
    
    private func updateColumns() {
        let screenWidth = UIScreen.main.bounds.width
        columns = screenWidth > 768 ? 3 : 2
    }
}
```

#### Grid with Different Item Sizes
```swift
RRGridView(columns: 3, spacing: 12) {
    ForEach(items) { item in
        RRCard {
            VStack {
                RRLabel(item.title)
                    .style(.headline)
                
                if item.isFeatured {
                    RRLabel("Featured")
                        .style(.caption)
                        .foregroundColor(.primary)
                }
            }
            .padding()
        }
        .frame(height: item.isFeatured ? 120 : 80)
    }
}
```

#### Grid with Headers
```swift
VStack(alignment: .leading, spacing: 16) {
    RRLabel("Products")
        .style(.title)
    
    RRGridView(columns: 2, spacing: 16) {
        ForEach(products) { product in
            ProductCardView(product: product)
        }
    }
}
```

## RRRowItem

A reusable row item component for lists with consistent styling and layout.

### Basic Usage

```swift
RRRowItem(
    title: "Settings",
    subtitle: "Manage your preferences",
    icon: "gear",
    accessory: Image(systemName: "chevron.right")
)
```

### Initialization

```swift
RRRowItem(
    title: String,
    subtitle: String?,
    icon: String?,
    accessory: AnyView?
)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Main title text |
| `subtitle` | `String?` | Optional subtitle text |
| `icon` | `String?` | Optional icon (SF Symbol) |
| `accessory` | `AnyView?` | Optional accessory view |

### Examples

#### Basic Row Item
```swift
RRRowItem(
    title: "Profile",
    subtitle: "Manage your account",
    icon: "person.circle",
    accessory: Image(systemName: "chevron.right")
)
```

#### Row Item with Badge
```swift
RRRowItem(
    title: "Notifications",
    subtitle: "Manage your notifications",
    icon: "bell",
    accessory: HStack {
        RRBadge("3")
            .style(.error)
        Image(systemName: "chevron.right")
    }
)
```

#### Row Item with Toggle
```swift
RRRowItem(
    title: "Dark Mode",
    subtitle: "Switch between light and dark themes",
    icon: "moon",
    accessory: RRToggle("", isOn: $darkModeEnabled)
        .style(.switch)
)
```

#### Row Item with Custom Accessory
```swift
RRRowItem(
    title: "Storage",
    subtitle: "2.1 GB used of 5 GB",
    icon: "internaldrive",
    accessory: VStack(alignment: .trailing) {
        RRLabel("2.1 GB")
            .style(.caption)
            .foregroundColor(.secondary)
        
        ProgressView(value: 0.42)
            .frame(width: 60)
    }
)
```

#### Row Item with Action
```swift
@State private var isSelected = false

RRRowItem(
    title: "Selectable Item",
    subtitle: "Tap to select",
    icon: isSelected ? "checkmark.circle.fill" : "circle",
    accessory: nil
)
.onTapGesture {
    withAnimation {
        isSelected.toggle()
    }
}
.foregroundColor(isSelected ? .primary : .primary)
```

#### Row Item with Custom Styling
```swift
RRRowItem(
    title: "Custom Item",
    subtitle: "With custom styling",
    icon: "star",
    accessory: Image(systemName: "chevron.right")
)
.background(.blue.opacity(0.1))
.cornerRadius(8)
.padding(.horizontal)
```

#### In List View
```swift
List {
    Section("Account") {
        RRRowItem(
            title: "Profile",
            subtitle: "Manage your account",
            icon: "person.circle",
            accessory: Image(systemName: "chevron.right")
        )
        
        RRRowItem(
            title: "Privacy",
            subtitle: "Control your privacy settings",
            icon: "lock.circle",
            accessory: Image(systemName: "chevron.right")
        )
    }
    
    Section("Preferences") {
        RRRowItem(
            title: "Notifications",
            subtitle: "Manage your notifications",
            icon: "bell",
            accessory: RRToggle("", isOn: $notificationsEnabled)
        )
        
        RRRowItem(
            title: "Dark Mode",
            subtitle: "Switch between themes",
            icon: "moon",
            accessory: RRToggle("", isOn: $darkModeEnabled)
        )
    }
}
```

## Best Practices

### Container Design

1. **Consistent Spacing**: Use consistent spacing throughout your containers
2. **Clear Hierarchy**: Maintain clear visual hierarchy
3. **Appropriate Sizing**: Use appropriate sizes for different content types
4. **Responsive Design**: Consider different screen sizes

### Content Organization

1. **Logical Grouping**: Group related content together
2. **Clear Labels**: Use clear, descriptive labels
3. **Appropriate Density**: Balance information density with readability
4. **Visual Hierarchy**: Use typography and spacing to create hierarchy

### Performance

1. **Lazy Loading**: Use lazy loading for large lists and grids
2. **Efficient Rendering**: Minimize unnecessary re-renders
3. **Memory Management**: Properly manage container state

## Common Patterns

### Card List
```swift
struct CardListView: View {
    let items: [Item]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    RRCard {
                        ItemCardView(item: item)
                    }
                }
            }
            .padding()
        }
    }
}
```

### Grid with Search
```swift
struct SearchableGridView: View {
    @State private var searchText = ""
    let items: [Item]
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            RRSearchBar(text: $searchText)
                .padding()
            
            RRGridView(columns: 2, spacing: 16) {
                ForEach(filteredItems) { item in
                    ItemCardView(item: item)
                }
            }
            .padding()
        }
    }
}
```

### Expandable Row Item
```swift
struct ExpandableRowItem: View {
    let title: String
    let subtitle: String
    let icon: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            RRRowItem(
                title: title,
                subtitle: subtitle,
                icon: icon,
                accessory: Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            )
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                VStack {
                    RRLabel("Expanded content goes here")
                        .style(.body)
                        .padding()
                }
                .background(.surface)
                .transition(.slide)
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Grid not responsive**: Check if columns are properly calculated
2. **Card content not fitting**: Verify padding and spacing
3. **Row item not interactive**: Check if tap gestures are properly configured

### Debug Tips

1. Use `.background(.red)` to visualize container bounds
2. Check console for layout warnings
3. Verify spacing and padding values
4. Test with different content sizes
