import SwiftUI
import Foundation

// MARK: - Rating Component

/// A customizable rating component with various styles (stars, hearts, etc.)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRRating: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var rating: Double
    @State private var hoverRating: Double = 0
    
    private let maxRating: Int
    private let style: RatingStyle
    private let size: CGFloat
    private let spacing: CGFloat
    private let isInteractive: Bool
    private let onRatingChanged: ((Double) -> Void)?
    
    public init(
        rating: Binding<Double>,
        maxRating: Int = 5,
        style: RatingStyle = .stars,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeLG,
        spacing: CGFloat = DesignTokens.Spacing.xs,
        isInteractive: Bool = true,
        onRatingChanged: ((Double) -> Void)? = nil
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.style = style
        self.size = size
        self.spacing = spacing
        self.isInteractive = isInteractive
        self.onRatingChanged = onRatingChanged
    }
    
    private var displayRating: Double {
        isInteractive ? hoverRating : rating
    }
    
    private func updateRating(at index: Int) {
        guard isInteractive else { return }
        
        let newRating = Double(index + 1)
        rating = newRating
        onRatingChanged?(newRating)
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<maxRating, id: \.self) { index in
                Button(action: {
                    updateRating(at: index)
                }) {
                    Image(systemName: style.iconName)
                        .font(.system(size: size, weight: .medium))
                        .foregroundColor(style.color(for: Double(index + 1), displayRating: displayRating, theme: theme))
                        .scaleEffect(style.scaleEffect(for: Double(index + 1), displayRating: displayRating))
                        .animation(.easeInOut(duration: 0.1), value: displayRating)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isInteractive)
                .onHover { isHovering in
                    if isInteractive {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            hoverRating = isHovering ? Double(index + 1) : rating
                        }
                    }
                }
            }
        }
        .onAppear {
            hoverRating = rating
        }
        .onChange(of: rating) { newRating in
            hoverRating = newRating
        }
    }
}

// MARK: - Rating Style

public enum RatingStyle {
    case stars
    case hearts
    case thumbs
    case circles
    case diamonds
    case custom(iconName: String)
    
    var iconName: String {
        switch self {
        case .stars: return "star"
        case .hearts: return "heart"
        case .thumbs: return "hand.thumbsup"
        case .circles: return "circle.fill"
        case .diamonds: return "diamond.fill"
        case .custom(let iconName): return iconName
        }
    }
    
    func color(for value: Double, displayRating: Double, theme: Theme) -> Color {
        if value <= displayRating {
            switch self {
            case .stars: return theme.colors.warning
            case .hearts: return theme.colors.error
            case .thumbs: return theme.colors.success
            case .circles: return theme.colors.primary
            case .diamonds: return theme.colors.secondary
            case .custom: return theme.colors.primary
            }
        } else {
            return theme.colors.outline
        }
    }
    
    func scaleEffect(for value: Double, displayRating: Double) -> CGFloat {
        if value <= displayRating {
            return 1.0
        } else {
            return 0.8
        }
    }
}

// MARK: - Read-Only Rating

/// A read-only rating display component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRReadOnlyRating: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let rating: Double
    private let maxRating: Int
    private let style: RatingStyle
    private let size: CGFloat
    private let spacing: CGFloat
    private let showText: Bool
    private let textFormat: String
    
    public init(
        rating: Double,
        maxRating: Int = 5,
        style: RatingStyle = .stars,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeMD,
        spacing: CGFloat = DesignTokens.Spacing.xs,
        showText: Bool = false,
        textFormat: String = "%.1f/5"
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.style = style
        self.size = size
        self.spacing = spacing
        self.showText = showText
        self.textFormat = textFormat
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            HStack(spacing: spacing) {
                ForEach(0..<maxRating, id: \.self) { index in
                    Image(systemName: style.iconName)
                        .font(.system(size: size, weight: .medium))
                        .foregroundColor(style.color(for: Double(index + 1), displayRating: rating, theme: theme))
                }
            }
            
            if showText {
                RRLabel(String(format: textFormat, rating), style: .caption, weight: .regular, color: .secondary)
            }
        }
    }
}

// MARK: - Rating Input with Labels

/// A rating input component with custom labels
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRRatingInput: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var rating: Double
    @State private var hoverRating: Double = 0
    
    private let maxRating: Int
    private let style: RatingStyle
    private let size: CGFloat
    private let spacing: CGFloat
    private let labels: [String]
    private let onRatingChanged: ((Double) -> Void)?
    
    public init(
        rating: Binding<Double>,
        maxRating: Int = 5,
        style: RatingStyle = .stars,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeXL,
        spacing: CGFloat = DesignTokens.Spacing.sm,
        labels: [String] = [],
        onRatingChanged: ((Double) -> Void)? = nil
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.style = style
        self.size = size
        self.spacing = spacing
        self.labels = labels
        self.onRatingChanged = onRatingChanged
    }
    
    private var displayRating: Double {
        hoverRating > 0 ? hoverRating : rating
    }
    
    private func updateRating(at index: Int) {
        let newRating = Double(index + 1)
        rating = newRating
        onRatingChanged?(newRating)
    }
    
    public var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: spacing) {
                ForEach(0..<maxRating, id: \.self) { index in
                    VStack(spacing: DesignTokens.Spacing.xs) {
                        Button(action: {
                            updateRating(at: index)
                        }) {
                            Image(systemName: style.iconName)
                                .font(.system(size: size, weight: .medium))
                                .foregroundColor(style.color(for: Double(index + 1), displayRating: displayRating, theme: theme))
                                .scaleEffect(style.scaleEffect(for: Double(index + 1), displayRating: displayRating))
                                .animation(.easeInOut(duration: 0.1), value: displayRating)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { isHovering in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                hoverRating = isHovering ? Double(index + 1) : rating
                            }
                        }
                        
                        if index < labels.count {
                            RRLabel(labels[index], style: .caption, weight: .regular, color: .secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            
            if rating > 0 {
                RRLabel("Rating: \(String(format: "%.1f", rating))/\(maxRating)", style: .caption, weight: .regular, color: .secondary)
            }
        }
        .onAppear {
            hoverRating = rating
        }
        .onChange(of: rating) { newRating in
            hoverRating = newRating
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRRating_Previews: PreviewProvider {
    @State static var rating = 3.5
    @State static var readOnlyRating = 4.2
    @State static var inputRating = 0.0
    
    static var previews: some View {
        RRRatingPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRRating Examples")
    }
}

private struct RRRatingPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var rating = 3.5
    @State private var readOnlyRating = 4.2
    @State private var inputRating = 0.0
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            // Interactive star rating
            VStack {
                RRLabel("Interactive Star Rating", style: .title, weight: .bold, color: .primary)
                RRRating(
                    rating: $rating,
                    maxRating: 5,
                    style: .stars,
                    size: DesignTokens.ComponentSize.iconSizeXL
                )
                RRLabel("Current: \(String(format: "%.1f", rating))", style: .caption, weight: .regular, color: .secondary)
            }
            
            // Read-only ratings
            VStack {
                RRLabel("Read-Only Ratings", style: .title, weight: .bold, color: .primary)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRReadOnlyRating(
                        rating: readOnlyRating,
                        style: .stars,
                        showText: true
                    )
                    
                    RRReadOnlyRating(
                        rating: 4.0,
                        style: .hearts,
                        size: DesignTokens.ComponentSize.iconSizeMD
                    )
                    
                    RRReadOnlyRating(
                        rating: 3.0,
                        style: .thumbs,
                        size: DesignTokens.ComponentSize.iconSizeMD
                    )
                }
            }
            
            // Rating input with labels
            VStack {
                RRLabel("Rating Input with Labels", style: .title, weight: .bold, color: .primary)
                RRRatingInput(
                    rating: $inputRating,
                    maxRating: 5,
                    style: .stars,
                    labels: ["Poor", "Fair", "Good", "Very Good", "Excellent"]
                )
            }
            
            // Different styles
            VStack {
                RRLabel("Different Styles", style: .title, weight: .bold, color: .primary)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRRating(
                        rating: .constant(4.0),
                        style: .hearts,
                        size: DesignTokens.ComponentSize.iconSizeMD,
                        isInteractive: false
                    )
                    
                    RRRating(
                        rating: .constant(3.0),
                        style: .thumbs,
                        size: DesignTokens.ComponentSize.iconSizeMD,
                        isInteractive: false
                    )
                    
                    RRRating(
                        rating: .constant(5.0),
                        style: .circles,
                        size: DesignTokens.ComponentSize.iconSizeMD,
                        isInteractive: false
                    )
                }
            }
        }
        .padding(DesignTokens.Spacing.componentPadding)
    }
}
