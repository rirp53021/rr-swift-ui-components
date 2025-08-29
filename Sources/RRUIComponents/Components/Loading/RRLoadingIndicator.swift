import SwiftUI

/// A customizable loading indicator component
public struct RRLoadingIndicator: View {
    /// The loading indicator style
    public enum Style {
        case circular
        case linear
        case dots
        case pulse
    }
    
    /// The loading indicator size
    public enum Size {
        case small
        case medium
        case large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 32
            case .large: return 48
            }
        }
        
        var strokeWidth: CGFloat {
            switch self {
            case .small: return 2
            case .medium: return 3
            case .large: return 4
            }
        }
    }
    
    /// The loading indicator style
    public let style: Style
    /// The loading indicator size
    public let size: Size
    /// The color of the loading indicator
    public let color: Color?
    /// Whether the loading indicator is animating
    public let isAnimating: Bool
    
    /// Creates a new loading indicator
    /// - Parameters:
    ///   - style: The loading indicator style
    ///   - size: The loading indicator size
    ///   - color: The color of the loading indicator (uses theme color if nil)
    ///   - isAnimating: Whether the loading indicator is animating
    public init(
        style: Style = .circular,
        size: Size = .medium,
        color: Color? = nil,
        isAnimating: Bool = true
    ) {
        self.style = style
        self.size = size
        self.color = color
        self.isAnimating = isAnimating
    }
    
    public var body: some View {
        Group {
            switch style {
            case .circular:
                CircularLoadingIndicator(size: size, color: color, isAnimating: isAnimating)
            case .linear:
                LinearLoadingIndicator(size: size, color: color, isAnimating: isAnimating)
            case .dots:
                DotsLoadingIndicator(size: size, color: color, isAnimating: isAnimating)
            case .pulse:
                PulseLoadingIndicator(size: size, color: color, isAnimating: isAnimating)
            }
        }
    }
}

// MARK: - Circular Loading Indicator
private struct CircularLoadingIndicator: View {
    let size: RRLoadingIndicator.Size
    let color: Color?
    let isAnimating: Bool
    
    @Environment(\.themeManager) private var themeManager
    
    private var indicatorColor: Color {
        color ?? themeManager.colorScheme.primary.main
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(indicatorColor.opacity(0.2), lineWidth: size.strokeWidth)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(indicatorColor, style: StrokeStyle(lineWidth: size.strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    isAnimating ? 
                        .linear(duration: 1.0).repeatForever(autoreverses: false) : 
                        .default,
                    value: isAnimating
                )
        }
        .frame(width: size.dimension, height: size.dimension)
    }
}

// MARK: - Linear Loading Indicator
private struct LinearLoadingIndicator: View {
    let size: RRLoadingIndicator.Size
    let color: Color?
    let isAnimating: Bool
    
    @Environment(\.themeManager) private var themeManager
    
    private var indicatorColor: Color {
        color ?? themeManager.colorScheme.primary.main
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(indicatorColor.opacity(0.2))
                    .frame(height: size.strokeWidth)
                
                Rectangle()
                    .fill(indicatorColor)
                    .frame(width: geometry.size.width * 0.3, height: size.strokeWidth)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width * 0.3)
                    .animation(
                        isAnimating ? 
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: false) : 
                            .default,
                        value: isAnimating
                    )
            }
        }
        .frame(height: size.dimension)
    }
}

// MARK: - Dots Loading Indicator
private struct DotsLoadingIndicator: View {
    let size: RRLoadingIndicator.Size
    let color: Color?
    let isAnimating: Bool
    
    @Environment(\.themeManager) private var themeManager
    
    private var indicatorColor: Color {
        color ?? themeManager.colorScheme.primary.main
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(indicatorColor)
                    .frame(width: size.dimension * 0.3, height: size.dimension * 0.3)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(
                        isAnimating ? 
                            .easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2) : 
                            .default,
                        value: isAnimating
                    )
            }
        }
        .frame(height: size.dimension)
    }
}

// MARK: - Pulse Loading Indicator
private struct PulseLoadingIndicator: View {
    let size: RRLoadingIndicator.Size
    let color: Color?
    let isAnimating: Bool
    
    @Environment(\.themeManager) private var themeManager
    
    private var indicatorColor: Color {
        color ?? themeManager.colorScheme.primary.main
    }
    
    var body: some View {
        Circle()
            .fill(indicatorColor)
            .frame(width: size.dimension, height: size.dimension)
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(
                isAnimating ? 
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: false) : 
                    .default,
                value: isAnimating
            )
    }
}

// MARK: - Convenience Initializers
public extension RRLoadingIndicator {
    /// Creates a circular loading indicator
    /// - Parameters:
    ///   - size: The loading indicator size
    ///   - color: The color of the loading indicator
    ///   - isAnimating: Whether the loading indicator is animating
    static func circular(
        size: Size = .medium,
        color: Color? = nil,
        isAnimating: Bool = true
    ) -> RRLoadingIndicator {
        RRLoadingIndicator(style: .circular, size: size, color: color, isAnimating: isAnimating)
    }
    
    /// Creates a linear loading indicator
    /// - Parameters:
    ///   - size: The loading indicator size
    ///   - color: The color of the loading indicator
    ///   - isAnimating: Whether the loading indicator is animating
    static func linear(
        size: Size = .medium,
        color: Color? = nil,
        isAnimating: Bool = true
    ) -> RRLoadingIndicator {
        RRLoadingIndicator(style: .linear, size: size, color: color, isAnimating: isAnimating)
    }
    
    /// Creates a dots loading indicator
    /// - Parameters:
    ///   - size: The loading indicator size
    ///   - color: The color of the loading indicator
    ///   - isAnimating: Whether the loading indicator is animating
    static func dots(
        size: Size = .medium,
        color: Color? = nil,
        isAnimating: Bool = true
    ) -> RRLoadingIndicator {
        RRLoadingIndicator(style: .dots, size: size, color: color, isAnimating: isAnimating)
    }
    
    /// Creates a pulse loading indicator
    /// - Parameters:
    ///   - size: The loading indicator size
    ///   - color: The color of the loading indicator
    ///   - isAnimating: Whether the loading indicator is animating
    static func pulse(
        size: Size = .medium,
        color: Color? = nil,
        isAnimating: Bool = true
    ) -> RRLoadingIndicator {
        RRLoadingIndicator(style: .pulse, size: size, color: color, isAnimating: isAnimating)
    }
}

// MARK: - Preview
#if DEBUG
struct RRLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            HStack(spacing: 20) {
                RRLoadingIndicator.circular(size: .small)
                RRLoadingIndicator.circular(size: .medium)
                RRLoadingIndicator.circular(size: .large)
            }
            
            HStack(spacing: 20) {
                RRLoadingIndicator.linear(size: .small)
                RRLoadingIndicator.linear(size: .medium)
                RRLoadingIndicator.linear(size: .large)
            }
            
            HStack(spacing: 20) {
                RRLoadingIndicator.dots(size: .small)
                RRLoadingIndicator.dots(size: .medium)
                RRLoadingIndicator.dots(size: .large)
            }
            
            HStack(spacing: 20) {
                RRLoadingIndicator.pulse(size: .small)
                RRLoadingIndicator.pulse(size: .medium)
                RRLoadingIndicator.pulse(size: .large)
            }
        }
        .padding()
        .themeManager(.preview)
    }
}
#endif
