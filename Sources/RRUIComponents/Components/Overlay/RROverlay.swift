import SwiftUI
import Combine

/// A generic overlay component for displaying content over other views
public struct RROverlay<Content: View, OverlayContent: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var isPresented = false
    
    private let content: Content
    private let overlayContent: OverlayContent
    private let style: OverlayStyle
    private let animation: Animation
    private let dismissOnTapOutside: Bool
    private let dismissOnTapOverlay: Bool
    
    // MARK: - Initialization
    
    /// Creates an overlay with the specified content and overlay content
    /// - Parameters:
    ///   - style: The overlay style
    ///   - animation: The animation for showing/hiding the overlay
    ///   - dismissOnTapOutside: Whether to dismiss when tapping outside the overlay
    ///   - dismissOnTapOverlay: Whether to dismiss when tapping the overlay itself
    ///   - content: The content that triggers the overlay
    ///   - overlayContent: The overlay content to display
    public init(
        style: OverlayStyle = .default,
        animation: Animation = .easeInOut(duration: 0.3),
        dismissOnTapOutside: Bool = true,
        dismissOnTapOverlay: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlayContent: () -> OverlayContent
    ) {
        self.content = content()
        self.overlayContent = overlayContent()
        self.style = style
        self.animation = animation
        self.dismissOnTapOutside = dismissOnTapOutside
        self.dismissOnTapOverlay = dismissOnTapOverlay
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Content
            content
                .onTapGesture {
                    showOverlay()
                }
            
            // Overlay
            if isPresented {
                overlayView
                    .zIndex(DesignTokens.ZIndex.overlay)
            }
        }
    }
    
    // MARK: - Overlay View
    
    private var overlayView: some View {
        ZStack {
            // Background
            if style.showBackground {
                backgroundView
                    .onTapGesture {
                        if dismissOnTapOutside {
                            hideOverlay()
                        }
                    }
            }
            
            // Overlay content
            overlayContent
                .padding(style.contentPadding)
                .background(style.background)
                .cornerRadius(style.cornerRadius)
                .shadow(
                    color: style.shadowColor,
                    radius: style.shadowRadius,
                    x: style.shadowOffset.width,
                    y: style.shadowOffset.height
                )
                .onTapGesture {
                    if dismissOnTapOverlay {
                        hideOverlay()
                    }
                }
        }
        .transition(style.transition)
        .animation(animation, value: isPresented)
    }
    
    // MARK: - Background View
    
    private var backgroundView: some View {
        Rectangle()
            .fill(style.backgroundColor)
            .ignoresSafeArea()
    }
    
    // MARK: - Actions
    
    private func showOverlay() {
        withAnimation(animation) {
            isPresented = true
        }
    }
    
    private func hideOverlay() {
        withAnimation(animation) {
            isPresented = false
        }
    }
}

// MARK: - Overlay Style

public struct OverlayStyle {
    public let background: Color
    public let backgroundColor: Color
    public let contentPadding: EdgeInsets
    public let cornerRadius: CGFloat
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    public let showBackground: Bool
    public let transition: AnyTransition
    
    public init(
        background: Color? = nil,
        backgroundColor: Color? = nil,
        contentPadding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        cornerRadius: CGFloat = DesignTokens.BorderRadius.lg,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat = 12,
        shadowOffset: CGSize = CGSize(width: 0, height: 6),
        showBackground: Bool = true,
        transition: AnyTransition = .opacity.combined(with: .scale(scale: 0.9))
    ) {
        self.background = background ?? Color.white
        self.backgroundColor = backgroundColor ?? Color.black.opacity(0.5)
        self.contentPadding = contentPadding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor ?? Color.black.opacity(0.2)
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.showBackground = showBackground
        self.transition = transition
    }
    
    public static let `default` = OverlayStyle()
    public static let modal = OverlayStyle(
        background: Color.white,
        backgroundColor: Color.black.opacity(0.6),
        cornerRadius: DesignTokens.BorderRadius.xl,
        shadowRadius: 20,
        transition: .asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 0.8).combined(with: .opacity)
        )
    )
    public static let sheet = OverlayStyle(
        background: Color.white,
        backgroundColor: Color.black.opacity(0.4),
        cornerRadius: DesignTokens.BorderRadius.lg,
        transition: .move(edge: .bottom).combined(with: .opacity)
    )
    public static let alert = OverlayStyle(
        background: Color.white,
        backgroundColor: Color.black.opacity(0.7),
        cornerRadius: DesignTokens.BorderRadius.md,
        shadowRadius: 16,
        transition: .scale(scale: 0.9).combined(with: .opacity)
    )
    public static let transparent = OverlayStyle(
        background: Color.clear,
        backgroundColor: Color.clear,
        showBackground: false,
        transition: .opacity
    )
}

// MARK: - Overlay Extensions

public extension RROverlay {
    
    /// Creates a modal overlay
    static func modal(
        animation: Animation = .easeInOut(duration: 0.3),
        dismissOnTapOutside: Bool = true,
        dismissOnTapOverlay: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlayContent: () -> OverlayContent
    ) -> RROverlay<Content, OverlayContent> {
        RROverlay(
            style: .modal,
            animation: animation,
            dismissOnTapOutside: dismissOnTapOutside,
            dismissOnTapOverlay: dismissOnTapOverlay,
            content: content,
            overlayContent: overlayContent
        )
    }
    
    /// Creates a sheet overlay
    static func sheet(
        animation: Animation = .easeInOut(duration: 0.3),
        dismissOnTapOutside: Bool = true,
        dismissOnTapOverlay: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlayContent: () -> OverlayContent
    ) -> RROverlay<Content, OverlayContent> {
        RROverlay(
            style: .sheet,
            animation: animation,
            dismissOnTapOutside: dismissOnTapOutside,
            dismissOnTapOverlay: dismissOnTapOverlay,
            content: content,
            overlayContent: overlayContent
        )
    }
    
    /// Creates an alert overlay
    static func alert(
        animation: Animation = .easeInOut(duration: 0.2),
        dismissOnTapOutside: Bool = true,
        dismissOnTapOverlay: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlayContent: () -> OverlayContent
    ) -> RROverlay<Content, OverlayContent> {
        RROverlay(
            style: .alert,
            animation: animation,
            dismissOnTapOutside: dismissOnTapOutside,
            dismissOnTapOverlay: dismissOnTapOverlay,
            content: content,
            overlayContent: overlayContent
        )
    }
    
    /// Creates a transparent overlay
    static func transparent(
        animation: Animation = .easeInOut(duration: 0.3),
        dismissOnTapOutside: Bool = true,
        dismissOnTapOverlay: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlayContent: () -> OverlayContent
    ) -> RROverlay<Content, OverlayContent> {
        RROverlay(
            style: .transparent,
            animation: animation,
            dismissOnTapOutside: dismissOnTapOutside,
            dismissOnTapOverlay: dismissOnTapOverlay,
            content: content,
            overlayContent: overlayContent
        )
    }
}

// MARK: - Overlay Manager

public class RROverlayManager: ObservableObject {
    @Published public var isPresented = false
    @Published public var content: AnyView?
    
    public init() {}
    
    public func show<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
        withAnimation {
            isPresented = true
        }
    }
    
    public func hide() {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.content = nil
        }
    }
}

// MARK: - Previews

#if DEBUG
struct RROverlay_Previews: PreviewProvider {
    static var previews: some View {
        RROverlayPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RROverlay Examples")
    }
}

private struct RROverlayPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Overlay Examples")
            
            // Basic overlays
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Overlays", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RROverlay {
                        RRButton("Default Overlay", style: .primary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Default Overlay", style: .title, weight: .semibold)
                            RRLabel("This is a default overlay with a semi-transparent background.", style: .body)
                            RRButton("Close", style: .secondary) {}
                        }
                    }
                    
                    RROverlay.modal {
                        RRButton("Modal Overlay", style: .secondary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Modal Overlay", style: .title, weight: .semibold)
                            RRLabel("This is a modal-style overlay with a dark background.", style: .body)
                            RRButton("Close", style: .primary) {}
                        }
                    }
                }
            }
            
            // Styled overlays
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Styled Overlays", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RROverlay.sheet {
                        RRButton("Sheet Overlay", style: .secondary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Sheet Overlay", style: .title, weight: .semibold)
                            RRLabel("This overlay slides up from the bottom.", style: .body)
                            RRButton("Close", style: .primary) {}
                        }
                    }
                    
                    RROverlay.alert {
                        RRButton("Alert Overlay", style: .primary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Alert Overlay", style: .title, weight: .semibold)
                            RRLabel("This is an alert-style overlay.", style: .body)
                            RRButton("Close", style: .secondary) {}
                        }
                    }
                }
            }
            
            // Custom overlays
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Custom Overlays", style: .subtitle, weight: .semibold)
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    RROverlay(
                        style: OverlayStyle(
                            background: theme.colors.primary,
                            backgroundColor: theme.colors.primary.opacity(0.8),
                            cornerRadius: DesignTokens.BorderRadius.xl,
                            shadowRadius: 24
                        )
                    ) {
                        RRButton("Primary Overlay", style: .secondary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Primary Overlay", style: .title, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This overlay uses the primary theme color.", style: .body, customColor: theme.colors.onPrimary)
                            RRButton("Close", style: .secondary) {}
                        }
                    }
                    
                    RROverlay.transparent {
                        RRButton("Transparent Overlay", style: .primary) {}
                    } overlayContent: {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            RRLabel("Transparent Overlay", style: .title, weight: .semibold)
                            RRLabel("This overlay has no background.", style: .body)
                            RRButton("Close", style: .secondary) {}
                        }
                        .background(theme.colors.surface)
                        .cornerRadius(DesignTokens.BorderRadius.md)
                        .shadow(radius: 8)
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
