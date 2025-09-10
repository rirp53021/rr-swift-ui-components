import SwiftUI

/// An async image loader with placeholder and error states
public struct RRAsyncImage<Content: View, Placeholder: View, ErrorView: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    private let errorView: (Error) -> ErrorView
    private let aspectRatio: CGFloat?
    private let contentMode: ContentMode
    
    public init(
        url: URL?,
        aspectRatio: CGFloat? = nil,
        contentMode: ContentMode = .fit,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder errorView: @escaping (Error) -> ErrorView
    ) {
        self.url = url
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
        self.content = content
        self.placeholder = placeholder
        self.errorView = errorView
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholder()
            case .success(let image):
                content(image)
            case .failure(let error):
                errorView(error)
            @unknown default:
                placeholder()
            }
        }
        .aspectRatio(aspectRatio, contentMode: contentMode)
    }
}

// MARK: - Default Views

public struct DefaultPlaceholder: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(theme.colors.surfaceVariant)
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
            )
    }
}

public struct DefaultErrorView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(theme.colors.surfaceVariant)
            .overlay(
                VStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "photo")
                        .font(DesignTokens.Typography.headlineLarge)
                        .foregroundColor(theme.colors.error)
                    RRLabel(
                        "Failed to load image",
                        style: .caption,
                        weight: .medium,
                        color: .secondary
                    )
                }
            )
    }
}

// MARK: - Convenience Initializers

public extension RRAsyncImage where Content == Image, Placeholder == DefaultPlaceholder, ErrorView == DefaultErrorView {
    /// Creates a simple async image with default placeholder and error views
    init(url: URL?, aspectRatio: CGFloat? = nil, contentMode: ContentMode = .fit) {
        self.init(
            url: url,
            aspectRatio: aspectRatio,
            contentMode: contentMode,
            content: { $0 },
            placeholder: { DefaultPlaceholder() },
            errorView: { _ in DefaultErrorView() }
        )
    }
}

// MARK: - Preview

#if DEBUG
struct RRAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        RRAsyncImagePreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRAsyncImage Examples")
    }
}

private struct RRAsyncImagePreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Async Image Examples")
            
            VStack(spacing: DesignTokens.Spacing.md) {
                // Simple async image
                RRAsyncImage(
                    url: URL(string: "https://picsum.photos/200/200")
                )
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.md))
                
                // Custom content
                RRAsyncImage(
                    url: URL(string: "https://picsum.photos/300/200"),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    },
                    placeholder: {
                        Circle()
                            .fill(theme.colors.primary.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                            )
                    },
                    errorView: { _ in
                        Circle()
                            .fill(theme.colors.error.opacity(0.3))
                            .overlay(
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(theme.colors.error)
                            )
                    }
                )
                .frame(width: 100, height: 100)
                
                // Different aspect ratios
                HStack(spacing: DesignTokens.Spacing.md) {
                    RRAsyncImage(
                        url: URL(string: "https://picsum.photos/100/100"),
                        aspectRatio: 1.0
                    )
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm))
                    
                    RRAsyncImage(
                        url: URL(string: "https://picsum.photos/150/100"),
                        aspectRatio: 1.5
                    )
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.sm))
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
