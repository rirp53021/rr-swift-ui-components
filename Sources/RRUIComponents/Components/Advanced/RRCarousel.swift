import SwiftUI
import Foundation

// MARK: - Carousel Component

/// A customizable carousel/image slider component with pagination and autoplay
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCarousel<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAutoPlaying = false
    @State private var autoPlayTimer: Timer?
    
    private let data: Data
    private let content: (Data.Element) -> Content
    private let style: CarouselStyle
    private let autoplay: Bool
    private let autoplayInterval: TimeInterval
    private let showIndicators: Bool
    private let showArrows: Bool
    private let indicatorStyle: PageIndicatorStyle
    private let onPageChanged: ((Int) -> Void)?
    
    public init(
        data: Data,
        style: CarouselStyle = .default,
        autoplay: Bool = false,
        autoplayInterval: TimeInterval = 3.0,
        showIndicators: Bool = true,
        showArrows: Bool = true,
        indicatorStyle: PageIndicatorStyle = .dots,
        onPageChanged: ((Int) -> Void)? = nil,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.style = style
        self.autoplay = autoplay
        self.autoplayInterval = autoplayInterval
        self.showIndicators = showIndicators
        self.showArrows = showArrows
        self.indicatorStyle = indicatorStyle
        self.onPageChanged = onPageChanged
    }
    
    private var itemCount: Int {
        data.count
    }
    
    private var currentItem: Data.Element? {
        guard !data.isEmpty, currentIndex < itemCount else { return nil }
        return Array(data)[currentIndex]
    }
    
    private func startAutoplay() {
        guard autoplay, !data.isEmpty else { return }
        stopAutoplay()
        
        autoPlayTimer = Timer.scheduledTimer(withTimeInterval: autoplayInterval, repeats: true) { _ in
            withAnimation(style.animation) {
                currentIndex = (currentIndex + 1) % itemCount
                onPageChanged?(currentIndex)
            }
        }
    }
    
    private func stopAutoplay() {
        autoPlayTimer?.invalidate()
        autoPlayTimer = nil
    }
    
    private func goToNext() {
        guard !data.isEmpty else { return }
        withAnimation(style.animation) {
            currentIndex = (currentIndex + 1) % itemCount
            onPageChanged?(currentIndex)
        }
    }
    
    private func goToPrevious() {
        guard !data.isEmpty else { return }
        withAnimation(style.animation) {
            currentIndex = currentIndex == 0 ? itemCount - 1 : currentIndex - 1
            onPageChanged?(currentIndex)
        }
    }
    
    private func goToPage(_ index: Int) {
        guard !data.isEmpty, index >= 0, index < itemCount else { return }
        withAnimation(style.animation) {
            currentIndex = index
            onPageChanged?(index)
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main carousel content
                HStack(spacing: 0) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        content(item)
                            .frame(width: geometry.size.width)
                            .clipped()
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width + dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold = geometry.size.width * 0.3
                            
                            if value.translation.width > threshold {
                                goToPrevious()
                            } else if value.translation.width < -threshold {
                                goToNext()
                            }
                            
                            withAnimation(style.animation) {
                                dragOffset = 0
                            }
                        }
                )
                
                // Navigation arrows
                if showArrows && itemCount > 1 {
                    HStack {
                        Button(action: goToPrevious) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: style.arrowSize, weight: .medium))
                                .foregroundColor(style.arrowColor(theme))
                                .padding(style.arrowPadding)
                                .background(style.arrowBackgroundColor(theme))
                                .clipShape(Circle())
                        }
                        .opacity(currentIndex > 0 ? 1 : 0.5)
                        .disabled(currentIndex == 0)
                        
                        Spacer()
                        
                        Button(action: goToNext) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: style.arrowSize, weight: .medium))
                                .foregroundColor(style.arrowColor(theme))
                                .padding(style.arrowPadding)
                                .background(style.arrowBackgroundColor(theme))
                                .clipShape(Circle())
                        }
                        .opacity(currentIndex < itemCount - 1 ? 1 : 0.5)
                        .disabled(currentIndex == itemCount - 1)
                    }
                    .padding(.horizontal, style.arrowHorizontalPadding)
                }
                
                // Page indicators
                if showIndicators && itemCount > 1 {
                    VStack {
                        Spacer()
                        
                        RRPageIndicator(
                            currentPage: currentIndex,
                            totalPages: itemCount,
                            style: indicatorStyle,
                            onPageSelected: goToPage
                        )
                        .padding(.bottom, style.indicatorBottomPadding)
                    }
                }
            }
        }
        .clipped()
        .onAppear {
            startAutoplay()
        }
        .onDisappear {
            stopAutoplay()
        }
        .onTapGesture {
            if autoplay {
                if isAutoPlaying {
                    stopAutoplay()
                } else {
                    startAutoplay()
                }
                isAutoPlaying.toggle()
            }
        }
    }
}

// MARK: - Carousel Style

public struct CarouselStyle {
    public let animation: Animation
    public let arrowSize: CGFloat
    public let arrowColor: (Theme) -> Color
    public let arrowBackgroundColor: (Theme) -> Color
    public let arrowPadding: CGFloat
    public let arrowHorizontalPadding: CGFloat
    public let indicatorBottomPadding: CGFloat
    
    public static let `default` = CarouselStyle(
        animation: DesignTokens.Animation.easeInOut,
        arrowSize: DesignTokens.ComponentSize.iconSizeLG,
        arrowColor: { theme in theme.colors.onPrimary },
        arrowBackgroundColor: { theme in theme.colors.primary },
        arrowPadding: DesignTokens.Spacing.sm,
        arrowHorizontalPadding: DesignTokens.Spacing.md,
        indicatorBottomPadding: DesignTokens.Spacing.md
    )
    
    public static let minimal = CarouselStyle(
        animation: DesignTokens.Animation.easeInOut,
        arrowSize: DesignTokens.ComponentSize.iconSizeMD,
        arrowColor: { theme in theme.colors.onSurface },
        arrowBackgroundColor: { theme in theme.colors.surfaceVariant },
        arrowPadding: DesignTokens.Spacing.xs,
        arrowHorizontalPadding: DesignTokens.Spacing.sm,
        indicatorBottomPadding: DesignTokens.Spacing.sm
    )
    
    public static let bold = CarouselStyle(
        animation: DesignTokens.Animation.spring,
        arrowSize: DesignTokens.ComponentSize.iconSizeXL,
        arrowColor: { theme in theme.colors.onPrimary },
        arrowBackgroundColor: { theme in theme.colors.primary },
        arrowPadding: DesignTokens.Spacing.sm,
        arrowHorizontalPadding: DesignTokens.Spacing.md,
        indicatorBottomPadding: DesignTokens.Spacing.md
    )
}

// MARK: - Image Carousel

/// A specialized carousel for images
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRImageCarousel: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAutoPlaying = false
    @State private var autoPlayTimer: Timer?
    
    private let images: [String]
    private let style: CarouselStyle
    private let autoplay: Bool
    private let autoplayInterval: TimeInterval
    private let showIndicators: Bool
    private let showArrows: Bool
    private let contentMode: ContentMode
    private let onPageChanged: ((Int) -> Void)?
    
    public init(
        images: [String],
        style: CarouselStyle = .default,
        autoplay: Bool = false,
        autoplayInterval: TimeInterval = 3.0,
        showIndicators: Bool = true,
        showArrows: Bool = true,
        contentMode: ContentMode = .fill,
        onPageChanged: ((Int) -> Void)? = nil
    ) {
        self.images = images
        self.style = style
        self.autoplay = autoplay
        self.autoplayInterval = autoplayInterval
        self.showIndicators = showIndicators
        self.showArrows = showArrows
        self.contentMode = contentMode
        self.onPageChanged = onPageChanged
    }
    
    public var body: some View {
        RRCarousel(
            data: images.enumerated().map { index, image in
                ImageItem(id: index, imageName: image)
            },
            style: style,
            autoplay: autoplay,
            autoplayInterval: autoplayInterval,
            showIndicators: showIndicators,
            showArrows: showArrows,
            onPageChanged: onPageChanged
        ) { item in
            RRAsyncImage(
                url: URL(string: item.imageName),
                contentMode: contentMode
            )
        }
    }
}

// MARK: - Image Item

private struct ImageItem: Identifiable {
    let id: Int
    let imageName: String
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRCarousel_Previews: PreviewProvider {
    struct SampleItem: Identifiable {
        let id = UUID()
        let title: String
        let color: Color
    }
    
    static let sampleItems = [
        SampleItem(title: "First", color: .blue),
        SampleItem(title: "Second", color: .green),
        SampleItem(title: "Third", color: .orange),
        SampleItem(title: "Fourth", color: .purple)
    ]
    
    static let sampleImages = [
        "https://picsum.photos/400/300?random=1",
        "https://picsum.photos/400/300?random=2",
        "https://picsum.photos/400/300?random=3"
    ]
    
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
            // Basic carousel with theme colors
            VStack {
                RRLabel.title("Basic Carousel")
                
                RRCarousel(
                    data: sampleItems,
                    style: .minimal,
                    showIndicators: true,
                    showArrows: true,
                    indicatorStyle: .dots
                ) { item in
                    RRCard(
                        style: .elevated,
                        content: {
                            VStack {
                                RRLabel.subtitle(item.title, weight: .semibold)
                                RRLabel.caption("Carousel Item")
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    )
                    .frame(height: 200)
                }
                .frame(height: 200)
            }
            
            // Image carousel with different indicator style
            VStack {
                RRLabel.title("Image Carousel")
                
                RRImageCarousel(
                    images: sampleImages,
                    style: .bold,
                    autoplay: true,
                    showIndicators: true,
                    showArrows: true
                )
                .frame(height: 200)
            }
            
            // Carousel with lines indicator
            VStack {
                RRLabel.title("Lines Indicator")
                
                RRCarousel(
                    data: sampleItems.prefix(3),
                    style: .default,
                    showIndicators: true,
                    showArrows: false,
                    indicatorStyle: .lines
                ) { item in
                    Rectangle()
                        .fill(item.color.opacity(0.7))
                        .overlay(
                            VStack {
                                Image(systemName: "star.fill")
                                    .font(.largeTitle)
                                RRLabel.subtitle(item.title, weight: .semibold)
                            }
                            .foregroundColor(.white)
                        )
                        .frame(height: 150)
                }
                .frame(height: 150)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .previewDisplayName("RRCarousel")
    }
}
