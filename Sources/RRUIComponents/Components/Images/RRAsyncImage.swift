import SwiftUI

/// An async image loader with placeholder and error states
public struct RRAsyncImage<Content: View, Placeholder: View, ErrorView: View>: View {
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
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            )
    }
}

public struct DefaultErrorView: View {
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Failed to load image")
                        .font(.caption)
                        .foregroundColor(.gray)
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
        VStack(spacing: 20) {
            // Simple async image
            RRAsyncImage(
                url: URL(string: "https://picsum.photos/200/200")
            )
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
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
                        .fill(Color.blue.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        )
                },
                errorView: { _ in
                    Circle()
                        .fill(Color.red.opacity(0.3))
                        .overlay(
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                        )
                }
            )
            .frame(width: 100, height: 100)
            
            // Different aspect ratios
            HStack(spacing: 16) {
                RRAsyncImage(
                    url: URL(string: "https://picsum.photos/100/100"),
                    aspectRatio: 1.0
                )
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                RRAsyncImage(
                    url: URL(string: "https://picsum.photos/150/100"),
                    aspectRatio: 1.5
                )
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .previewDisplayName("RRAsyncImage")
    }
}
#endif
