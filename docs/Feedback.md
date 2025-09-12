# Feedback - RRUIComponents

## Overview

Feedback components provide user feedback and status information. The RRUIComponents library includes comprehensive feedback components for alerts, loading states, empty states, and notifications.

## Components

- `RRAlert` - Alert dialogs
- `RREmptyState` - Empty state display
- `RRLoadingIndicator` - Loading states
- `RRSnackbar` - Toast notifications

## RRAlert

A customizable alert dialog component with multiple styles and configurations.

### Basic Usage

```swift
@State private var showAlert = false

RRAlert(
    title: "Success",
    message: "Your changes have been saved.",
    isPresented: $showAlert
)
```

### Initialization

```swift
RRAlert(title: String, message: String?, isPresented: Binding<Bool>)
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.success` | Success alert | Confirmations, success messages |
| `.error` | Error alert | Error messages, failures |
| `.warning` | Warning alert | Warnings, cautions |
| `.info` | Information alert | General information |

### Examples

#### Success Alert
```swift
@State private var showSuccessAlert = false

RRAlert(
    title: "Success",
    message: "Your profile has been updated successfully.",
    isPresented: $showSuccessAlert
)
.style(.success)
```

#### Error Alert
```swift
@State private var showErrorAlert = false

RRAlert(
    title: "Error",
    message: "Failed to save changes. Please try again.",
    isPresented: $showErrorAlert
)
.style(.error)
```

#### Warning Alert
```swift
@State private var showWarningAlert = false

RRAlert(
    title: "Warning",
    message: "This action cannot be undone. Are you sure?",
    isPresented: $showWarningAlert
)
.style(.warning)
```

#### With Custom Actions
```swift
@State private var showConfirmAlert = false

RRAlert(
    title: "Delete Item",
    message: "Are you sure you want to delete this item?",
    isPresented: $showConfirmAlert
)
.primaryAction("Delete", style: .destructive) {
    deleteItem()
}
.secondaryAction("Cancel") {
    showConfirmAlert = false
}
```

#### With Custom Content
```swift
@State private var showCustomAlert = false

RRAlert(
    title: "Custom Alert",
    message: nil,
    isPresented: $showCustomAlert
) {
    VStack {
        Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
            .foregroundColor(.orange)
        
        RRLabel("Custom content goes here")
            .multilineTextAlignment(.center)
    }
    .padding()
}
```

## RREmptyState

An empty state display component for when there's no content to show.

### Basic Usage

```swift
RREmptyState(
    title: "No Items",
    subtitle: "Add some items to get started",
    illustration: Image(systemName: "tray"),
    action: {
        addItem()
    }
)
```

### Initialization

```swift
RREmptyState(
    title: String,
    subtitle: String?,
    illustration: Image?,
    action: (() -> Void)?
)
```

### Examples

#### Basic Empty State
```swift
RREmptyState(
    title: "No Results",
    subtitle: "Try adjusting your search criteria",
    illustration: Image(systemName: "magnifyingglass")
)
```

#### With Action Button
```swift
RREmptyState(
    title: "No Favorites",
    subtitle: "Start adding items to your favorites",
    illustration: Image(systemName: "heart"),
    action: {
        navigateToBrowse()
    }
)
.actionTitle("Browse Items")
```

#### With Custom Illustration
```swift
RREmptyState(
    title: "No Internet Connection",
    subtitle: "Please check your connection and try again",
    illustration: Image("no-internet")
)
.actionTitle("Retry")
```

#### In List View
```swift
struct ItemsListView: View {
    @State private var items: [Item] = []
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                RRLoadingIndicator(style: .spinner, message: "Loading items...")
            } else if items.isEmpty {
                RREmptyState(
                    title: "No Items",
                    subtitle: "Add your first item to get started",
                    illustration: Image(systemName: "plus.circle"),
                    action: {
                        showAddItemSheet = true
                    }
                )
            } else {
                List(items) { item in
                    ItemRowView(item: item)
                }
            }
        }
    }
}
```

## RRLoadingIndicator

A loading indicator component with multiple styles and configurations.

### Basic Usage

```swift
RRLoadingIndicator(style: .spinner, message: "Loading...")
```

### Initialization

```swift
RRLoadingIndicator(style: LoadingStyle)
RRLoadingIndicator(style: LoadingStyle, message: String?)
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.spinner` | Spinning indicator | General loading |
| `.dots` | Animated dots | Light loading |
| `.pulse` | Pulsing indicator | Subtle loading |
| `.wave` | Wave animation | Fun loading |
| `.progress` | Progress bar | Determinate progress |
| `.skeleton` | Skeleton loading | Content placeholders |

### Examples

#### Basic Spinner
```swift
RRLoadingIndicator(style: .spinner)
```

#### With Message
```swift
RRLoadingIndicator(style: .spinner, message: "Loading data...")
    .size(.large)
```

#### Progress Indicator
```swift
@State private var progress: Double = 0.0

RRLoadingIndicator(style: .progress, message: "Uploading...")
    .progress(progress)
    .color(.blue)
```

#### Skeleton Loading
```swift
RRLoadingIndicator(style: .skeleton)
    .skeletonLines(5)
    .skeletonHeight(20)
```

#### Dots Animation
```swift
RRLoadingIndicator(style: .dots)
    .color(.primary)
    .size(.medium)
```

#### Wave Animation
```swift
RRLoadingIndicator(style: .wave)
    .color(.blue)
    .waveCount(3)
```

#### In Full Screen Overlay
```swift
struct LoadingOverlay: View {
    let isLoading: Bool
    let message: String?
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    RRLoadingIndicator(style: .spinner, message: message)
                        .size(.large)
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(12)
            }
        }
    }
}
```

## RRSnackbar

A toast notification component for displaying temporary messages.

### Basic Usage

```swift
@State private var showSnackbar = false

RRSnackbar(message: "Changes saved successfully", isPresented: $showSnackbar)
```

### Initialization

```swift
RRSnackbar(message: String, isPresented: Binding<Bool>)
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.success` | Success notification | Confirmations |
| `.error` | Error notification | Error messages |
| `.warning` | Warning notification | Warnings |
| `.info` | Information notification | General info |

### Examples

#### Basic Snackbar
```swift
@State private var showSnackbar = false

RRSnackbar(message: "Operation completed", isPresented: $showSnackbar)
```

#### Success Snackbar
```swift
@State private var showSuccessSnackbar = false

RRSnackbar(message: "Changes saved successfully", isPresented: $showSuccessSnackbar)
    .style(.success)
    .duration(3)
```

#### Error Snackbar
```swift
@State private var showErrorSnackbar = false

RRSnackbar(message: "Failed to save changes", isPresented: $showErrorSnackbar)
    .style(.error)
    .duration(5)
```

#### With Action
```swift
@State private var showSnackbar = false

RRSnackbar(message: "Item deleted", isPresented: $showSnackbar)
    .action("Undo") {
        undoDelete()
    }
    .duration(5)
```

#### With Custom Styling
```swift
RRSnackbar(message: "Custom message", isPresented: $showSnackbar)
    .background(.blue)
    .foregroundColor(.white)
    .cornerRadius(8)
    .shadow(radius: 4)
```

#### Multiple Snackbars
```swift
class SnackbarManager: ObservableObject {
    @Published var snackbars: [SnackbarItem] = []
    
    func show(_ message: String, style: SnackbarStyle = .info) {
        let snackbar = SnackbarItem(
            id: UUID(),
            message: message,
            style: style
        )
        snackbars.append(snackbar)
        
        // Auto-dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(snackbar.id)
        }
    }
    
    func dismiss(_ id: UUID) {
        snackbars.removeAll { $0.id == id }
    }
}

struct SnackbarContainer: View {
    @StateObject private var snackbarManager = SnackbarManager()
    
    var body: some View {
        ZStack {
            // Your main content
            ContentView()
            
            // Snackbars
            VStack {
                Spacer()
                
                ForEach(snackbarManager.snackbars) { snackbar in
                    RRSnackbar(
                        message: snackbar.message,
                        isPresented: .constant(true)
                    )
                    .style(snackbar.style)
                    .onTapGesture {
                        snackbarManager.dismiss(snackbar.id)
                    }
                }
            }
        }
        .environmentObject(snackbarManager)
    }
}
```

## Best Practices

### Feedback Design

1. **Clear Messages**: Use clear, actionable messages
2. **Appropriate Timing**: Show feedback at the right time
3. **Consistent Styling**: Use consistent feedback styling
4. **Non-Intrusive**: Don't interrupt user flow unnecessarily

### Accessibility

1. **Screen Readers**: Ensure feedback is accessible to screen readers
2. **Focus Management**: Manage focus appropriately during feedback
3. **Clear Labels**: Use clear, descriptive labels
4. **Duration**: Consider appropriate display duration

### Performance

1. **Memory Management**: Properly manage feedback state
2. **Animation Performance**: Use efficient animations
3. **Resource Usage**: Minimize resource usage for loading indicators

## Common Patterns

### Feedback Manager
```swift
class FeedbackManager: ObservableObject {
    @Published var currentAlert: AlertItem?
    @Published var currentSnackbar: SnackbarItem?
    @Published var isLoading = false
    
    func showAlert(_ alert: AlertItem) {
        currentAlert = alert
    }
    
    func showSnackbar(_ snackbar: SnackbarItem) {
        currentSnackbar = snackbar
    }
    
    func showLoading(_ message: String? = nil) {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
}
```

### Async Operation Feedback
```swift
struct AsyncOperationView: View {
    @StateObject private var feedbackManager = FeedbackManager()
    @State private var data: [Item] = []
    
    var body: some View {
        VStack {
            if feedbackManager.isLoading {
                RRLoadingIndicator(style: .spinner, message: "Loading...")
            } else {
                List(data) { item in
                    ItemRowView(item: item)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        feedbackManager.showLoading("Loading items...")
        
        Task {
            do {
                let items = try await fetchItems()
                await MainActor.run {
                    self.data = items
                    feedbackManager.hideLoading()
                }
            } catch {
                await MainActor.run {
                    feedbackManager.hideLoading()
                    feedbackManager.showAlert(AlertItem(
                        title: "Error",
                        message: "Failed to load items: \(error.localizedDescription)",
                        style: .error
                    ))
                }
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Alert not showing**: Check if the binding is properly connected
2. **Snackbar not dismissing**: Verify the duration and dismissal logic
3. **Loading indicator not animating**: Ensure the animation is not blocked

### Debug Tips

1. Use `.background(.red)` to visualize feedback elements
2. Check console for feedback-related warnings
3. Verify bindings are properly connected
4. Test with different user interactions
