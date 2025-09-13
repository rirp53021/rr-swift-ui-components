# RRUIComponents Best Practices Guide

## Table of Contents

1. [Getting Started](#getting-started)
2. [Component Usage](#component-usage)
3. [Theming](#theming)
4. [Performance](#performance)
5. [Accessibility](#accessibility)
6. [Testing](#testing)
7. [Common Patterns](#common-patterns)
8. [Troubleshooting](#troubleshooting)

## Getting Started

### 1. Project Setup

Always start by setting up the `ThemeProvider` at the root of your app:

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

### 2. Import the Framework

```swift
import RRUIComponents
```

### 3. Use Environment for Theme Access

```swift
struct MyView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        // Your view content
    }
}
```

## Component Usage

### 1. Always Use Design Tokens

❌ **Don't:**
```swift
VStack(spacing: 16) {
    Text("Title")
        .font(.title)
        .foregroundColor(.blue)
}
```

✅ **Do:**
```swift
VStack(spacing: DesignTokens.Spacing.lg) {
    RRLabel("Title", style: .titleLarge, color: .primary)
}
```

### 2. Use Consistent Component Patterns

❌ **Don't:**
```swift
Button("Click me") {
    // Action
}
.foregroundColor(.white)
.background(Color.blue)
.padding()
```

✅ **Do:**
```swift
RRButton("Click me", style: .primary) {
    // Action
}
```

### 3. Leverage Component Variants

```swift
// Use appropriate button styles
RRButton("Primary Action", style: .primary) { }
RRButton("Secondary Action", style: .secondary) { }
RRButton("Destructive Action", style: .destructive) { }

// Use appropriate text styles
RRLabel("Large Title", style: .displayLarge)
RRLabel("Section Header", style: .headlineLarge)
RRLabel("Body Text", style: .bodyLarge)
RRLabel("Caption", style: .labelLarge)
```

## Theming

### 1. Theme Provider Configuration

```swift
// Light theme (default)
.themeProvider(ThemeProvider())

// Dark theme
.themeProvider(ThemeProvider(theme: .dark))

// High contrast theme
.themeProvider(ThemeProvider(theme: .highContrast))

// Custom theme
let customTheme = Theme(
    colors: CustomColors(),
    typography: CustomTypography(),
    spacing: CustomSpacing()
)
.themeProvider(ThemeProvider(theme: customTheme))
```

### 2. Color Usage

```swift
// Use theme colors
.background(theme.colors.surface)
.foregroundColor(theme.colors.primary)

// Use design token colors
.background(DesignTokens.Colors.surface)
.foregroundColor(DesignTokens.Colors.primary)
```

### 3. Typography Consistency

```swift
// Use consistent typography hierarchy
RRLabel("Page Title", style: .displayLarge)
RRLabel("Section Title", style: .headlineLarge)
RRLabel("Card Title", style: .titleLarge)
RRLabel("Body Text", style: .bodyLarge)
RRLabel("Label", style: .labelLarge)
```

### 4. Spacing Consistency

```swift
// Use consistent spacing scale
VStack(spacing: DesignTokens.Spacing.md) {
    // Content
}
.padding(DesignTokens.Spacing.lg)
```

## Performance

### 1. Lazy Loading for Large Lists

```swift
// Use LazyVStack for large vertical lists
LazyVStack(spacing: DesignTokens.Spacing.sm) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}

// Use LazyHStack for large horizontal lists
LazyHStack(spacing: DesignTokens.Spacing.sm) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

### 2. Memory Management

```swift
// Components automatically handle memory cleanup
// No manual cleanup needed for most components

// For custom components, use @State and @Binding appropriately
struct MyComponent: View {
    @State private var localState = ""
    @Binding var externalState: String
    
    var body: some View {
        // Component content
    }
}
```

### 3. Bundle Optimization

```swift
// Use bundle optimization for better performance
BundleOptimizer.shared.optimizeCaches()
```

## Accessibility

### 1. Semantic Labels

```swift
// Components automatically include accessibility labels
RRButton("Save", style: .primary) { }
// Automatically accessible as "Save button"

// Add custom accessibility hints when needed
RRButton("Save", style: .primary) { }
    .accessibilityHint("Saves the current document")
```

### 2. Keyboard Navigation

```swift
// All interactive components support keyboard navigation
VStack {
    RRTextField("Email", text: $email)
    RRTextField("Password", text: $password, isSecure: true)
    RRButton("Login", style: .primary) { }
}
// Tab navigation works automatically
```

### 3. Screen Reader Support

```swift
// Use proper heading hierarchy
RRLabel("Page Title", style: .displayLarge)
    .accessibilityAddTraits(.isHeader)

RRLabel("Section Title", style: .headlineLarge)
    .accessibilityAddTraits(.isHeader)
```

### 4. Dynamic Type Support

```swift
// All text components respect Dynamic Type
RRLabel("Text", style: .bodyLarge)
// Automatically scales with user's text size preference
```

## Testing

### 1. Unit Testing

```swift
@Test func testButtonInitialization() {
    let button = RRButton("Test", style: .primary) { }
    // Test button properties
}
```

### 2. Integration Testing

```swift
@Test func testThemeIntegration() {
    let themeProvider = ThemeProvider(theme: .dark)
    // Test theme integration
}
```

### 3. Visual Regression Testing

```swift
@Test func testComponentAppearance() {
    let component = RRButton("Test", style: .primary) { }
    // Test visual appearance
}
```

## Common Patterns

### 1. Form Layout

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Login", style: .displayLarge)
                .padding(.bottom, DesignTokens.Spacing.md)
            
            VStack(spacing: DesignTokens.Spacing.md) {
                RRTextField("Email", text: $email)
                RRTextField("Password", text: $password, isSecure: isSecure)
            }
            
            RRButton("Login", style: .primary) {
                // Login action
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

### 2. Card Layout

```swift
struct ProfileCard: View {
    let profile: Profile
    
    var body: some View {
        RRCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    RRAsyncImage(url: profile.avatarURL)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        RRLabel(profile.name, style: .titleLarge)
                        RRLabel(profile.title, style: .bodyMedium, color: .secondary)
                    }
                    
                    Spacer()
                }
                
                RRLabel(profile.bio, style: .bodyLarge)
            }
        }
    }
}
```

### 3. Modal Presentation

```swift
struct ContentView: View {
    @State private var showingModal = false
    
    var body: some View {
        VStack {
            RRButton("Show Modal", style: .primary) {
                showingModal = true
            }
        }
        .modal(isPresented: $showingModal) {
            ModalContentView()
        }
    }
}
```

### 4. Data Display

```swift
struct DataView: View {
    let users: [User]
    
    var body: some View {
        RRTable(data: users) { user in
            RRTableColumn("Name") { user.name }
            RRTableColumn("Email") { user.email }
            RRTableColumn("Role") { user.role }
        }
    }
}
```

### 5. Navigation

```swift
struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        RRTabBar(selection: $selectedTab, tabs: [
            TabItem(title: "Home", icon: "house"),
            TabItem(title: "Profile", icon: "person"),
            TabItem(title: "Settings", icon: "gear")
        ]) {
            switch selectedTab {
            case 0: HomeView()
            case 1: ProfileView()
            case 2: SettingsView()
            default: EmptyView()
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Theme Not Applied

**Problem:** Components don't use the theme colors.

**Solution:** Ensure `ThemeProvider` is properly configured at the app root.

```swift
// Make sure this is in your App struct
.themeProvider(ThemeProvider())
```

#### 2. Colors Not Updating

**Problem:** Colors don't change when switching themes.

**Solution:** Use theme colors instead of hardcoded colors.

```swift
// ❌ Don't use hardcoded colors
.foregroundColor(.blue)

// ✅ Use theme colors
.foregroundColor(theme.colors.primary)
```

#### 3. Spacing Inconsistent

**Problem:** Spacing looks inconsistent across components.

**Solution:** Use `DesignTokens.Spacing` values.

```swift
// ❌ Don't use arbitrary spacing
VStack(spacing: 16) { }

// ✅ Use design token spacing
VStack(spacing: DesignTokens.Spacing.lg) { }
```

#### 4. Accessibility Issues

**Problem:** Components aren't accessible to screen readers.

**Solution:** Verify proper accessibility configuration.

```swift
// Add accessibility traits when needed
RRLabel("Title", style: .titleLarge)
    .accessibilityAddTraits(.isHeader)
```

### Debug Tips

1. **Use Xcode's Accessibility Inspector** to test screen reader support
2. **Test with different text sizes** to ensure Dynamic Type works
3. **Verify keyboard navigation** by tabbing through interactive elements
4. **Check color contrast ratios** using accessibility tools
5. **Test on different devices** to ensure responsive design works

### Performance Debugging

1. **Use Xcode's Memory Graph Debugger** to check for memory leaks
2. **Profile with Instruments** to identify performance bottlenecks
3. **Test with large datasets** to ensure components scale well
4. **Monitor bundle size** to ensure optimization is working

### Getting Help

1. **Check the API documentation** for component usage
2. **Review the design system guide** for theming guidelines
3. **Look at the example code** for common patterns
4. **Test with the provided test suite** to understand expected behavior
