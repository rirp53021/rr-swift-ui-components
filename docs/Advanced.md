# Advanced - RRUIComponents

## Overview

Advanced components provide complex interactive functionality and specialized UI patterns. The RRUIComponents library includes sophisticated components for carousels, modals, ratings, search, and more.

## Components

- `RRCarousel` - Content carousel
- `RRModal` - Modal dialogs
- `RRRating` - Rating input
- `RRSearchBar` - Search input
- `RRSegmentedControl` - Segmented control
- `RRTagInput` - Tag input
- `RRTimeline` - Timeline display

## RRCarousel

A content carousel component for displaying multiple items in a scrollable format.

### Basic Usage

```swift
RRCarousel(items: carouselItems) { item in
    RRCard {
        VStack {
            RRAsyncImage(url: item.imageURL)
            RRLabel(item.title)
        }
    }
}
```

### Initialization

```swift
RRCarousel<Content>(items: [Item], content: @escaping (Item) -> Content)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `items` | `[Item]` | Array of items to display |
| `content` | `(Item) -> Content` | Content builder for each item |
| `style` | `CarouselStyle` | Visual style of the carousel |
| `autoPlay` | `Bool` | Whether to auto-play the carousel |
| `showIndicators` | `Bool` | Whether to show page indicators |

### Examples

#### Basic Carousel
```swift
RRCarousel(items: featuredItems) { item in
    RRCard {
        VStack {
            RRAsyncImage(url: item.imageURL)
                .frame(height: 200)
                .clipped()
            
            VStack(alignment: .leading) {
                RRLabel(item.title)
                    .style(.headline)
                
                RRLabel(item.description)
                    .style(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
```

#### With Page Indicators
```swift
RRCarousel(items: carouselItems) { item in
    ItemCardView(item: item)
}
.showIndicators(true)
.style(.paged)
```

#### Auto-playing Carousel
```swift
RRCarousel(items: carouselItems) { item in
    ItemCardView(item: item)
}
.autoPlay(true)
.autoPlayInterval(3.0)
.showIndicators(true)
```

#### Vertical Carousel
```swift
RRCarousel(items: carouselItems) { item in
    ItemCardView(item: item)
}
.orientation(.vertical)
.style(.continuous)
```

## RRModal

A modal dialog component with multiple presentation styles.

### Basic Usage

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
```

### Initialization

```swift
RRModal(isPresented: Binding<Bool>, content: () -> AnyView)
```

### Presentation Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.sheet` | Sheet presentation | Settings, forms |
| `.fullScreenCover` | Full screen cover | Onboarding, media |
| `.popover` | Popover presentation | Context menus |
| `.bottomSheet` | Bottom sheet | Quick actions |

### Examples

#### Basic Modal
```swift
@State private var showModal = false

RRModal(isPresented: $showModal) {
    VStack(spacing: 20) {
        RRLabel("Settings")
            .style(.title)
        
        VStack(spacing: 16) {
            RRToggle("Notifications", isOn: $notificationsEnabled)
            RRToggle("Dark Mode", isOn: $darkModeEnabled)
        }
        
        HStack {
            RRButton("Cancel") {
                showModal = false
            }
            .style(.ghost)
            
            Spacer()
            
            RRButton("Save") {
                saveSettings()
                showModal = false
            }
            .style(.primary)
        }
    }
    .padding()
}
.presentationStyle(.sheet)
```

#### Full Screen Modal
```swift
@State private var showFullScreenModal = false

RRModal(isPresented: $showFullScreenModal) {
    VStack {
        HStack {
            RRButton("Close") {
                showFullScreenModal = false
            }
            .style(.ghost)
            
            Spacer()
        }
        .padding()
        
        Spacer()
        
        RRLabel("Full Screen Content")
            .style(.title)
        
        Spacer()
    }
}
.presentationStyle(.fullScreenCover)
```

#### Bottom Sheet Modal
```swift
@State private var showBottomSheet = false

RRModal(isPresented: $showBottomSheet) {
    VStack(spacing: 20) {
        RRLabel("Quick Actions")
            .style(.headline)
        
        VStack(spacing: 12) {
            RRButton("Share") {
                shareContent()
                showBottomSheet = false
            }
            .style(.ghost)
            
            RRButton("Save") {
                saveContent()
                showBottomSheet = false
            }
            .style(.ghost)
            
            RRButton("Delete") {
                deleteContent()
                showBottomSheet = false
            }
            .style(.ghost)
            .foregroundColor(.red)
        }
    }
    .padding()
}
.presentationStyle(.bottomSheet)
```

## RRRating

A rating input component with multiple styles and configurations.

### Basic Usage

```swift
@State private var rating = 0.0

RRRating(rating: $rating)
```

### Initialization

```swift
RRRating(rating: Binding<Double>)
RRRating(rating: Binding<Double>, maxRating: Int)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `rating` | `Binding<Double>` | Current rating value |
| `maxRating` | `Int` | Maximum rating value |
| `style` | `RatingStyle` | Visual style of the rating |
| `size` | `RatingSize` | Size of the rating stars |
| `isInteractive` | `Bool` | Whether the rating is interactive |

### Examples

#### Basic Rating
```swift
@State private var rating = 3.0

RRRating(rating: $rating)
    .style(.stars)
    .size(.large)
```

#### Read-only Rating
```swift
RRRating(rating: .constant(4.5))
    .style(.stars)
    .size(.medium)
    .isInteractive(false)
```

#### Custom Max Rating
```swift
@State private var rating = 0.0

RRRating(rating: $rating, maxRating: 10)
    .style(.stars)
    .size(.large)
```

#### Different Styles
```swift
// Stars
RRRating(rating: $rating)
    .style(.stars)
    .color(.yellow)

// Hearts
RRRating(rating: $rating)
    .style(.hearts)
    .color(.red)

// Thumbs
RRRating(rating: $rating)
    .style(.thumbs)
    .color(.blue)
```

#### Rating with Label
```swift
VStack(alignment: .leading, spacing: 8) {
    RRLabel("Rate this item")
        .style(.headline)
    
    RRRating(rating: $rating)
        .style(.stars)
        .size(.large)
    
    RRLabel("\(rating, specifier: "%.1f") out of 5")
        .style(.caption)
        .foregroundColor(.secondary)
}
```

## RRSearchBar

A search input component with suggestions and filtering capabilities.

### Basic Usage

```swift
@State private var searchText = ""

RRSearchBar(text: $searchText)
```

### Initialization

```swift
RRSearchBar(text: Binding<String>)
RRSearchBar(text: Binding<String>, placeholder: String?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | `Binding<String>` | Search text binding |
| `placeholder` | `String?` | Placeholder text |
| `suggestions` | `[String]` | Search suggestions |
| `onSearch` | `(String) -> Void` | Search action callback |

### Examples

#### Basic Search Bar
```swift
@State private var searchText = ""

RRSearchBar(text: $searchText)
    .placeholder("Search items...")
```

#### With Suggestions
```swift
@State private var searchText = ""
@State private var suggestions = ["Apple", "Banana", "Cherry"]

RRSearchBar(text: $searchText)
    .placeholder("Search fruits...")
    .suggestions(suggestions)
    .onSearch { query in
        performSearch(query)
    }
```

#### With Custom Styling
```swift
RRSearchBar(text: $searchText)
    .placeholder("Search...")
    .background(.surface)
    .cornerRadius(12)
    .padding(.horizontal)
```

#### In Navigation
```swift
VStack {
    RRSearchBar(text: $searchText)
        .padding()
    
    if searchText.isEmpty {
        RREmptyState(
            title: "Search",
            subtitle: "Enter a search term to find items",
            illustration: Image(systemName: "magnifyingglass")
        )
    } else {
        List(filteredItems) { item in
            ItemRowView(item: item)
        }
    }
}
```

## RRSegmentedControl

A segmented control component for selecting between multiple options.

### Basic Usage

```swift
@State private var selectedSegment = 0

RRSegmentedControl(
    selection: $selectedSegment,
    segments: ["All", "Favorites", "Recent"]
)
```

### Initialization

```swift
RRSegmentedControl(selection: Binding<Int>, segments: [String])
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `selection` | `Binding<Int>` | Selected segment index |
| `segments` | `[String]` | Segment titles |
| `style` | `SegmentedControlStyle` | Visual style |
| `color` | `Color` | Accent color |

### Examples

#### Basic Segmented Control
```swift
@State private var selectedSegment = 0

RRSegmentedControl(
    selection: $selectedSegment,
    segments: ["All", "Favorites", "Recent"]
)
```

#### With Custom Styling
```swift
RRSegmentedControl(
    selection: $selectedSegment,
    segments: ["All", "Favorites", "Recent"]
)
.style(.standard)
.color(.blue)
```

#### With Icons
```swift
@State private var selectedSegment = 0

RRSegmentedControl(
    selection: $selectedSegment,
    segments: ["house", "heart", "clock"]
)
.style(.icon)
```

#### In Content Filter
```swift
VStack {
    RRSegmentedControl(
        selection: $selectedFilter,
        segments: ["All", "Active", "Completed"]
    )
    .padding()
    
    List(filteredItems) { item in
        ItemRowView(item: item)
    }
}
```

## RRTagInput

A tag input component for managing tags and labels.

### Basic Usage

```swift
@State private var tags = ["Swift", "iOS"]

RRTagInput(tags: $tags)
```

### Initialization

```swift
RRTagInput(tags: Binding<[String]>)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `tags` | `Binding<[String]>` | Tags array binding |
| `placeholder` | `String` | Placeholder text |
| `maxTags` | `Int?` | Maximum number of tags |
| `allowedCharacters` | `CharacterSet` | Allowed characters |

### Examples

#### Basic Tag Input
```swift
@State private var tags = ["Swift", "iOS"]

RRTagInput(tags: $tags)
    .placeholder("Add tags...")
```

#### With Max Tags
```swift
@State private var tags = ["Swift", "iOS"]

RRTagInput(tags: $tags)
    .placeholder("Add tags...")
    .maxTags(5)
```

#### With Custom Styling
```swift
RRTagInput(tags: $tags)
    .placeholder("Add tags...")
    .tagStyle(.rounded)
    .tagColor(.blue)
    .backgroundColor(.surface)
```

#### In Form
```swift
VStack(alignment: .leading, spacing: 16) {
    RRLabel("Tags")
        .style(.headline)
    
    RRTagInput(tags: $tags)
        .placeholder("Add tags...")
        .maxTags(10)
    
    RRLabel("\(tags.count) tags added")
        .style(.caption)
        .foregroundColor(.secondary)
}
```

## RRTimeline

A timeline/progress tracker component for displaying sequential events.

### Basic Usage

```swift
RRTimeline(items: [
    TimelineItem(title: "Order Placed", date: Date(), status: .completed),
    TimelineItem(title: "Processing", date: Date(), status: .inProgress),
    TimelineItem(title: "Shipped", date: Date(), status: .pending)
])
```

### Initialization

```swift
RRTimeline(items: [TimelineItem])
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `items` | `[TimelineItem]` | Timeline items |
| `orientation` | `TimelineOrientation` | Vertical or horizontal |
| `style` | `TimelineStyle` | Visual style |
| `showConnectors` | `Bool` | Show connecting lines |

### Examples

#### Basic Timeline
```swift
RRTimeline(items: timelineItems)
    .orientation(.vertical)
    .showConnectors(true)
```

#### Horizontal Timeline
```swift
RRTimeline(items: timelineItems)
    .orientation(.horizontal)
    .style(.compact)
```

#### With Custom Styling
```swift
RRTimeline(items: timelineItems)
    .orientation(.vertical)
    .style(.detailed)
    .completedColor(.green)
    .pendingColor(.gray)
    .inProgressColor(.blue)
```

#### Order Tracking
```swift
struct OrderTrackingView: View {
    let order: Order
    
    var timelineItems: [TimelineItem] {
        [
            TimelineItem(
                title: "Order Placed",
                subtitle: "Your order has been placed",
                date: order.createdAt,
                status: .completed
            ),
            TimelineItem(
                title: "Processing",
                subtitle: "Your order is being prepared",
                date: order.processingAt,
                status: .inProgress
            ),
            TimelineItem(
                title: "Shipped",
                subtitle: "Your order is on its way",
                date: order.shippedAt,
                status: .pending
            ),
            TimelineItem(
                title: "Delivered",
                subtitle: "Your order has been delivered",
                date: order.deliveredAt,
                status: .pending
            )
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            RRLabel("Order #\(order.id)")
                .style(.title)
            
            RRTimeline(items: timelineItems)
                .orientation(.vertical)
                .showConnectors(true)
        }
        .padding()
    }
}
```

## Best Practices

### Advanced Component Usage

1. **Performance**: Use lazy loading for large datasets
2. **State Management**: Properly manage complex component state
3. **Accessibility**: Ensure all components are accessible
4. **Customization**: Provide appropriate customization options

### User Experience

1. **Loading States**: Show appropriate loading states
2. **Error Handling**: Handle errors gracefully
3. **Feedback**: Provide clear user feedback
4. **Consistency**: Maintain consistent behavior

### Performance

1. **Memory Management**: Properly manage component memory
2. **Rendering**: Optimize rendering performance
3. **Animations**: Use efficient animations
4. **Data Loading**: Implement efficient data loading

## Common Patterns

### Modal Management
```swift
class ModalManager: ObservableObject {
    @Published var currentModal: ModalType?
    
    func present(_ modal: ModalType) {
        currentModal = modal
    }
    
    func dismiss() {
        currentModal = nil
    }
}

enum ModalType {
    case settings
    case profile
    case search
}
```

### Search with Filtering
```swift
struct SearchableListView: View {
    @State private var searchText = ""
    @State private var selectedFilter = 0
    
    let items: [Item]
    
    var filteredItems: [Item] {
        var filtered = items
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch selectedFilter {
        case 0: // All
            break
        case 1: // Favorites
            filtered = filtered.filter { $0.isFavorite }
        case 2: // Recent
            filtered = filtered.filter { $0.isRecent }
        default:
            break
        }
        
        return filtered
    }
    
    var body: some View {
        VStack {
            RRSearchBar(text: $searchText)
                .padding()
            
            RRSegmentedControl(
                selection: $selectedFilter,
                segments: ["All", "Favorites", "Recent"]
            )
            .padding(.horizontal)
            
            List(filteredItems) { item in
                ItemRowView(item: item)
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Modal not presenting**: Check if the binding is properly connected
2. **Carousel not scrolling**: Verify the carousel style and content
3. **Search not working**: Check if the search callback is properly set

### Debug Tips

1. Use `.background(.red)` to visualize component bounds
2. Check console for component-related warnings
3. Verify bindings are properly connected
4. Test with different data sets and configurations
