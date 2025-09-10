# Quick Start Guide

Get up and running with RRUIComponents in minutes!

## 🚀 Installation

### Swift Package Manager

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/your-username/rr-swift-ui-components.git`
3. Select the version and add to your target

### Manual Installation

1. Clone the repository
2. Drag `RRUIComponents.xcodeproj` into your project
3. Add `RRUIComponents` to your target dependencies

## ⚡ 5-Minute Setup

### 1. Import the Framework

```swift
import SwiftUI
import RRUIComponents
```

### 2. Set Up ThemeProvider

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

### 3. Use Your First Component

```swift
struct ContentView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Hello RRUIComponents!", style: .title, weight: .semibold)
            
            RRButton("Get Started", style: .primary) {
                print("Button tapped!")
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(theme.colors.surface)
    }
}
```

## 🎨 Essential Components

### RRLabel - Typography

```swift
// Basic usage
RRLabel("Hello World", style: .title, weight: .semibold)

// With custom color
RRLabel("Error message", style: .body, color: .error)

// Available styles: .title, .subtitle, .body, .caption, .overline
// Available weights: .light, .regular, .medium, .semibold, .bold
// Available colors: .primary, .secondary, .tertiary, .error, .success, .warning, .info
```

### RRButton - Buttons

```swift
// Primary button
RRButton("Save", style: .primary) {
    // Action
}

// Secondary button
RRButton("Cancel", style: .secondary) {
    // Action
}

// With custom size
RRButton("Large Button", style: .primary, size: .large) {
    // Action
}

// Available styles: .primary, .secondary, .tertiary, .outline, .ghost
// Available sizes: .small, .medium, .large
```

### RRTextField - Text Input

```swift
@State private var text = ""

// Basic text field
RRTextField("Enter text", text: $text)

// With validation
RRTextField("Email", text: $email, validationState: .valid)

// Secure text field
RRTextField("Password", text: $password, isSecure: true)

// Available validation states: .none, .valid, .invalid, .warning
```

### RRCard - Cards

```swift
RRCard {
    VStack {
        RRLabel("Card Title", style: .title, weight: .semibold)
        RRLabel("Card content goes here", style: .body)
    }
}

// With header and footer
RRCard(
    header: {
        RRLabel("Header", style: .subtitle)
    },
    footer: {
        RRButton("Action", style: .primary) { }
    }
) {
    RRLabel("Card content", style: .body)
}
```

## 🎯 Design Tokens

### Spacing

```swift
// Use spacing tokens for consistent spacing
VStack(spacing: DesignTokens.Spacing.md) {
    // Content
}

// Available spacing: .xs (4px), .sm (8px), .md (16px), .lg (24px), .xl (32px), .xxl (48px)
```

### Colors

```swift
@Environment(\.themeProvider) private var themeProvider
private var theme: Theme { themeProvider.currentTheme }

// Use theme colors
.background(theme.colors.primary)
.foregroundColor(theme.colors.onPrimary)

// Available colors: primary, secondary, surface, background, error, success, warning, info, etc.
```

### Typography

```swift
// Use typography tokens
.font(DesignTokens.Typography.titleLarge)
.font(DesignTokens.Typography.bodyMedium)

// Or use RRLabel for automatic typography
RRLabel("Text", style: .title, weight: .medium)
```

## 🌙 Theming

### Light/Dark Mode

The design system automatically supports light and dark mode:

```swift
// Automatic theme switching
.themeProvider(ThemeProvider())

// Force light theme
.themeProvider(ThemeProvider(theme: .light))

// Force dark theme
.themeProvider(ThemeProvider(theme: .dark))
```

### Custom Colors

```swift
// Create custom theme colors
let customColors = ThemeColors(
    primary: Color.blue,
    secondary: Color.green,
    // ... other colors
)

let customTheme = Theme(colors: customColors)
.themeProvider(ThemeProvider(customTheme: customTheme))
```

## 📱 Common Patterns

### Form with Validation

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isValid = false
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            RRTextField(
                "Email",
                text: $email,
                validationState: isValid ? .valid : .none
            )
            
            RRTextField(
                "Password",
                text: $password,
                isSecure: true,
                validationState: isValid ? .valid : .none
            )
            
            RRButton("Login", style: .primary) {
                // Login action
            }
            .disabled(!isValid)
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

### List with Cards

```swift
struct ItemList: View {
    let items: [Item]
    
    var body: some View {
        LazyVStack(spacing: DesignTokens.Spacing.md) {
            ForEach(items) { item in
                RRCard {
                    HStack {
                        RRAsyncImage(url: item.imageURL)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm))
                        
                        VStack(alignment: .leading) {
                            RRLabel(item.title, style: .subtitle, weight: .medium)
                            RRLabel(item.description, style: .caption, color: .secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
```

### Modal Presentation

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
            ModalContent()
        }
    }
}

struct ModalContent: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Modal Title", style: .title, weight: .semibold)
            RRLabel("Modal content goes here", style: .body)
            
            RRButton("Close", style: .primary) {
                dismiss()
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

## ♿ Accessibility

All components are accessible by default:

```swift
// Accessibility labels
RRButton("Save")
    .accessibilityLabel("Save document")

// Accessibility hints
RRButton("Delete")
    .accessibilityHint("Permanently delete this item")

// Accessibility traits
RRButton("Play")
    .accessibilityAddTraits(.isButton)
```

## 🎨 Best Practices

### 1. Always Use Design Tokens

```swift
// ✅ Good
.padding(DesignTokens.Spacing.md)
.background(theme.colors.primary)

// ❌ Bad
.padding(16)
.background(Color.blue)
```

### 2. Use ThemeProvider

```swift
// ✅ Good
@Environment(\.themeProvider) private var themeProvider
private var theme: Theme { themeProvider.currentTheme }

// ❌ Bad
.background(Color.blue)
```

### 3. Use RRLabel for Text

```swift
// ✅ Good
RRLabel("Hello", style: .title, weight: .medium)

// ❌ Bad
Text("Hello")
    .font(.title)
    .fontWeight(.medium)
```

## 🚀 Next Steps

1. **Explore Components** - Check out all 31 components in the documentation
2. **Read the Guide** - See the [Design System Guide](DESIGN_SYSTEM_GUIDE.md) for comprehensive information
3. **Check Examples** - Look at the example project for real-world usage
4. **Join Community** - Get help and share your experience

## 📚 Resources

- **[Design System Guide](DESIGN_SYSTEM_GUIDE.md)** - Comprehensive guide
- **[API Documentation](docs/API.md)** - Complete API reference
- **[Examples](docs/Examples.md)** - Usage examples
- **[GitHub Repository](https://github.com/your-username/rr-swift-ui-components)** - Source code

---

**Ready to build amazing apps with RRUIComponents!** 🎉
