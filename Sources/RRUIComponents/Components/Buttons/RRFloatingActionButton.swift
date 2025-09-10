import SwiftUI

/// A floating action button component, typically used for primary actions
public struct RRFloatingActionButton: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    public enum Size {
        case small
        case medium
        case large
    }
    
    public enum Position {
        case bottomTrailing
        case bottomLeading
        case topTrailing
        case topLeading
        case center
    }
    
    private let icon: Image
    private let size: Size
    private let position: Position
    private let action: () -> Void
    
    public init(
        icon: Image,
        size: Size = .medium,
        position: Position = .bottomTrailing,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.action = action
        self.position = position
    }
    
    public var body: some View {
        Button(action: action) {
            icon
                .font(iconFont)
                .foregroundColor(.white)
                .frame(width: buttonSize, height: buttonSize)
                .background(
                    Circle()
                        .fill(backgroundColor)
                        .shadow(
                            color: shadowColor,
                            radius: shadowRadius,
                            x: shadowOffset.width,
                            y: shadowOffset.height
                        )
                )
        }
        .position(positionPoint)
    }
    
    // MARK: - Computed Properties
    
    private var buttonSize: CGFloat {
        switch size {
        case .small: return 44
        case .medium: return 56
        case .large: return 64
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .title3
        case .medium: return .title2
        case .large: return .title
        }
    }
    
    private var shadowRadius: CGFloat {
        switch size {
        case .small: return RRSpacing.xs
        case .medium: return RRSpacing.sm
        case .large: return RRSpacing.sm
        }
    }
    
    private var shadowOffset: CGSize {
        switch size {
        case .small: return CGSize(width: 0, height: 2)
        case .medium: return CGSize(width: 0, height: 3)
        case .large: return CGSize(width: 0, height: 4)
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        return theme.colors.primary
    }
    
    private var shadowColor: Color {
        return theme.colors.onSurface.opacity(0.3)
    }
    
    private var positionPoint: CGPoint {
        // This is a placeholder - in a real implementation, you'd need to calculate
        // the actual position based on the parent view's bounds
        return CGPoint(x: 100, y: 100)
    }
}

// MARK: - Convenience Initializers

public extension RRFloatingActionButton {
    /// Creates a floating action button with a plus icon
    static func plus(
        size: Size = .medium,
        position: Position = .bottomTrailing,
        action: @escaping () -> Void
    ) -> RRFloatingActionButton {
        RRFloatingActionButton(
            icon: Image(systemName: "plus"),
            size: size,
            position: position,
            action: action
        )
    }
    
    /// Creates a floating action button with a custom icon
    static func custom(
        icon: String,
        size: Size = .medium,
        position: Position = .bottomTrailing,
        action: @escaping () -> Void
    ) -> RRFloatingActionButton {
        RRFloatingActionButton(
            icon: Image(systemName: icon),
            size: size,
            position: position,
            action: action
        )
    }
}

// MARK: - Preview

#if DEBUG
struct RRFloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                Text("Floating Action Buttons")
                    .font(.title)
                    .padding(RRSpacing.paddingMD)
                
                Spacer()
            }
            
            // Different sizes
            VStack(spacing: RRSpacing.lg) {
                RRFloatingActionButton.plus(size: .small, position: .topLeading) { }
                RRFloatingActionButton.plus(size: .medium, position: .topTrailing) { }
                RRFloatingActionButton.plus(size: .large, position: .center) { }
            }
            
            // Bottom positioned FABs
            VStack {
                Spacer()
                HStack {
                    RRFloatingActionButton.custom(
                        icon: "heart",
                        size: .small,
                        position: .bottomLeading
                    ) { }
                    Spacer()
                    RRFloatingActionButton.plus(size: .medium, position: .bottomTrailing) { }
                }
                .padding(RRSpacing.paddingMD)
            }
        }
        .previewDisplayName("RRFloatingActionButton")
    }
}
#endif