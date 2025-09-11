import SwiftUI

/// A customizable tooltip component for displaying contextual information
public struct RRTooltip<Content: View, TooltipContent: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var isVisible = false
    @State private var tooltipFrame: CGRect = .zero
    @State private var contentFrame: CGRect = .zero
    
    private let content: Content
    private let tooltipContent: TooltipContent
    private let style: TooltipStyle
    private let position: TooltipPosition
    private let trigger: TooltipTrigger
    private let delay: Double
    private let duration: Double
    private let maxWidth: CGFloat?
    private let showArrow: Bool
    
    // MARK: - Initialization
    
    /// Creates a tooltip with the specified content and tooltip content
    /// - Parameters:
    ///   - style: The tooltip style
    ///   - position: The tooltip position
    ///   - trigger: The trigger for showing the tooltip
    ///   - delay: The delay before showing the tooltip
    ///   - duration: The duration to show the tooltip (0 = until manually dismissed)
    ///   - maxWidth: The maximum width of the tooltip
    ///   - showArrow: Whether to show an arrow pointing to the content
    ///   - content: The content that triggers the tooltip
    ///   - tooltipContent: The tooltip content to display
    public init(
        style: TooltipStyle = .default,
        position: TooltipPosition = .top,
        trigger: TooltipTrigger = .hover,
        delay: Double = 0.5,
        duration: Double = 0,
        maxWidth: CGFloat? = 200,
        showArrow: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder tooltipContent: () -> TooltipContent
    ) {
        self.content = content()
        self.tooltipContent = tooltipContent()
        self.style = style
        self.position = position
        self.trigger = trigger
        self.delay = delay
        self.duration = duration
        self.maxWidth = maxWidth
        self.showArrow = showArrow
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Content
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
                    if trigger == .tap {
                        toggleTooltip()
                    }
                }
                .onHover { isHovering in
                    if trigger == .hover {
                        if isHovering {
                            showTooltip()
                        } else {
                            hideTooltip()
                        }
                    }
                }
            
            // Tooltip
            if isVisible {
                tooltipView
                    .zIndex(DesignTokens.ZIndex.tooltip)
            }
        }
    }
    
    // MARK: - Tooltip View
    
    private var tooltipView: some View {
        VStack(spacing: 0) {
            if position == .bottom && showArrow {
                arrowView
            }
            
            tooltipContent
                .padding(style.padding)
                .frame(maxWidth: maxWidth)
                .background(style.background)
                .foregroundColor(style.foregroundColor)
                .cornerRadius(style.cornerRadius)
                .shadow(
                    color: style.shadowColor,
                    radius: style.shadowRadius,
                    x: style.shadowOffset.width,
                    y: style.shadowOffset.height
                )
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                tooltipFrame = geometry.frame(in: .global)
                            }
                    }
                )
            
            if position == .top && showArrow {
                arrowView
            }
        }
        .position(tooltipPosition)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 0.8).combined(with: .opacity)
        ))
        .animation(.easeInOut(duration: 0.2), value: isVisible)
    }
    
    // MARK: - Arrow View
    
    private var arrowView: some View {
        Triangle()
            .fill(style.background)
            .frame(width: 12, height: 8)
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                x: style.shadowOffset.width,
                y: style.shadowOffset.height
            )
    }
    
    // MARK: - Computed Properties
    
    private var tooltipPosition: CGPoint {
        let contentCenter = CGPoint(
            x: contentFrame.midX,
            y: contentFrame.midY
        )
        
        let offset: CGFloat = 8
        
        switch position {
        case .top:
            return CGPoint(
                x: contentCenter.x,
                y: contentFrame.minY - offset
            )
        case .bottom:
            return CGPoint(
                x: contentCenter.x,
                y: contentFrame.maxY + offset
            )
        case .leading:
            return CGPoint(
                x: contentFrame.minX - offset,
                y: contentCenter.y
            )
        case .trailing:
            return CGPoint(
                x: contentFrame.maxX + offset,
                y: contentCenter.y
            )
        }
    }
    
    // MARK: - Actions
    
    private func showTooltip() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                isVisible = true
            }
            
            if duration > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    hideTooltip()
                }
            }
        }
    }
    
    private func hideTooltip() {
        withAnimation {
            isVisible = false
        }
    }
    
    private func toggleTooltip() {
        if isVisible {
            hideTooltip()
        } else {
            showTooltip()
        }
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Tooltip Style

public struct TooltipStyle {
    public let background: Color
    public let foregroundColor: Color
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    
    public init(
        background: Color? = nil,
        foregroundColor: Color? = nil,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.sm,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.sm,
            trailing: DesignTokens.Spacing.md
        ),
        cornerRadius: CGFloat = DesignTokens.BorderRadius.sm,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat = 4,
        shadowOffset: CGSize = CGSize(width: 0, height: 2)
    ) {
        self.background = background ?? Color.black.opacity(0.8)
        self.foregroundColor = foregroundColor ?? Color.white
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor ?? Color.black.opacity(0.2)
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
    public static let `default` = TooltipStyle()
    public static let light = TooltipStyle(
        background: Color.white,
        foregroundColor: Color.black,
        shadowColor: Color.black.opacity(0.1)
    )
    public static let dark = TooltipStyle(
        background: Color.black,
        foregroundColor: Color.white,
        shadowColor: Color.black.opacity(0.3)
    )
    public static let primary = TooltipStyle(
        background: Color.blue,
        foregroundColor: Color.white,
        shadowColor: Color.blue.opacity(0.3)
    )
}

// MARK: - Tooltip Position

public enum TooltipPosition {
    case top
    case bottom
    case leading
    case trailing
}

// MARK: - Tooltip Trigger

public enum TooltipTrigger {
    case hover
    case tap
    case focus
}

// MARK: - Previews

#if DEBUG
struct RRTooltip_Previews: PreviewProvider {
    static var previews: some View {
        RRTooltipPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRTooltip Examples")
    }
}

private struct RRTooltipPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Tooltip Examples")
            
            // Basic tooltips
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Tooltips", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRTooltip(position: .top) {
                        RRButton("Top Tooltip", style: .primary) {}
                    } tooltipContent: {
                        RRLabel("This is a top tooltip", style: .caption, customColor: .white)
                    }
                    
                    RRTooltip(position: .bottom) {
                        RRButton("Bottom Tooltip", style: .secondary) {}
                    } tooltipContent: {
                        RRLabel("This is a bottom tooltip", style: .caption, customColor: .white)
                    }
                    
                    RRTooltip(position: .leading) {
                        RRButton("Left Tooltip", style: .secondary) {}
                    } tooltipContent: {
                        RRLabel("This is a left tooltip", style: .caption, customColor: .white)
                    }
                    
                    RRTooltip(position: .trailing) {
                        RRButton("Right Tooltip", style: .primary) {}
                    } tooltipContent: {
                        RRLabel("This is a right tooltip", style: .caption, customColor: .white)
                    }
                }
            }
            
            // Styled tooltips
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Styled Tooltips", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRTooltip(
                        style: .light,
                        position: .top
                    ) {
                        RRButton("Light Tooltip", style: .primary) {}
                    } tooltipContent: {
                        RRLabel("Light style tooltip", style: .caption, customColor: .black)
                    }
                    
                    RRTooltip(
                        style: .dark,
                        position: .top
                    ) {
                        RRButton("Dark Tooltip", style: .secondary) {}
                    } tooltipContent: {
                        RRLabel("Dark style tooltip", style: .caption, customColor: .white)
                    }
                    
                    RRTooltip(
                        style: .primary,
                        position: .top
                    ) {
                        RRButton("Primary Tooltip", style: .secondary) {}
                    } tooltipContent: {
                        RRLabel("Primary style tooltip", style: .caption, customColor: .white)
                    }
                }
            }
            
            // Trigger types
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Trigger Types", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRTooltip(
                        position: .top,
                        trigger: .hover
                    ) {
                        RRButton("Hover Trigger", style: .primary) {}
                    } tooltipContent: {
                        RRLabel("Hover to show", style: .caption, customColor: .white)
                    }
                    
                    RRTooltip(
                        position: .top,
                        trigger: .tap
                    ) {
                        RRButton("Tap Trigger", style: .secondary) {}
                    } tooltipContent: {
                        RRLabel("Tap to show", style: .caption, customColor: .white)
                    }
                }
            }
            
            // Custom tooltips
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Custom Tooltips", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RRTooltip(
                        style: TooltipStyle(
                            background: theme.colors.success,
                            foregroundColor: theme.colors.onSuccess,
                            cornerRadius: DesignTokens.BorderRadius.lg
                        ),
                        position: .top,
                        maxWidth: 150
                    ) {
                        RRButton("Success Tooltip", style: .primary) {}
                    } tooltipContent: {
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLabel("Success!", style: .caption, weight: .semibold, customColor: theme.colors.onSuccess)
                            RRLabel("Operation completed", style: .caption, customColor: theme.colors.onSuccess)
                        }
                    }
                    
                    RRTooltip(
                        style: TooltipStyle(
                            background: theme.colors.error,
                            foregroundColor: theme.colors.onError,
                            cornerRadius: DesignTokens.BorderRadius.lg
                        ),
                        position: .top,
                        maxWidth: 150
                    ) {
                        RRButton("Error Tooltip", style: .primary) {}
                    } tooltipContent: {
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            RRLabel("Error!", style: .caption, weight: .semibold, customColor: theme.colors.onError)
                            RRLabel("Something went wrong", style: .caption, customColor: theme.colors.onError)
                        }
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
