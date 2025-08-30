import SwiftUI

/// Represents the typography system for UI components
public struct Typography {
    /// Large title text style
    public let largeTitle: Font
    /// Title text style
    public let title: Font
    /// Title 2 text style
    public let title2: Font
    /// Title 3 text style
    public let title3: Font
    /// Headline text style
    public let headline: Font
    /// Body text style
    public let body: Font
    /// Callout text style
    public let callout: Font
    /// Subheadline text style
    public let subheadline: Font
    /// Footnote text style
    public let footnote: Font
    /// Caption text style
    public let caption: Font
    /// Caption 2 text style
    public let caption2: Font
    
    /// Creates a new typography system
    /// - Parameters:
    ///   - largeTitle: Large title font
    ///   - title: Title font
    ///   - title2: Title 2 font
    ///   - title3: Title 3 font
    ///   - headline: Headline font
    ///   - body: Body font
    ///   - callout: Callout font
    ///   - subheadline: Subheadline font
    ///   - footnote: Footnote font
    ///   - caption: Caption font
    ///   - caption2: Caption 2 font
    public init(
        largeTitle: Font,
        title: Font,
        title2: Font,
        title3: Font,
        headline: Font,
        body: Font,
        callout: Font,
        subheadline: Font,
        footnote: Font,
        caption: Font,
        caption2: Font
    ) {
        self.largeTitle = largeTitle
        self.title = title
        self.title2 = title2
        self.title3 = title3
        self.headline = headline
        self.body = body
        self.callout = callout
        self.subheadline = subheadline
        self.footnote = footnote
        self.caption = caption
        self.caption2 = caption2
    }
}

// MARK: - Default Typography
public extension Typography {
    /// Default typography system using system fonts
    static let `default` = Typography(
        largeTitle: .largeTitle,
        title: .title,
        title2: .title2,
        title3: .title3,
        headline: .headline,
        body: .body,
        callout: .callout,
        subheadline: .subheadline,
        footnote: .footnote,
        caption: .caption,
        caption2: .caption2
    )
    
    /// Typography system with rounded design
    static let rounded = Typography(
        largeTitle: .system(.largeTitle, design: .rounded),
        title: .system(.title, design: .rounded),
        title2: .system(.title2, design: .rounded),
        title3: .system(.title3, design: .rounded),
        headline: .system(.headline, design: .rounded),
        body: .system(.body, design: .rounded),
        callout: .system(.callout, design: .rounded),
        subheadline: .system(.subheadline, design: .rounded),
        footnote: .system(.footnote, design: .rounded),
        caption: .system(.caption, design: .rounded),
        caption2: .system(.caption2, design: .rounded)
    )
    
    /// Typography system with monospaced design
    static let monospaced = Typography(
        largeTitle: .system(.largeTitle, design: .monospaced),
        title: .system(.title, design: .monospaced),
        title2: .system(.title2, design: .monospaced),
        title3: .system(.title3, design: .monospaced),
        headline: .system(.headline, design: .monospaced),
        body: .system(.body, design: .monospaced),
        callout: .system(.callout, design: .monospaced),
        subheadline: .system(.subheadline, design: .monospaced),
        footnote: .system(.footnote, design: .monospaced),
        caption: .system(.caption, design: .monospaced),
        caption2: .system(.caption2, design: .monospaced)
    )
}

// MARK: - Typography Modifiers
public extension View {
    /// Applies large title typography
    func largeTitleStyle() -> some View {
        self.font(.largeTitle)
    }
    
    /// Applies title typography
    func titleStyle() -> some View {
        self.font(.title)
    }
    
    /// Applies title 2 typography
    func title2Style() -> some View {
        self.font(.title2)
    }
    
    /// Applies title 3 typography
    func title3Style() -> some View {
        self.font(.title3)
    }
    
    /// Applies headline typography
    func headlineStyle() -> some View {
        self.font(.headline)
    }
    
    /// Applies body typography
    func bodyStyle() -> some View {
        self.font(.body)
    }
    
    /// Applies callout typography
    func calloutStyle() -> some View {
        self.font(.callout)
    }
    
    /// Applies subheadline typography
    func subheadlineStyle() -> some View {
        self.font(.subheadline)
    }
    
    /// Applies footnote typography
    func footnoteStyle() -> some View {
        self.font(.footnote)
    }
    
    /// Applies caption typography
    func captionStyle() -> some View {
        self.font(.caption)
    }
    
    /// Applies caption 2 typography
    func caption2Style() -> some View {
        self.font(.caption2)
    }
}

