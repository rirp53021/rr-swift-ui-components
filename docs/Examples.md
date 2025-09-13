# Component Examples

## Table of Contents

1. [Basic Components](#basic-components)
2. [Form Components](#form-components)
3. [Navigation Components](#navigation-components)
4. [Feedback Components](#feedback-components)
5. [Layout Components](#layout-components)
6. [Data Display Components](#data-display-components)
7. [Overlay Components](#overlay-components)
8. [Media Components](#media-components)
9. [Advanced Components](#advanced-components)
10. [Complete Examples](#complete-examples)

## Basic Components

### RRLabel

#### Basic Usage

```swift
RRLabel("Hello World", style: .bodyLarge)
```

#### With Custom Styling

```swift
RRLabel("Title", style: .titleLarge, weight: .semibold, color: .primary)
```

#### Multiple Styles

```swift
VStack(alignment: .leading) {
    RRLabel("Display Text", style: .displayLarge)
    RRLabel("Headline Text", style: .headlineLarge)
    RRLabel("Title Text", style: .titleLarge)
    RRLabel("Body Text", style: .bodyLarge)
    RRLabel("Label Text", style: .labelLarge)
}
```

### RRButton

#### Basic Usage

```swift
RRButton("Click me", style: .primary) {
    print("Button tapped")
}
```

#### Different Styles

```swift
VStack(spacing: 16) {
    RRButton("Primary", style: .primary) { }
    RRButton("Secondary", style: .secondary) { }
    RRButton("Tertiary", style: .tertiary) { }
    RRButton("Destructive", style: .destructive) { }
}
```

#### Different Sizes

```swift
VStack(spacing: 16) {
    RRButton("Small", style: .primary, size: .small) { }
    RRButton("Medium", style: .primary, size: .medium) { }
    RRButton("Large", style: .primary, size: .large) { }
}
```

#### Disabled State

```swift
RRButton("Disabled", style: .primary, isEnabled: false) { }
```

### RRTextField

#### Basic Usage

```swift
@State private var text = ""

RRTextField("Enter text", text: $text)
```

#### With Validation

```swift
@State private var email = ""
@State private var validationState: ValidationState = .valid

RRTextField(
    "Email",
    text: $email,
    style: .outlined,
    validationState: validationState,
    helperText: "Enter your email address",
    errorText: validationState == .invalid ? "Invalid email" : nil
)
```

#### Secure Text Field

```swift
@State private var password = ""

RRTextField("Password", text: $password, isSecure: true)
```

### RRAsyncImage

#### Basic Usage

```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
```

#### With Placeholder and Error

```swift
RRAsyncImage(
    url: URL(string: "https://example.com/image.jpg"),
    placeholder: {
        Image(systemName: "photo")
            .foregroundColor(.gray)
    },
    error: {
        Image(systemName: "exclamationmark.triangle")
            .foregroundColor(.red)
    }
)
```

#### With Custom Sizing

```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 100, height: 100)
    .clipShape(Circle())
```

## Form Components

### RRToggle

#### Basic Usage

```swift
@State private var isOn = false

RRToggle("Enable notifications", isOn: $isOn)
```

#### With Custom Styling

```swift
RRToggle("Custom toggle", isOn: $isOn, style: .switch)
```

### RRCheckbox

#### Basic Usage

```swift
@State private var isChecked = false

RRCheckbox("I agree to the terms", isChecked: $isChecked)
```

#### With Validation

```swift
@State private var isChecked = false
@State private var validationState: ValidationState = .valid

RRCheckbox(
    "I agree to the terms",
    isChecked: $isChecked,
    validationState: validationState
)
```

### RRDropdown

#### Basic Usage

```swift
@State private var selection = "Option 1"
let options = ["Option 1", "Option 2", "Option 3"]

RRDropdown("Select option", selection: $selection, options: options)
```

#### With Custom Options

```swift
struct Option: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

@State private var selection: Option?
let options = [
    Option(title: "First Option", value: "1"),
    Option(title: "Second Option", value: "2"),
    Option(title: "Third Option", value: "3")
]

RRDropdown("Select option", selection: $selection, options: options)
```

### RRDatePicker

#### Basic Usage

```swift
@State private var date = Date()

RRDatePicker("Select date", selection: $date)
```

#### With Time

```swift
@State private var date = Date()

RRDatePicker(
    "Select date and time",
    selection: $date,
    displayedComponents: [.date, .hourAndMinute]
)
```

### RRSlider

#### Basic Usage

```swift
@State private var value: Double = 50

RRSlider(value: $value, in: 0...100)
```

#### With Custom Range

```swift
@State private var value: Double = 25

RRSlider(value: $value, in: 0...50, step: 5)
```

### RRStepper

#### Basic Usage

```swift
@State private var value = 0

RRStepper("Value", value: $value, in: 0...100)
```

#### With Custom Step

```swift
@State private var value = 0

RRStepper("Value", value: $value, in: 0...100, step: 5)
```

## Navigation Components

### RRNavigationBar

#### Basic Usage

```swift
RRNavigationBar(title: "Title")
```

#### With Buttons

```swift
RRNavigationBar(
    title: "Title",
    leadingButton: {
        AnyView(Button("Back") {})
    },
    trailingButton: {
        AnyView(Button("Done") {})
    }
)
```

### RRTabBar

#### Basic Usage

```swift
@State private var selectedTab = 0

RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house"),
    TabItem(title: "Profile", icon: "person"),
    TabItem(title: "Settings", icon: "gear")
])
```

#### With Custom Icons

```swift
RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house.fill"),
    TabItem(title: "Search", icon: "magnifyingglass"),
    TabItem(title: "Favorites", icon: "heart.fill"),
    TabItem(title: "Profile", icon: "person.circle")
])
```

### RRSegmentedControl

#### Basic Usage

```swift
@State private var selection = 0

RRSegmentedControl(selection: $selection, options: ["Option 1", "Option 2", "Option 3"])
```

#### With Custom Options

```swift
@State private var selection = "First"

RRSegmentedControl(selection: $selection, options: ["First", "Second", "Third"])
```

## Feedback Components

### RRAlert

#### Basic Usage

```swift
@State private var showingAlert = false

RRAlert(
    isPresented: $showingAlert,
    title: "Alert",
    message: "This is an alert message",
    primaryButton: AlertButton(title: "OK", action: {})
)
```

#### With Multiple Buttons

```swift
RRAlert(
    isPresented: $showingAlert,
    title: "Confirm",
    message: "Are you sure you want to delete this item?",
    primaryButton: AlertButton(title: "Delete", action: {}),
    secondaryButton: AlertButton(title: "Cancel", action: {})
)
```

### RRSnackbar

#### Basic Usage

```swift
@State private var showingSnackbar = false

RRSnackbar(
    isPresented: $showingSnackbar,
    message: "Operation completed successfully",
    style: .success
)
```

#### With Custom Duration

```swift
RRSnackbar(
    isPresented: $showingSnackbar,
    message: "This message will show for 5 seconds",
    style: .info,
    duration: 5.0
)
```

### RRLoadingIndicator

#### Basic Usage

```swift
RRLoadingIndicator()
```

#### With Custom Styling

```swift
RRLoadingIndicator(style: .spinner, size: .large, color: .primary)
```

### RREmptyState

#### Basic Usage

```swift
RREmptyState(
    title: "No Data",
    message: "There are no items to display",
    icon: "tray"
)
```

#### With Custom Action

```swift
RREmptyState(
    title: "No Data",
    message: "There are no items to display",
    icon: "tray",
    action: {
        Button("Refresh") {
            // Refresh action
        }
    }
)
```

## Layout Components

### RRCard

#### Basic Usage

```swift
RRCard {
    RRLabel("Card content", style: .bodyLarge)
}
```

#### With Header and Footer

```swift
RRCard(
    header: {
        RRLabel("Card Header", style: .titleLarge)
    },
    content: {
        RRLabel("Card content", style: .bodyLarge)
    },
    footer: {
        RRButton("Action", style: .primary) { }
    }
)
```

### RRGridView

#### Basic Usage

```swift
let items = [1, 2, 3, 4, 5, 6]

RRGridView(data: items, columns: 2) { item in
    RRLabel("Item \(item)", style: .bodyLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
}
```

#### With Custom Spacing

```swift
RRGridView(data: items, columns: 3, spacing: 16) { item in
    RRLabel("Item \(item)", style: .bodyLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
}
```

### RRDivider

#### Basic Usage

```swift
VStack {
    RRLabel("Content above", style: .bodyLarge)
    RRDivider()
    RRLabel("Content below", style: .bodyLarge)
}
```

#### With Custom Styling

```swift
RRDivider(style: .dashed, color: .gray)
```

### RRSpacer

#### Basic Usage

```swift
HStack {
    RRLabel("Left", style: .bodyLarge)
    RRSpacer()
    RRLabel("Right", style: .bodyLarge)
}
```

#### With Custom Length

```swift
VStack {
    RRLabel("Top", style: .bodyLarge)
    RRSpacer(minLength: 20, maxLength: 100)
    RRLabel("Bottom", style: .bodyLarge)
}
```

### RRContainer

#### Basic Usage

```swift
RRContainer {
    RRLabel("Container content", style: .bodyLarge)
}
```

#### With Custom Max Width

```swift
RRContainer(maxWidth: .large, padding: .medium) {
    RRLabel("Container content", style: .bodyLarge)
}
```

### RRSection

#### Basic Usage

```swift
RRSection(header: "Section Title") {
    RRLabel("Section content", style: .bodyLarge)
}
```

#### With Header and Footer

```swift
RRSection(
    header: "Section Title",
    footer: "Section footer text"
) {
    RRLabel("Section content", style: .bodyLarge)
}
```

## Data Display Components

### RRTable

#### Basic Usage

```swift
struct User: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let role: String
}

let users = [
    User(name: "John Doe", email: "john@example.com", role: "Admin"),
    User(name: "Jane Smith", email: "jane@example.com", role: "User")
]

RRTable(data: users) { user in
    RRTableColumn("Name") { user.name }
    RRTableColumn("Email") { user.name }
    RRTableColumn("Role") { user.role }
}
```

#### With Sorting

```swift
RRTable(data: users, sortable: true) { user in
    RRTableColumn("Name") { user.name }
    RRTableColumn("Email") { user.email }
    RRTableColumn("Role") { user.role }
}
```

### RRList

#### Basic Usage

```swift
let items = ["Item 1", "Item 2", "Item 3"]

RRList(data: items) { item in
    HStack {
        RRLabel(item, style: .bodyLarge)
        Spacer()
        Image(systemName: "chevron.right")
    }
}
```

#### With Custom Cells

```swift
struct ListItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

let items = [
    ListItem(title: "First Item", subtitle: "Subtitle 1", icon: "star"),
    ListItem(title: "Second Item", subtitle: "Subtitle 2", icon: "heart")
]

RRList(data: items) { item in
    HStack {
        Image(systemName: item.icon)
        VStack(alignment: .leading) {
            RRLabel(item.title, style: .bodyLarge)
            RRLabel(item.subtitle, style: .bodyMedium, color: .secondary)
        }
        Spacer()
    }
    .padding()
}
```

### RRChart

#### Basic Usage

```swift
let chartData = [
    ChartDataPoint(label: "Jan", value: 100),
    ChartDataPoint(label: "Feb", value: 150),
    ChartDataPoint(label: "Mar", value: 200)
]

RRChart(data: chartData, type: .bar)
```

#### Different Chart Types

```swift
VStack {
    RRChart(data: chartData, type: .bar)
    RRChart(data: chartData, type: .line)
    RRChart(data: chartData, type: .pie)
}
```

### RRDataGrid

#### Basic Usage

```swift
let gridData = [
    GridDataItem(title: "Item 1", value: "100"),
    GridDataItem(title: "Item 2", value: "200"),
    GridDataItem(title: "Item 3", value: "300")
]

RRDataGrid(data: gridData, columns: 2) { item in
    VStack {
        RRLabel(item.title, style: .bodyLarge)
        RRLabel(item.value, style: .titleLarge)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
}
```

## Overlay Components

### RRModal

#### Basic Usage

```swift
@State private var showingModal = false

RRModal(isPresented: $showingModal) {
    VStack {
        RRLabel("Modal Content", style: .titleLarge)
        RRButton("Close", style: .primary) {
            showingModal = false
        }
    }
    .padding()
}
```

#### Different Styles

```swift
RRModal(isPresented: $showingModal, style: .sheet) {
    ModalContent()
}

RRModal(isPresented: $showingModal, style: .fullScreen) {
    ModalContent()
}
```

### RRTooltip

#### Basic Usage

```swift
RRTooltip(text: "This is a tooltip") {
    RRButton("Hover me", style: .primary) { }
}
```

#### With Custom Position

```swift
RRTooltip(text: "Tooltip text", position: .top) {
    RRButton("Hover me", style: .primary) { }
}
```

### RRPopover

#### Basic Usage

```swift
@State private var showingPopover = false

RRPopover(isPresented: $showingPopover) {
    VStack {
        RRLabel("Popover Content", style: .bodyLarge)
        RRButton("Close", style: .primary) {
            showingPopover = false
        }
    }
    .padding()
}
```

### RRContextMenu

#### Basic Usage

```swift
RRContextMenu(actions: [
    ContextAction(title: "Edit", icon: "pencil") {
        print("Edit tapped")
    },
    ContextAction(title: "Delete", icon: "trash") {
        print("Delete tapped")
    }
]) {
    RRButton("Long press me", style: .primary) { }
}
```

### RROverlay

#### Basic Usage

```swift
@State private var showingOverlay = false

RROverlay(isPresented: $showingOverlay) {
    VStack {
        RRLabel("Content", style: .bodyLarge)
        RRButton("Show Overlay", style: .primary) {
            showingOverlay = true
        }
    }
} overlayContent: {
    VStack {
        RRLabel("Overlay Content", style: .titleLarge)
        RRButton("Close", style: .primary) {
            showingOverlay = false
        }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
}
```

## Media Components

### RRCarousel

#### Basic Usage

```swift
let carouselItems = [
    CarouselItem(title: "Item 1", image: "photo1"),
    CarouselItem(title: "Item 2", image: "photo2"),
    CarouselItem(title: "Item 3", image: "photo3")
]

RRCarousel(data: carouselItems) { item in
    VStack {
        Image(systemName: item.image)
            .font(.system(size: 50))
        RRLabel(item.title, style: .titleLarge)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(12)
}
```

#### With Autoplay

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

#### Basic Usage

```swift
let videoURL = URL(string: "https://example.com/video.mp4")!

RRVideoPlayer(videoURL: videoURL) { player in
    // Custom video controls
    HStack {
        Button("Play") { player.play() }
        Button("Pause") { player.pause() }
    }
}
```

#### With Autoplay

```swift
RRVideoPlayer(videoURL: videoURL, autoplay: true) { player in
    // Custom video controls
}
```

### RRImageGallery

#### Basic Usage

```swift
let images = [
    GalleryImage(url: URL(string: "https://example.com/image1.jpg")!),
    GalleryImage(url: URL(string: "https://example.com/image2.jpg")!),
    GalleryImage(url: URL(string: "https://example.com/image3.jpg")!)
]

RRImageGallery(images: images) { image in
    RRAsyncImage(url: image.url)
        .aspectRatio(contentMode: .fit)
}
```

#### With Custom Navigation

```swift
@State private var selectedIndex = 0

RRImageGallery(
    images: images,
    selectedIndex: $selectedIndex
) { image in
    RRAsyncImage(url: image.url)
        .aspectRatio(contentMode: .fit)
}
```

### RRMediaViewer

#### Basic Usage

```swift
let mediaItems = [
    MediaItem(type: .image, url: URL(string: "https://example.com/image.jpg")!),
    MediaItem(type: .video, url: URL(string: "https://example.com/video.mp4")!),
    MediaItem(type: .image, url: URL(string: "https://example.com/image2.jpg")!)
]

RRMediaViewer(mediaItems: mediaItems) { item in
    switch item.type {
    case .image:
        RRAsyncImage(url: item.url)
    case .video:
        RRVideoPlayer(videoURL: item.url) { _ in }
    }
}
```

## Advanced Components

### RRSearchBar

#### Basic Usage

```swift
@State private var searchText = ""

RRSearchBar(text: $searchText, placeholder: "Search...")
```

#### With Suggestions

```swift
@State private var searchText = ""
@State private var suggestions = ["Apple", "Banana", "Cherry"]

RRSearchBar(
    text: $searchText,
    placeholder: "Search fruits...",
    suggestions: suggestions
)
```

### RRRating

#### Basic Usage

```swift
@State private var rating = 3

RRRating(rating: $rating, maxRating: 5)
```

#### With Custom Style

```swift
RRRating(rating: $rating, maxRating: 5, style: .stars)
```

### RRTimeline

#### Basic Usage

```swift
let timelineEvents = [
    TimelineEvent(title: "Event 1", description: "Description 1", date: Date()),
    TimelineEvent(title: "Event 2", description: "Description 2", date: Date()),
    TimelineEvent(title: "Event 3", description: "Description 3", date: Date())
]

RRTimeline(events: timelineEvents) { event in
    VStack(alignment: .leading) {
        RRLabel(event.title, style: .titleLarge)
        RRLabel(event.description, style: .bodyLarge)
        RRLabel(event.date.formatted(), style: .bodyMedium, color: .secondary)
    }
}
```

### RRTagInput

#### Basic Usage

```swift
@State private var tags = ["Swift", "SwiftUI"]

RRTagInput(tags: $tags, placeholder: "Add tags...")
```

#### With Max Tags

```swift
RRTagInput(tags: $tags, placeholder: "Add tags...", maxTags: 5)
```

## Complete Examples

### Login Form

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Welcome Back", style: .displayLarge)
                .padding(.bottom, DesignTokens.Spacing.md)
            
            VStack(spacing: DesignTokens.Spacing.md) {
                RRTextField("Email", text: $email)
                RRTextField("Password", text: $password, isSecure: true)
                
                HStack {
                    RRCheckbox("Remember me", isChecked: $rememberMe)
                    Spacer()
                }
            }
            
            RRButton("Sign In", style: .primary) {
                // Login action
            }
            
            RRButton("Forgot Password?", style: .tertiary) {
                // Forgot password action
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Invalid credentials"))
        }
    }
}
```

### Profile Card

```swift
struct ProfileCard: View {
    let profile: Profile
    
    var body: some View {
        RRCard {
            VStack(spacing: DesignTokens.Spacing.md) {
                HStack {
                    RRAsyncImage(url: profile.avatarURL)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        RRLabel(profile.name, style: .titleLarge)
                        RRLabel(profile.title, style: .bodyMedium, color: .secondary)
                        RRLabel(profile.location, style: .bodySmall, color: .tertiary)
                    }
                    
                    Spacer()
                }
                
                RRLabel(profile.bio, style: .bodyLarge)
                
                HStack {
                    RRButton("Follow", style: .primary) { }
                    RRButton("Message", style: .secondary) { }
                }
            }
        }
    }
}
```

### Data Dashboard

```swift
struct DataDashboard: View {
    let data: [DataPoint]
    @State private var selectedChart = 0
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Analytics Dashboard", style: .displayLarge)
            
            RRSegmentedControl(
                selection: $selectedChart,
                options: ["Bar Chart", "Line Chart", "Pie Chart"]
            )
            
            RRChart(
                data: data,
                type: selectedChart == 0 ? .bar : selectedChart == 1 ? .line : .pie
            )
            .frame(height: 300)
            
            RRTable(data: data) { point in
                RRTableColumn("Label") { point.label }
                RRTableColumn("Value") { "\(point.value)" }
                RRTableColumn("Percentage") { "\(point.percentage)%" }
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

### Media Gallery

```swift
struct MediaGallery: View {
    let mediaItems: [MediaItem]
    @State private var selectedIndex = 0
    @State private var showingFullScreen = false
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            RRLabel("Media Gallery", style: .titleLarge)
            
            RRCarousel(data: mediaItems, selectedIndex: $selectedIndex) { item in
                RRAsyncImage(url: item.thumbnailURL)
                    .aspectRatio(16/9, contentMode: .fit)
                    .cornerRadius(8)
                    .onTapGesture {
                        showingFullScreen = true
                    }
            }
            
            RRImageGallery(
                images: mediaItems.map { GalleryImage(url: $0.fullSizeURL) },
                selectedIndex: $selectedIndex
            ) { image in
                RRAsyncImage(url: image.url)
                    .aspectRatio(contentMode: .fit)
            }
            .fullScreenCover(isPresented: $showingFullScreen) {
                RRMediaViewer(mediaItems: mediaItems) { item in
                    switch item.type {
                    case .image:
                        RRAsyncImage(url: item.fullSizeURL)
                    case .video:
                        RRVideoPlayer(videoURL: item.fullSizeURL) { _ in }
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }
}
```

These examples demonstrate the comprehensive capabilities of RRUIComponents and provide practical patterns for building real-world applications.
