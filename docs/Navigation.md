# Navigation - RRUIComponents

## Overview

Navigation components provide structure and flow control for user interfaces. The RRUIComponents library includes comprehensive navigation components with theming and customization support.

## Components

- `RRNavigationBar` - Custom navigation bar
- `RRPageIndicator` - Page navigation indicator
- `RRStepper` - Step-by-step navigation
- `RRTabBar` - Tab navigation

## RRNavigationBar

A customizable navigation bar component that replaces the standard iOS navigation bar.

### Basic Usage

```swift
RRNavigationBar(title: "Settings")
```

### Initialization

```swift
RRNavigationBar(title: String)
RRNavigationBar(title: String, leading: AnyView?, trailing: AnyView?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Navigation bar title |
| `leading` | `AnyView?` | Leading button/view |
| `trailing` | `AnyView?` | Trailing button/view |

### Examples

#### Basic Navigation Bar
```swift
RRNavigationBar(title: "Home")
```

#### With Back Button
```swift
RRNavigationBar(title: "Settings") {
    Button("Back") {
        dismiss()
    }
    .style(.ghost)
} trailing: {
    Button("Save") {
        saveSettings()
    }
    .style(.primary)
}
```

#### With Custom Actions
```swift
RRNavigationBar(title: "Profile") {
    Button("Cancel") {
        dismiss()
    }
    .style(.ghost)
} trailing: {
    HStack {
        Button("Edit") {
            editProfile()
        }
        .style(.ghost)
        
        Button("Share") {
            shareProfile()
        }
        .style(.ghost)
    }
}
```

#### With Search
```swift
@State private var searchText = ""

RRNavigationBar(title: "Search") {
    Button("Back") {
        dismiss()
    }
    .style(.ghost)
} trailing: {
    RRSearchBar(text: $searchText)
        .frame(width: 200)
}
```

### Customization

#### Custom Styling
```swift
RRNavigationBar(title: "Custom")
    .background(.surface)
    .foregroundColor(.primary)
    .font(.headline)
```

#### Large Title
```swift
RRNavigationBar(title: "Large Title")
    .largeTitle(true)
    .background(.background)
```

## RRPageIndicator

A page navigation indicator component for carousels and paginated content.

### Basic Usage

```swift
RRPageIndicator(currentPage: 2, totalPages: 5)
```

### Initialization

```swift
RRPageIndicator(currentPage: Int, totalPages: Int)
```

### Styles

| Style | Description | Appearance |
|-------|-------------|------------|
| `.dots` | Dot indicators (default) | Circular dots |
| `.lines` | Line indicators | Horizontal lines |
| `.numbers` | Number indicators | Page numbers |

### Examples

#### Basic Page Indicator
```swift
@State private var currentPage = 0

RRPageIndicator(currentPage: currentPage, totalPages: 5)
```

#### With Custom Styling
```swift
RRPageIndicator(currentPage: currentPage, totalPages: 5)
    .style(.dots)
    .color(.primary)
    .size(.medium)
```

#### Line Style
```swift
RRPageIndicator(currentPage: currentPage, totalPages: 5)
    .style(.lines)
    .color(.blue)
    .height(4)
```

#### Number Style
```swift
RRPageIndicator(currentPage: currentPage, totalPages: 5)
    .style(.numbers)
    .color(.primary)
    .font(.caption)
```

#### In Carousel
```swift
TabView(selection: $currentPage) {
    ForEach(0..<5) { index in
        RRLabel("Page \(index + 1)")
            .tag(index)
    }
}
.tabViewStyle(PageTabViewStyle())
.overlay(
    VStack {
        Spacer()
        RRPageIndicator(currentPage: currentPage, totalPages: 5)
            .padding(.bottom, 20)
    }
)
```

## RRStepper

A step-by-step navigation component for multi-step processes.

### Basic Usage

```swift
RRStepper(currentStep: 2, totalSteps: 4)
```

### Initialization

```swift
RRStepper(currentStep: Int, totalSteps: Int)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `currentStep` | `Int` | Current step (1-based) |
| `totalSteps` | `Int` | Total number of steps |
| `orientation` | `StepperOrientation` | Horizontal or vertical |
| `showLabels` | `Bool` | Show step labels |
| `showConnectors` | `Bool` | Show connecting lines |

### Examples

#### Basic Stepper
```swift
@State private var currentStep = 1

RRStepper(currentStep: currentStep, totalSteps: 4)
```

#### With Labels
```swift
RRStepper(currentStep: currentStep, totalSteps: 4)
    .showLabels(true)
    .labels(["Personal", "Contact", "Preferences", "Review"])
```

#### Vertical Stepper
```swift
RRStepper(currentStep: currentStep, totalSteps: 4)
    .orientation(.vertical)
    .showLabels(true)
    .labels(["Step 1", "Step 2", "Step 3", "Step 4"])
```

#### Custom Styling
```swift
RRStepper(currentStep: currentStep, totalSteps: 4)
    .color(.primary)
    .completedColor(.green)
    .pendingColor(.gray)
    .size(.large)
```

#### In Multi-Step Form
```swift
struct MultiStepForm: View {
    @State private var currentStep = 1
    @State private var formData = FormData()
    
    var body: some View {
        VStack {
            RRStepper(currentStep: currentStep, totalSteps: 4)
                .padding()
            
            TabView(selection: $currentStep) {
                PersonalInfoView(data: $formData)
                    .tag(1)
                
                ContactInfoView(data: $formData)
                    .tag(2)
                
                PreferencesView(data: $formData)
                    .tag(3)
                
                ReviewView(data: $formData)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                if currentStep > 1 {
                    RRButton("Previous") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .style(.ghost)
                }
                
                Spacer()
                
                RRButton(currentStep == 4 ? "Submit" : "Next") {
                    if currentStep < 4 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        submitForm()
                    }
                }
                .style(.primary)
            }
            .padding()
        }
    }
}
```

## RRTabBar

A tab navigation component for main app navigation.

### Basic Usage

```swift
@State private var selectedTab = 0

RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house"),
    TabItem(title: "Search", icon: "magnifyingglass"),
    TabItem(title: "Profile", icon: "person")
])
```

### Initialization

```swift
RRTabBar(selection: Binding<Int>, tabs: [TabItem])
```

### TabItem Structure

```swift
struct TabItem {
    let title: String
    let icon: String
    let badge: String?
    let isEnabled: Bool
}
```

### Examples

#### Basic Tab Bar
```swift
@State private var selectedTab = 0

RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house"),
    TabItem(title: "Search", icon: "magnifyingglass"),
    TabItem(title: "Favorites", icon: "heart"),
    TabItem(title: "Profile", icon: "person")
])
```

#### With Badges
```swift
@State private var selectedTab = 0
@State private var notificationCount = 3

RRTabBar(selection: $selectedTab, tabs: [
    TabItem(title: "Home", icon: "house"),
    TabItem(title: "Messages", icon: "message", badge: "\(notificationCount)"),
    TabItem(title: "Profile", icon: "person")
])
```

#### With Custom Styling
```swift
RRTabBar(selection: $selectedTab, tabs: tabs)
    .background(.surface)
    .selectedColor(.primary)
    .unselectedColor(.secondary)
    .font(.caption)
```

#### With Conditional Tabs
```swift
@State private var selectedTab = 0
@State private var isLoggedIn = false

var tabs: [TabItem] {
    var baseTabs = [
        TabItem(title: "Home", icon: "house"),
        TabItem(title: "Search", icon: "magnifyingglass")
    ]
    
    if isLoggedIn {
        baseTabs.append(TabItem(title: "Profile", icon: "person"))
    } else {
        baseTabs.append(TabItem(title: "Login", icon: "person.circle"))
    }
    
    return baseTabs
}

RRTabBar(selection: $selectedTab, tabs: tabs)
```

#### In Main App Structure
```swift
struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                SearchView()
                    .tag(1)
                
                FavoritesView()
                    .tag(2)
                
                ProfileView()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Tab bar
            RRTabBar(selection: $selectedTab, tabs: [
                TabItem(title: "Home", icon: "house"),
                TabItem(title: "Search", icon: "magnifyingglass"),
                TabItem(title: "Favorites", icon: "heart"),
                TabItem(title: "Profile", icon: "person")
            ])
        }
    }
}
```

## Best Practices

### Navigation Design

1. **Clear Hierarchy**: Maintain a clear navigation hierarchy
2. **Consistent Patterns**: Use consistent navigation patterns throughout the app
3. **Breadcrumbs**: Provide clear indication of current location
4. **Back Navigation**: Always provide a way to go back

### Accessibility

1. **Labels**: Ensure all navigation elements have proper accessibility labels
2. **Hints**: Provide helpful hints for navigation actions
3. **Focus Management**: Manage focus appropriately during navigation
4. **VoiceOver**: Test with VoiceOver for screen reader compatibility

### Performance

1. **Lazy Loading**: Use lazy loading for tab content
2. **State Management**: Properly manage navigation state
3. **Memory Management**: Avoid retaining unnecessary view state

## Common Patterns

### Navigation State Management
```swift
class NavigationManager: ObservableObject {
    @Published var currentTab = 0
    @Published var navigationPath = NavigationPath()
    @Published var isPresentingModal = false
    
    func navigateToTab(_ tab: Int) {
        currentTab = tab
    }
    
    func presentModal() {
        isPresentingModal = true
    }
    
    func dismissModal() {
        isPresentingModal = false
    }
}
```

### Deep Linking
```swift
struct DeepLinkHandler: ViewModifier {
    @Environment(\.openURL) private var openURL
    
    func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                handleDeepLink(url)
            }
    }
    
    private func handleDeepLink(_ url: URL) {
        // Handle deep link navigation
        switch url.host {
        case "tab":
            // Navigate to specific tab
        case "page":
            // Navigate to specific page
        default:
            break
        }
    }
}
```

### Navigation Transitions
```swift
extension View {
    func navigationTransition() -> some View {
        self
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
    }
}
```

## Troubleshooting

### Common Issues

1. **Tab not switching**: Check if the tab selection binding is properly connected
2. **Navigation bar not showing**: Verify the navigation bar is properly configured
3. **Stepper not updating**: Ensure the current step binding is properly managed

### Debug Tips

1. Use `.background(.red)` to visualize navigation elements
2. Check console for navigation-related warnings
3. Verify bindings are properly connected
4. Test navigation flow with different user interactions
