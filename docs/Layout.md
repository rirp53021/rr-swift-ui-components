# Layout - RRUIComponents

## Overview

Layout components provide structure and spacing for content organization. The RRUIComponents library includes flexible layout components for containers, dividers, sections, and spacers.

## Components

- `RRContainer` - Content container
- `RRDivider` - Section dividers
- `RRSection` - Content sections
- `RRSpacer` - Flexible spacers

## RRContainer

A content container component with flexible constraints and styling options.

### Basic Usage

```swift
RRContainer {
    VStack {
        RRLabel("Content")
    }
}
```

### Initialization

```swift
RRContainer(content: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `maxWidth` | `ContainerMaxWidth` | Maximum width constraint |
| `padding` | `CGFloat` | Internal padding |
| `background` | `Color` | Background color |
| `cornerRadius` | `CGFloat` | Corner radius |
| `shadow` | `ShadowConfiguration` | Shadow configuration |

### Examples

#### Basic Container
```swift
RRContainer {
    VStack {
        RRLabel("Container Content")
            .style(.headline)
        
        RRLabel("This is a basic container")
            .style(.body)
    }
}
```

#### With Max Width
```swift
RRContainer {
    VStack {
        RRLabel("Centered Content")
            .style(.title)
        
        RRLabel("This container has a maximum width")
            .style(.body)
    }
}
.maxWidth(.medium)
```

#### With Custom Styling
```swift
RRContainer {
    VStack {
        RRLabel("Styled Container")
            .style(.headline)
        
        RRLabel("Custom background and shadow")
            .style(.body)
    }
}
.background(.blue.opacity(0.1))
.cornerRadius(16)
.shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
```

#### With Padding
```swift
RRContainer {
    VStack {
        RRLabel("Padded Content")
            .style(.headline)
        
        RRLabel("This container has custom padding")
            .style(.body)
    }
}
.padding(.large)
.background(.surface)
```

#### Responsive Container
```swift
struct ResponsiveContainer: View {
    @State private var containerWidth: CGFloat = 0
    
    var body: some View {
        RRContainer {
            VStack {
                RRLabel("Responsive Container")
                    .style(.headline)
                
                RRLabel("Width: \(Int(containerWidth))pt")
                    .style(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .maxWidth(.large)
        .background(.surface)
        .onAppear {
            containerWidth = UIScreen.main.bounds.width
        }
    }
}
```

## RRDivider

A section divider component for separating content sections.

### Basic Usage

```swift
VStack {
    RRLabel("Section 1")
    RRDivider()
    RRLabel("Section 2")
}
```

### Initialization

```swift
RRDivider()
RRDivider(orientation: DividerOrientation)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `orientation` | `DividerOrientation` | Horizontal or vertical |
| `color` | `Color` | Divider color |
| `thickness` | `CGFloat` | Divider thickness |
| `spacing` | `CGFloat` | Spacing around divider |

### Examples

#### Basic Divider
```swift
VStack {
    RRLabel("Section 1")
    RRDivider()
    RRLabel("Section 2")
}
```

#### Vertical Divider
```swift
HStack {
    RRLabel("Left")
    RRDivider(orientation: .vertical)
    RRLabel("Right")
}
```

#### Styled Divider
```swift
VStack {
    RRLabel("Section 1")
    RRDivider()
        .color(.primary)
        .thickness(2)
    
    RRLabel("Section 2")
}
```

#### With Spacing
```swift
VStack {
    RRLabel("Section 1")
    
    RRDivider()
        .spacing(.medium)
    
    RRLabel("Section 2")
}
```

#### In List
```swift
List {
    Section("Personal") {
        RRRowItem(
            title: "Profile",
            subtitle: "Manage your account",
            icon: "person.circle"
        )
        
        RRRowItem(
            title: "Privacy",
            subtitle: "Control your privacy",
            icon: "lock.circle"
        )
    }
    
    RRDivider()
        .listRowInsets(EdgeInsets())
    
    Section("Preferences") {
        RRRowItem(
            title: "Notifications",
            subtitle: "Manage notifications",
            icon: "bell"
        )
        
        RRRowItem(
            title: "Theme",
            subtitle: "Choose your theme",
            icon: "paintbrush"
        )
    }
}
```

## RRSection

A content section component for organizing content into logical groups.

### Basic Usage

```swift
RRSection(title: "Settings") {
    VStack {
        RRToggle("Notifications", isOn: $notificationsEnabled)
        RRToggle("Dark Mode", isOn: $darkModeEnabled)
    }
}
```

### Initialization

```swift
RRSection(title: String?, content: () -> AnyView)
RRSection(title: String?, subtitle: String?, content: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String?` | Section title |
| `subtitle` | `String?` | Section subtitle |
| `content` | `() -> AnyView` | Section content |
| `headerStyle` | `SectionHeaderStyle` | Header style |
| `footer` | `AnyView?` | Optional footer content |

### Examples

#### Basic Section
```swift
RRSection(title: "Account") {
    VStack(alignment: .leading, spacing: 16) {
        RRRowItem(
            title: "Profile",
            subtitle: "Manage your profile",
            icon: "person.circle"
        )
        
        RRRowItem(
            title: "Security",
            subtitle: "Manage your security",
            icon: "lock.circle"
        )
    }
}
```

#### With Subtitle
```swift
RRSection(title: "Preferences", subtitle: "Customize your experience") {
    VStack(alignment: .leading, spacing: 16) {
        RRToggle("Notifications", isOn: $notificationsEnabled)
        RRToggle("Dark Mode", isOn: $darkModeEnabled)
        RRToggle("Auto-save", isOn: $autoSaveEnabled)
    }
}
```

#### With Footer
```swift
RRSection(title: "Storage", subtitle: "Manage your storage") {
    VStack(alignment: .leading, spacing: 16) {
        HStack {
            RRLabel("Used Space")
                .style(.body)
            
            Spacer()
            
            RRLabel("2.1 GB of 5 GB")
                .style(.caption)
                .foregroundColor(.secondary)
        }
        
        ProgressView(value: 0.42)
            .progressViewStyle(LinearProgressViewStyle())
    }
} footer: {
    HStack {
        RRButton("Manage Storage") {
            showStorageManagement()
        }
        .style(.ghost)
        
        Spacer()
        
        RRButton("Upgrade") {
            showUpgradeOptions()
        }
        .style(.primary)
    }
}
```

#### With Custom Header
```swift
RRSection(title: "Custom Section") {
    VStack {
        RRLabel("Section content")
    }
}
.headerStyle(.custom) {
    HStack {
        Image(systemName: "star.fill")
            .foregroundColor(.yellow)
        
        RRLabel("Featured Section")
            .style(.headline)
        
        Spacer()
        
        RRBadge("New")
            .style(.success)
    }
}
```

#### In Settings View
```swift
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoSaveEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                RRSection(title: "Notifications", subtitle: "Manage your notifications") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRToggle("Push Notifications", isOn: $notificationsEnabled)
                        RRToggle("Email Notifications", isOn: $emailNotificationsEnabled)
                        RRToggle("SMS Notifications", isOn: $smsNotificationsEnabled)
                    }
                }
                
                RRSection(title: "Appearance", subtitle: "Customize your app's appearance") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRToggle("Dark Mode", isOn: $darkModeEnabled)
                        RRToggle("Auto Theme", isOn: $autoThemeEnabled)
                    }
                }
                
                RRSection(title: "Data", subtitle: "Manage your data and storage") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRRowItem(
                            title: "Storage",
                            subtitle: "2.1 GB used of 5 GB",
                            icon: "internaldrive"
                        )
                        
                        RRRowItem(
                            title: "Backup",
                            subtitle: "Last backup: 2 hours ago",
                            icon: "icloud"
                        )
                    }
                }
            }
            .padding()
        }
    }
}
```

## RRSpacer

A flexible spacer component for creating space between elements.

### Basic Usage

```swift
HStack {
    RRLabel("Left")
    RRSpacer()
    RRLabel("Right")
}
```

### Initialization

```swift
RRSpacer()
RRSpacer(minLength: CGFloat?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `minLength` | `CGFloat?` | Minimum length |
| `maxLength` | `CGFloat?` | Maximum length |
| `priority` | `SpacerPriority` | Spacer priority |

### Examples

#### Basic Spacer
```swift
HStack {
    RRLabel("Left")
    RRSpacer()
    RRLabel("Right")
}
```

#### With Minimum Length
```swift
HStack {
    RRLabel("Left")
    RRSpacer(minLength: 20)
    RRLabel("Right")
}
```

#### With Maximum Length
```swift
HStack {
    RRLabel("Left")
    RRSpacer()
        .maxLength(100)
    RRLabel("Right")
}
```

#### Vertical Spacer
```swift
VStack {
    RRLabel("Top")
    RRSpacer()
    RRLabel("Bottom")
}
```

#### In Navigation
```swift
HStack {
    RRButton("Back") {
        dismiss()
    }
    .style(.ghost)
    
    RRSpacer()
    
    RRLabel("Title")
        .style(.headline)
    
    RRSpacer()
    
    RRButton("Done") {
        save()
    }
    .style(.primary)
}
```

#### In Card Layout
```swift
RRCard {
    VStack(alignment: .leading, spacing: 12) {
        RRLabel("Card Title")
            .style(.headline)
        
        RRLabel("Card description goes here")
            .style(.body)
            .foregroundColor(.secondary)
        
        RRSpacer(minLength: 8)
        
        HStack {
            RRLabel("$99.99")
                .style(.title)
                .foregroundColor(.primary)
            
            Spacer()
            
            RRButton("Add to Cart") {
                addToCart()
            }
            .style(.primary)
            .size(.small)
        }
    }
    .padding()
}
```

## Best Practices

### Layout Design

1. **Consistent Spacing**: Use consistent spacing throughout your app
2. **Responsive Design**: Consider different screen sizes
3. **Visual Hierarchy**: Use spacing to create clear hierarchy
4. **Content Organization**: Group related content together

### Performance

1. **Efficient Rendering**: Minimize unnecessary re-renders
2. **Lazy Loading**: Use lazy loading for large content
3. **Memory Management**: Properly manage layout state

### Accessibility

1. **Screen Readers**: Ensure layout is accessible to screen readers
2. **Focus Management**: Manage focus appropriately
3. **Dynamic Type**: Support dynamic type sizing

## Common Patterns

### Responsive Layout
```swift
struct ResponsiveLayout: View {
    @State private var isCompact = false
    
    var body: some View {
        Group {
            if isCompact {
                compactLayout
            } else {
                regularLayout
            }
        }
        .onAppear {
            updateLayout()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            updateLayout()
        }
    }
    
    private var compactLayout: some View {
        VStack {
            RRLabel("Compact Layout")
            RRSpacer()
        }
    }
    
    private var regularLayout: some View {
        HStack {
            RRLabel("Regular Layout")
            RRSpacer()
        }
    }
    
    private func updateLayout() {
        isCompact = UIScreen.main.bounds.width < 768
    }
}
```

### Sectioned Content
```swift
struct SectionedContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                RRSection(title: "Personal Information") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRTextField("First Name", text: $firstName)
                        RRTextField("Last Name", text: $lastName)
                        RRTextField("Email", text: $email)
                    }
                }
                
                RRDivider()
                
                RRSection(title: "Preferences") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRToggle("Notifications", isOn: $notificationsEnabled)
                        RRToggle("Dark Mode", isOn: $darkModeEnabled)
                    }
                }
                
                RRDivider()
                
                RRSection(title: "Account Actions") {
                    VStack(alignment: .leading, spacing: 16) {
                        RRButton("Change Password") {
                            changePassword()
                        }
                        .style(.ghost)
                        
                        RRButton("Delete Account") {
                            deleteAccount()
                        }
                        .style(.ghost)
                        .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Spacing not working**: Check if spacers are properly configured
2. **Container not sizing**: Verify max width constraints
3. **Divider not showing**: Check divider color and thickness

### Debug Tips

1. Use `.background(.red)` to visualize layout bounds
2. Check console for layout warnings
3. Verify spacing and padding values
4. Test with different content sizes
