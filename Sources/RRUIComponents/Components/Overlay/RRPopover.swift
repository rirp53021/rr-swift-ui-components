import SwiftUI

/// A customizable popover component for displaying contextual content
public struct RRPopover<Content: View, PopoverContent: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var isPresented = false
    @State private var contentFrame: CGRect = .zero
    
    private let content: Content
    private let popoverContent: PopoverContent
    private let style: PopoverStyle
    private let attachmentAnchor: SwiftUI.PopoverAttachmentAnchor
    private let arrowEdge: Edge
    private let dismissOnTapOutside: Bool
    private let maxWidth: CGFloat?
    private let maxHeight: CGFloat?
    
    // MARK: - Initialization
    
    /// Creates a popover with the specified content and popover content
    /// - Parameters:
    ///   - style: The popover style
    ///   - attachmentAnchor: The attachment anchor for the popover
    ///   - arrowEdge: The edge where the arrow should appear
    ///   - dismissOnTapOutside: Whether to dismiss when tapping outside
    ///   - maxWidth: The maximum width of the popover
    ///   - maxHeight: The maximum height of the popover
    ///   - content: The content that triggers the popover
    ///   - popoverContent: The popover content to display
    public init(
        style: PopoverStyle = .default,
        attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top,
        dismissOnTapOutside: Bool = true,
        maxWidth: CGFloat? = 300,
        maxHeight: CGFloat? = 400,
        @ViewBuilder content: () -> Content,
        @ViewBuilder popoverContent: () -> PopoverContent
    ) {
        self.content = content()
        self.popoverContent = popoverContent()
        self.style = style
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
        self.dismissOnTapOutside = dismissOnTapOutside
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            contentFrame = geometry.frame(in: .global)
                        }
                        .onChange(of: geometry.frame(in: .global)) { newFrame in
                            contentFrame = newFrame
                        }
                }
            )
            .onTapGesture {
                isPresented.toggle()
            }
            .popover(
                isPresented: $isPresented,
                attachmentAnchor: attachmentAnchor,
                arrowEdge: arrowEdge
            ) {
                popoverView
                    .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                    .modifier(PresentationCompactAdaptationModifier())
            }
    }
    
    // MARK: - Popover View
    
    private var popoverView: some View {
        VStack(spacing: 0) {
            // Header
            if style.showHeader {
                popoverHeader
            }
            
            // Content
            popoverContent
                .padding(style.contentPadding)
            
            // Footer
            if style.showFooter {
                popoverFooter
            }
        }
        .background(style.background)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        )
        .shadow(
            color: style.shadowColor,
            radius: style.shadowRadius,
            x: style.shadowOffset.width,
            y: style.shadowOffset.height
        )
    }
    
    // MARK: - Popover Header
    
    private var popoverHeader: some View {
        HStack {
            if let title = style.title {
                RRLabel(title, style: .subtitle, weight: .semibold, customColor: style.foregroundColor)
            }
            
            Spacer()
            
            if style.showCloseButton {
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(style.foregroundColor)
                        .font(.caption)
                }
            }
        }
        .padding(style.headerPadding)
        .background(style.headerBackground)
        .overlay(
            Rectangle()
                .fill(style.borderColor)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Popover Footer
    
    private var popoverFooter: some View {
        HStack {
            if style.showFooter {
                Spacer()
                
                if let footerText = style.footerText {
                    RRLabel(footerText, style: .caption, customColor: style.foregroundColor.opacity(0.7))
                }
            }
        }
        .padding(style.footerPadding)
        .background(style.footerBackground)
        .overlay(
            Rectangle()
                .fill(style.borderColor)
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Popover Style

public struct PopoverStyle {
    public let background: Color
    public let foregroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    public let contentPadding: EdgeInsets
    public let headerPadding: EdgeInsets
    public let footerPadding: EdgeInsets
    public let showHeader: Bool
    public let showFooter: Bool
    public let showCloseButton: Bool
    public let title: String?
    public let footerText: String?
    public let headerBackground: Color
    public let footerBackground: Color
    
    public init(
        background: Color? = nil,
        foregroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat = 8,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        contentPadding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        headerPadding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.sm,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.sm,
            trailing: DesignTokens.Spacing.md
        ),
        footerPadding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.sm,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.sm,
            trailing: DesignTokens.Spacing.md
        ),
        showHeader: Bool = false,
        showFooter: Bool = false,
        showCloseButton: Bool = true,
        title: String? = nil,
        footerText: String? = nil,
        headerBackground: Color? = nil,
        footerBackground: Color? = nil
    ) {
        self.background = background ?? Color.white
        self.foregroundColor = foregroundColor ?? Color.black
        self.borderColor = borderColor ?? Color.gray.opacity(0.3)
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor ?? Color.black.opacity(0.1)
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.contentPadding = contentPadding
        self.headerPadding = headerPadding
        self.footerPadding = footerPadding
        self.showHeader = showHeader
        self.showFooter = showFooter
        self.showCloseButton = showCloseButton
        self.title = title
        self.footerText = footerText
        self.headerBackground = headerBackground ?? Color.gray.opacity(0.1)
        self.footerBackground = footerBackground ?? Color.gray.opacity(0.05)
    }
    
    public static let `default` = PopoverStyle()
    public static let card = PopoverStyle(
        background: Color.white,
        borderColor: Color.gray.opacity(0.2),
        shadowRadius: 12,
        showHeader: true,
        showCloseButton: true
    )
    public static let minimal = PopoverStyle(
        background: Color.white,
        borderWidth: 0,
        shadowRadius: 4,
        showHeader: false,
        showFooter: false,
        showCloseButton: false
    )
    public static let dark = PopoverStyle(
        background: Color.black,
        foregroundColor: Color.white,
        borderColor: Color.gray.opacity(0.3),
        shadowColor: Color.black.opacity(0.3)
    )
}

// MARK: - Popover Attachment Anchor (using SwiftUI's native type)

// MARK: - Presentation Compact Adaptation Modifier

private struct PresentationCompactAdaptationModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 13.3, iOS 16.4, tvOS 16.4, watchOS 9.4, *) {
            content.presentationCompactAdaptation(.popover)
        } else {
            content
        }
    }
}

// MARK: - Popover Extensions

public extension RRPopover {
    
    /// Creates a popover with a title
    static func withTitle(
        _ title: String,
        style: PopoverStyle = .card,
        attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top,
        dismissOnTapOutside: Bool = true,
        maxWidth: CGFloat? = 300,
        maxHeight: CGFloat? = 400,
        @ViewBuilder content: () -> Content,
        @ViewBuilder popoverContent: () -> PopoverContent
    ) -> RRPopover<Content, PopoverContent> {
        RRPopover(
            style: PopoverStyle(
                background: style.background,
                foregroundColor: style.foregroundColor,
                borderColor: style.borderColor,
                borderWidth: style.borderWidth,
                cornerRadius: style.cornerRadius,
                shadowColor: style.shadowColor,
                shadowRadius: style.shadowRadius,
                shadowOffset: style.shadowOffset,
                contentPadding: style.contentPadding,
                headerPadding: style.headerPadding,
                footerPadding: style.footerPadding,
                showHeader: true,
                showFooter: style.showFooter,
                showCloseButton: style.showCloseButton,
                title: title,
                footerText: style.footerText,
                headerBackground: style.headerBackground,
                footerBackground: style.footerBackground
            ),
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge,
            dismissOnTapOutside: dismissOnTapOutside,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            content: content,
            popoverContent: popoverContent
        )
    }
    
    /// Creates a minimal popover without header or footer
    static func minimal(
        attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge = .top,
        dismissOnTapOutside: Bool = true,
        maxWidth: CGFloat? = 300,
        maxHeight: CGFloat? = 400,
        @ViewBuilder content: () -> Content,
        @ViewBuilder popoverContent: () -> PopoverContent
    ) -> RRPopover<Content, PopoverContent> {
        RRPopover(
            style: .minimal,
            attachmentAnchor: attachmentAnchor,
            arrowEdge: arrowEdge,
            dismissOnTapOutside: dismissOnTapOutside,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            content: content,
            popoverContent: popoverContent
        )
    }
}

// MARK: - Previews

#if DEBUG
struct RRPopover_Previews: PreviewProvider {
    static var previews: some View {
        RRPopoverPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRPopover Examples")
    }
}

private struct RRPopoverPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Popover Examples")
            
            // Basic popovers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Popovers", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRPopover {
                        RRButton("Default Popover", style: .primary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Popover Content", style: .subtitle, weight: .semibold)
                            RRLabel("This is a basic popover with some content.", style: .body)
                            RRLabel("It can contain any SwiftUI view.", style: .body)
                        }
                    }
                    
                    RRPopover.withTitle("Card Popover") {
                        RRButton("Card Popover", style: .secondary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This popover has a header with a title.", style: .body)
                            RRLabel("It also includes a close button.", style: .body)
                        }
                    }
                    
                    RRPopover.minimal {
                        RRButton("Minimal Popover", style: .secondary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Minimal popover", style: .subtitle, weight: .semibold)
                            RRLabel("No header or footer", style: .body)
                        }
                    }
                }
            }
            
            // Styled popovers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Styled Popovers", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRPopover(
                        style: .dark
                    ) {
                        RRButton("Dark Popover", style: .primary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Dark Theme", style: .subtitle, weight: .semibold, customColor: .white)
                            RRLabel("This popover uses a dark theme.", style: .body, customColor: .white)
                        }
                    }
                    
                    RRPopover(
                        style: PopoverStyle(
                            background: theme.colors.primary,
                            foregroundColor: theme.colors.onPrimary,
                            borderColor: theme.colors.primary,
                            cornerRadius: DesignTokens.BorderRadius.lg
                        )
                    ) {
                        RRButton("Primary Popover", style: .secondary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Primary Theme", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This popover uses the primary theme color.", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                }
            }
            
            // Complex popovers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Complex Popovers", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRPopover.withTitle(
                        "Settings",
                        maxWidth: 250
                    ) {
                        RRButton("Settings", style: .primary) {}
                    } popoverContent: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            RRLabel("Appearance", style: .subtitle, weight: .semibold)
                            
                            HStack {
                                RRLabel("Dark Mode", style: .body)
                                Spacer()
                                RRToggle(isOn: .constant(false))
                            }
                            
                            HStack {
                                RRLabel("Notifications", style: .body)
                                Spacer()
                                RRToggle(isOn: .constant(false))
                            }
                            
                            RRDivider()
                            
                            RRLabel("Privacy", style: .subtitle, weight: .semibold)
                            
                            HStack {
                                RRLabel("Analytics", style: .body)
                                Spacer()
                                RRToggle(isOn: .constant(false))
                            }
                        }
                    }
                    
                    RRPopover.withTitle(
                        "User Profile",
                        maxWidth: 200
                    ) {
                        RRButton("Profile", style: .secondary) {}
                    } popoverContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                                RRAvatar(
                                    image: nil,
                                    size: .md,
                                    style: .circle
                                )
                            } else {
                                Circle()
                                    .fill(theme.colors.primary)
                                    .frame(width: 40, height: 40)
                            }
                            
                            RRLabel("John Doe", style: .subtitle, weight: .semibold, alignment: .center)
                            RRLabel("john.doe@example.com", style: .caption, color: .secondary, alignment: .center)
                            
                            RRDivider()
                            
                            VStack(spacing: DesignTokens.Spacing.sm) {
                                RRButton("Edit Profile", style: .primary, size: .sm) {}
                                RRButton("Sign Out", style: .secondary, size: .sm) {}
                            }
                        }
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
