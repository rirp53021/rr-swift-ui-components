import SwiftUI
import AVKit

/// A customizable video player component with design system integration
public struct RRVideoPlayer: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var isControlsVisible = true
    @State private var isFullscreen = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let videoURL: URL?
    private let style: VideoPlayerStyle
    private let showControls: Bool
    private let autoPlay: Bool
    private let loop: Bool
    private let muted: Bool
    private let aspectRatio: AspectRatio
    private let cornerRadius: CGFloat
    private let onPlay: (() -> Void)?
    private let onPause: (() -> Void)?
    private let onEnd: (() -> Void)?
    private let onError: ((Error) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a video player with the specified configuration
    /// - Parameters:
    ///   - videoURL: The URL of the video to play
    ///   - style: The video player style
    ///   - showControls: Whether to show playback controls
    ///   - autoPlay: Whether to start playing automatically
    ///   - loop: Whether to loop the video
    ///   - muted: Whether to start muted
    ///   - aspectRatio: The aspect ratio of the video
    ///   - cornerRadius: The corner radius of the player
    ///   - onPlay: Callback when video starts playing
    ///   - onPause: Callback when video is paused
    ///   - onEnd: Callback when video ends
    ///   - onError: Callback when an error occurs
    public init(
        videoURL: URL?,
        style: VideoPlayerStyle = .default,
        showControls: Bool = true,
        autoPlay: Bool = false,
        loop: Bool = false,
        muted: Bool = false,
        aspectRatio: AspectRatio = .fit,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        onPlay: (() -> Void)? = nil,
        onPause: (() -> Void)? = nil,
        onEnd: (() -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        self.videoURL = videoURL
        self.style = style
        self.showControls = showControls
        self.autoPlay = autoPlay
        self.loop = loop
        self.muted = muted
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
        self.onPlay = onPlay
        self.onPause = onPause
        self.onEnd = onEnd
        self.onError = onError
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            if videoURL != nil {
                videoPlayerView
            } else {
                placeholderView
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            cleanupPlayer()
        }
        .alert("Video Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Video Player View
    
    private var videoPlayerView: some View {
        ZStack {
            // Video Player
            VideoPlayer(player: player)
                .aspectRatio(aspectRatio.ratio, contentMode: aspectRatio.contentMode)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
                .onTapGesture {
                    if showControls {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isControlsVisible.toggle()
                        }
                    }
                }
            
            // Custom Controls Overlay
            if showControls && isControlsVisible {
                customControlsOverlay
            }
            
            // Loading Indicator
            if player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                loadingOverlay
            }
        }
        .background(style.backgroundColor)
        .cornerRadius(cornerRadius)
    }
    
    // MARK: - Custom Controls Overlay
    
    private var customControlsOverlay: some View {
        VStack {
            Spacer()
            
            HStack(spacing: DesignTokens.Spacing.md) {
                // Play/Pause Button
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(style.controlsColor)
                        .font(.title2)
                }
                
                // Progress Bar
                VStack(spacing: DesignTokens.Spacing.xs) {
                    ProgressView(value: currentTime, total: duration)
                        .progressViewStyle(LinearProgressViewStyle(tint: style.progressColor))
                        .scaleEffect(y: 2)
                    
                    HStack {
                        RRLabel(timeString(currentTime), style: .caption, customColor: style.controlsColor)
                        Spacer()
                        RRLabel(timeString(duration), style: .caption, customColor: style.controlsColor)
                    }
                }
                
                // Fullscreen Button
                Button(action: toggleFullscreen) {
                    Image(systemName: isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(style.controlsColor)
                        .font(.title3)
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .cornerRadius(cornerRadius)
    }
    
    // MARK: - Loading Overlay
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .cornerRadius(cornerRadius)
            
            RRLoadingIndicator(style: .spinner, size: DesignTokens.ComponentSize.iconSizeXL)
        }
    }
    
    // MARK: - Placeholder View
    
    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
            
            VStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: "video.slash")
                    .font(.largeTitle)
                    .foregroundColor(style.placeholderColor)
                
                RRLabel("No Video Available", style: .subtitle, customColor: style.placeholderColor)
                RRLabel("Please provide a valid video URL", style: .caption, customColor: style.placeholderColor)
            }
        }
        .aspectRatio(aspectRatio.ratio, contentMode: aspectRatio.contentMode)
    }
    
    // MARK: - Player Setup
    
    private func setupPlayer() {
        guard let videoURL = videoURL else { return }
        
        player = AVPlayer(url: videoURL)
        player?.isMuted = muted
        
        if autoPlay {
            player?.play()
            isPlaying = true
        }
        
        // Add time observer
        _ = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { time in
            currentTime = time.seconds
        }
        
        // Add end time observer
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            if loop {
                player?.seek(to: .zero)
                player?.play()
            } else {
                isPlaying = false
                onEnd?()
            }
        }
        
        // Get duration
        if let duration = player?.currentItem?.duration {
            self.duration = duration.seconds
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    private func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
            isPlaying = false
            onPause?()
        } else {
            player.play()
            isPlaying = true
            onPlay?()
        }
    }
    
    private func toggleFullscreen() {
        isFullscreen.toggle()
        // Fullscreen implementation would go here
    }
    
    private func timeString(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Video Player Style

public struct VideoPlayerStyle {
    public let backgroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let controlsColor: Color
    public let progressColor: Color
    public let placeholderColor: Color
    
    public init(
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        controlsColor: Color? = nil,
        progressColor: Color? = nil,
        placeholderColor: Color? = nil
    ) {
        self.backgroundColor = backgroundColor ?? Color.black
        self.borderColor = borderColor ?? Color.gray.opacity(0.3)
        self.borderWidth = borderWidth
        self.controlsColor = controlsColor ?? Color.white
        self.progressColor = progressColor ?? Color.blue
        self.placeholderColor = placeholderColor ?? Color.gray
    }
    
    public static let `default` = VideoPlayerStyle()
    public static let light = VideoPlayerStyle(
        backgroundColor: Color.white,
        borderColor: Color.gray.opacity(0.2),
        controlsColor: Color.black,
        progressColor: Color.blue,
        placeholderColor: Color.gray
    )
    public static let dark = VideoPlayerStyle(
        backgroundColor: Color.black,
        borderColor: Color.gray.opacity(0.5),
        controlsColor: Color.white,
        progressColor: Color.blue,
        placeholderColor: Color.gray
    )
}

// MARK: - Aspect Ratio

public enum AspectRatio {
    case fit
    case fill
    case custom(CGFloat)
    
    var ratio: CGFloat {
        switch self {
        case .fit: return 16/9
        case .fill: return 16/9
        case .custom(let ratio): return ratio
        }
    }
    
    var contentMode: ContentMode {
        switch self {
        case .fit: return .fit
        case .fill: return .fill
        case .custom: return .fit
        }
    }
}

// MARK: - Previews

#if DEBUG
struct RRVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        RRVideoPlayerPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRVideoPlayer Examples")
    }
}

private struct RRVideoPlayerPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Video Player Examples")
            
            // Basic video players
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Video Players", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRVideoPlayer(
                        videoURL: nil,
                        style: .default,
                        showControls: true
                    )
                    .frame(height: 200)
                    
                    RRVideoPlayer(
                        videoURL: nil,
                        style: .light,
                        showControls: true
                    )
                    .frame(height: 200)
                }
            }
            
            // Styled video players
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Styled Video Players", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRVideoPlayer(
                        videoURL: nil,
                        style: VideoPlayerStyle(
                            backgroundColor: theme.colors.primary,
                            borderColor: theme.colors.primary,
                            controlsColor: theme.colors.onPrimary,
                            progressColor: theme.colors.onPrimary,
                            placeholderColor: theme.colors.onPrimary
                        ),
                        cornerRadius: DesignTokens.BorderRadius.lg
                    )
                    .frame(height: 200)
                    
                    RRVideoPlayer(
                        videoURL: nil,
                        style: .dark,
                        cornerRadius: DesignTokens.BorderRadius.xl
                    )
                    .frame(height: 200)
                }
            }
            
            // Different aspect ratios
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Different Aspect Ratios", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRVideoPlayer(
                        videoURL: nil,
                        aspectRatio: .fit
                    )
                    .frame(height: 150)
                    
                    RRVideoPlayer(
                        videoURL: nil,
                        aspectRatio: .custom(4/3)
                    )
                    .frame(height: 150)
                    
                    RRVideoPlayer(
                        videoURL: nil,
                        aspectRatio: .custom(1/1)
                    )
                    .frame(height: 150)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
