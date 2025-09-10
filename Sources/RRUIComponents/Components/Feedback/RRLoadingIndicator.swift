import SwiftUI

/// A collection of loading indicator components
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRLoadingIndicator: View {
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let style: LoadingStyle
    private let size: CGFloat
    private let color: Color
    private let lineWidth: CGFloat
    private let animationSpeed: Double
    
    @State private var isAnimating = false
    
    // MARK: - Computed Properties
    
    private var effectiveColor: Color {
        color == Color.blue ? theme.colors.primary : color
    }
    
    // MARK: - Initialization
    
    public init(
        style: LoadingStyle = .spinner,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeLG,
        color: Color? = nil,
        lineWidth: CGFloat = 3,
        animationSpeed: Double = DesignTokens.Animation.durationNormal
    ) {
        self.style = style
        self.size = size
        self.color = color ?? Color.blue // Will be overridden by theme in body
        self.lineWidth = lineWidth
        self.animationSpeed = animationSpeed
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .spinner:
                spinnerView
            case .dots:
                dotsView
            case .pulse:
                pulseView
            case .wave:
                waveView
            case .progress:
                progressView
            case .skeleton:
                skeletonView
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    // MARK: - Spinner View
    
    private var spinnerView: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(effectiveColor, lineWidth: lineWidth)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: DesignTokens.Animation.durationNormal / animationSpeed)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
    
    // MARK: - Dots View
    
    private var dotsView: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(effectiveColor)
                    .frame(width: size / 4, height: size / 4)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6 / animationSpeed)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2 / animationSpeed),
                        value: isAnimating
                    )
            }
        }
    }
    
    // MARK: - Pulse View
    
    private var pulseView: some View {
        Circle()
            .fill(effectiveColor)
            .frame(width: size, height: size)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.3 : 1.0)
            .animation(
                .easeInOut(duration: 1.0 / animationSpeed)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
    
    // MARK: - Wave View
    
    private var waveView: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                    .fill(effectiveColor)
                    .frame(width: DesignTokens.ComponentSize.iconSizeXS, height: size)
                    .scaleEffect(y: isAnimating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.8 / animationSpeed)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1 / animationSpeed),
                        value: isAnimating
                    )
            }
        }
    }
    
    // MARK: - Progress View
    
    private var progressView: some View {
        ZStack {
            Circle()
                .stroke(effectiveColor.opacity(0.3), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(effectiveColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.0 / animationSpeed)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
    }
    
    // MARK: - Skeleton View
    
    private var skeletonView: some View {
        RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
            .fill(effectiveColor.opacity(0.3))
            .frame(width: size, height: size / 3)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                    .fill(effectiveColor.opacity(0.6))
                    .frame(width: size, height: size / 3)
                    .offset(x: isAnimating ? size : -size)
                    .animation(
                        .linear(duration: 1.5 / animationSpeed)
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            )
            .clipped()
    }
}

// MARK: - Loading Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRLoadingIndicator {
    enum LoadingStyle {
        case spinner
        case dots
        case pulse
        case wave
        case progress
        case skeleton
    }
}

// MARK: - Loading Overlay

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRLoadingOverlay<Content: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let isLoading: Bool
    private let message: String?
    private let style: RRLoadingIndicator.LoadingStyle
    private let backgroundColor: Color
    private let indicatorColor: Color
    private let textColor: Color
    
    // MARK: - Computed Properties
    
    private var effectiveBackgroundColor: Color {
        backgroundColor == Color.black.opacity(0.3) ? theme.colors.surface.opacity(0.8) : backgroundColor
    }
    
    private var effectiveIndicatorColor: Color {
        indicatorColor == Color.white ? theme.colors.primary : indicatorColor
    }
    
    private var effectiveTextColor: Color {
        textColor == Color.white ? theme.colors.primaryText : textColor
    }
    
    public init(
        isLoading: Bool,
        message: String? = nil,
        style: RRLoadingIndicator.LoadingStyle = .spinner,
        backgroundColor: Color? = nil,
        indicatorColor: Color? = nil,
        textColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.isLoading = isLoading
        self.message = message
        self.style = style
        self.backgroundColor = backgroundColor ?? Color.black.opacity(0.3) // Will be overridden by theme
        self.indicatorColor = indicatorColor ?? Color.white // Will be overridden by theme
        self.textColor = textColor ?? Color.white // Will be overridden by theme
    }
    
    public var body: some View {
        ZStack {
            content
            
            if isLoading {
                effectiveBackgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLoadingIndicator(
                        style: style,
                        size: DesignTokens.ComponentSize.iconSizeXL,
                        color: effectiveIndicatorColor
                    )
                    
                    if let message = message {
                        RRLabel(message, style: .body, weight: .medium, customColor: effectiveTextColor)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(DesignTokens.Spacing.lg)
                .background(theme.colors.surface.opacity(0.9))
                .cornerRadius(DesignTokens.BorderRadius.lg)
                .padding(.horizontal, DesignTokens.Spacing.xl)
            }
        }
    }
}

// MARK: - Progress Bar

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRProgressBar: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let progress: Double
    private let height: CGFloat
    private let backgroundColor: Color
    private let progressColor: Color
    private let cornerRadius: CGFloat
    private let showPercentage: Bool
    private let animation: Animation
    
    // MARK: - Computed Properties
    
    private var effectiveBackgroundColor: Color {
        backgroundColor == Color.gray.opacity(0.2) ? theme.colors.surfaceVariant : backgroundColor
    }
    
    private var effectiveProgressColor: Color {
        progressColor == Color.blue ? theme.colors.primary : progressColor
    }
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        backgroundColor: Color? = nil,
        progressColor: Color? = nil,
        cornerRadius: CGFloat = 4,
        showPercentage: Bool = false,
        animation: Animation = .easeInOut(duration: 0.3)
    ) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.backgroundColor = backgroundColor ?? Color.gray.opacity(0.2) // Will be overridden by theme
        self.progressColor = progressColor ?? Color.blue // Will be overridden by theme
        self.cornerRadius = cornerRadius
        self.showPercentage = showPercentage
        self.animation = animation
    }
    
    public var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(effectiveBackgroundColor)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(effectiveProgressColor)
                    .frame(width: CGFloat(progress) * 300, height: height)
                    .animation(animation, value: progress)
            }
            
            if showPercentage {
                RRLabel("\(Int(progress * 100))%", style: .caption, weight: .medium, color: .secondary)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                // Loading indicators
                VStack(spacing: DesignTokens.Spacing.lg) {
                    RRLabel("Loading Indicators", style: .title, weight: .bold, color: .primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DesignTokens.Spacing.lg) {
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .spinner, size: 30, color: .blue)
                            RRLabel("Spinner", style: .caption, weight: .medium, color: .secondary)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .dots, size: 30, color: .green)
                            RRLabel("Dots", style: .caption, weight: .medium, color: .secondary)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .pulse, size: 30, color: .orange)
                            RRLabel("Pulse", style: .caption, weight: .medium, color: .secondary)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .wave, size: 30, color: .purple)
                            RRLabel("Wave", style: .caption, weight: .medium, color: .secondary)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .progress, size: 30, color: .red)
                            RRLabel("Progress", style: .caption, weight: .medium, color: .secondary)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLoadingIndicator(style: .skeleton, size: 30, color: .gray)
                            RRLabel("Skeleton", style: .caption, weight: .medium, color: .secondary)
                        }
                    }
                }
                
                // Progress bars
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Progress Bars", style: .title, weight: .bold, color: .primary)
                    
                    VStack(spacing: DesignTokens.Spacing.sm) {
                        RRProgressBar(progress: 0.3, showPercentage: true)
                        RRProgressBar(progress: 0.6, progressColor: .green, showPercentage: true)
                        RRProgressBar(progress: 0.9, progressColor: .red, showPercentage: true)
                    }
                }
                
                // Loading overlay
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Loading Overlay", style: .title, weight: .bold, color: .primary)
                    
                    RRLoadingOverlay(
                        isLoading: true,
                        message: "Loading content...",
                        style: .spinner
                    ) {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 100)
                            
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 20)
                                
                                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 16)
                                
                                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 16)
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                }
            }
            .padding(DesignTokens.Spacing.componentPadding)
        }
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRLoadingIndicator Examples")
    }
}
#endif
