# Overlay - RRUIComponents

## Overview

Overlay components provide contextual information and interactions that appear above other content. The RRUIComponents library includes components for tooltips, popovers, context menus, and generic overlays.

## Components

- `RRTooltip` - Tooltip display
- `RRPopover` - Popover display
- `RRContextMenu` - Context menu
- `RROverlay` - Generic overlay

## RRTooltip

A tooltip component for displaying contextual information when hovering or focusing on elements.

### Basic Usage

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
```

### Initialization

```swift
RRTooltip(content: () -> AnyView, tooltip: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `content` | `() -> AnyView` | Content that triggers the tooltip |
| `tooltip` | `() -> AnyView` | Tooltip content |
| `position` | `TooltipPosition` | Tooltip position |
| `delay` | `Double` | Delay before showing tooltip |
| `duration` | `Double` | How long to show tooltip |

### Examples

#### Basic Tooltip
```swift
RRTooltip(
    content: {
        RRButton("Help") { }
            .style(.ghost)
    },
    tooltip: {
        RRLabel("Click for help")
            .padding()
            .background(.surface)
            .cornerRadius(8)
    }
)
```

#### With Custom Position
```swift
RRTooltip(
    content: {
        RRButton("Info") { }
            .style(.ghost)
    },
    tooltip: {
        VStack(alignment: .leading, spacing: 4) {
            RRLabel("Information")
                .style(.headline)
            RRLabel("This button provides additional information")
                .style(.body)
        }
        .padding()
        .background(.surface)
        .cornerRadius(8)
    }
)
.position(.top)
.delay(0.5)
```

#### With Custom Styling
```swift
RRTooltip(
    content: {
        RRButton("Custom") { }
            .style(.ghost)
    },
    tooltip: {
        RRLabel("Custom styled tooltip")
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
)
.position(.right)
.duration(3.0)
```

#### In Form
```swift
HStack {
    RRLabel("Password")
        .style(.body)
    
    RRTooltip(
        content: {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.secondary)
        },
        tooltip: {
            VStack(alignment: .leading, spacing: 4) {
                RRLabel("Password Requirements")
                    .style(.headline)
                RRLabel("• At least 8 characters")
                RRLabel("• Include uppercase and lowercase")
                RRLabel("• Include numbers and symbols")
            }
            .padding()
            .background(.surface)
            .cornerRadius(8)
        }
    )
    
    Spacer()
    
    RRTextField("Password", text: $password)
        .isSecure(true)
}
```

## RRPopover

A popover component for displaying content in a floating container.

### Basic Usage

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

### Initialization

```swift
RRPopover(isPresented: Binding<Bool>, content: () -> AnyView, popover: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `isPresented` | `Binding<Bool>` | Whether popover is presented |
| `content` | `() -> AnyView` | Content that triggers the popover |
| `popover` | `() -> AnyView` | Popover content |
| `attachmentAnchor` | `PopoverAttachmentAnchor` | Attachment anchor |
| `arrowEdge` | `Edge` | Arrow edge position |

### Examples

#### Basic Popover
```swift
@State private var showPopover = false

RRPopover(isPresented: $showPopover) {
    RRButton("Show Popover") {
        showPopover = true
    }
    .style(.primary)
} popover: {
    VStack(spacing: 16) {
        RRLabel("Popover Title")
            .style(.headline)
        
        RRLabel("This is popover content")
            .style(.body)
        
        HStack {
            RRButton("Cancel") {
                showPopover = false
            }
            .style(.ghost)
            
            RRButton("OK") {
                // Action
                showPopover = false
            }
            .style(.primary)
        }
    }
    .padding()
}
```

#### With Custom Attachment
```swift
@State private var showPopover = false

RRPopover(isPresented: $showPopover) {
    RRButton("Show Popover") {
        showPopover = true
    }
    .style(.primary)
} popover: {
    VStack {
        RRLabel("Custom Popover")
            .style(.headline)
        
        RRLabel("This popover has custom attachment")
            .style(.body)
    }
    .padding()
}
.attachmentAnchor(.point(.top))
.arrowEdge(.top)
```

#### In Settings
```swift
HStack {
    RRLabel("Theme")
        .style(.body)
    
    Spacer()
    
    RRPopover(isPresented: $showThemePopover) {
        RRButton("Current Theme") {
            showThemePopover = true
        }
        .style(.ghost)
    } popover: {
        VStack(alignment: .leading, spacing: 12) {
            RRLabel("Choose Theme")
                .style(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                RRButton("Light") {
                    setTheme(.light)
                    showThemePopover = false
                }
                .style(.ghost)
                
                RRButton("Dark") {
                    setTheme(.dark)
                    showThemePopover = false
                }
                .style(.ghost)
                
                RRButton("Auto") {
                    setTheme(.auto)
                    showThemePopover = false
                }
                .style(.ghost)
            }
        }
        .padding()
    }
}
```

## RRContextMenu

A context menu component for displaying contextual actions.

### Basic Usage

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

### Initialization

```swift
RRContextMenu(content: () -> AnyView, menuItems: [ContextMenuItem])
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `content` | `() -> AnyView` | Content that triggers the context menu |
| `menuItems` | `[ContextMenuItem]` | Array of menu items |
| `style` | `ContextMenuStyle` | Menu style |
| `animation` | `Animation` | Menu animation |

### Examples

#### Basic Context Menu
```swift
RRContextMenu {
    RRCard {
        VStack {
            RRLabel("Item Title")
                .style(.headline)
            RRLabel("Item description")
                .style(.body)
        }
        .padding()
    }
} menuItems: [
    ContextMenuItem("Edit", icon: "pencil") {
        editItem()
    },
    ContextMenuItem("Share", icon: "square.and.arrow.up") {
        shareItem()
    },
    ContextMenuItem("Delete", icon: "trash", isDestructive: true) {
        deleteItem()
    }
]
```

#### With Custom Styling
```swift
RRContextMenu {
    RRCard {
        RRLabel("Styled Context Menu")
    }
} menuItems: [
    ContextMenuItem("Action 1", icon: "star") { },
    ContextMenuItem("Action 2", icon: "heart") { },
    ContextMenuItem("Action 3", icon: "bookmark") { }
]
.style(.custom)
.animation(.easeInOut)
```

#### In List
```swift
List(items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
    .contextMenu {
        RRContextMenu {
            EmptyView()
        } menuItems: [
            ContextMenuItem("Edit", icon: "pencil") {
                editItem(item)
            },
            ContextMenuItem("Duplicate", icon: "doc.on.doc") {
                duplicateItem(item)
            },
            ContextMenuItem("Delete", icon: "trash", isDestructive: true) {
                deleteItem(item)
            }
        ]
    }
}
```

#### With Conditional Items
```swift
RRContextMenu {
    RRCard {
        RRLabel("Conditional Menu")
    }
} menuItems: {
    var items: [ContextMenuItem] = [
        ContextMenuItem("Always Available", icon: "star") { }
    ]
    
    if item.isEditable {
        items.append(ContextMenuItem("Edit", icon: "pencil") {
            editItem()
        })
    }
    
    if item.isShareable {
        items.append(ContextMenuItem("Share", icon: "square.and.arrow.up") {
            shareItem()
        })
    }
    
    if item.isDeletable {
        items.append(ContextMenuItem("Delete", icon: "trash", isDestructive: true) {
            deleteItem()
        })
    }
    
    return items
}()
```

## RROverlay

A generic overlay component for displaying content over other views.

### Basic Usage

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

### Initialization

```swift
RROverlay(isPresented: Binding<Bool>, content: () -> AnyView)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `isPresented` | `Binding<Bool>` | Whether overlay is presented |
| `content` | `() -> AnyView` | Overlay content |
| `background` | `Color` | Overlay background color |
| `animation` | `Animation` | Overlay animation |
| `dismissOnTap` | `Bool` | Dismiss on background tap |

### Examples

#### Basic Overlay
```swift
@State private var showOverlay = false

RROverlay(isPresented: $showOverlay) {
    VStack(spacing: 20) {
        RRLabel("Overlay Title")
            .style(.headline)
        
        RRLabel("This is overlay content")
            .style(.body)
        
        RRButton("Close") {
            showOverlay = false
        }
        .style(.primary)
    }
    .padding()
    .background(.surface)
    .cornerRadius(12)
}
```

#### With Custom Background
```swift
RROverlay(isPresented: $showOverlay) {
    VStack {
        RRLabel("Custom Overlay")
            .style(.title)
        
        RRLabel("With custom background")
            .style(.body)
    }
    .padding()
    .background(.blue.opacity(0.9))
    .foregroundColor(.white)
    .cornerRadius(16)
}
.background(.black.opacity(0.5))
.dismissOnTap(true)
```

#### Loading Overlay
```swift
@State private var isLoading = false

ZStack {
    // Main content
    VStack {
        RRLabel("Main Content")
        RRButton("Start Loading") {
            isLoading = true
        }
    }
    
    // Loading overlay
    RROverlay(isPresented: $isLoading) {
        VStack(spacing: 20) {
            RRLoadingIndicator(style: .spinner, message: "Loading...")
                .size(.large)
            
            RRButton("Cancel") {
                isLoading = false
            }
            .style(.ghost)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}
```

#### Modal Overlay
```swift
@State private var showModal = false

RROverlay(isPresented: $showModal) {
    VStack(spacing: 20) {
        HStack {
            RRLabel("Modal Title")
                .style(.headline)
            
            Spacer()
            
            Button("×") {
                showModal = false
            }
            .font(.title2)
        }
        
        RRLabel("Modal content goes here")
            .style(.body)
        
        HStack {
            RRButton("Cancel") {
                showModal = false
            }
            .style(.ghost)
            
            Spacer()
            
            RRButton("Save") {
                saveChanges()
                showModal = false
            }
            .style(.primary)
        }
    }
    .padding()
    .background(.surface)
    .cornerRadius(16)
    .shadow(radius: 8)
}
.background(.black.opacity(0.3))
.dismissOnTap(true)
```

## Best Practices

### Overlay Design

1. **Clear Purpose**: Make overlay purpose clear
2. **Appropriate Size**: Use appropriate overlay sizes
3. **Easy Dismissal**: Provide clear ways to dismiss
4. **Non-Intrusive**: Don't interrupt user flow unnecessarily

### Accessibility

1. **Screen Readers**: Ensure overlays are accessible
2. **Focus Management**: Manage focus appropriately
3. **Keyboard Navigation**: Support keyboard navigation
4. **Clear Labels**: Use clear, descriptive labels

### Performance

1. **Memory Management**: Properly manage overlay state
2. **Animation Performance**: Use efficient animations
3. **Rendering**: Minimize unnecessary re-renders

## Common Patterns

### Overlay Manager
```swift
class OverlayManager: ObservableObject {
    @Published var currentOverlay: OverlayType?
    
    func present(_ overlay: OverlayType) {
        currentOverlay = overlay
    }
    
    func dismiss() {
        currentOverlay = nil
    }
}

enum OverlayType {
    case loading
    case error(String)
    case success(String)
    case confirmation(String, () -> Void)
}
```

### Context Menu with State
```swift
struct ItemContextMenu: View {
    let item: Item
    @State private var isEditing = false
    @State private var isSharing = false
    
    var body: some View {
        RRContextMenu {
            ItemRowView(item: item)
        } menuItems: [
            ContextMenuItem("Edit", icon: "pencil") {
                isEditing = true
            },
            ContextMenuItem("Share", icon: "square.and.arrow.up") {
                isSharing = true
            },
            ContextMenuItem("Delete", icon: "trash", isDestructive: true) {
                deleteItem()
            }
        ]
        .sheet(isPresented: $isEditing) {
            EditItemView(item: item)
        }
        .sheet(isPresented: $isSharing) {
            ShareItemView(item: item)
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Overlay not showing**: Check if the binding is properly connected
2. **Context menu not working**: Verify menu items are properly configured
3. **Tooltip not appearing**: Check tooltip position and delay settings

### Debug Tips

1. Use `.background(.red)` to visualize overlay bounds
2. Check console for overlay-related warnings
3. Verify bindings are properly connected
4. Test with different user interactions
