# Buttons - RRUIComponents

## Overview

Button components provide interactive elements for user actions. The RRUIComponents library includes two main button components: `RRButton` for general use and `RRFloatingActionButton` for primary actions.

## RRButton

A customizable button component with multiple styles, sizes, and configurations.

### Basic Usage

```swift
RRButton("Click Me") {
    // Action
}
```

### Initialization

```swift
// Basic button
RRButton(title: String, action: @escaping () -> Void)

// Button with icon
RRButton(title: String, icon: String?, action: @escaping () -> Void)
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.primary` | Primary action button | Main actions, confirmations |
| `.secondary` | Secondary action button | Alternative actions |
| `.tertiary` | Tertiary action button | Less important actions |
| `.outline` | Outlined button | Secondary actions with emphasis |
| `.ghost` | Ghost button | Subtle actions |
| `.link` | Link-style button | Navigation, external links |

### Sizes

| Size | Description | Height |
|------|-------------|--------|
| `.small` | Small button | 32pt |
| `.medium` | Medium button (default) | 40pt |
| `.large` | Large button | 48pt |

### Examples

#### Primary Button
```swift
RRButton("Save Changes") {
    saveChanges()
}
.style(.primary)
.size(.large)
```

#### Secondary Button with Icon
```swift
RRButton("Download", icon: "arrow.down.circle") {
    downloadFile()
}
.style(.secondary)
.size(.medium)
```

#### Ghost Button
```swift
RRButton("Cancel") {
    dismiss()
}
.style(.ghost)
.size(.small)
```

#### Disabled Button
```swift
RRButton("Processing...") {
    // Action
}
.style(.primary)
.disabled(isLoading)
```

### Customization

#### Custom Colors
```swift
RRButton("Custom Button") {
    // Action
}
.style(.primary)
.foregroundColor(.customText)
.background(.customBackground)
```

#### Custom Styling
```swift
RRButton("Styled Button") {
    // Action
}
.style(.outline)
.cornerRadius(8)
.borderWidth(2)
.borderColor(.primary)
```

### Theme Integration

The button automatically uses theme colors and respects the current theme:

```swift
@Environment(\.themeProvider) private var themeProvider

var body: some View {
    RRButton("Themed Button") {
        // Action
    }
    .style(.primary) // Uses theme.primary color
}
```

## RRFloatingActionButton

A floating action button for primary actions, typically positioned in the bottom-right corner.

### Basic Usage

```swift
RRFloatingActionButton(icon: "plus") {
    addItem()
}
```

### Initialization

```swift
RRFloatingActionButton(icon: String, action: @escaping () -> Void)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `icon` | `String` | SF Symbol name for the icon |
| `action` | `() -> Void` | Action to perform when tapped |

### Examples

#### Basic FAB
```swift
RRFloatingActionButton(icon: "plus") {
    showAddSheet = true
}
```

#### FAB with Custom Position
```swift
RRFloatingActionButton(icon: "camera") {
    openCamera()
}
.position(.bottomLeading)
.size(.large)
```

#### FAB with Custom Color
```swift
RRFloatingActionButton(icon: "heart") {
    addToFavorites()
}
.background(.red)
.foregroundColor(.white)
```

### Positioning

| Position | Description |
|----------|-------------|
| `.bottomTrailing` | Bottom-right corner (default) |
| `.bottomLeading` | Bottom-left corner |
| `.topTrailing` | Top-right corner |
| `.topLeading` | Top-left corner |

## Best Practices

### Button Selection

1. **Primary Actions**: Use `.primary` style for the main action on a screen
2. **Secondary Actions**: Use `.secondary` or `.outline` for alternative actions
3. **Destructive Actions**: Use `.primary` with red color for destructive actions
4. **Navigation**: Use `.link` style for navigation actions

### Accessibility

1. **Labels**: Always provide clear, descriptive button labels
2. **Hints**: Add accessibility hints for complex actions
3. **State**: Indicate button state (enabled/disabled) to screen readers

### Performance

1. **Actions**: Keep button actions lightweight
2. **Async Actions**: Show loading state for async operations
3. **Debouncing**: Prevent rapid tapping for expensive operations

## Common Patterns

### Loading State
```swift
RRButton(isLoading ? "Saving..." : "Save") {
    saveChanges()
}
.style(.primary)
.disabled(isLoading)
```

### Icon with Text
```swift
RRButton("Download", icon: "arrow.down.circle") {
    downloadFile()
}
.style(.secondary)
```

### Conditional Styling
```swift
RRButton("Submit") {
    submitForm()
}
.style(isFormValid ? .primary : .ghost)
.disabled(!isFormValid)
```

### Multiple Actions
```swift
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
```

## Troubleshooting

### Common Issues

1. **Button not responding**: Check if the button is disabled or covered by another view
2. **Styling not applied**: Ensure the style modifier is called after initialization
3. **Theme not updating**: Verify `ThemeProvider` is properly injected into the environment

### Debug Tips

1. Use `.background(.red)` to visualize button bounds
2. Check console for theme-related warnings
3. Verify button is not outside safe area
