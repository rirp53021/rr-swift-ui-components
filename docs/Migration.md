# Migration Guide

## Table of Contents

1. [From Native SwiftUI](#from-native-swiftui)
2. [From Other UI Libraries](#from-other-ui-libraries)
3. [Version Migration](#version-migration)
4. [Breaking Changes](#breaking-changes)
5. [Migration Checklist](#migration-checklist)

## From Native SwiftUI

### 1. Basic Components

#### Text → RRLabel

**Before:**
```swift
Text("Hello World")
    .font(.title)
    .fontWeight(.semibold)
    .foregroundColor(.primary)
```

**After:**
```swift
RRLabel("Hello World", style: .titleLarge, weight: .semibold, color: .primary)
```

#### Button → RRButton

**Before:**
```swift
Button("Click me") {
    // Action
}
.foregroundColor(.white)
.background(Color.blue)
.padding()
.cornerRadius(8)
```

**After:**
```swift
RRButton("Click me", style: .primary) {
    // Action
}
```

#### TextField → RRTextField

**Before:**
```swift
TextField("Placeholder", text: $text)
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding()
```

**After:**
```swift
RRTextField("Placeholder", text: $text, style: .outlined)
```

### 2. Layout Components

#### VStack/HStack with Spacing

**Before:**
```swift
VStack(spacing: 16) {
    Text("Title")
    Text("Subtitle")
}
.padding(20)
```

**After:**
```swift
VStack(spacing: DesignTokens.Spacing.lg) {
    RRLabel("Title", style: .titleLarge)
    RRLabel("Subtitle", style: .bodyLarge)
}
.padding(DesignTokens.Spacing.lg)
```

#### Custom Card → RRCard

**Before:**
```swift
VStack {
    Text("Card Content")
}
.padding()
.background(Color(.systemBackground))
.cornerRadius(12)
.shadow(radius: 4)
```

**After:**
```swift
RRCard {
    RRLabel("Card Content", style: .bodyLarge)
}
```

### 3. Navigation

#### NavigationView → RRNavigationBar

**Before:**
```swift
NavigationView {
    VStack {
        Text("Content")
    }
    .navigationTitle("Title")
    .navigationBarTitleDisplayMode(.large)
}
```

**After:**
```swift
VStack {
    RRLabel("Content", style: .bodyLarge)
}
.navigationBar(
    title: "Title",
    leadingButton: { AnyView(Button("Back") {}) },
    trailingButton: { AnyView(Button("Done") {}) }
)
```

### 4. Modals

#### Sheet → RRModal

**Before:**
```swift
.sheet(isPresented: $showingModal) {
    ModalContent()
}
```

**After:**
```swift
.modal(isPresented: $showingModal) {
    ModalContent()
}
```

### 5. Lists

#### List → RRList

**Before:**
```swift
List(items) { item in
    HStack {
        Text(item.title)
        Spacer()
        Text(item.subtitle)
    }
}
```

**After:**
```swift
RRList(data: items) { item in
    HStack {
        RRLabel(item.title, style: .bodyLarge)
        Spacer()
        RRLabel(item.subtitle, style: .bodyMedium, color: .secondary)
    }
}
```

## From Other UI Libraries

### 1. From Material Design Components

#### Material Button → RRButton

**Before (Material):**
```swift
Button(action: {}) {
    Text("Button")
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(4)
}
```

**After:**
```swift
RRButton("Button", style: .primary) {
    // Action
}
```

#### Material Card → RRCard

**Before (Material):**
```swift
Card {
    VStack {
        Text("Card Content")
    }
    .padding()
}
```

**After:**
```swift
RRCard {
    RRLabel("Card Content", style: .bodyLarge)
}
```

### 2. From UIKit Components

#### UIButton → RRButton

**Before (UIKit):**
```swift
let button = UIButton(type: .system)
button.setTitle("Button", for: .normal)
button.backgroundColor = .systemBlue
button.layer.cornerRadius = 8
```

**After:**
```swift
RRButton("Button", style: .primary) {
    // Action
}
```

#### UITextField → RRTextField

**Before (UIKit):**
```swift
let textField = UITextField()
textField.placeholder = "Placeholder"
textField.borderStyle = .roundedRect
```

**After:**
```swift
RRTextField("Placeholder", text: $text, style: .outlined)
```

### 3. From React Native Components

#### React Native Button → RRButton

**Before (React Native):**
```jsx
<TouchableOpacity style={styles.button}>
    <Text style={styles.buttonText}>Button</Text>
</TouchableOpacity>
```

**After:**
```swift
RRButton("Button", style: .primary) {
    // Action
}
```

#### React Native Text → RRLabel

**Before (React Native):**
```jsx
<Text style={styles.title}>Title</Text>
```

**After:**
```swift
RRLabel("Title", style: .titleLarge)
```

## Version Migration

### From v1.0 to v1.8

#### 1. Theme Provider Changes

**Before:**
```swift
@StateObject private var themeProvider = ThemeProvider()
```

**After:**
```swift
@Environment(\.themeProvider) private var themeProvider
```

#### 2. Component API Updates

**Before:**
```swift
RRLabel("Text", style: .title)
```

**After:**
```swift
RRLabel("Text", style: .titleLarge)
```

#### 3. Design Tokens Access

**Before:**
```swift
DesignTokens.Colors.primary
```

**After:**
```swift
theme.colors.primary
// or
DesignTokens.Colors.primary
```

### From v1.5 to v1.8

#### 1. New Components Added

- RRTable
- RRList
- RRChart
- RRDataGrid
- RRDivider
- RRSpacer
- RRContainer
- RRSection
- RRTooltip
- RRPopover
- RRContextMenu
- RROverlay
- RRVideoPlayer
- RRImageGallery
- RRMediaViewer

#### 2. Performance Optimizations

- Bundle optimization
- Memory management
- Lazy loading support

#### 3. Testing Framework

- Swift Testing framework
- Comprehensive test coverage
- Visual regression tests

## Breaking Changes

### v1.8.0

#### 1. Swift 6 Compatibility

- All components now use `@MainActor`
- Concurrency support updated
- Some API changes for thread safety

#### 2. Theme Provider API

- Environment-based theme access
- Simplified theme switching
- Better performance

#### 3. Component API Updates

- Consistent parameter naming
- Improved accessibility
- Better error handling

### v1.5.0

#### 1. Design Token Structure

- Reorganized token hierarchy
- Better type safety
- Improved performance

#### 2. Component Lifecycle

- Automatic memory management
- Better state handling
- Improved performance

## Migration Checklist

### Pre-Migration

- [ ] Backup your current project
- [ ] Review breaking changes
- [ ] Update to latest Xcode version
- [ ] Check Swift version compatibility

### Migration Steps

#### 1. Update Dependencies

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/your-username/rr-swift-ui-components.git", from: "1.8.0")
]
```

#### 2. Update Imports

```swift
import RRUIComponents
```

#### 3. Add Theme Provider

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeProvider(ThemeProvider())
        }
    }
}
```

#### 4. Update Components

- [ ] Replace `Text` with `RRLabel`
- [ ] Replace `Button` with `RRButton`
- [ ] Replace `TextField` with `RRTextField`
- [ ] Update spacing to use `DesignTokens.Spacing`
- [ ] Update colors to use theme colors

#### 5. Update Layout

- [ ] Use `RRCard` for card layouts
- [ ] Use `RRModal` for modal presentations
- [ ] Use `RRNavigationBar` for navigation
- [ ] Use `RRTabBar` for tab navigation

#### 6. Update Forms

- [ ] Use `RRToggle` for toggles
- [ ] Use `RRCheckbox` for checkboxes
- [ ] Use `RRDropdown` for dropdowns
- [ ] Use `RRDatePicker` for date selection
- [ ] Use `RRSlider` for sliders
- [ ] Use `RRStepper` for steppers

#### 7. Update Data Display

- [ ] Use `RRTable` for data tables
- [ ] Use `RRList` for lists
- [ ] Use `RRChart` for charts
- [ ] Use `RRDataGrid` for grid data

#### 8. Update Media

- [ ] Use `RRCarousel` for carousels
- [ ] Use `RRVideoPlayer` for video
- [ ] Use `RRImageGallery` for image galleries
- [ ] Use `RRMediaViewer` for media viewing

#### 9. Update Overlays

- [ ] Use `RRTooltip` for tooltips
- [ ] Use `RRPopover` for popovers
- [ ] Use `RRContextMenu` for context menus
- [ ] Use `RROverlay` for overlays

#### 10. Update Advanced Components

- [ ] Use `RRSearchBar` for search
- [ ] Use `RRRating` for ratings
- [ ] Use `RRTimeline` for timelines
- [ ] Use `RRTagInput` for tag input

### Post-Migration

- [ ] Test all functionality
- [ ] Verify accessibility
- [ ] Check performance
- [ ] Update documentation
- [ ] Train team on new components

### Testing

- [ ] Run unit tests
- [ ] Run integration tests
- [ ] Run visual regression tests
- [ ] Test on different devices
- [ ] Test with different themes

### Performance

- [ ] Check memory usage
- [ ] Verify bundle size
- [ ] Test with large datasets
- [ ] Profile performance

### Accessibility

- [ ] Test with VoiceOver
- [ ] Test keyboard navigation
- [ ] Test with different text sizes
- [ ] Check color contrast

## Support

If you encounter issues during migration:

1. Check the [API Documentation](API.md)
2. Review the [Best Practices Guide](BestPractices.md)
3. Look at the example code
4. Check the test suite for usage examples
5. Open an issue on GitHub

## Migration Tools

### Automated Migration Script

A migration script is available to help automate the migration process:

```bash
# Run migration script
./migrate.sh --from-version=1.0 --to-version=1.8
```

### Manual Migration Helper

Use the migration helper to identify components that need updating:

```swift
// Add this to your project temporarily
import RRUIComponents

struct MigrationHelper {
    static func identifyComponents() {
        // This will help identify components that need migration
    }
}
```

## Common Migration Issues

### 1. Theme Not Applied

**Issue:** Components don't use the theme after migration.

**Solution:** Ensure `ThemeProvider` is properly configured and components use theme colors.

### 2. Spacing Inconsistent

**Issue:** Spacing looks different after migration.

**Solution:** Update all spacing values to use `DesignTokens.Spacing`.

### 3. Colors Not Updating

**Issue:** Colors don't change when switching themes.

**Solution:** Replace hardcoded colors with theme colors.

### 4. Accessibility Issues

**Issue:** Components aren't accessible after migration.

**Solution:** Verify proper accessibility configuration and test with VoiceOver.

### 5. Performance Issues

**Issue:** App performance degraded after migration.

**Solution:** Check for memory leaks and optimize component usage.
