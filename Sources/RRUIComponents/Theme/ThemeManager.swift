import SwiftUI
import RRFoundation

/// Manages the theme for UI components
public class ThemeManager: ObservableObject {
    /// The current color scheme
    @Published public var colorScheme: RRColorScheme
    /// The current typography system
    @Published public var typography: Typography
    /// The current spacing system
    @Published public var spacing: Spacing
    
    /// Shared instance for global theme access
    public static let shared = ThemeManager()
    
    /// Creates a new theme manager
    /// - Parameters:
    ///   - colorScheme: The color scheme to use
    ///   - typography: The typography system to use
    ///   - spacing: The spacing system to use
    public init(
        colorScheme: RRColorScheme = .light,
        typography: Typography = .default,
        spacing: Spacing = Spacing(16)
    ) {
        self.colorScheme = colorScheme
        self.typography = typography
        self.spacing = spacing
    }
    
    /// Switches to light theme
    public func switchToLight() {
        colorScheme = .light
    }
    
    /// Switches to dark theme
    public func switchToDark() {
        colorScheme = .dark
    }
    
    /// Switches to rounded typography
    public func switchToRoundedTypography() {
        typography = .rounded
    }
    
    /// Switches to monospaced typography
    public func switchToMonospacedTypography() {
        typography = .monospaced
    }
    
    /// Switches to default typography
    public func switchToDefaultTypography() {
        typography = .default
    }
    
    /// Applies a custom color scheme
    /// - Parameter scheme: The custom color scheme to apply
    public func applyCustomColorScheme(_ scheme: RRColorScheme) {
        colorScheme = scheme
    }
    
    /// Applies a custom typography system
    /// - Parameter typography: The custom typography system to apply
    public func applyCustomTypography(_ typography: Typography) {
        self.typography = typography
    }
}

// MARK: - Environment Key
public struct ThemeManagerKey: EnvironmentKey {
    public static let defaultValue: ThemeManager = ThemeManager.shared
}

public extension EnvironmentValues {
    /// The theme manager for the current environment
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// MARK: - View Extension
public extension View {
    /// Sets the theme manager for this view and its children
    /// - Parameter themeManager: The theme manager to use
    func themeManager(_ themeManager: ThemeManager) -> some View {
        self.environment(\.themeManager, themeManager)
    }
    
    /// Sets the color scheme for this view and its children
    /// - Parameter colorScheme: The color scheme to use
    func colorScheme(_ colorScheme: RRColorScheme) -> some View {
        self.environment(\.themeManager, ThemeManager(colorScheme: colorScheme))
    }
    
    /// Sets the typography for this view and its children
    /// - Parameter typography: The typography system to use
    func typography(_ typography: Typography) -> some View {
        self.environment(\.themeManager, ThemeManager(typography: typography))
    }
}

// MARK: - Preview Support
#if DEBUG
public extension ThemeManager {
    /// Preview theme manager for SwiftUI previews
    static let preview = ThemeManager(
        colorScheme: .light,
        typography: .rounded,
        spacing: Spacing(16)
    )
}
#endif
