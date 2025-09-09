import SwiftUI
import Foundation

// MARK: - Carousel Component

/// A customizable carousel/image slider component with pagination and autoplay
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCarousel<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
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
    private let onPageChanged: ((Int) -> Void)?
    
    public init(
        data: Data,
        style: CarouselStyle = .default,
        autoplay: Bool = false,
        autoplayInterval: TimeInterval = 3.0,
        showIndicators: Bool = true,
        showArrows: Bool = true,
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
                                .foregroundColor(style.arrowColor)
                                .padding(style.arrowPadding)
                                .background(style.arrowBackgroundColor)
                                .clipShape(Circle())
                        }
                        .opacity(currentIndex > 0 ? 1 : 0.5)
                        .disabled(currentIndex == 0)
                        
                        Spacer()
                        
                        Button(action: goToNext) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: style.arrowSize, weight: .medium))
                                .foregroundColor(style.arrowColor)
                                .padding(style.arrowPadding)
                                .background(style.arrowBackgroundColor)
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
                        
                        HStack(spacing: style.indicatorSpacing) {
                            ForEach(0..<itemCount, id: \.self) { index in
                                Button(action: {
                                    goToPage(index)
                                }) {
                                    Circle()
                                        .fill(index == currentIndex ? style.activeIndicatorColor : style.inactiveIndicatorColor)
                                        .frame(width: style.indicatorSize, height: style.indicatorSize)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
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
    public let arrowColor: Color
    public let arrowBackgroundColor: Color
    public let arrowPadding: CGFloat
    public let arrowHorizontalPadding: CGFloat
    public let indicatorSize: CGFloat
    public let indicatorSpacing: CGFloat
    public let activeIndicatorColor: Color
    public let inactiveIndicatorColor: Color
    public let indicatorBottomPadding: CGFloat
    
    public static let `default` = CarouselStyle(
        animation: .easeInOut(duration: 0.3),
        arrowSize: 20,
        arrowColor: .white,
        arrowBackgroundColor: Color.black.opacity(0.5),
        arrowPadding: 8,
        arrowHorizontalPadding: 16,
        indicatorSize: 8,
        indicatorSpacing: 8,
        activeIndicatorColor: .white,
        inactiveIndicatorColor: Color.white.opacity(0.5),
        indicatorBottomPadding: 16
    )
    
    public static let minimal = CarouselStyle(
        animation: .easeInOut(duration: 0.2),
        arrowSize: 16,
        arrowColor: .primary,
        arrowBackgroundColor: Color.primary.opacity(0.8),
        arrowPadding: 6,
        arrowHorizontalPadding: 12,
        indicatorSize: 6,
        indicatorSpacing: 6,
        activeIndicatorColor: .blue,
        inactiveIndicatorColor: Color.gray.opacity(0.3),
        indicatorBottomPadding: 12
    )
    
    public static let bold = CarouselStyle(
        animation: .spring(response: 0.5, dampingFraction: 0.8),
        arrowSize: 24,
        arrowColor: .white,
        arrowBackgroundColor: .blue,
        arrowPadding: 12,
        arrowHorizontalPadding: 20,
        indicatorSize: 10,
        indicatorSpacing: 10,
        activeIndicatorColor: .blue,
        inactiveIndicatorColor: Color.gray.opacity(0.2),
        indicatorBottomPadding: 20
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
            AsyncImage(url: URL(string: item.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        ProgressView()
                    )
            }
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
        VStack(spacing: 30) {
            // Basic carousel
            VStack {
                Text("Basic Carousel")
                    .font(.headline)
                
                RRCarousel(
                    data: sampleItems,
                    style: .default,
                    showIndicators: true,
                    showArrows: true
                ) { item in
                    Rectangle()
                        .fill(item.color)
                        .overlay(
                            Text(item.title)
                                .font(.title)
                                .foregroundColor(.white)
                        )
                        .frame(height: 200)
                }
                .frame(height: 200)
            }
            
            // Image carousel
            VStack {
                Text("Image Carousel")
                    .font(.headline)
                
                RRImageCarousel(
                    images: sampleImages,
                    style: .minimal,
                    autoplay: true,
                    showIndicators: true,
                    showArrows: true
                )
                .frame(height: 200)
            }
        }
        .padding()
        .previewDisplayName("RRCarousel")
    }
}
