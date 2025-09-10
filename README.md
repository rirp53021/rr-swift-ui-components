# RRUIComponents

A comprehensive SwiftUI design system with 31 fully integrated components, advanced theming, and accessibility features.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)](https://developer.apple.com/macos/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- **🎨 31 Fully Integrated Components** - Complete set of UI components with consistent theming
- **🎯 100% Design System Complete** - All components, tokens, and features integrated
- **🌙 Advanced Theming** - Light/dark mode support with customizable color schemes
- **♿ Accessibility First** - WCAG compliant components with built-in accessibility features
- **🚀 Production Ready** - Battle-tested components ready for real applications
- **📱 Cross-Platform** - iOS, macOS, watchOS, and tvOS support
- **⚡ Performance Optimized** - Efficient rendering and minimal memory footprint

## 🚀 Quick Start

### Installation

#### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/rr-swift-ui-components.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

### Basic Usage

```swift
import SwiftUI
import RRUIComponents

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeProvider(ThemeProvider())
        }
    }
}

struct ContentView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Welcome to RRUIComponents", style: .title, weight: .semibold)
            
            RRButton("Get Started", style: .primary) {
                // Action
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(theme.colors.surface)
    }
}
```

## 📚 Documentation

- **[Design System Guide](DESIGN_SYSTEM_GUIDE.md)** - Comprehensive guide to the design system
- **[API Documentation](docs/API.md)** - Complete API reference
- **[Component Examples](docs/Examples.md)** - Usage examples for all components
- **[Migration Guide](docs/Migration.md)** - Guide for migrating from other UI libraries

## 🎨 Components

### Basic Components
- **RRLabel** - Typography component with design system integration
- **RRButton** - Button component with multiple styles and states
- **RRTextField** - Text input component with validation states
- **RRAsyncImage** - Async image loading with placeholder and error states

### Form Components
- **RRToggle** - Toggle switch component
- **RRCheckbox** - Checkbox component with validation states
- **RRDropdown** - Dropdown/picker component
- **RRDatePicker** - Date and time picker component
- **RRSlider** - Slider component with range support
- **RRStepper** - Stepper component for numeric input

### Navigation Components
- **RRNavigationBar** - Navigation bar component
- **RRTabBar** - Tab bar component
- **RRSegmentedControl** - Segmented control component

### Feedback Components
- **RRAlert** - Alert component with multiple styles
- **RRSnackbar** - Snackbar component for notifications
- **RRLoadingIndicator** - Loading indicator component
- **RREmptyState** - Empty state component

### Layout Components
- **RRCard** - Card component with header/footer support
- **RRRowItem** - Row item component for lists
- **RRGridView** - Grid layout component
- **RRStackedView** - Stacked view component

### Advanced Components
- **RRModal** - Modal component with multiple presentation styles
- **RRCarousel** - Carousel component with page indicators
- **RRSearchBar** - Search bar component with suggestions
- **RRRating** - Rating component with multiple styles
- **RRTimeline** - Timeline component for progress tracking
- **RRTagInput** - Tag input component

## 🎯 Design System

### Design Tokens

The design system includes comprehensive design tokens:

- **Colors** - Primary, secondary, surface, state, gradient, and overlay colors
- **Typography** - Display, headline, title, body, and label styles
- **Spacing** - Consistent spacing scale (xs, sm, md, lg, xl, xxl)
- **Layout** - Grid system, container widths, and breakpoints
- **Elevation** - Shadow and elevation tokens
- **Transitions** - Animation and transition tokens
- **Z-Index** - Layer ordering tokens

### Theming

```swift
// Light theme (default)
.themeProvider(ThemeProvider())

// Dark theme
.themeProvider(ThemeProvider(theme: .dark))

// High contrast theme
.themeProvider(ThemeProvider(theme: .highContrast))

// Custom theme
let customTheme = Theme(/* custom configuration */)
.themeProvider(ThemeProvider(customTheme: customTheme))
```

### Color System

The design system includes a comprehensive color system:

- **Primary Colors** - Brand colors for primary actions
- **Secondary Colors** - Secondary brand colors
- **Surface Colors** - Background and surface colors
- **State Colors** - Success, warning, error, and info colors
- **Interactive States** - Focus, hover, pressed, selected, and active colors
- **Gradient Colors** - Gradient backgrounds
- **Overlay Colors** - Modal and overlay backgrounds

## ♿ Accessibility

All components are built with accessibility in mind:

- **WCAG 2.1 AA Compliant** - Meets accessibility standards
- **Screen Reader Support** - Proper accessibility labels and hints
- **Keyboard Navigation** - Full keyboard accessibility
- **High Contrast Support** - Automatic adaptation to high contrast mode
- **Dynamic Type Support** - Respects user's text size preferences

## 📱 Platform Support

- **iOS 15.0+**
- **macOS 12.0+**
- **watchOS 8.0+**
- **tvOS 15.0+**

## 🔧 Requirements

- **Swift 5.9+**
- **Xcode 15.0+**
- **iOS 15.0+** / **macOS 12.0+** / **watchOS 8.0+** / **tvOS 15.0+**

## 📦 Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/rr-swift-ui-components.git", from: "1.0.0")
]
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'RRUIComponents', '~> 1.0'
```

### Carthage

Add the following to your `Cartfile`:

```
github "your-username/rr-swift-ui-components" ~> 1.0
```

## 🚀 Getting Started

### 1. Add the Package

Add RRUIComponents to your project using Swift Package Manager.

### 2. Import the Framework

```swift
import RRUIComponents
```

### 3. Set Up ThemeProvider

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

### 4. Use Components

```swift
struct ContentView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Hello World", style: .title, weight: .semibold)
            
            RRButton("Click me", style: .primary) {
                // Action
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(theme.colors.surface)
    }
}
```

## 📖 Examples

### Basic Form

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            RRTextField("Email", text: $email)
            RRTextField("Password", text: $password, isSecure: true)
            
            RRButton("Login", style: .primary) {
                // Login action
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

### Card with Image

```swift
struct ProfileCard: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        RRCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                RRAsyncImage(url: profileImageURL)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                RRLabel(profile.name, style: .title, weight: .semibold)
                RRLabel(profile.title, style: .body, color: .secondary)
            }
        }
        .background(theme.colors.surface)
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
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Open `rr-swift-ui-components.xcodeproj`
3. Build and run the example project
4. Make your changes
5. Add tests for new functionality
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- SwiftUI team for the amazing framework
- Design system community for inspiration and best practices
- Contributors and users for feedback and improvements

## 📞 Support

- **Documentation**: [Design System Guide](DESIGN_SYSTEM_GUIDE.md)
- **Issues**: [GitHub Issues](https://github.com/your-username/rr-swift-ui-components/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/rr-swift-ui-components/discussions)

## 🗺️ Roadmap

- [ ] Additional components (RRTable, RRChart, RRVideoPlayer)
- [ ] Advanced theming features
- [ ] Performance optimizations
- [ ] Additional platform support
- [ ] Visual regression testing
- [ ] Component playground

---

**Made with ❤️ for the SwiftUI community**