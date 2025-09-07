import SwiftUI

/// A collection of loading indicator components
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRLoadingIndicator: View {
    // MARK: - Properties
    
    private let style: LoadingStyle
    private let size: CGFloat
    private let color: Color
    private let lineWidth: CGFloat
    private let animationSpeed: Double
    
    @State private var isAnimating = false
    
    // MARK: - Initialization
    
    public init(
        style: LoadingStyle = .spinner,
        size: CGFloat = 24,
        color: Color = .blue,
        lineWidth: CGFloat = 3,
        animationSpeed: Double = 1.0
    ) {
        self.style = style
        self.size = size
        self.color = color
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
            .stroke(color, lineWidth: lineWidth)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1.0 / animationSpeed)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
    
    // MARK: - Dots View
    
    private var dotsView: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
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
            .fill(color)
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
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(width: 3, height: size)
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
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(color, lineWidth: lineWidth)
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
        RoundedRectangle(cornerRadius: 4)
            .fill(color.opacity(0.3))
            .frame(width: size, height: size / 3)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.6))
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
    private let content: Content
    private let isLoading: Bool
    private let message: String?
    private let style: RRLoadingIndicator.LoadingStyle
    private let backgroundColor: Color
    private let indicatorColor: Color
    private let textColor: Color
    
    public init(
        isLoading: Bool,
        message: String? = nil,
        style: RRLoadingIndicator.LoadingStyle = .spinner,
        backgroundColor: Color = Color.black.opacity(0.3),
        indicatorColor: Color = .white,
        textColor: Color = .white,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.isLoading = isLoading
        self.message = message
        self.style = style
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
        self.textColor = textColor
    }
    
    public var body: some View {
        ZStack {
            content
            
            if isLoading {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    RRLoadingIndicator(
                        style: style,
                        size: 40,
                        color: indicatorColor
                    )
                    
                    if let message = message {
                        Text(message)
                            .foregroundColor(textColor)
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.7))
                .cornerRadius(12)
                .padding(.horizontal, 32)
            }
        }
    }
}

// MARK: - Progress Bar

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRProgressBar: View {
    private let progress: Double
    private let height: CGFloat
    private let backgroundColor: Color
    private let progressColor: Color
    private let cornerRadius: CGFloat
    private let showPercentage: Bool
    private let animation: Animation
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        backgroundColor: Color = Color(.systemGray5),
        progressColor: Color = .blue,
        cornerRadius: CGFloat = 4,
        showPercentage: Bool = false,
        animation: Animation = .easeInOut(duration: 0.3)
    ) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
        self.cornerRadius = cornerRadius
        self.showPercentage = showPercentage
        self.animation = animation
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(progressColor)
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width, height: height)
                    .animation(animation, value: progress)
            }
            
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
            VStack(spacing: 30) {
                // Loading indicators
                VStack(spacing: 20) {
                    Text("Loading Indicators")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .spinner, size: 30, color: .blue)
                            Text("Spinner")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .dots, size: 30, color: .green)
                            Text("Dots")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .pulse, size: 30, color: .orange)
                            Text("Pulse")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .wave, size: 30, color: .purple)
                            Text("Wave")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .progress, size: 30, color: .red)
                            Text("Progress")
                                .font(.caption)
                        }
                        
                        VStack(spacing: 8) {
                            RRLoadingIndicator(style: .skeleton, size: 30, color: .gray)
                            Text("Skeleton")
                                .font(.caption)
                        }
                    }
                }
                
                // Progress bars
                VStack(spacing: 16) {
                    Text("Progress Bars")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        RRProgressBar(progress: 0.3, showPercentage: true)
                        RRProgressBar(progress: 0.6, progressColor: .green, showPercentage: true)
                        RRProgressBar(progress: 0.9, progressColor: .red, showPercentage: true)
                    }
                }
                
                // Loading overlay
                VStack(spacing: 16) {
                    Text("Loading Overlay")
                        .font(.headline)
                    
                    RRLoadingOverlay(
                        isLoading: true,
                        message: "Loading content...",
                        style: .spinner
                    ) {
                        VStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(height: 100)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 20)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 16)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 16)
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                }
            }
            .padding()
        }
        .previewDisplayName("RRLoadingIndicator Examples")
    }
}
#endif
