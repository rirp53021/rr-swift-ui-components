# RRUIComponents - Component Documentation

This document provides comprehensive documentation for all components in the RRUIComponents library. Each component includes API reference, usage examples, best practices, and theme customization options.

## Table of Contents

- [Getting Started](#getting-started)
- [Component Categories](#component-categories)
- [API Reference](#api-reference)
  - [Buttons](#buttons)
  - [Labels](#labels)
  - [Text Inputs](#text-inputs)
  - [Forms](#forms)
  - [Images](#images)
  - [Navigation](#navigation)
  - [Containers](#containers)
  - [Feedback](#feedback)
  - [Data Display](#data-display)
  - [Layout](#layout)
  - [Overlay](#overlay)
  - [Media](#media)
  - [Advanced](#advanced)
- [Best Practices](#best-practices)
- [Theme Customization](#theme-customization)
- [Accessibility Guidelines](#accessibility-guidelines)

## Getting Started

### Installation

Add RRUIComponents to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/rr-swift-ui-components.git", from: "1.0.0")
]
```

### Basic Usage

```swift
import RRUIComponents

struct ContentView: View {
    @StateObject private var themeProvider = ThemeProvider()
    
    var body: some View {
        VStack {
            RRLabel("Hello, World!")
                .style(.title)
            
            RRButton("Click Me") {
                // Action
            }
            .style(.primary)
        }
        .environment(\.themeProvider, themeProvider)
    }
}
```

## Component Categories

### Buttons
Interactive elements for user actions
- `RRButton` - Primary button component
- `RRFloatingActionButton` - Floating action button

### Labels
Text display components
- `RRLabel` - Flexible text component
- `RRBadge` - Status and category indicators

### Text Inputs
User input components
- `RRTextField` - Text input field

### Forms
Form control components
- `RRCheckbox` - Checkbox input
- `RRDatePicker` - Date and time selection
- `RRDropdown` - Dropdown selection
- `RRSlider` - Range input slider
- `RRToggle` - Toggle switch

### Images
Image display and handling
- `RRAsyncImage` - Asynchronous image loading
- `RRAvatar` - User avatar display

### Navigation
Navigation and flow components
- `RRNavigationBar` - Custom navigation bar
- `RRPageIndicator` - Page navigation indicator
- `RRStepper` - Step-by-step navigation
- `RRTabBar` - Tab navigation

### Containers
Content organization components
- `RRCard` - Card container
- `RRGridView` - Grid layout
- `RRRowItem` - List row item

### Feedback
User feedback components
- `RRAlert` - Alert dialogs
- `RREmptyState` - Empty state display
- `RRLoadingIndicator` - Loading states
- `RRSnackbar` - Toast notifications

### Data Display
Data visualization components
- `RRChart` - Basic charts
- `RRDataGrid` - Data grid display
- `RRList` - Enhanced list
- `RRTable` - Data table

### Layout
Layout and spacing components
- `RRContainer` - Content container
- `RRDivider` - Section dividers
- `RRSection` - Content sections
- `RRSpacer` - Flexible spacers

### Overlay
Overlay and popup components
- `RRContextMenu` - Context menus
- `RROverlay` - Generic overlay
- `RRPopover` - Popover display
- `RRTooltip` - Tooltip display

### Media
Media handling components
- `RRImageGallery` - Image gallery
- `RRMediaViewer` - Media viewer
- `RRVideoPlayer` - Video player

### Advanced
Complex interactive components
- `RRCarousel` - Content carousel
- `RRModal` - Modal dialogs
- `RRRating` - Rating input
- `RRSearchBar` - Search input
- `RRSegmentedControl` - Segmented control
- `RRTagInput` - Tag input
- `RRTimeline` - Timeline display

## API Reference

### Buttons

#### RRButton

A customizable button component with multiple styles and sizes.

**Initialization:**
```swift
RRButton(title: String, action: @escaping () -> Void)
RRButton(title: String, icon: String?, action: @escaping () -> Void)
```

**Styles:**
- `.primary` - Primary action button
- `.secondary` - Secondary action button
- `.tertiary` - Tertiary action button
- `.outline` - Outlined button
- `.ghost` - Ghost button
- `.link` - Link-style button

**Sizes:**
- `.small` - Small button
- `.medium` - Medium button (default)
- `.large` - Large button

**Example:**
```swift
RRButton("Save Changes") {
    // Save action
}
.style(.primary)
.size(.large)
.disabled(isLoading)
```

**Theme Customization:**
```swift
// Custom button colors
RRButton("Custom Button") { }
    .style(.primary)
    .foregroundColor(.customText)
    .background(.customBackground)
```

#### RRFloatingActionButton

A floating action button for primary actions.

**Initialization:**
```swift
RRFloatingActionButton(icon: String, action: @escaping () -> Void)
```

**Example:**
```swift
RRFloatingActionButton(icon: "plus") {
    // Add action
}
.position(.bottomTrailing)
.size(.large)
```

### Labels

#### RRLabel

A flexible text component with typography styles and theme support.

**Initialization:**
```swift
RRLabel(_ text: String)
RRLabel(_ text: String, style: TypographyStyle)
```

**Typography Styles:**
- `.display` - Large display text
- `.headline` - Section headlines
- `.title` - Page titles
- `.subtitle` - Subtitles
- `.body` - Body text
- `.caption` - Small text
- `.footnote` - Footnotes

**Weights:**
- `.light` - Light weight
- `.regular` - Regular weight (default)
- `.medium` - Medium weight
- `.semibold` - Semibold weight
- `.bold` - Bold weight

**Example:**
```swift
RRLabel("Welcome")
    .style(.title)
    .weight(.bold)
    .color(.primary)
```

#### RRBadge

A badge component for status indicators and categories.

**Initialization:**
```swift
RRBadge(_ text: String)
RRBadge(_ text: String, style: BadgeStyle)
```

**Styles:**
- `.primary` - Primary badge
- `.secondary` - Secondary badge
- `.success` - Success indicator
- `.warning` - Warning indicator
- `.error` - Error indicator
- `.info` - Information indicator

**Sizes:**
- `.small` - Small badge
- `.medium` - Medium badge (default)
- `.large` - Large badge

**Example:**
```swift
RRBadge("New")
    .style(.success)
    .size(.small)
```

### Text Inputs

#### RRTextField

A customizable text input field with validation and theming.

**Initialization:**
```swift
RRTextField(_ title: String, text: Binding<String>)
RRTextField(_ title: String, text: Binding<String>, placeholder: String?)
```

**Properties:**
- `title` - Field label
- `text` - Binding to text value
- `placeholder` - Placeholder text
- `isSecure` - Secure text entry
- `keyboardType` - Keyboard type
- `validationState` - Validation state

**Example:**
```swift
@State private var email = ""

RRTextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .validationState(email.isValidEmail ? .valid : .invalid)
```

### Forms

#### RRCheckbox

A checkbox input component with multiple styles.

**Initialization:**
```swift
RRCheckbox(_ title: String, isChecked: Binding<Bool>)
```

**Styles:**
- `.square` - Square checkbox (default)
- `.circle` - Circular checkbox
- `.rounded` - Rounded checkbox

**Example:**
```swift
@State private var isAccepted = false

RRCheckbox("I agree to the terms", isChecked: $isAccepted)
    .style(.rounded)
```

#### RRDatePicker

A date and time picker component.

**Initialization:**
```swift
RRDatePicker(_ title: String, selection: Binding<Date>)
RRDatePicker(_ title: String, selection: Binding<Date>, mode: DatePickerMode)
```

**Modes:**
- `.date` - Date only
- `.time` - Time only
- `.dateAndTime` - Date and time

**Example:**
```swift
@State private var selectedDate = Date()

RRDatePicker("Select Date", selection: $selectedDate)
    .mode(.date)
    .style(.compact)
```

#### RRDropdown

A dropdown selection component.

**Initialization:**
```swift
RRDropdown(_ title: String, selection: Binding<String>, options: [String])
```

**Example:**
```swift
@State private var selectedOption = ""

RRDropdown("Choose Option", selection: $selectedOption, options: ["Option 1", "Option 2", "Option 3"])
    .style(.standard)
```

#### RRSlider

A range input slider component.

**Initialization:**
```swift
RRSlider(value: Binding<Double>, in: ClosedRange<Double>)
RRSlider(value: Binding<Double>, in: ClosedRange<Double>, step: Double)
```

**Styles:**
- `.standard` - Standard slider
- `.range` - Range slider
- `.stepped` - Stepped slider

**Example:**
```swift
@State private var sliderValue = 50.0

RRSlider(value: $sliderValue, in: 0...100)
    .style(.standard)
    .step(1)
```

#### RRToggle

A toggle switch component.

**Initialization:**
```swift
RRToggle(_ title: String, isOn: Binding<Bool>)
```

**Styles:**
- `.standard` - Standard toggle
- `.custom` - Custom styled toggle
- `.switch` - Switch-style toggle

**Example:**
```swift
@State private var isEnabled = false

RRToggle("Enable Notifications", isOn: $isEnabled)
    .style(.switch)
```

### Images

#### RRAsyncImage

An asynchronous image loading component with placeholder and error states.

**Initialization:**
```swift
RRAsyncImage(url: URL?)
RRAsyncImage(url: URL?, placeholder: Image?, errorImage: Image?)
```

**Properties:**
- `url` - Image URL
- `placeholder` - Placeholder image
- `errorImage` - Error state image
- `contentMode` - Content mode
- `clipped` - Clip to bounds

**Example:**
```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .placeholder(Image(systemName: "photo"))
    .errorImage(Image(systemName: "exclamationmark.triangle"))
    .contentMode(.fit)
    .frame(width: 200, height: 200)
```

#### RRAvatar

A user avatar display component.

**Initialization:**
```swift
RRAvatar(image: Image?)
RRAvatar(initials: String)
RRAvatar(image: Image?, fallback: String)
```

**Sizes:**
- `.small` - Small avatar
- `.medium` - Medium avatar (default)
- `.large` - Large avatar
- `.xlarge` - Extra large avatar

**Example:**
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
    .style(.circle)
```

### Navigation

#### RRNavigationBar

A customizable navigation bar component.

**Initialization:**
```swift
RRNavigationBar(title: String)
RRNavigationBar(title: String, leading: AnyView?, trailing: AnyView?)
```

**Example:**
```swift
RRNavigationBar(title: "Settings")
    .leading(Button("Back") { /* action */ })
    .trailing(Button("Save") { /* action */ })
```

#### RRPageIndicator

A page navigation indicator component.

**Initialization:**
```swift
RRPageIndicator(currentPage: Int, totalPages: Int)
```

**Styles:**
- `.dots` - Dot indicators (default)
- `.lines` - Line indicators
- `.numbers` - Number indicators

**Example:**
```swift
RRPageIndicator(currentPage: 2, totalPages: 5)
    .style(.dots)
    .color(.primary)
```

#### RRStepper

A step-by-step navigation component.

**Initialization:**
```swift
RRStepper(currentStep: Int, totalSteps: Int)
```

**Example:**
```swift
RRStepper(currentStep: 2, totalSteps: 4)
    .style(.horizontal)
    .showLabels(true)
```

#### RRTabBar

A tab navigation component.

**Initialization:**
```swift
RRTabBar(selection: Binding<Int>, tabs: [TabItem])
```

**Example:**
```swift
@State private var selectedTab = 0

RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house"),
    TabItem(title: "Search", icon: "magnifyingglass"),
    TabItem(title: "Profile", icon: "person")
])
```

### Containers

#### RRCard

A card container component for content organization.

**Initialization:**
```swift
RRCard(content: () -> AnyView)
RRCard(header: AnyView?, content: () -> AnyView, footer: AnyView?)
```

**Example:**
```swift
RRCard {
    VStack {
        RRLabel("Card Title")
            .style(.headline)
        RRLabel("Card content goes here")
            .style(.body)
    }
}
.header {
    RRLabel("Header")
        .style(.title)
}
.footer {
    RRButton("Action") { }
        .style(.primary)
}
```

#### RRGridView

A flexible grid layout component.

**Initialization:**
```swift
RRGridView(columns: Int, spacing: CGFloat, content: () -> AnyView)
```

**Example:**
```swift
RRGridView(columns: 2, spacing: 16) {
    ForEach(items) { item in
        RRCard {
            RRLabel(item.title)
        }
    }
}
```

#### RRRowItem

A reusable row item component for lists.

**Initialization:**
```swift
RRRowItem(title: String, subtitle: String?, icon: String?, accessory: AnyView?)
```

**Example:**
```swift
RRRowItem(
    title: "Settings",
    subtitle: "Manage your preferences",
    icon: "gear",
    accessory: Image(systemName: "chevron.right")
)
```

### Feedback

#### RRAlert

A customizable alert dialog component.

**Initialization:**
```swift
RRAlert(title: String, message: String?, isPresented: Binding<Bool>)
```

**Styles:**
- `.success` - Success alert
- `.error` - Error alert
- `.warning` - Warning alert
- `.info` - Information alert

**Example:**
```swift
@State private var showAlert = false

RRAlert(
    title: "Success",
    message: "Your changes have been saved.",
    isPresented: $showAlert
)
.style(.success)
```

#### RREmptyState

An empty state display component.

**Initialization:**
```swift
RREmptyState(title: String, subtitle: String?, illustration: Image?, action: (() -> Void)?)
```

**Example:**
```swift
RREmptyState(
    title: "No Items",
    subtitle: "Add some items to get started",
    illustration: Image(systemName: "tray"),
    action: {
        // Add action
    }
)
```

#### RRLoadingIndicator

A loading indicator component with multiple styles.

**Initialization:**
```swift
RRLoadingIndicator(style: LoadingStyle)
RRLoadingIndicator(style: LoadingStyle, message: String?)
```

**Styles:**
- `.spinner` - Spinning indicator
- `.dots` - Animated dots
- `.pulse` - Pulsing indicator
- `.wave` - Wave animation
- `.progress` - Progress bar
- `.skeleton` - Skeleton loading

**Example:**
```swift
RRLoadingIndicator(style: .spinner, message: "Loading...")
    .size(.large)
```

#### RRSnackbar

A toast notification component.

**Initialization:**
```swift
RRSnackbar(message: String, isPresented: Binding<Bool>)
```

**Styles:**
- `.success` - Success notification
- `.error` - Error notification
- `.warning` - Warning notification
- `.info` - Information notification

**Example:**
```swift
@State private var showSnackbar = false

RRSnackbar(message: "Changes saved successfully", isPresented: $showSnackbar)
    .style(.success)
    .duration(3)
```

### Data Display

#### RRTable

A data table component for tabular data.

**Initialization:**
```swift
RRTable<Data>(data: [Data], columns: [TableColumn<Data>])
```

**Example:**
```swift
struct User {
    let name: String
    let email: String
    let age: Int
}

RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
```

#### RRList

An enhanced list component with various styles.

**Initialization:**
```swift
RRList<Data, Content>(data: [Data], content: @escaping (Data) -> Content)
```

**Example:**
```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.style(.grouped)
```

#### RRDataGrid

A grid data display component.

**Initialization:**
```swift
RRDataGrid<Data>(data: [Data], columns: [GridColumn<Data>])
```

**Example:**
```swift
RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price),
        GridColumn("Stock", \.stock)
    ]
)
```

#### RRChart

A basic chart component.

**Initialization:**
```swift
RRChart(data: [ChartDataPoint], type: ChartType)
```

**Types:**
- `.bar` - Bar chart
- `.line` - Line chart
- `.pie` - Pie chart

**Example:**
```swift
RRChart(
    data: [
        ChartDataPoint(label: "Jan", value: 100),
        ChartDataPoint(label: "Feb", value: 150),
        ChartDataPoint(label: "Mar", value: 200)
    ],
    type: .bar
)
```

### Layout

#### RRContainer

A content container component with flexible constraints.

**Initialization:**
```swift
RRContainer(content: () -> AnyView)
```

**Properties:**
- `maxWidth` - Maximum width constraint
- `padding` - Internal padding
- `background` - Background color
- `cornerRadius` - Corner radius
- `shadow` - Shadow configuration

**Example:**
```swift
RRContainer {
    VStack {
        RRLabel("Content")
    }
}
.maxWidth(.medium)
.padding(.large)
.background(.surface)
.cornerRadius(.medium)
```

#### RRDivider

A section divider component.

**Initialization:**
```swift
RRDivider()
RRDivider(orientation: DividerOrientation)
```

**Orientations:**
- `.horizontal` - Horizontal divider (default)
- `.vertical` - Vertical divider

**Example:**
```swift
VStack {
    RRLabel("Section 1")
    RRDivider()
    RRLabel("Section 2")
}
```

#### RRSection

A content section component for organizing content.

**Initialization:**
```swift
RRSection(title: String?, content: () -> AnyView)
RRSection(title: String?, subtitle: String?, content: () -> AnyView)
```

**Example:**
```swift
RRSection(title: "Settings", subtitle: "Manage your preferences") {
    VStack {
        RRToggle("Notifications", isOn: $notificationsEnabled)
        RRToggle("Dark Mode", isOn: $darkModeEnabled)
    }
}
```

#### RRSpacer

A flexible spacer component.

**Initialization:**
```swift
RRSpacer()
RRSpacer(minLength: CGFloat?)
```

**Example:**
```swift
HStack {
    RRLabel("Left")
    RRSpacer()
    RRLabel("Right")
}
```

### Overlay

#### RRTooltip

A tooltip component for displaying contextual information.

**Initialization:**
```swift
RRTooltip(content: () -> AnyView, tooltip: () -> AnyView)
```

**Example:**
```swift
RRTooltip(
    content: {
        RRButton("Hover me") { }
    },
    tooltip: {
        RRLabel("This is a tooltip")
            .padding()
            .background(.surface)
    }
)
.position(.top)
```

#### RRPopover

A popover component for displaying content.

**Initialization:**
```swift
RRPopover(isPresented: Binding<Bool>, content: () -> AnyView, popover: () -> AnyView)
```

**Example:**
```swift
@State private var showPopover = false

RRPopover(isPresented: $showPopover) {
    RRButton("Show Popover") {
        showPopover = true
    }
} popover: {
    VStack {
        RRLabel("Popover Content")
        RRButton("Close") {
            showPopover = false
        }
    }
    .padding()
}
```

#### RRContextMenu

A context menu component for displaying contextual actions.

**Initialization:**
```swift
RRContextMenu(content: () -> AnyView, menuItems: [ContextMenuItem])
```

**Example:**
```swift
RRContextMenu {
    RRCard {
        RRLabel("Right-click me")
    }
} menuItems: [
    ContextMenuItem("Edit", icon: "pencil") { /* edit action */ },
    ContextMenuItem("Delete", icon: "trash", isDestructive: true) { /* delete action */ }
]
```

#### RROverlay

A generic overlay component for displaying content over other views.

**Initialization:**
```swift
RROverlay(isPresented: Binding<Bool>, content: () -> AnyView)
```

**Example:**
```swift
@State private var showOverlay = false

RROverlay(isPresented: $showOverlay) {
    VStack {
        RRLabel("Overlay Content")
        RRButton("Close") {
            showOverlay = false
        }
    }
    .padding()
    .background(.surface)
}
```

### Media

#### RRVideoPlayer

A customizable video player component.

**Initialization:**
```swift
RRVideoPlayer(url: URL?)
RRVideoPlayer(url: URL?, poster: Image?)
```

**Example:**
```swift
RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
    .poster(Image("video-poster"))
    .controls(true)
    .autoplay(false)
```

#### RRImageGallery

An image gallery component with multiple layouts.

**Initialization:**
```swift
RRImageGallery(images: [Image], selectedIndex: Binding<Int>)
RRImageGallery(images: [Image], selectedIndex: Binding<Int>, layout: GalleryLayout)
```

**Layouts:**
- `.carousel` - Carousel layout
- `.grid` - Grid layout
- `.stack` - Stack layout

**Example:**
```swift
@State private var selectedIndex = 0

RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.layout(.carousel)
.showIndicators(true)
```

#### RRMediaViewer

A comprehensive media viewer for images, videos, and documents.

**Initialization:**
```swift
RRMediaViewer(media: [MediaItem], selectedIndex: Binding<Int>)
```

**Example:**
```swift
@State private var selectedIndex = 0

RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
.style(.fullScreen)
```

### Advanced

#### RRCarousel

A content carousel component.

**Initialization:**
```swift
RRCarousel<Content>(items: [Item], content: @escaping (Item) -> Content)
```

**Example:**
```swift
RRCarousel(items: carouselItems) { item in
    RRCard {
        VStack {
            RRAsyncImage(url: item.imageURL)
            RRLabel(item.title)
        }
    }
}
.style(.paged)
.autoPlay(true)
```

#### RRModal

A modal dialog component with multiple presentation styles.

**Initialization:**
```swift
RRModal(isPresented: Binding<Bool>, content: () -> AnyView)
```

**Presentation Styles:**
- `.sheet` - Sheet presentation
- `.fullScreenCover` - Full screen cover
- `.popover` - Popover presentation
- `.bottomSheet` - Bottom sheet

**Example:**
```swift
@State private var showModal = false

RRModal(isPresented: $showModal) {
    VStack {
        RRLabel("Modal Content")
        RRButton("Close") {
            showModal = false
        }
    }
    .padding()
}
.presentationStyle(.sheet)
```

#### RRRating

A rating input component.

**Initialization:**
```swift
RRRating(rating: Binding<Double>)
RRRating(rating: Binding<Double>, maxRating: Int)
```

**Example:**
```swift
@State private var rating = 0.0

RRRating(rating: $rating, maxRating: 5)
    .style(.stars)
    .size(.large)
```

#### RRSearchBar

A search input component with suggestions.

**Initialization:**
```swift
RRSearchBar(text: Binding<String>)
RRSearchBar(text: Binding<String>, placeholder: String?)
```

**Example:**
```swift
@State private var searchText = ""

RRSearchBar(text: $searchText, placeholder: "Search...")
    .suggestions(searchSuggestions)
    .onSearch { query in
        // Handle search
    }
```

#### RRSegmentedControl

A segmented control component.

**Initialization:**
```swift
RRSegmentedControl(selection: Binding<Int>, segments: [String])
```

**Example:**
```swift
@State private var selectedSegment = 0

RRSegmentedControl(
    selection: $selectedSegment,
    segments: ["All", "Favorites", "Recent"]
)
.style(.standard)
```

#### RRTagInput

A tag input component for managing tags.

**Initialization:**
```swift
RRTagInput(tags: Binding<[String]>)
```

**Example:**
```swift
@State private var tags = ["Swift", "iOS"]

RRTagInput(tags: $tags)
    .placeholder("Add tags...")
    .maxTags(10)
```

#### RRTimeline

A timeline/progress tracker component.

**Initialization:**
```swift
RRTimeline(items: [TimelineItem])
```

**Example:**
```swift
RRTimeline(items: [
    TimelineItem(title: "Order Placed", date: Date(), status: .completed),
    TimelineItem(title: "Processing", date: Date(), status: .inProgress),
    TimelineItem(title: "Shipped", date: Date(), status: .pending)
])
.orientation(.vertical)
```

## Best Practices

### Component Usage

1. **Always use ThemeProvider**: Wrap your app with `ThemeProvider` to ensure consistent theming across all components.

2. **Use Design Tokens**: Prefer design tokens over hardcoded values for spacing, colors, and typography.

3. **Consistent Styling**: Use the same style patterns throughout your app for consistency.

4. **Accessibility**: Always provide meaningful labels and hints for screen readers.

5. **Performance**: Use `LazyVStack` and `LazyHStack` for large lists to improve performance.

### Theme Integration

1. **Environment Setup**: Always inject `ThemeProvider` into your view hierarchy.

2. **Color Usage**: Use semantic color names (`.primary`, `.surface`) instead of specific colors.

3. **Typography**: Use the predefined typography styles for consistency.

4. **Spacing**: Use design tokens for consistent spacing throughout your app.

### State Management

1. **Binding Usage**: Use `@State` and `@Binding` appropriately for component state.

2. **ObservableObject**: Use `@StateObject` for theme provider and other observable objects.

3. **Environment Values**: Use `@Environment` for accessing theme and other shared values.

## Theme Customization

### Custom Themes

Create custom themes by extending the `Theme` struct:

```swift
extension Theme {
    static let custom = Theme(
        colors: ThemeColors(
            primary: Color("CustomPrimary"),
            secondary: Color("CustomSecondary"),
            // ... other colors
        ),
        typography: ThemeTypography(
            // ... typography settings
        ),
        spacing: ThemeSpacing(
            // ... spacing settings
        )
    )
}
```

### Dynamic Theme Switching

```swift
@StateObject private var themeProvider = ThemeProvider()

var body: some View {
    VStack {
        Picker("Theme", selection: $selectedTheme) {
            Text("Light").tag(Theme.light)
            Text("Dark").tag(Theme.dark)
            Text("Custom").tag(Theme.custom)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        // Your content
    }
    .environment(\.themeProvider, themeProvider)
    .onChange(of: selectedTheme) { theme in
        themeProvider.setTheme(theme)
    }
}
```

## Accessibility Guidelines

### Screen Reader Support

1. **Labels**: Always provide meaningful labels for interactive elements.
2. **Hints**: Add hints to explain complex interactions.
3. **Values**: Provide current values for sliders, progress indicators, etc.
4. **Grouping**: Use appropriate accessibility grouping for related elements.

### High Contrast Support

1. **Color Contrast**: Ensure sufficient contrast between text and background colors.
2. **Visual Indicators**: Use shapes and patterns in addition to color for important information.
3. **Focus Indicators**: Provide clear focus indicators for keyboard navigation.

### Keyboard Navigation

1. **Tab Order**: Ensure logical tab order for interactive elements.
2. **Focus Management**: Manage focus appropriately in modals and overlays.
3. **Keyboard Shortcuts**: Provide keyboard shortcuts for common actions.

---

This documentation provides a comprehensive guide to using RRUIComponents in your SwiftUI applications. For more specific examples and advanced usage patterns, refer to the individual component files and their preview implementations.
