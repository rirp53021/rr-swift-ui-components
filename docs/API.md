# RRUIComponents API Documentation

## Overview

RRUIComponents provides a comprehensive set of SwiftUI components with consistent theming, accessibility, and cross-platform support.

## Core Components

### RRLabel

A typography component with design system integration.

```swift
RRLabel(
    "Text content",
    style: .title,
    weight: .semibold,
    color: .primary
)
```

**Parameters:**
- `text`: The text content to display
- `style`: Typography style (`.displayLarge`, `.headlineLarge`, `.titleLarge`, `.bodyLarge`, `.labelLarge`)
- `weight`: Font weight (`.light`, `.regular`, `.medium`, `.semibold`, `.bold`)
- `color`: Text color (`.primary`, `.secondary`, `.tertiary`)

### RRButton

A button component with multiple styles and states.

```swift
RRButton(
    "Button Text",
    style: .primary,
    size: .medium,
    isEnabled: true
) {
    // Action
}
```

**Parameters:**
- `title`: Button text
- `style`: Button style (`.primary`, `.secondary`, `.tertiary`, `.destructive`)
- `size`: Button size (`.small`, `.medium`, `.large`)
- `isEnabled`: Whether the button is enabled
- `action`: Action closure

### RRTextField

A text input component with validation states.

```swift
RRTextField(
    "Placeholder",
    text: $text,
    style: .outlined,
    validationState: .valid
)
```

**Parameters:**
- `placeholder`: Placeholder text
- `text`: Binding to text value
- `style`: Text field style (`.filled`, `.outlined`)
- `validationState`: Validation state (`.valid`, `.invalid`, `.warning`)
- `isDisabled`: Whether the field is disabled
- `helperText`: Helper text below the field
- `errorText`: Error text below the field

## Form Components

### RRToggle

A toggle switch component.

```swift
RRToggle(
    "Toggle Label",
    isOn: $isOn,
    style: .switch
)
```

### RRCheckbox

A checkbox component with validation states.

```swift
RRCheckbox(
    "Checkbox Label",
    isChecked: $isChecked,
    validationState: .valid
)
```

### RRDropdown

A dropdown/picker component.

```swift
RRDropdown(
    "Select Option",
    selection: $selection,
    options: options
)
```

### RRDatePicker

A date and time picker component.

```swift
RRDatePicker(
    "Select Date",
    selection: $date,
    displayedComponents: .date
)
```

### RRSlider

A slider component with range support.

```swift
RRSlider(
    value: $value,
    in: 0...100,
    step: 1
)
```

### RRStepper

A stepper component for numeric input.

```swift
RRStepper(
    "Value",
    value: $value,
    in: 0...100,
    step: 1
)
```

## Navigation Components

### RRNavigationBar

A navigation bar component.

```swift
RRNavigationBar(
    title: "Title",
    leadingButton: { AnyView(Button("Back") {}) },
    trailingButton: { AnyView(Button("Done") {}) }
)
```

### RRTabBar

A tab bar component.

```swift
RRTabBar(
    selection: $selection,
    tabs: [
        TabItem(title: "Home", icon: "house"),
        TabItem(title: "Profile", icon: "person")
    ]
)
```

### RRSegmentedControl

A segmented control component.

```swift
RRSegmentedControl(
    selection: $selection,
    options: ["Option 1", "Option 2", "Option 3"]
)
```

## Feedback Components

### RRAlert

An alert component with multiple styles.

```swift
RRAlert(
    title: "Alert Title",
    message: "Alert message",
    primaryButton: AlertButton(title: "OK", action: {}),
    secondaryButton: AlertButton(title: "Cancel", action: {})
)
```

### RRSnackbar

A snackbar component for notifications.

```swift
RRSnackbar(
    message: "Notification message",
    style: .info,
    duration: 3.0
)
```

### RRLoadingIndicator

A loading indicator component.

```swift
RRLoadingIndicator(
    style: .spinner,
    size: .medium,
    color: .primary
)
```

### RREmptyState

An empty state component.

```swift
RREmptyState(
    title: "No Data",
    message: "No items to display",
    icon: "tray"
)
```

## Layout Components

### RRCard

A card component with header/footer support.

```swift
RRCard(
    header: { Text("Header") },
    content: { Text("Content") },
    footer: { Text("Footer") }
)
```

### RRGridView

A grid layout component.

```swift
RRGridView(
    data: items,
    columns: 2,
    spacing: 16
) { item in
    GridItemView(item: item)
}
```

### RRDivider

A section divider component.

```swift
RRDivider(
    style: .solid,
    color: .separator
)
```

### RRSpacer

A flexible spacer component.

```swift
RRSpacer(
    minLength: 8,
    maxLength: 32
)
```

### RRContainer

A content container component.

```swift
RRContainer(
    maxWidth: .large,
    padding: .medium
) {
    ContentView()
}
```

### RRSection

A content section component.

```swift
RRSection(
    header: "Section Title",
    footer: "Section Footer"
) {
    ContentView()
}
```

## Data Display Components

### RRTable

A data table component with sorting and filtering.

```swift
RRTable(
    data: users,
    sortable: true,
    filterable: true
) { user in
    RRTableColumn("Name") { user.name }
    RRTableColumn("Email") { user.email }
    RRTableColumn("Role") { user.role }
}
```

### RRList

An enhanced list component with custom cells.

```swift
RRList(
    data: items,
    style: .grouped
) { item in
    ListItemView(item: item)
}
```

### RRChart

A basic chart component for data visualization.

```swift
RRChart(
    data: chartData,
    type: .bar,
    style: .default
)
```

### RRDataGrid

A grid data display component.

```swift
RRDataGrid(
    data: gridData,
    columns: 3,
    cellSpacing: 8
) { item in
    DataCellView(item: item)
}
```

## Overlay Components

### RRModal

A modal component with multiple presentation styles.

```swift
RRModal(
    isPresented: $showingModal,
    style: .sheet
) {
    ModalContentView()
}
```

### RRTooltip

A tooltip component for contextual information.

```swift
RRTooltip(
    text: "Tooltip text",
    position: .top
) {
    Button("Hover me") {}
}
```

### RRPopover

A popover component for additional content.

```swift
RRPopover(
    isPresented: $showingPopover,
    attachmentAnchor: .point(.top)
) {
    PopoverContentView()
}
```

### RRContextMenu

A context menu component.

```swift
RRContextMenu(
    actions: [
        ContextAction(title: "Edit", icon: "pencil") {},
        ContextAction(title: "Delete", icon: "trash") {}
    ]
) {
    Button("Long press me") {}
}
```

### RROverlay

A generic overlay component.

```swift
RROverlay(
    isPresented: $showingOverlay
) {
    ContentView()
} overlayContent: {
    OverlayContentView()
}
```

## Media Components

### RRCarousel

A carousel component with page indicators and autoplay.

```swift
RRCarousel(
    data: carouselItems,
    autoplay: true,
    autoplayInterval: 3.0
) { item in
    CarouselItemView(item: item)
}
```

### RRVideoPlayer

A video player component with controls.

```swift
RRVideoPlayer(
    videoURL: videoURL,
    autoplay: false
) { player in
    // Custom video controls
}
```

### RRImageGallery

An image gallery component with navigation.

```swift
RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
) { image in
    AsyncImage(url: image.url)
}
```

### RRMediaViewer

A media viewer component for various content types.

```swift
RRMediaViewer(
    mediaItems: mediaItems,
    currentIndex: $currentIndex
) { item in
    MediaItemView(item: item)
}
```

## Advanced Components

### RRSearchBar

A search bar component with suggestions.

```swift
RRSearchBar(
    text: $searchText,
    placeholder: "Search...",
    suggestions: suggestions
)
```

### RRRating

A rating component with multiple styles.

```swift
RRRating(
    rating: $rating,
    maxRating: 5,
    style: .stars
)
```

### RRTimeline

A timeline component for progress tracking.

```swift
RRTimeline(
    events: timelineEvents,
    style: .vertical
) { event in
    TimelineEventView(event: event)
}
```

### RRTagInput

A tag input component.

```swift
RRTagInput(
    tags: $tags,
    placeholder: "Add tags...",
    maxTags: 10
)
```

## Theme System

### ThemeProvider

The main theme provider for the design system.

```swift
ThemeProvider(
    theme: .light,
    bundle: .uiComponents
)
```

### Theme

A theme configuration with colors, typography, and spacing.

```swift
let customTheme = Theme(
    colors: customColors,
    typography: customTypography,
    spacing: customSpacing
)
```

### Design Tokens

Access design system tokens for consistent styling.

```swift
DesignTokens.Colors.primary
DesignTokens.Typography.headlineLarge
DesignTokens.Spacing.large
DesignTokens.BorderRadius.medium
DesignTokens.Shadows.small
```

## Best Practices

### Component Usage

1. **Always use ThemeProvider**: Wrap your app with `ThemeProvider` for consistent theming
2. **Use Design Tokens**: Access colors, spacing, and typography through `DesignTokens`
3. **Leverage Environment**: Use `@Environment(\.themeProvider)` to access theme
4. **Consistent Styling**: Use the same style patterns across your app

### Performance

1. **Lazy Loading**: Use `LazyVStack` and `LazyHStack` for large lists
2. **Memory Management**: Components automatically handle memory cleanup
3. **Bundle Optimization**: Use the built-in bundle optimization features

### Accessibility

1. **Semantic Labels**: All components include proper accessibility labels
2. **Keyboard Navigation**: Full keyboard support for interactive components
3. **Screen Reader**: Proper VoiceOver support for all components
4. **Dynamic Type**: Respects user's text size preferences

## Common Patterns

### Form Layout

```swift
VStack(spacing: DesignTokens.Spacing.md) {
    RRTextField("Email", text: $email)
    RRTextField("Password", text: $password, isSecure: true)
    RRButton("Submit", style: .primary) { submit() }
}
```

### Card Layout

```swift
RRCard {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
        RRLabel("Title", style: .titleLarge)
        RRLabel("Description", style: .bodyMedium, color: .secondary)
    }
}
```

### Modal Presentation

```swift
RRModal(isPresented: $showingModal) {
    VStack {
        RRLabel("Modal Content", style: .headlineLarge)
        RRButton("Close", style: .secondary) {
            showingModal = false
        }
    }
}
```

## Migration Guide

### From Native SwiftUI

1. Replace `Text` with `RRLabel`
2. Replace `Button` with `RRButton`
3. Replace `TextField` with `RRTextField`
4. Add `ThemeProvider` to your app
5. Use `DesignTokens` for consistent spacing and colors

### From Other UI Libraries

1. Update import statements
2. Replace component names with RR prefixed versions
3. Update styling to use design tokens
4. Add theme provider configuration
5. Test accessibility features

## Troubleshooting

### Common Issues

1. **Theme not applied**: Ensure `ThemeProvider` is properly configured
2. **Colors not updating**: Check that components use theme colors
3. **Spacing inconsistent**: Use `DesignTokens.Spacing` values
4. **Accessibility issues**: Verify proper label and hint configuration

### Debug Tips

1. Use Xcode's accessibility inspector
2. Test with different text sizes
3. Verify keyboard navigation
4. Check color contrast ratios
