import SwiftUI

/// A customizable image gallery component with design system integration
public struct RRImageGallery: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedIndex = 0
    @State private var isFullscreen = false
    @State private var showThumbnails = true
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    private let images: [GalleryImage]
    private let style: GalleryStyle
    private let layout: GalleryLayout
    private let showThumbnailsNavigation: Bool
    private let showIndicators: Bool
    private let autoPlay: Bool
    private let autoPlayInterval: Double
    private let onImageTap: ((Int) -> Void)?
    private let onImageLongPress: ((Int) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates an image gallery with the specified configuration
    /// - Parameters:
    ///   - images: Array of gallery images
    ///   - style: The gallery style
    ///   - layout: The gallery layout
    ///   - showThumbnails: Whether to show thumbnail navigation
    ///   - showIndicators: Whether to show page indicators
    ///   - autoPlay: Whether to auto-play the gallery
    ///   - autoPlayInterval: Interval between auto-play transitions
    ///   - onImageTap: Callback when an image is tapped
    ///   - onImageLongPress: Callback when an image is long-pressed
    public init(
        images: [GalleryImage],
        style: GalleryStyle = .default,
        layout: GalleryLayout = .carousel,
        showThumbnails: Bool = true,
        showIndicators: Bool = true,
        autoPlay: Bool = false,
        autoPlayInterval: Double = 3.0,
        onImageTap: ((Int) -> Void)? = nil,
        onImageLongPress: ((Int) -> Void)? = nil
    ) {
        self.images = images
        self.style = style
        self.layout = layout
        self.showThumbnailsNavigation = showThumbnails
        self.showIndicators = showIndicators
        self.autoPlay = autoPlay
        self.autoPlayInterval = autoPlayInterval
        self.onImageTap = onImageTap
        self.onImageLongPress = onImageLongPress
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            if images.isEmpty {
                emptyStateView
            } else {
                switch layout {
                case .carousel:
                    carouselView
                case .grid:
                    gridView
                case .stack:
                    stackView
                }
            }
        }
        .frame(maxWidth: .infinity)
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
    
    // MARK: - Carousel View
    
    private var carouselView: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Main Image
            TabView(selection: $selectedIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    galleryImageView(image: image, index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(DefaultTabViewStyle())
            .frame(maxWidth: .infinity, maxHeight: style.mainImageHeight)
            .onTapGesture {
                onImageTap?(selectedIndex)
            }
            .onLongPressGesture {
                onImageLongPress?(selectedIndex)
            }
            
            // Indicators
            if showIndicators && images.count > 1 {
                pageIndicators
            }
            
            // Thumbnails
            if showThumbnailsNavigation && images.count > 1 {
                thumbnailsView
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Grid View
    
    private var gridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DesignTokens.Spacing.sm), count: style.gridColumns), spacing: DesignTokens.Spacing.sm) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                galleryImageView(image: image, index: index)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .cornerRadius(DesignTokens.BorderRadius.sm)
                    .onTapGesture {
                        selectedIndex = index
                        onImageTap?(index)
                    }
                    .onLongPressGesture {
                        onImageLongPress?(index)
                    }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
    
    // MARK: - Stack View
    
    private var stackView: some View {
        ZStack {
            ForEach(Array(images.enumerated().reversed()), id: \.offset) { index, image in
                galleryImageView(image: image, index: index)
                    .scaleEffect(selectedIndex == index ? 1.0 : 0.9)
                    .opacity(selectedIndex == index ? 1.0 : 0.7)
                    .offset(
                        x: CGFloat(index - selectedIndex) * 20,
                        y: CGFloat(index - selectedIndex) * 10
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                        onImageTap?(index)
                    }
                    .onLongPressGesture {
                        onImageLongPress?(index)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: style.mainImageHeight)
        .padding(DesignTokens.Spacing.md)
        .clipped()
    }
    
    // MARK: - Gallery Image View
    
    private func galleryImageView(image: GalleryImage, index: Int) -> some View {
        ZStack {
            RRAsyncImage(
                url: image.url,
                aspectRatio: image.aspectRatio,
                contentMode: .fit
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(image.aspectRatio, contentMode: .fit)
            .clipped()
            .cornerRadius(DesignTokens.BorderRadius.sm)
            
            // Overlay
            if let overlay = image.overlay {
                overlay
            }
            
            // Loading indicator
            if image.isLoading {
                RRLoadingIndicator(style: .spinner, size: DesignTokens.ComponentSize.iconSizeMD)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Page Indicators
    
    private var pageIndicators: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<images.count, id: \.self) { index in
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
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    RRAsyncImage(
                        url: image.url,
                        aspectRatio: 1,
                        contentMode: .fill
                    )
                    .frame(width: 60, height: 60)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .cornerRadius(DesignTokens.BorderRadius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm)
                            .stroke(selectedIndex == index ? style.thumbnailBorderColor : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
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
                    
                    RRLabel("\(selectedIndex + 1) of \(images.count)", style: .subtitle, customColor: .white)
                }
                .padding()
                
                Spacer()
                
                // Image
                if selectedIndex < images.count {
                    galleryImageView(image: images[selectedIndex], index: selectedIndex)
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
                
                Spacer()
                
                // Controls
                HStack {
                    Button(action: previousImage) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .disabled(selectedIndex == 0)
                    
                    Spacer()
                    
                    Button(action: nextImage) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .disabled(selectedIndex == images.count - 1)
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
            
            RRLabel("No Images", style: .subtitle, customColor: style.placeholderColor)
            RRLabel("Add images to display in the gallery", style: .caption, customColor: style.placeholderColor)
        }
        .frame(height: style.mainImageHeight)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Actions
    
    private func previousImage() {
        if selectedIndex > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex -= 1
            }
        }
    }
    
    private func nextImage() {
        if selectedIndex < images.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex += 1
            }
        }
    }
}

// MARK: - Gallery Image

public struct GalleryImage {
    public let url: URL?
    public let placeholder: String?
    public let errorImage: String?
    public let aspectRatio: CGFloat
    public let overlay: AnyView?
    public let isLoading: Bool
    
    public init(
        url: URL?,
        placeholder: String? = nil,
        errorImage: String? = nil,
        aspectRatio: CGFloat = 16/9,
        overlay: AnyView? = nil,
        isLoading: Bool = false
    ) {
        self.url = url
        self.placeholder = placeholder
        self.errorImage = errorImage
        self.aspectRatio = aspectRatio
        self.overlay = overlay
        self.isLoading = isLoading
    }
}

// MARK: - Gallery Style
@MainActor
public struct GalleryStyle {
    public let backgroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let mainImageHeight: CGFloat
    public let gridColumns: Int
    public let indicatorColor: Color
    public let thumbnailBorderColor: Color
    public let placeholderColor: Color
    
    public init(
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        mainImageHeight: CGFloat = 300,
        gridColumns: Int = 3,
        indicatorColor: Color? = nil,
        thumbnailBorderColor: Color? = nil,
        placeholderColor: Color? = nil
    ) {
        self.backgroundColor = backgroundColor ?? Color.clear
        self.borderColor = borderColor ?? Color.gray.opacity(0.3)
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.mainImageHeight = mainImageHeight
        self.gridColumns = gridColumns
        self.indicatorColor = indicatorColor ?? Color.blue
        self.thumbnailBorderColor = thumbnailBorderColor ?? Color.blue
        self.placeholderColor = placeholderColor ?? Color.gray
    }
    
    public static let `default` = GalleryStyle()
    public static let compact = GalleryStyle(
        mainImageHeight: 200,
        gridColumns: 4
    )
    public static let spacious = GalleryStyle(
        mainImageHeight: 400,
        gridColumns: 2
    )
}

// MARK: - Gallery Layout

public enum GalleryLayout {
    case carousel
    case grid
    case stack
}


// MARK: - Previews

#if DEBUG
struct RRImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        RRImageGalleryPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRImageGallery Examples")
    }
}

private struct RRImageGalleryPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let sampleImages = [
        GalleryImage(url: nil, placeholder: "photo", aspectRatio: 16/9),
        GalleryImage(url: nil, placeholder: "photo", aspectRatio: 16/9),
        GalleryImage(url: nil, placeholder: "photo", aspectRatio: 16/9),
        GalleryImage(url: nil, placeholder: "photo", aspectRatio: 16/9),
        GalleryImage(url: nil, placeholder: "photo", aspectRatio: 16/9)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                RRLabel.title("Image Gallery Examples", customColor: theme.colors.onSurface)
                
                // Carousel layout
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Carousel Layout", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRImageGallery(
                        images: sampleImages,
                        style: .default,
                        layout: .carousel,
                        showThumbnails: true,
                        showIndicators: true
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Grid layout
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Grid Layout", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRImageGallery(
                        images: sampleImages,
                        style: .compact,
                        layout: .grid,
                        showThumbnails: false,
                        showIndicators: false
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Stack layout
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Stack Layout", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRImageGallery(
                        images: sampleImages,
                        style: .spacious,
                        layout: .stack,
                        showThumbnails: false,
                        showIndicators: true
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Empty state
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Empty State", style: .subtitle, weight: .semibold, customColor: theme.colors.onSurface)
                    
                    RRImageGallery(
                        images: [],
                        style: .default,
                        layout: .carousel
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
}
#endif
