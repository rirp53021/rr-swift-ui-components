# RRUIComponents

A comprehensive SwiftUI UI component library with centralized theming, layout helpers, and reusable components.

## Features

### 🎨 **Centralized Theming**
- **Color Schemes**: Light and dark themes with semantic colors
- **Typography**: Multiple font systems (default, rounded, monospaced)
- **Spacing**: Consistent spacing scale with convenient modifiers
- **Theme Manager**: Observable theme management with environment support

### 🔘 **UI Components**
- **Buttons**: Multiple styles (primary, secondary, outline, danger, success) with loading states
- **Loading Indicators**: Circular, linear, dots, and pulse animations
- **Empty States**: Pre-built empty states for common scenarios (no data, no internet, no results)

### 📱 **Layout Helpers**
- **Responsive Design**: Device-specific and orientation-aware layouts
- **Layout Modifiers**: Convenient modifiers for common layout patterns
- **Safe Area Handling**: Keyboard and safe area management
- **Device Adaptation**: iPhone and iPad specific layouts

## Requirements

- iOS 13.0+
- macOS 11.0+
- tvOS 13.0+
- watchOS 6.0+
- visionOS 1.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rirp53021/rr-swift-ui-component.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/rirp53021/rr-swift-ui-component.git`
3. Select version: `1.0.0`

## Quick Start

### 1. Import the Library

```swift
import RRUIComponents
```

### 2. Set Up Theme Manager

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeManager(ThemeManager.shared)
        }
    }
}
```

### 3. Use Components

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Primary Button
            RRButton.primary(title: "Get Started") {
                print("Button tapped!")
            }
            
            // Loading Indicator
            RRLoadingIndicator.circular(size: .large)
            
            // Empty State
            RREmptyState.info(
                icon: Image(systemName: "star"),
                title: "Welcome!",
                subtitle: "Get started by creating your first item.",
                primaryAction: RRButton.primary(title: "Create Item") {}
            )
        }
        .paddingMD()
    }
}
```

## Usage Examples

### Buttons

```swift
// Different button styles
RRButton.primary(title: "Primary Action") {}
RRButton.secondary(title: "Secondary Action") {}
RRButton.outline(title: "Outline Action") {}

// With icons and loading states
RRButton.primary(
    title: "Save",
    icon: Image(systemName: "checkmark"),
    isLoading: true
) {}

// Custom button
RRButton(
    title: "Custom",
    style: .danger,
    size: .large
) {}
```

### Loading Indicators

```swift
// Different loading styles
RRLoadingIndicator.circular(size: .medium)
RRLoadingIndicator.linear(size: .large)
RRLoadingIndicator.dots(size: .small)
RRLoadingIndicator.pulse(size: .medium)

// Custom colors
RRLoadingIndicator.circular(
    size: .large,
    color: .blue
)
```

### Empty States

```swift
// Pre-built empty states
RREmptyState.noSearchResults(query: "example")
RREmptyState.noInternet()
RREmptyState.emptyList()

// Custom empty state
RREmptyState.info(
    icon: Image(systemName: "heart"),
    title: "No Favorites",
    subtitle: "You haven't added any favorites yet.",
    primaryAction: RRButton.primary(title: "Browse Items") {}
)
```

### Layout Helpers

```swift
// Centering
Text("Centered")
    .centerInParent()

// Full width/height
Rectangle()
    .fill(.blue)
    .fullWidth()
    .fixedHeight(100)

// Responsive layout
Text("Responsive")
    .responsive(
        portrait: { $0.font(.title) },
        landscape: { $0.font(.largeTitle) }
    )

// Device-specific
Text("Device Specific")
    .deviceSpecific(
        iPhone: { $0.font(.headline) },
        iPad: { $0.font(.title) }
    )
```

### Theming

```swift
// Access theme in views
@Environment(\.themeManager) private var themeManager

var body: some View {
    Text("Hello World")
        .foregroundColor(themeManager.colorScheme.primary.main)
        .font(themeManager.typography.title)
}

// Switch themes programmatically
Button("Switch to Dark") {
    themeManager.switchToDark()
}

Button("Switch to Light") {
    themeManager.switchToLight()
}
```

## Architecture

The library follows Clean Architecture principles with MVVM:

- **Views**: Pure SwiftUI views with no business logic
- **ViewModels**: State management and user actions
- **Use Cases**: Business logic encapsulation
- **Services**: External dependencies and data access

## Testing

The library includes comprehensive unit tests using the Testing framework:

```bash
swift test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Version History

See [CHANGELOG.md](CHANGELOG.md) for a complete list of changes and versions.

## Support

For questions, issues, or contributions, please open an issue on GitHub or contact the maintainers.


