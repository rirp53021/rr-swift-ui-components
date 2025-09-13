# Design Guidelines

## Table of Contents

1. [Visual Design Principles](#visual-design-principles)
2. [Component Composition Rules](#component-composition-rules)
3. [Accessibility Guidelines](#accessibility-guidelines)
4. [Performance Recommendations](#performance-recommendations)
5. [Color System Guidelines](#color-system-guidelines)
6. [Typography Guidelines](#typography-guidelines)
7. [Spacing and Layout Guidelines](#spacing-and-layout-guidelines)
8. [Animation Guidelines](#animation-guidelines)
9. [Responsive Design Guidelines](#responsive-design-guidelines)
10. [Theme Customization Guidelines](#theme-customization-guidelines)

## Visual Design Principles

### 1. Consistency

**Principle:** Maintain visual consistency across all components and screens.

**Implementation:**
- Use the same color palette throughout the application
- Apply consistent spacing using `DesignTokens.Spacing`
- Use the same typography hierarchy across all text
- Maintain consistent border radius and shadow styles

**Example:**
```swift
// ✅ Consistent spacing
VStack(spacing: DesignTokens.Spacing.md) {
    RRLabel("Title", style: .titleLarge)
    RRLabel("Subtitle", style: .bodyLarge)
}

// ❌ Inconsistent spacing
VStack(spacing: 16) {
    RRLabel("Title", style: .titleLarge)
    RRLabel("Subtitle", style: .bodyLarge)
}
```

### 2. Hierarchy

**Principle:** Establish clear visual hierarchy to guide user attention.

**Implementation:**
- Use typography scale to create information hierarchy
- Apply appropriate color contrast for different content levels
- Use spacing to group related elements
- Apply visual weight through size, color, and positioning

**Example:**
```swift
VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
    RRLabel("Page Title", style: .displayLarge)        // Most important
    RRLabel("Section Title", style: .headlineLarge)    // Secondary
    RRLabel("Content", style: .bodyLarge)              // Body text
    RRLabel("Caption", style: .labelLarge)             // Least important
}
```

### 3. Clarity

**Principle:** Make interfaces clear and easy to understand.

**Implementation:**
- Use clear, descriptive labels and text
- Provide appropriate visual feedback for user actions
- Use icons and imagery that support the content
- Avoid visual clutter and unnecessary elements

**Example:**
```swift
// ✅ Clear and descriptive
RRButton("Save Changes", style: .primary) { save() }
RRButton("Cancel", style: .secondary) { cancel() }

// ❌ Unclear
RRButton("OK", style: .primary) { save() }
RRButton("No", style: .secondary) { cancel() }
```

### 4. Accessibility

**Principle:** Design for all users, including those with disabilities.

**Implementation:**
- Ensure sufficient color contrast ratios
- Provide alternative text for images
- Support keyboard navigation
- Respect user's text size preferences

**Example:**
```swift
RRAsyncImage(url: imageURL)
    .accessibilityLabel("Profile picture of John Doe")
    .accessibilityHint("Double tap to view full size")
```

## Component Composition Rules

### 1. Single Responsibility

**Rule:** Each component should have a single, well-defined purpose.

**Implementation:**
- Use `RRLabel` only for text display
- Use `RRButton` only for user actions
- Use `RRCard` only for content grouping
- Avoid mixing responsibilities in a single component

**Example:**
```swift
// ✅ Single responsibility
RRCard {
    VStack {
        RRLabel("Title", style: .titleLarge)
        RRLabel("Description", style: .bodyLarge)
        RRButton("Action", style: .primary) { }
    }
}

// ❌ Mixed responsibilities
RRButton("Title\nDescription\nAction", style: .primary) { }
```

### 2. Composition over Inheritance

**Rule:** Build complex UIs by composing simple components.

**Implementation:**
- Combine basic components to create complex layouts
- Use container components for grouping
- Create reusable component combinations
- Avoid creating overly complex single components

**Example:**
```swift
// ✅ Composition
struct UserProfile: View {
    let user: User
    
    var body: some View {
        RRCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                ProfileHeader(user: user)
                ProfileDetails(user: user)
                ProfileActions(user: user)
            }
        }
    }
}

// ❌ Monolithic component
struct UserProfile: View {
    // All profile logic in one component
}
```

### 3. Consistent API Design

**Rule:** Maintain consistent parameter naming and ordering across components.

**Implementation:**
- Use consistent parameter names (e.g., `style`, `size`, `isEnabled`)
- Order parameters logically (content first, then styling, then behavior)
- Use consistent naming conventions
- Provide sensible defaults

**Example:**
```swift
// ✅ Consistent API
RRButton("Text", style: .primary, size: .medium, isEnabled: true) { }
RRLabel("Text", style: .titleLarge, weight: .semibold, color: .primary)
RRTextField("Placeholder", text: $text, style: .outlined, isDisabled: false)

// ❌ Inconsistent API
RRButton("Text", isEnabled: true, style: .primary, size: .medium) { }
RRLabel("Text", color: .primary, style: .titleLarge, weight: .semibold)
```

## Accessibility Guidelines

### 1. WCAG 2.1 AA Compliance

**Requirement:** Meet WCAG 2.1 AA accessibility standards.

**Implementation:**
- Ensure color contrast ratios meet 4.5:1 for normal text
- Provide alternative text for all images
- Support keyboard navigation
- Use semantic HTML elements

**Example:**
```swift
// ✅ Accessible color contrast
RRLabel("Text", style: .bodyLarge, color: .primary)
    .foregroundColor(theme.colors.primary) // High contrast

// ✅ Accessible images
RRAsyncImage(url: imageURL)
    .accessibilityLabel("Descriptive text for screen readers")
```

### 2. Screen Reader Support

**Requirement:** Provide proper support for screen readers.

**Implementation:**
- Use semantic labels and hints
- Provide meaningful alternative text
- Use proper heading hierarchy
- Announce dynamic content changes

**Example:**
```swift
// ✅ Screen reader friendly
RRLabel("Page Title", style: .displayLarge)
    .accessibilityAddTraits(.isHeader)

RRButton("Save", style: .primary) { }
    .accessibilityLabel("Save document")
    .accessibilityHint("Saves the current document to disk")
```

### 3. Keyboard Navigation

**Requirement:** Support full keyboard navigation.

**Implementation:**
- Ensure all interactive elements are keyboard accessible
- Provide visible focus indicators
- Use logical tab order
- Support keyboard shortcuts

**Example:**
```swift
// ✅ Keyboard accessible
VStack {
    RRTextField("Email", text: $email)
        .accessibilityIdentifier("email-field")
    RRTextField("Password", text: $password, isSecure: true)
        .accessibilityIdentifier("password-field")
    RRButton("Login", style: .primary) { }
        .accessibilityIdentifier("login-button")
}
```

### 4. Dynamic Type Support

**Requirement:** Respect user's text size preferences.

**Implementation:**
- Use system fonts that scale with Dynamic Type
- Test with different text sizes
- Ensure layouts adapt to larger text
- Provide alternative layouts for very large text

**Example:**
```swift
// ✅ Dynamic Type support
RRLabel("Text", style: .bodyLarge)
    .font(.system(size: 16, weight: .regular, design: .default))
    .minimumScaleFactor(0.8)
    .lineLimit(nil)
```

## Performance Recommendations

### 1. Lazy Loading

**Recommendation:** Use lazy loading for large lists and complex views.

**Implementation:**
- Use `LazyVStack` and `LazyHStack` for large lists
- Implement pagination for data-heavy components
- Use `LazyVGrid` for large grids
- Load images asynchronously

**Example:**
```swift
// ✅ Lazy loading
LazyVStack(spacing: DesignTokens.Spacing.sm) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}

// ✅ Async image loading
RRAsyncImage(url: imageURL)
    .frame(width: 100, height: 100)
```

### 2. Memory Management

**Recommendation:** Implement proper memory management.

**Implementation:**
- Use `@State` and `@Binding` appropriately
- Avoid strong reference cycles
- Clean up resources when views disappear
- Use weak references for delegates

**Example:**
```swift
// ✅ Proper memory management
struct MyView: View {
    @State private var data: [Item] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                RRLoadingIndicator()
            } else {
                RRList(data: data) { item in
                    ItemView(item: item)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        // Load data implementation
    }
}
```

### 3. Bundle Optimization

**Recommendation:** Optimize bundle size and loading performance.

**Implementation:**
- Use bundle optimization features
- Implement code splitting
- Optimize images and assets
- Use efficient data structures

**Example:**
```swift
// ✅ Bundle optimization
BundleOptimizer.shared.optimizeCaches()
MemoryOptimizer.shared.performMemoryCleanup()
```

## Color System Guidelines

### 1. Color Palette

**Guideline:** Use a consistent color palette throughout the application.

**Implementation:**
- Use primary colors for main actions and branding
- Use secondary colors for supporting elements
- Use semantic colors for status and feedback
- Use neutral colors for text and backgrounds

**Example:**
```swift
// ✅ Consistent color usage
RRButton("Primary Action", style: .primary) { }
    .foregroundColor(theme.colors.onPrimary)
    .background(theme.colors.primary)

RRButton("Secondary Action", style: .secondary) { }
    .foregroundColor(theme.colors.onSecondary)
    .background(theme.colors.secondary)
```

### 2. Color Contrast

**Guideline:** Ensure sufficient color contrast for accessibility.

**Implementation:**
- Use high contrast colors for text
- Test with color contrast analyzers
- Provide alternative color schemes
- Use color utilities for contrast checking

**Example:**
```swift
// ✅ High contrast text
RRLabel("Text", style: .bodyLarge, color: .primary)
    .foregroundColor(theme.colors.primary) // High contrast

// ✅ Color contrast utility
let contrastRatio = Color.contrastRatio(
    between: theme.colors.primary,
    and: theme.colors.surface
)
```

### 3. Dark Mode Support

**Guideline:** Provide consistent dark mode support.

**Implementation:**
- Use theme-aware colors
- Test both light and dark modes
- Provide appropriate color variants
- Use system color preferences

**Example:**
```swift
// ✅ Theme-aware colors
.foregroundColor(theme.colors.primary)
.background(theme.colors.surface)

// ✅ Dark mode support
@Environment(\.colorScheme) private var colorScheme
```

## Typography Guidelines

### 1. Font Hierarchy

**Guideline:** Use consistent typography hierarchy.

**Implementation:**
- Use display styles for page titles
- Use headline styles for section titles
- Use body styles for content
- Use label styles for UI elements

**Example:**
```swift
// ✅ Typography hierarchy
VStack(alignment: .leading) {
    RRLabel("Page Title", style: .displayLarge)
    RRLabel("Section Title", style: .headlineLarge)
    RRLabel("Content", style: .bodyLarge)
    RRLabel("Label", style: .labelLarge)
}
```

### 2. Font Weights

**Guideline:** Use appropriate font weights for emphasis.

**Implementation:**
- Use regular weight for body text
- Use medium weight for emphasis
- Use semibold weight for headings
- Use bold weight for strong emphasis

**Example:**
```swift
// ✅ Appropriate font weights
RRLabel("Title", style: .titleLarge, weight: .semibold)
RRLabel("Content", style: .bodyLarge, weight: .regular)
RRLabel("Important", style: .bodyLarge, weight: .bold)
```

### 3. Line Height and Spacing

**Guideline:** Use appropriate line height and spacing for readability.

**Implementation:**
- Use 1.2-1.5 line height for body text
- Use 1.1-1.3 line height for headings
- Provide adequate spacing between lines
- Use consistent paragraph spacing

**Example:**
```swift
// ✅ Proper line height
RRLabel("Text", style: .bodyLarge)
    .lineSpacing(4)
    .lineLimit(nil)
```

## Spacing and Layout Guidelines

### 1. Spacing Scale

**Guideline:** Use consistent spacing scale throughout the application.

**Implementation:**
- Use `DesignTokens.Spacing` values
- Maintain consistent spacing relationships
- Use appropriate spacing for different content types
- Test spacing on different screen sizes

**Example:**
```swift
// ✅ Consistent spacing
VStack(spacing: DesignTokens.Spacing.lg) {
    RRLabel("Title", style: .titleLarge)
    RRLabel("Content", style: .bodyLarge)
}
.padding(DesignTokens.Spacing.md)
```

### 2. Grid System

**Guideline:** Use grid system for consistent layouts.

**Implementation:**
- Use `RRGridView` for grid layouts
- Maintain consistent column spacing
- Use responsive grid breakpoints
- Align content to grid lines

**Example:**
```swift
// ✅ Grid system
RRGridView(data: items, columns: 2, spacing: DesignTokens.Spacing.md) { item in
    ItemView(item: item)
}
```

### 3. Container Widths

**Guideline:** Use appropriate container widths for different content types.

**Implementation:**
- Use `RRContainer` for content width control
- Set appropriate max-widths
- Use responsive breakpoints
- Center content appropriately

**Example:**
```swift
// ✅ Container widths
RRContainer(maxWidth: .large) {
    ContentView()
}
```

## Animation Guidelines

### 1. Purposeful Animation

**Guideline:** Use animation to enhance user experience, not distract.

**Implementation:**
- Use subtle animations for state changes
- Provide smooth transitions between views
- Use appropriate animation durations
- Avoid excessive or distracting animations

**Example:**
```swift
// ✅ Purposeful animation
RRButton("Button", style: .primary) { }
    .scaleEffect(isPressed ? 0.95 : 1.0)
    .animation(.easeInOut(duration: 0.1), value: isPressed)
```

### 2. Performance

**Guideline:** Ensure animations don't impact performance.

**Implementation:**
- Use efficient animation properties
- Avoid animating expensive operations
- Use appropriate animation curves
- Test on lower-end devices

**Example:**
```swift
// ✅ Performance-friendly animation
.opacity(isVisible ? 1.0 : 0.0)
.animation(.easeInOut(duration: 0.3), value: isVisible)
```

### 3. Accessibility

**Guideline:** Respect user's motion preferences.

**Implementation:**
- Check `UIAccessibility.isReduceMotionEnabled`
- Provide alternative feedback for reduced motion
- Use appropriate animation durations
- Test with accessibility settings

**Example:**
```swift
// ✅ Accessibility-aware animation
.animation(
    UIAccessibility.isReduceMotionEnabled ? .none : .easeInOut(duration: 0.3),
    value: isVisible
)
```

## Responsive Design Guidelines

### 1. Breakpoints

**Guideline:** Use consistent breakpoints for different screen sizes.

**Implementation:**
- Define breakpoints for different device types
- Use responsive design tokens
- Test on different screen sizes
- Provide appropriate layouts for each breakpoint

**Example:**
```swift
// ✅ Responsive breakpoints
@Environment(\.horizontalSizeClass) private var horizontalSizeClass

var body: some View {
    if horizontalSizeClass == .compact {
        CompactLayout()
    } else {
        RegularLayout()
    }
}
```

### 2. Flexible Layouts

**Guideline:** Create layouts that adapt to different screen sizes.

**Implementation:**
- Use flexible containers
- Implement adaptive layouts
- Test on different orientations
- Provide appropriate spacing for each size

**Example:**
```swift
// ✅ Flexible layout
HStack(spacing: DesignTokens.Spacing.md) {
    if horizontalSizeClass == .regular {
        SidebarView()
    }
    MainContentView()
}
```

### 3. Touch Targets

**Guideline:** Ensure appropriate touch target sizes.

**Implementation:**
- Use minimum 44pt touch targets
- Provide adequate spacing between interactive elements
- Test on different device sizes
- Consider thumb reach zones

**Example:**
```swift
// ✅ Appropriate touch targets
RRButton("Button", style: .primary) { }
    .frame(minHeight: 44)
    .padding(.horizontal, DesignTokens.Spacing.md)
```

## Theme Customization Guidelines

### 1. Consistent Theming

**Guideline:** Maintain consistency when customizing themes.

**Implementation:**
- Use theme validation to ensure consistency
- Test custom themes thoroughly
- Provide fallbacks for missing values
- Document custom theme usage

**Example:**
```swift
// ✅ Consistent theming
let customTheme = Theme(
    colors: CustomColors(),
    typography: CustomTypography(),
    spacing: CustomSpacing()
)

// Validate theme
let validationIssues = ThemeValidator.validate(customTheme)
if validationIssues.isEmpty {
    // Use custom theme
}
```

### 2. Accessibility in Custom Themes

**Guideline:** Ensure custom themes maintain accessibility.

**Implementation:**
- Test color contrast ratios
- Verify accessibility labels work
- Test with different text sizes
- Ensure keyboard navigation works

**Example:**
```swift
// ✅ Accessibility-aware custom theme
let customTheme = Theme(
    colors: CustomColors(
        primary: Color.blue,
        onPrimary: Color.white,
        surface: Color.white,
        onSurface: Color.black
    )
)

// Test contrast ratios
let contrastRatio = Color.contrastRatio(
    between: customTheme.colors.primary,
    and: customTheme.colors.onPrimary
)
```

### 3. Performance Considerations

**Guideline:** Consider performance when customizing themes.

**Implementation:**
- Use efficient color calculations
- Cache theme values when appropriate
- Avoid expensive theme operations
- Test performance with custom themes

**Example:**
```swift
// ✅ Performance-conscious theming
@StateObject private var themeProvider = ThemeProvider(theme: customTheme)

var body: some View {
    ContentView()
        .themeProvider(themeProvider)
        .onAppear {
            // Cache theme values
            themeProvider.cacheThemeValues()
        }
}
```

## Best Practices Summary

### 1. Design System Usage

- Always use design tokens for consistency
- Follow component composition rules
- Maintain accessibility standards
- Test on different devices and orientations

### 2. Performance

- Use lazy loading for large lists
- Implement proper memory management
- Optimize bundle size
- Test performance regularly

### 3. Accessibility

- Ensure WCAG 2.1 AA compliance
- Support screen readers
- Provide keyboard navigation
- Respect user preferences

### 4. Maintenance

- Document custom themes
- Test thoroughly
- Keep components updated
- Follow version control best practices

By following these guidelines, you can create consistent, accessible, and performant user interfaces using RRUIComponents.
