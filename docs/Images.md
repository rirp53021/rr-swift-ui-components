# Images - RRUIComponents

## Overview

Image components provide image display and handling capabilities. The RRUIComponents library includes components for asynchronous image loading and avatar display.

## Components

- `RRAsyncImage` - Asynchronous image loading
- `RRAvatar` - User avatar display

## RRAsyncImage

An asynchronous image loading component with placeholder and error states.

### Basic Usage

```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
```

### Initialization

```swift
RRAsyncImage(url: URL?)
RRAsyncImage(url: URL?, placeholder: Image?, errorImage: Image?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `url` | `URL?` | Image URL to load |
| `placeholder` | `Image?` | Placeholder image while loading |
| `errorImage` | `Image?` | Image to show on error |
| `contentMode` | `ContentMode` | How to fit the image |
| `clipped` | `Bool` | Whether to clip to bounds |

### Examples

#### Basic Async Image
```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 200, height: 200)
    .clipped()
```

#### With Placeholder
```swift
RRAsyncImage(
    url: URL(string: "https://example.com/image.jpg"),
    placeholder: Image(systemName: "photo")
)
.frame(width: 200, height: 200)
.clipped()
```

#### With Error Handling
```swift
RRAsyncImage(
    url: URL(string: "https://example.com/image.jpg"),
    placeholder: Image(systemName: "photo"),
    errorImage: Image(systemName: "exclamationmark.triangle")
)
.frame(width: 200, height: 200)
.clipped()
```

#### With Loading State
```swift
@State private var isLoading = false

RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 200, height: 200)
    .clipped()
    .overlay(
        Group {
            if isLoading {
                RRLoadingIndicator(style: .spinner)
                    .background(.regularMaterial)
            }
        }
    )
    .onAppear {
        isLoading = true
    }
    .onDisappear {
        isLoading = false
    }
```

#### With Custom Styling
```swift
RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 200, height: 200)
    .clipped()
    .cornerRadius(12)
    .shadow(radius: 4)
    .overlay(
        RoundedRectangle(cornerRadius: 12)
            .stroke(.primary, lineWidth: 2)
    )
```

#### In Card
```swift
RRCard {
    VStack(spacing: 0) {
        RRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
            .frame(height: 200)
            .clipped()
        
        VStack(alignment: .leading, spacing: 8) {
            RRLabel("Image Title")
                .style(.headline)
            
            RRLabel("Image description")
                .style(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
```

## RRAvatar

A user avatar display component with multiple sizes and styles.

### Basic Usage

```swift
RRAvatar(image: Image("user-photo"))
```

### Initialization

```swift
RRAvatar(image: Image?)
RRAvatar(initials: String)
RRAvatar(image: Image?, fallback: String)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `image` | `Image?` | Avatar image |
| `initials` | `String` | Initials to display |
| `fallback` | `String` | Fallback text if image fails |

### Sizes

| Size | Description | Dimensions |
|------|-------------|------------|
| `.small` | Small avatar | 32x32pt |
| `.medium` | Medium avatar (default) | 48x48pt |
| `.large` | Large avatar | 64x64pt |
| `.xlarge` | Extra large avatar | 96x96pt |

### Examples

#### Basic Avatar
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
```

#### Avatar with Initials
```swift
RRAvatar(initials: "JD")
    .size(.medium)
    .background(.blue)
    .foregroundColor(.white)
```

#### Avatar with Fallback
```swift
RRAvatar(
    image: Image("user-photo"),
    fallback: "User"
)
.size(.large)
```

#### Circular Avatar
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
    .style(.circle)
    .border(.primary, width: 2)
```

#### Square Avatar
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
    .style(.square)
    .cornerRadius(8)
```

#### Avatar with Badge
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
    .overlay(
        RRBadge("Online")
            .style(.success)
            .size(.small),
        alignment: .bottomTrailing
    )
```

#### Avatar Group
```swift
HStack(spacing: -8) {
    RRAvatar(initials: "A")
        .size(.small)
        .background(.blue)
        .foregroundColor(.white)
        .border(.white, width: 2)
    
    RRAvatar(initials: "B")
        .size(.small)
        .background(.green)
        .foregroundColor(.white)
        .border(.white, width: 2)
    
    RRAvatar(initials: "C")
        .size(.small)
        .background(.orange)
        .foregroundColor(.white)
        .border(.white, width: 2)
    
    RRAvatar(initials: "+3")
        .size(.small)
        .background(.gray)
        .foregroundColor(.white)
        .border(.white, width: 2)
}
```

#### Avatar with Status
```swift
RRAvatar(image: Image("user-photo"))
    .size(.large)
    .overlay(
        Circle()
            .fill(.green)
            .frame(width: 16, height: 16),
        alignment: .bottomTrailing
    )
```

#### Avatar in List
```swift
HStack {
    RRAvatar(image: Image("user-photo"))
        .size(.medium)
    
    VStack(alignment: .leading) {
        RRLabel("John Doe")
            .style(.headline)
        
        RRLabel("Online")
            .style(.caption)
            .foregroundColor(.green)
    }
    
    Spacer()
    
    RRLabel("2 min ago")
        .style(.caption)
        .foregroundColor(.secondary)
}
```

## Best Practices

### Image Loading

1. **Placeholders**: Always provide meaningful placeholders
2. **Error Handling**: Handle loading errors gracefully
3. **Caching**: Use appropriate caching strategies
4. **Performance**: Optimize image sizes and formats

### Avatar Design

1. **Consistent Sizing**: Use consistent avatar sizes throughout your app
2. **Fallbacks**: Always provide fallback options
3. **Accessibility**: Ensure avatars are accessible to screen readers
4. **Status Indicators**: Use status indicators appropriately

### Performance

1. **Lazy Loading**: Use lazy loading for large image lists
2. **Memory Management**: Properly manage image memory
3. **Caching**: Implement appropriate caching strategies
4. **Compression**: Use appropriate image compression

## Common Patterns

### Image Gallery
```swift
struct ImageGallery: View {
    let images: [URL]
    @State private var selectedImage: URL?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(images, id: \.self) { url in
                    RRAsyncImage(url: url)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedImage = url
                        }
                }
            }
            .padding()
        }
        .sheet(item: $selectedImage) { url in
            ImageDetailView(url: url)
        }
    }
}
```

### User Profile
```swift
struct UserProfileView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            RRAvatar(image: Image(user.photo))
                .size(.xlarge)
                .overlay(
                    Circle()
                        .fill(.green)
                        .frame(width: 20, height: 20),
                    alignment: .bottomTrailing
                )
            
            VStack(spacing: 8) {
                RRLabel(user.name)
                    .style(.title)
                
                RRLabel(user.email)
                    .style(.body)
                    .foregroundColor(.secondary)
                
                RRBadge(user.status)
                    .style(.success)
            }
        }
        .padding()
    }
}
```

### Image with Loading State
```swift
struct LoadingImageView: View {
    let url: URL
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        ZStack {
            RRAsyncImage(
                url: url,
                placeholder: Image(systemName: "photo"),
                errorImage: Image(systemName: "exclamationmark.triangle")
            )
            .frame(width: 200, height: 200)
            .clipped()
            .cornerRadius(12)
            
            if isLoading {
                RRLoadingIndicator(style: .spinner)
                    .background(.regularMaterial)
                    .cornerRadius(12)
            }
        }
        .onAppear {
            isLoading = true
        }
        .onDisappear {
            isLoading = false
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Image not loading**: Check URL validity and network connectivity
2. **Placeholder not showing**: Verify placeholder image is properly set
3. **Avatar not displaying**: Check if image or initials are properly provided

### Debug Tips

1. Use `.background(.red)` to visualize image bounds
2. Check console for image loading errors
3. Verify URL validity and accessibility
4. Test with different image formats and sizes
