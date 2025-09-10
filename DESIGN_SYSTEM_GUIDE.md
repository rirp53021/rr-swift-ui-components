# RRUIComponents Design System Guide

## Table of Contents
1. [Overview](#overview)
2. [Design Principles](#design-principles)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Spacing & Layout](#spacing--layout)
6. [Components](#components)
7. [Theming](#theming)
8. [Accessibility](#accessibility)
9. [Usage Examples](#usage-examples)
10. [Best Practices](#best-practices)

## Overview

RRUIComponents is a comprehensive SwiftUI design system that provides a complete set of reusable UI components, design tokens, and theming capabilities. The design system is built with accessibility, consistency, and flexibility in mind.

### Key Features
- **31 Fully Integrated Components** - Complete set of UI components with consistent theming
- **Comprehensive Design Tokens** - Spacing, typography, colors, elevation, transitions, and layout tokens
- **Advanced Theming** - Light/dark mode support with customizable color schemes
- **Accessibility First** - WCAG compliant components with built-in accessibility features
- **Production Ready** - Battle-tested components ready for real applications

## Design Principles

### 1. Consistency
All components follow the same design patterns, spacing, and visual hierarchy to create a cohesive user experience.

### 2. Accessibility
Every component is built with accessibility in mind, supporting screen readers, high contrast modes, and WCAG guidelines.

### 3. Flexibility
Components are highly customizable while maintaining design system consistency through design tokens.

### 4. Performance
Optimized for performance with efficient rendering and minimal memory footprint.

### 5. Maintainability
Clean, well-documented code that's easy to maintain and extend.

## Color System

### Color Categories

#### Primary Colors
- **Primary**: Main brand color for primary actions and highlights
- **OnPrimary**: Text and icons on primary backgrounds
- **PrimaryVariant**: Lighter variant of primary color

#### Secondary Colors
- **Secondary**: Secondary brand color for secondary actions
- **OnSecondary**: Text and icons on secondary backgrounds
- **SecondaryVariant**: Lighter variant of secondary color

#### Tertiary Colors
- **Tertiary**: Tertiary brand color for additional actions
- **OnTertiary**: Text and icons on tertiary backgrounds

#### Surface Colors
- **Background**: Main background color
- **Surface**: Surface color for cards and containers
- **SurfaceVariant**: Variant surface color for subtle backgrounds
- **OnBackground**: Text and icons on background
- **OnSurface**: Text and icons on surface
- **OnSurfaceVariant**: Text and icons on surface variant

#### State Colors
- **Success**: Success states and positive feedback
- **Warning**: Warning states and caution
- **Error**: Error states and negative feedback
- **Info**: Informational states
- **Disabled**: Disabled states
- **OnSuccess/OnWarning/OnError/OnInfo**: Text and icons on state colors

#### Interactive State Colors
- **Focus**: Focus states for accessibility
- **Hover**: Hover states for interactive elements
- **Pressed**: Pressed states for buttons and controls
- **Selected**: Selected states for selections
- **Active**: Active states for active elements

#### Gradient Colors
- **PrimaryGradient**: Primary gradient for backgrounds
- **SecondaryGradient**: Secondary gradient for backgrounds
- **SurfaceGradient**: Surface gradient for subtle backgrounds
- **BackgroundGradient**: Background gradient for main backgrounds

#### Overlay Colors
- **ModalOverlay**: Overlay for modal presentations
- **TooltipBackground**: Background for tooltips
- **DropdownOverlay**: Overlay for dropdowns
- **LoadingOverlay**: Overlay for loading states

#### Text Colors
- **PrimaryText**: Primary text color
- **SecondaryText**: Secondary text color

#### Outline Colors
- **Outline**: Primary outline color
- **OutlineVariant**: Variant outline color
- **OnOutline/OnOutlineVariant**: Text and icons on outlines

### Color Usage Guidelines

1. **Use semantic colors** - Always use semantic color names (primary, secondary, error) rather than specific colors
2. **Maintain contrast** - Ensure sufficient contrast between text and background colors
3. **Consistent theming** - Use ThemeProvider to ensure consistent color application
4. **Accessibility** - Test colors in high contrast mode and with colorblind users

## Typography

### Typography Scale

#### Display
- **DisplayLarge**: 57px, 64px line height, 400 weight
- **DisplayMedium**: 45px, 52px line height, 400 weight
- **DisplaySmall**: 36px, 44px line height, 400 weight

#### Headline
- **HeadlineLarge**: 32px, 40px line height, 400 weight
- **HeadlineMedium**: 28px, 36px line height, 400 weight
- **HeadlineSmall**: 24px, 32px line height, 400 weight

#### Title
- **TitleLarge**: 22px, 28px line height, 400 weight
- **TitleMedium**: 16px, 24px line height, 500 weight
- **TitleSmall**: 14px, 20px line height, 500 weight

#### Body
- **BodyLarge**: 16px, 24px line height, 400 weight
- **BodyMedium**: 14px, 20px line height, 400 weight
- **BodySmall**: 12px, 16px line height, 400 weight

#### Label
- **LabelLarge**: 14px, 20px line height, 500 weight
- **LabelMedium**: 12px, 16px line height, 500 weight
- **LabelSmall**: 11px, 16px line height, 500 weight

### Typography Usage

```swift
// Using RRLabel with design system typography
RRLabel("Hello World", style: .title, weight: .medium, color: .primary)

// Available styles: .title, .subtitle, .body, .caption, .overline
// Available weights: .light, .regular, .medium, .semibold, .bold
// Available colors: .primary, .secondary, .tertiary, .error, .success, .warning, .info
```

## Spacing & Layout

### Spacing Scale

- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 48px

### Layout Tokens

#### Grid System
- **gridColumns**: 12-column grid system
- **gridGap**: 16px default gap
- **gridGapSmall**: 8px small gap
- **gridGapLarge**: 24px large gap

#### Container Max Widths
- **containerMaxWidth**: 1200px default
- **containerMaxWidthSmall**: 768px
- **containerMaxWidthMedium**: 1024px
- **containerMaxWidthLarge**: 1440px

#### Breakpoints
- **mobile**: 0px
- **tablet**: 768px
- **desktop**: 1024px
- **wide**: 1440px

### Usage Examples

```swift
// Using spacing tokens
VStack(spacing: DesignTokens.Spacing.md) {
    // Content
}

// Using layout tokens
HStack(spacing: DesignTokens.Layout.gridGap) {
    // Grid items
}

// Using breakpoints
if DesignTokens.Breakpoints.isTablet(width) {
    // Tablet-specific layout
}
```

## Components

### Component Categories

#### Basic Components
- **RRLabel**: Typography component with design system integration
- **RRButton**: Button component with multiple styles and states
- **RRTextField**: Text input component with validation states
- **RRAsyncImage**: Async image loading with placeholder and error states

#### Form Components
- **RRToggle**: Toggle switch component
- **RRCheckbox**: Checkbox component with validation states
- **RRDropdown**: Dropdown/picker component
- **RRDatePicker**: Date and time picker component
- **RRSlider**: Slider component with range support
- **RRStepper**: Stepper component for numeric input

#### Navigation Components
- **RRNavigationBar**: Navigation bar component
- **RRTabBar**: Tab bar component
- **RRSegmentedControl**: Segmented control component

#### Feedback Components
- **RRAlert**: Alert component with multiple styles
- **RRSnackbar**: Snackbar component for notifications
- **RRLoadingIndicator**: Loading indicator component
- **RREmptyState**: Empty state component

#### Layout Components
- **RRCard**: Card component with header/footer support
- **RRRowItem**: Row item component for lists
- **RRGridView**: Grid layout component
- **RRStackedView**: Stacked view component

#### Advanced Components
- **RRModal**: Modal component with multiple presentation styles
- **RRCarousel**: Carousel component with page indicators
- **RRSearchBar**: Search bar component with suggestions
- **RRRating**: Rating component with multiple styles
- **RRTimeline**: Timeline component for progress tracking
- **RRTagInput**: Tag input component

### Component Usage

All components follow a consistent pattern:

```swift
// Basic usage
RRButton("Click me", style: .primary, size: .medium) {
    // Action
}

// With customization
RRButton("Custom Button", style: .secondary, size: .large) {
    // Action
}
.foregroundColor(.white)
.background(Color.blue)
.cornerRadius(DesignTokens.BorderRadius.md)
```

## Theming

### ThemeProvider

The ThemeProvider is the central component for managing themes and colors throughout the application.

```swift
// Basic usage
@Environment(\.themeProvider) private var themeProvider
private var theme: Theme { themeProvider.currentTheme }

// Using theme colors
.background(theme.colors.primary)
.foregroundColor(theme.colors.onPrimary)
```

### Theme Variants

#### Light Theme
Default theme with light backgrounds and dark text.

#### Dark Theme
Dark theme with dark backgrounds and light text.

#### High Contrast Theme
High contrast theme for accessibility.

### Custom Themes

```swift
// Creating a custom theme
let customTheme = Theme(
    colors: ThemeColors(
        primary: Color.blue,
        secondary: Color.green,
        // ... other colors
    ),
    typography: ThemeTypography(),
    spacing: DesignTokens.Spacing.self,
    // ... other properties
)

// Applying custom theme
.themeProvider(ThemeProvider(customTheme: customTheme))
```

## Accessibility

### WCAG Compliance

All components are built to meet WCAG 2.1 AA standards:

- **Color Contrast**: Minimum 4.5:1 contrast ratio for normal text
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Proper accessibility labels and hints
- **Focus Management**: Clear focus indicators

### Accessibility Features

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

### High Contrast Support

The design system automatically adapts to high contrast mode:

```swift
// High contrast colors are automatically applied
.background(theme.colors.primary) // Automatically uses high contrast variant
```

## Usage Examples

### Basic App Setup

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
```

### Component Composition

```swift
struct ProfileView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRAsyncImage(url: profileImageURL)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            RRLabel(profile.name, style: .title, weight: .semibold)
            
            RRButton("Edit Profile", style: .primary) {
                // Edit action
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(theme.colors.surface)
        .cornerRadius(DesignTokens.BorderRadius.lg)
    }
}
```

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
    }
}
```

## Best Practices

### 1. Use Design Tokens
Always use design tokens instead of hardcoded values:

```swift
// ✅ Good
.padding(DesignTokens.Spacing.md)
.background(theme.colors.primary)

// ❌ Bad
.padding(16)
.background(Color.blue)
```

### 2. Use ThemeProvider
Always use ThemeProvider for consistent theming:

```swift
// ✅ Good
@Environment(\.themeProvider) private var themeProvider
private var theme: Theme { themeProvider.currentTheme }

// ❌ Bad
.background(Color.blue)
```

### 3. Use RRLabel
Use RRLabel instead of native Text for consistent typography:

```swift
// ✅ Good
RRLabel("Hello", style: .title, weight: .medium)

// ❌ Bad
Text("Hello")
    .font(.title)
    .fontWeight(.medium)
```

### 4. Accessibility First
Always consider accessibility when building components:

```swift
// ✅ Good
RRButton("Save")
    .accessibilityLabel("Save document")
    .accessibilityHint("Saves the current document")

// ❌ Bad
RRButton("Save") // No accessibility information
```

### 5. Consistent Spacing
Use the spacing scale consistently:

```swift
// ✅ Good
VStack(spacing: DesignTokens.Spacing.md) {
    // Content
}

// ❌ Bad
VStack(spacing: 15) { // Inconsistent spacing
    // Content
}
```

### 6. Error Handling
Always handle error states properly:

```swift
// ✅ Good
RRAsyncImage(url: imageURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
} errorView: { error in
    RRLabel("Failed to load image", style: .caption, color: .error)
}
```

### 7. Performance
Use lazy loading for large lists:

```swift
// ✅ Good
LazyVStack {
    ForEach(items) { item in
        RRRowItem(item)
    }
}

// ❌ Bad
VStack { // Loads all items at once
    ForEach(items) { item in
        RRRowItem(item)
    }
}
```

## Conclusion

The RRUIComponents design system provides a comprehensive foundation for building consistent, accessible, and maintainable SwiftUI applications. By following the guidelines and best practices outlined in this guide, you can create applications that are both beautiful and functional.

For more detailed information about specific components, refer to the individual component documentation and API references.
