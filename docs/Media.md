# Media - RRUIComponents

## Overview

Media components provide functionality for displaying and interacting with various media types. The RRUIComponents library includes components for video playback, image galleries, and media viewing.

## Components

- `RRVideoPlayer` - Video player
- `RRImageGallery` - Image gallery
- `RRMediaViewer` - Comprehensive media viewer

## RRVideoPlayer

A customizable video player component with controls and theming support.

### Basic Usage

```swift
RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
```

### Initialization

```swift
RRVideoPlayer(url: URL?)
RRVideoPlayer(url: URL?, poster: Image?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `url` | `URL?` | Video URL |
| `poster` | `Image?` | Poster image |
| `controls` | `Bool` | Show video controls |
| `autoplay` | `Bool` | Auto-play video |
| `looping` | `Bool` | Loop video |
| `muted` | `Bool` | Mute video by default |

### Examples

#### Basic Video Player
```swift
RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
    .frame(height: 200)
    .cornerRadius(12)
```

#### With Poster Image
```swift
RRVideoPlayer(
    url: URL(string: "https://example.com/video.mp4"),
    poster: Image("video-poster")
)
.frame(height: 200)
.cornerRadius(12)
```

#### With Custom Controls
```swift
RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
    .frame(height: 200)
    .controls(true)
    .autoplay(false)
    .looping(false)
    .muted(false)
```

#### In Card
```swift
RRCard {
    VStack(spacing: 0) {
        RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
            .frame(height: 200)
            .clipped()
        
        VStack(alignment: .leading, spacing: 8) {
            RRLabel("Video Title")
                .style(.headline)
            
            RRLabel("Video description goes here")
                .style(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
```

#### With Custom Styling
```swift
RRVideoPlayer(url: URL(string: "https://example.com/video.mp4"))
    .frame(height: 200)
    .cornerRadius(16)
    .shadow(radius: 8)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(.primary, lineWidth: 2)
    )
```

## RRImageGallery

An image gallery component with multiple layouts and interactive features.

### Basic Usage

```swift
@State private var selectedIndex = 0

RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
```

### Initialization

```swift
RRImageGallery(images: [Image], selectedIndex: Binding<Int>)
RRImageGallery(images: [Image], selectedIndex: Binding<Int>, layout: GalleryLayout)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `images` | `[Image]` | Array of images |
| `selectedIndex` | `Binding<Int>` | Currently selected image index |
| `layout` | `GalleryLayout` | Gallery layout style |
| `showIndicators` | `Bool` | Show page indicators |
| `autoPlay` | `Bool` | Auto-play gallery |

### Layouts

| Layout | Description | Use Case |
|--------|-------------|----------|
| `.carousel` | Carousel layout | Featured images |
| `.grid` | Grid layout | Image collections |
| `.stack` | Stack layout | Overlapping images |

### Examples

#### Basic Image Gallery
```swift
@State private var selectedIndex = 0

RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.frame(height: 200)
```

#### Carousel Layout
```swift
RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.layout(.carousel)
.showIndicators(true)
.autoPlay(true)
.frame(height: 200)
```

#### Grid Layout
```swift
RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.layout(.grid)
.showIndicators(false)
.frame(height: 300)
```

#### Stack Layout
```swift
RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.layout(.stack)
.showIndicators(true)
.frame(height: 200)
```

#### With Custom Styling
```swift
RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.layout(.carousel)
.showIndicators(true)
.frame(height: 200)
.cornerRadius(12)
.shadow(radius: 4)
```

#### In Full Screen
```swift
@State private var showFullScreen = false

RRImageGallery(
    images: galleryImages,
    selectedIndex: $selectedIndex
)
.frame(height: 200)
.onTapGesture {
    showFullScreen = true
}
.fullScreenCover(isPresented: $showFullScreen) {
    RRImageGallery(
        images: galleryImages,
        selectedIndex: $selectedIndex
    )
    .layout(.carousel)
    .showIndicators(true)
}
```

## RRMediaViewer

A comprehensive media viewer for images, videos, audio, and documents.

### Basic Usage

```swift
@State private var selectedIndex = 0

RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
```

### Initialization

```swift
RRMediaViewer(media: [MediaItem], selectedIndex: Binding<Int>)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `media` | `[MediaItem]` | Array of media items |
| `selectedIndex` | `Binding<Int>` | Currently selected media index |
| `style` | `MediaViewerStyle` | Viewer style |
| `showControls` | `Bool` | Show media controls |
| `allowZoom` | `Bool` | Allow zooming |

### Media Types

| Type | Description | Supported Formats |
|-------|-------------|-------------------|
| `.image` | Image media | JPEG, PNG, GIF, WebP |
| `.video` | Video media | MP4, MOV, AVI |
| `.audio` | Audio media | MP3, AAC, WAV |
| `.document` | Document media | PDF, DOC, TXT |

### Examples

#### Basic Media Viewer
```swift
@State private var selectedIndex = 0

RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
```

#### With Custom Style
```swift
RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
.style(.fullScreen)
.showControls(true)
.allowZoom(true)
```

#### Mixed Media Types
```swift
let mediaItems: [MediaItem] = [
    MediaItem(type: .image, url: URL(string: "https://example.com/image1.jpg")),
    MediaItem(type: .video, url: URL(string: "https://example.com/video1.mp4")),
    MediaItem(type: .audio, url: URL(string: "https://example.com/audio1.mp3")),
    MediaItem(type: .document, url: URL(string: "https://example.com/document1.pdf"))
]

RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
```

#### With Thumbnails
```swift
RRMediaViewer(
    media: mediaItems,
    selectedIndex: $selectedIndex
)
.showThumbnails(true)
.thumbnailSize(.small)
```

#### In Modal
```swift
@State private var showMediaViewer = false
@State private var selectedIndex = 0

VStack {
    RRButton("View Media") {
        showMediaViewer = true
    }
    .style(.primary)
}
.sheet(isPresented: $showMediaViewer) {
    RRMediaViewer(
        media: mediaItems,
        selectedIndex: $selectedIndex
    )
    .style(.fullScreen)
}
```

## Best Practices

### Media Handling

1. **Format Support**: Ensure supported media formats
2. **Loading States**: Show appropriate loading states
3. **Error Handling**: Handle media loading errors gracefully
4. **Performance**: Optimize media loading and caching

### User Experience

1. **Controls**: Provide intuitive media controls
2. **Navigation**: Easy navigation between media items
3. **Accessibility**: Ensure media is accessible
4. **Responsive**: Support different screen sizes

### Performance

1. **Lazy Loading**: Use lazy loading for large media collections
2. **Caching**: Implement appropriate caching strategies
3. **Memory Management**: Properly manage media memory
4. **Compression**: Use appropriate media compression

## Common Patterns

### Media Gallery with Thumbnails
```swift
struct MediaGalleryView: View {
    @State private var selectedIndex = 0
    @State private var showFullScreen = false
    
    let mediaItems: [MediaItem]
    
    var body: some View {
        VStack {
            // Thumbnail strip
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(mediaItems.enumerated()), id: \.offset) { index, item in
                        ThumbnailView(item: item, isSelected: index == selectedIndex)
                            .onTapGesture {
                                selectedIndex = index
                            }
                    }
                }
                .padding()
            }
            
            // Main media viewer
            RRMediaViewer(
                media: mediaItems,
                selectedIndex: $selectedIndex
            )
            .frame(height: 300)
            .onTapGesture {
                showFullScreen = true
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            RRMediaViewer(
                media: mediaItems,
                selectedIndex: $selectedIndex
            )
            .style(.fullScreen)
        }
    }
}
```

### Video Player with Custom Controls
```swift
struct CustomVideoPlayer: View {
    let videoURL: URL
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    
    var body: some View {
        VStack {
            RRVideoPlayer(url: videoURL)
                .frame(height: 200)
                .onPlaybackStatusChanged { status in
                    isPlaying = status.isPlaying
                    currentTime = status.currentTime
                    duration = status.duration
                }
            
            // Custom controls
            HStack {
                RRButton(isPlaying ? "Pause" : "Play") {
                    togglePlayback()
                }
                .style(.ghost)
                
                RRLabel(formatTime(currentTime))
                    .style(.caption)
                
                Slider(value: $currentTime, in: 0...duration)
                    .onChange(of: currentTime) { newValue in
                        seekTo(newValue)
                    }
                
                RRLabel(formatTime(duration))
                    .style(.caption)
            }
            .padding()
        }
    }
    
    private func togglePlayback() {
        // Toggle playback logic
    }
    
    private func seekTo(_ time: Double) {
        // Seek logic
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
```

### Image Gallery with Filters
```swift
struct FilteredImageGallery: View {
    @State private var selectedIndex = 0
    @State private var selectedFilter: ImageFilter = .all
    
    let images: [ImageItem]
    
    var filteredImages: [ImageItem] {
        switch selectedFilter {
        case .all:
            return images
        case .favorites:
            return images.filter { $0.isFavorite }
        case .recent:
            return images.filter { $0.isRecent }
        }
    }
    
    var body: some View {
        VStack {
            // Filter buttons
            HStack {
                ForEach(ImageFilter.allCases, id: \.self) { filter in
                    RRButton(filter.rawValue) {
                        selectedFilter = filter
                    }
                    .style(selectedFilter == filter ? .primary : .ghost)
                }
            }
            .padding()
            
            // Image gallery
            RRImageGallery(
                images: filteredImages.map { $0.image },
                selectedIndex: $selectedIndex
            )
            .layout(.grid)
            .frame(height: 300)
        }
    }
}

enum ImageFilter: String, CaseIterable {
    case all = "All"
    case favorites = "Favorites"
    case recent = "Recent"
}
```

## Troubleshooting

### Common Issues

1. **Video not playing**: Check URL validity and format support
2. **Images not loading**: Verify image URLs and formats
3. **Controls not working**: Check control configuration

### Debug Tips

1. Use `.background(.red)` to visualize media bounds
2. Check console for media loading errors
3. Verify URL validity and accessibility
4. Test with different media formats and sizes
