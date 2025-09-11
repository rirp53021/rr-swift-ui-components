import SwiftUI
import AVKit

/// A comprehensive media viewer component for displaying images, videos, and other media content
public struct RRMediaViewer: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedIndex = 0
    @State private var isFullscreen = false
    @State private var showControls = true
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    
    private let mediaItems: [MediaItem]
    private let style: MediaViewerStyle
    private let showThumbnails: Bool
    private let showIndicators: Bool
    private let autoPlay: Bool
    private let onMediaTap: ((Int) -> Void)?
    private let onMediaLongPress: ((Int) -> Void)?
    private let onShare: ((Int) -> Void)?
    private let onDownload: ((Int) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a media viewer with the specified configuration
    /// - Parameters:
    ///   - mediaItems: Array of media items to display
    ///   - style: The media viewer style
    ///   - showThumbnails: Whether to show thumbnail navigation
    ///   - showIndicators: Whether to show page indicators
    ///   - autoPlay: Whether to auto-play videos
    ///   - onMediaTap: Callback when media is tapped
    ///   - onMediaLongPress: Callback when media is long-pressed
    ///   - onShare: Callback when share is requested
    ///   - onDownload: Callback when download is requested
    public init(
        mediaItems: [MediaItem],
        style: MediaViewerStyle = .default,
        showThumbnails: Bool = true,
        showIndicators: Bool = true,
        autoPlay: Bool = false,
        onMediaTap: ((Int) -> Void)? = nil,
        onMediaLongPress: ((Int) -> Void)? = nil,
        onShare: ((Int) -> Void)? = nil,
        onDownload: ((Int) -> Void)? = nil
    ) {
        self.mediaItems = mediaItems
        self.style = style
        self.showThumbnails = showThumbnails
        self.showIndicators = showIndicators
        self.autoPlay = autoPlay
        self.onMediaTap = onMediaTap
        self.onMediaLongPress = onMediaLongPress
        self.onShare = onShare
        self.onDownload = onDownload
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            if mediaItems.isEmpty {
                emptyStateView
            } else {
                mainView
            }
        }
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        )
        .sheet(isPresented: $isFullscreen) {
            fullscreenView
        }
    }
    
    // MARK: - Main View
    
    private var mainView: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Media Content
            TabView(selection: $selectedIndex) {
                ForEach(Array(mediaItems.enumerated()), id: \.offset) { index, item in
                    mediaContentView(item: item, index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(DefaultTabViewStyle())
            .frame(height: style.mediaHeight)
            .onTapGesture {
                onMediaTap?(selectedIndex)
            }
            .onLongPressGesture {
                onMediaLongPress?(selectedIndex)
            }
            
            // Media Info
            if let currentItem = currentMediaItem {
                mediaInfoView(item: currentItem)
            }
            
            // Controls
            if showControls {
                mediaControlsView
            }
            
            // Indicators
            if showIndicators && mediaItems.count > 1 {
                pageIndicators
            }
            
            // Thumbnails
            if showThumbnails && mediaItems.count > 1 {
                thumbnailsView
            }
        }
    }
    
    // MARK: - Media Content View
    
    private func mediaContentView(item: MediaItem, index: Int) -> some View {
        ZStack {
            switch item.type {
            case .image(let imageData):
                imageView(imageData: imageData, index: index)
            case .video(let videoData):
                videoView(videoData: videoData, index: index)
            case .audio(let audioData):
                audioView(audioData: audioData, index: index)
            case .document(let documentData):
                documentView(documentData: documentData, index: index)
            }
            
            // Loading indicator
            if item.isLoading {
                RRLoadingIndicator(style: .spinner, size: DesignTokens.ComponentSize.iconSizeXL)
            }
            
            // Error overlay
            if item.hasError {
                errorOverlay(item: item)
            }
        }
    }
    
    // MARK: - Image View
    
    private func imageView(imageData: ImageData, index: Int) -> some View {
        RRAsyncImage(
            url: imageData.url,
            aspectRatio: imageData.aspectRatio,
            contentMode: .fit
        )
        .aspectRatio(imageData.aspectRatio, contentMode: .fit)
        .clipped()
        .cornerRadius(DesignTokens.BorderRadius.sm)
        .scaleEffect(scale)
        .offset(dragOffset)
        .gesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            scale = max(1.0, min(3.0, value))
                        }
                    },
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
            )
        )
    }
    
    // MARK: - Video View
    
    private func videoView(videoData: VideoData, index: Int) -> some View {
        RRVideoPlayer(
            videoURL: videoData.url,
            style: VideoPlayerStyle(
                backgroundColor: style.videoBackgroundColor,
                borderColor: style.borderColor,
                controlsColor: style.controlsColor,
                progressColor: style.progressColor
            ),
            showControls: true,
            autoPlay: autoPlay,
            loop: videoData.loop,
            muted: videoData.muted,
            aspectRatio: .fit,
            cornerRadius: DesignTokens.BorderRadius.sm
        )
    }
    
    // MARK: - Audio View
    
    private func audioView(audioData: AudioData, index: Int) -> some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Audio visualizer or album art
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.lg)
                    .fill(style.audioBackgroundColor)
                    .frame(width: 200, height: 200)
                
                if let albumArtURL = audioData.albumArtURL {
                    RRAsyncImage(
                        url: albumArtURL,
                        aspectRatio: 1,
                        contentMode: .fill
                    )
                    .frame(width: 200, height: 200)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .cornerRadius(DesignTokens.BorderRadius.lg)
                } else {
                    Image(systemName: "music.note")
                        .font(.system(size: 60))
                        .foregroundColor(style.controlsColor)
                }
            }
            
            // Audio controls
            VStack(spacing: DesignTokens.Spacing.sm) {
                RRLabel(audioData.title ?? "Unknown Title", style: .subtitle, weight: .semibold, customColor: style.textColor)
                RRLabel(audioData.artist ?? "Unknown Artist", style: .body, customColor: style.textColor)
                
                // Progress bar
                ProgressView(value: currentTime, total: duration)
                    .progressViewStyle(LinearProgressViewStyle(tint: style.progressColor))
                    .scaleEffect(y: 2)
                
                HStack {
                    RRLabel(timeString(currentTime), style: .caption, customColor: style.textColor)
                    Spacer()
                    RRLabel(timeString(duration), style: .caption, customColor: style.textColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignTokens.Spacing.md)
    }
    
    // MARK: - Document View
    
    private func documentView(documentData: DocumentData, index: Int) -> some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Document icon
            Image(systemName: documentData.iconName)
                .font(.system(size: 80))
                .foregroundColor(style.controlsColor)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                RRLabel(documentData.title, style: .subtitle, weight: .semibold, customColor: style.textColor)
                RRLabel(documentData.subtitle, style: .body, customColor: style.textColor)
                RRLabel(documentData.size, style: .caption, customColor: style.textColor)
            }
            
            // Document actions
            HStack(spacing: DesignTokens.Spacing.md) {
                Button("Open") {
                    // Open document action
                }
                .buttonStyle(.bordered)
                
                Button("Share") {
                    onShare?(index)
                }
                .buttonStyle(.bordered)
                
                Button("Download") {
                    onDownload?(index)
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignTokens.Spacing.md)
    }
    
    // MARK: - Media Info View
    
    private func mediaInfoView(item: MediaItem) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            if let title = item.title {
                RRLabel(title, style: .subtitle, weight: .semibold, customColor: style.textColor)
            }
            if let subtitle = item.subtitle {
                RRLabel(subtitle, style: .body, customColor: style.textColor)
            }
            if let description = item.description {
                RRLabel(description, style: .caption, customColor: style.textColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DesignTokens.Spacing.md)
    }
    
    // MARK: - Media Controls View
    
    private var mediaControlsView: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Button(action: previousMedia) {
                Image(systemName: "chevron.left")
                    .foregroundColor(style.controlsColor)
                    .font(.title2)
            }
            .disabled(selectedIndex == 0)
            
            Spacer()
            
            Button(action: toggleFullscreen) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundColor(style.controlsColor)
                    .font(.title3)
            }
            
            Button(action: { onShare?(selectedIndex) }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(style.controlsColor)
                    .font(.title3)
            }
            
            Button(action: { onDownload?(selectedIndex) }) {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(style.controlsColor)
                    .font(.title3)
            }
            
            Spacer()
            
            Button(action: nextMedia) {
                Image(systemName: "chevron.right")
                    .foregroundColor(style.controlsColor)
                    .font(.title2)
            }
            .disabled(selectedIndex == mediaItems.count - 1)
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
    }
    
    // MARK: - Page Indicators
    
    private var pageIndicators: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<mediaItems.count, id: \.self) { index in
                Circle()
                    .fill(selectedIndex == index ? style.indicatorColor : style.indicatorColor.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedIndex = index
                        }
                    }
            }
        }
        .padding(.vertical, DesignTokens.Spacing.sm)
    }
    
    // MARK: - Thumbnails View
    
    private var thumbnailsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(Array(mediaItems.enumerated()), id: \.offset) { index, item in
                    thumbnailView(item: item, index: index)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
        }
    }
    
    // MARK: - Thumbnail View
    
    private func thumbnailView(item: MediaItem, index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm)
                .fill(style.thumbnailBackgroundColor)
                .frame(width: 60, height: 60)
            
            switch item.type {
            case .image(let imageData):
                RRAsyncImage(
                    url: imageData.url,
                    aspectRatio: 1,
                    contentMode: .fill
                )
                .frame(width: 60, height: 60)
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .cornerRadius(DesignTokens.BorderRadius.sm)
                
            case .video:
                Image(systemName: "play.rectangle")
                    .foregroundColor(style.controlsColor)
                    .font(.title2)
                
            case .audio:
                Image(systemName: "music.note")
                    .foregroundColor(style.controlsColor)
                    .font(.title2)
                
            case .document:
                Image(systemName: "doc")
                    .foregroundColor(style.controlsColor)
                    .font(.title2)
            }
            
            // Selection indicator
            if selectedIndex == index {
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm)
                    .stroke(style.thumbnailBorderColor, lineWidth: 2)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex = index
            }
        }
    }
    
    // MARK: - Fullscreen View
    
    private var fullscreenView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
                    Button("Done") {
                        isFullscreen = false
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    RRLabel("\(selectedIndex + 1) of \(mediaItems.count)", style: .subtitle, customColor: .white)
                }
                .padding()
                
                Spacer()
                
                // Media content
                if selectedIndex < mediaItems.count {
                    mediaContentView(item: mediaItems[selectedIndex], index: selectedIndex)
                }
                
                Spacer()
                
                // Controls
                HStack {
                    Button(action: previousMedia) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .disabled(selectedIndex == 0)
                    
                    Spacer()
                    
                    Button(action: nextMedia) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .disabled(selectedIndex == mediaItems.count - 1)
                }
                .padding()
            }
        }
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: "photo.on.rectangle")
                .font(.largeTitle)
                .foregroundColor(style.placeholderColor)
            
            RRLabel("No Media", style: .subtitle, customColor: style.placeholderColor)
            RRLabel("Add media items to display in the viewer", style: .caption, customColor: style.placeholderColor)
        }
        .frame(height: style.mediaHeight)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Error Overlay
    
    private func errorOverlay(item: MediaItem) -> some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundColor(style.errorColor)
            
            RRLabel("Failed to load", style: .caption, customColor: style.errorColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .cornerRadius(DesignTokens.BorderRadius.sm)
    }
    
    // MARK: - Computed Properties
    
    private var currentMediaItem: MediaItem? {
        guard selectedIndex < mediaItems.count else { return nil }
        return mediaItems[selectedIndex]
    }
    
    // MARK: - Actions
    
    private func previousMedia() {
        if selectedIndex > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex -= 1
            }
        }
    }
    
    private func nextMedia() {
        if selectedIndex < mediaItems.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex += 1
            }
        }
    }
    
    private func toggleFullscreen() {
        isFullscreen.toggle()
    }
    
    private func timeString(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Media Item

public struct MediaItem {
    public let type: MediaType
    public let title: String?
    public let subtitle: String?
    public let description: String?
    public let isLoading: Bool
    public let hasError: Bool
    
    public init(
        type: MediaType,
        title: String? = nil,
        subtitle: String? = nil,
        description: String? = nil,
        isLoading: Bool = false,
        hasError: Bool = false
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.isLoading = isLoading
        self.hasError = hasError
    }
}

// MARK: - Media Type

public enum MediaType {
    case image(ImageData)
    case video(VideoData)
    case audio(AudioData)
    case document(DocumentData)
}

// MARK: - Media Data Types

public struct ImageData {
    public let url: URL?
    public let placeholder: String?
    public let errorImage: String?
    public let aspectRatio: CGFloat
    
    public init(
        url: URL?,
        placeholder: String? = nil,
        errorImage: String? = nil,
        aspectRatio: CGFloat = 16/9
    ) {
        self.url = url
        self.placeholder = placeholder
        self.errorImage = errorImage
        self.aspectRatio = aspectRatio
    }
}

public struct VideoData {
    public let url: URL?
    public let loop: Bool
    public let muted: Bool
    
    public init(
        url: URL?,
        loop: Bool = false,
        muted: Bool = false
    ) {
        self.url = url
        self.loop = loop
        self.muted = muted
    }
}

public struct AudioData {
    public let url: URL?
    public let title: String?
    public let artist: String?
    public let albumArtURL: URL?
    
    public init(
        url: URL?,
        title: String? = nil,
        artist: String? = nil,
        albumArtURL: URL? = nil
    ) {
        self.url = url
        self.title = title
        self.artist = artist
        self.albumArtURL = albumArtURL
    }
}

public struct DocumentData {
    public let url: URL?
    public let title: String
    public let subtitle: String
    public let size: String
    public let iconName: String
    
    public init(
        url: URL?,
        title: String,
        subtitle: String,
        size: String,
        iconName: String = "doc"
    ) {
        self.url = url
        self.title = title
        self.subtitle = subtitle
        self.size = size
        self.iconName = iconName
    }
}

// MARK: - Media Viewer Style

public struct MediaViewerStyle {
    public let backgroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let mediaHeight: CGFloat
    public let textColor: Color
    public let controlsColor: Color
    public let progressColor: Color
    public let indicatorColor: Color
    public let thumbnailBackgroundColor: Color
    public let thumbnailBorderColor: Color
    public let placeholderColor: Color
    public let errorColor: Color
    public let videoBackgroundColor: Color
    public let audioBackgroundColor: Color
    
    public init(
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        mediaHeight: CGFloat = 400,
        textColor: Color? = nil,
        controlsColor: Color? = nil,
        progressColor: Color? = nil,
        indicatorColor: Color? = nil,
        thumbnailBackgroundColor: Color? = nil,
        thumbnailBorderColor: Color? = nil,
        placeholderColor: Color? = nil,
        errorColor: Color? = nil,
        videoBackgroundColor: Color? = nil,
        audioBackgroundColor: Color? = nil
    ) {
        self.backgroundColor = backgroundColor ?? Color.clear
        self.borderColor = borderColor ?? Color.gray.opacity(0.3)
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.mediaHeight = mediaHeight
        self.textColor = textColor ?? Color.primary
        self.controlsColor = controlsColor ?? Color.blue
        self.progressColor = progressColor ?? Color.blue
        self.indicatorColor = indicatorColor ?? Color.blue
        self.thumbnailBackgroundColor = thumbnailBackgroundColor ?? Color.gray.opacity(0.1)
        self.thumbnailBorderColor = thumbnailBorderColor ?? Color.blue
        self.placeholderColor = placeholderColor ?? Color.gray
        self.errorColor = errorColor ?? Color.red
        self.videoBackgroundColor = videoBackgroundColor ?? Color.black
        self.audioBackgroundColor = audioBackgroundColor ?? Color.gray.opacity(0.1)
    }
    
    public static let `default` = MediaViewerStyle()
    public static let light = MediaViewerStyle(
        backgroundColor: Color.white,
        borderColor: Color.gray.opacity(0.2),
        textColor: Color.black,
        controlsColor: Color.blue,
        thumbnailBackgroundColor: Color.gray.opacity(0.1)
    )
    public static let dark = MediaViewerStyle(
        backgroundColor: Color.black,
        borderColor: Color.gray.opacity(0.5),
        textColor: Color.white,
        controlsColor: Color.white,
        thumbnailBackgroundColor: Color.gray.opacity(0.3)
    )
}


// MARK: - Previews

#if DEBUG
struct RRMediaViewer_Previews: PreviewProvider {
    static var previews: some View {
        RRMediaViewerPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRMediaViewer Examples")
    }
}

private struct RRMediaViewerPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let sampleMediaItems = [
        MediaItem(
            type: .image(ImageData(url: nil, placeholder: "photo", aspectRatio: 16/9)),
            title: "Beautiful Landscape",
            subtitle: "Nature Photography",
            description: "A stunning view of mountains and lakes"
        ),
        MediaItem(
            type: .video(VideoData(url: nil, loop: false, muted: false)),
            title: "Sample Video",
            subtitle: "Video Content",
            description: "An example video file"
        ),
        MediaItem(
            type: .audio(AudioData(url: nil, title: "Sample Song", artist: "Unknown Artist")),
            title: "Sample Song",
            subtitle: "Unknown Artist",
            description: "An example audio file"
        ),
        MediaItem(
            type: .document(DocumentData(url: nil, title: "Sample Document", subtitle: "PDF File", size: "2.4 MB")),
            title: "Sample Document",
            subtitle: "PDF File",
            description: "An example document file"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                RRLabel.title("Media Viewer Examples", customColor: theme.colors.onSurface)
                
                // Basic media viewer
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Basic Media Viewer", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRMediaViewer(
                        mediaItems: sampleMediaItems,
                        style: .default,
                        showThumbnails: true,
                        showIndicators: true
                    )
                }
                
                // Light theme
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Light Theme", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRMediaViewer(
                        mediaItems: sampleMediaItems,
                        style: .light,
                        showThumbnails: true,
                        showIndicators: true
                    )
                }
                
                // Dark theme
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Dark Theme", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRMediaViewer(
                        mediaItems: sampleMediaItems,
                        style: .dark,
                        showThumbnails: true,
                        showIndicators: true
                    )
                }
                
                // Empty state
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Empty State", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRMediaViewer(
                        mediaItems: [],
                        style: .default
                    )
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
}
#endif
