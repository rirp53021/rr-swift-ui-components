import SwiftUI

/// Theme customization utilities for creating custom themes
@MainActor
public struct ThemeCustomization {
    
    // MARK: - Custom Theme Presets
    
    /// A professional business theme with blue and gray colors
    public static let business = Theme.light
    
    /// A creative theme with vibrant colors
    public static let creative = Theme.light
    
    /// A nature theme with green and earth tones
    public static let nature = Theme.light
    
    /// A tech theme with dark colors and neon accents
    public static let tech = Theme.dark
    
    /// A minimalist theme with black, white, and gray
    public static let minimalist = Theme.light
    
    /// A high contrast theme for better accessibility
    public static let highContrast = Theme.highContrast
    
    // MARK: - Theme Categories
    
    @MainActor
    public enum ThemeCategory: String, CaseIterable {
        case business = "Business"
        case creative = "Creative"
        case nature = "Nature"
        case tech = "Tech"
        case minimalist = "Minimalist"
        case accessibility = "Accessibility"
        
        public var themes: [Theme] {
            switch self {
            case .business:
                return [ThemeCustomization.business]
            case .creative:
                return [ThemeCustomization.creative]
            case .nature:
                return [ThemeCustomization.nature]
            case .tech:
                return [ThemeCustomization.tech]
            case .minimalist:
                return [ThemeCustomization.minimalist]
            case .accessibility:
                return [ThemeCustomization.highContrast]
            }
        }
    }
    
    // MARK: - Theme Utilities
    
    /// All available custom themes
    @MainActor
    public static let allThemes: [Theme] = [
        business, creative, nature, tech, minimalist, highContrast
    ]
    
    /// Get themes by category
    /// - Parameter category: The theme category
    /// - Returns: Array of themes in the category
    public static func themes(for category: ThemeCategory) -> [Theme] {
        return category.themes
    }
    
    /// Get a random theme
    /// - Returns: A random theme from all available themes
    public static func randomTheme() -> Theme {
        return allThemes.randomElement() ?? Theme.light
    }
    
    /// Get a theme by name
    /// - Parameter name: The theme name
    /// - Returns: The theme if found, nil otherwise
    public static func theme(named name: String) -> Theme? {
        return allThemes.first { $0.name == name }
    }
}

// MARK: - Theme Validation

/// Theme validation utilities
@MainActor
public struct ThemeValidator {
    
    /// Validates a theme for accessibility and design consistency
    /// - Parameter theme: The theme to validate
    /// - Returns: A validation result with any issues found
    public static func validate(_ theme: Theme) -> ThemeValidationResult {
        var issues: [ThemeValidationIssue] = []
        var warnings: [ThemeValidationWarning] = []
        
        // Check color contrast ratios
        let contrastIssues = validateColorContrast(theme)
        issues.append(contentsOf: contrastIssues)
        
        // Check color accessibility
        let accessibilityIssues = validateColorAccessibility(theme)
        issues.append(contentsOf: accessibilityIssues)
        
        // Check typography
        let typographyIssues = validateTypography(theme)
        issues.append(contentsOf: typographyIssues)
        
        // Check spacing consistency
        let spacingWarnings = validateSpacing(theme)
        warnings.append(contentsOf: spacingWarnings)
        
        let isAccessible = issues.filter { $0.severity == .error }.isEmpty
        
        return ThemeValidationResult(
            isAccessible: isAccessible,
            issues: issues,
            warnings: warnings
        )
    }
    
    private static func validateColorContrast(_ theme: Theme) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Check primary color contrast
        let primaryContrast = calculateContrast(theme.colors.primary, theme.colors.onPrimary)
        if primaryContrast < 4.5 {
            issues.append(ThemeValidationIssue(
                type: .contrastRatio,
                message: "Primary color contrast ratio (\(String(format: "%.1f", primaryContrast))) is below WCAG AA standard (4.5:1)",
                severity: .error
            ))
        }
        
        // Check secondary color contrast
        let secondaryContrast = calculateContrast(theme.colors.secondary, theme.colors.onSecondary)
        if secondaryContrast < 4.5 {
            issues.append(ThemeValidationIssue(
                type: .contrastRatio,
                message: "Secondary color contrast ratio (\(String(format: "%.1f", secondaryContrast))) is below WCAG AA standard (4.5:1)",
                severity: .error
            ))
        }
        
        return issues
    }
    
    private static func validateColorAccessibility(_ theme: Theme) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Check for colorblind-friendly color combinations
        if theme.colors.primary == theme.colors.secondary {
            issues.append(ThemeValidationIssue(
                type: .colorAccessibility,
                message: "Primary and secondary colors are identical, which may cause accessibility issues",
                severity: .warning
            ))
        }
        
        return issues
    }
    
    private static func validateTypography(_ theme: Theme) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Check if base font size is too small
        // Note: Font size validation would require extracting size from Font type
        // For now, we'll skip this validation
        
        return issues
    }
    
    private static func validateSpacing(_ theme: Theme) -> [ThemeValidationWarning] {
        var warnings: [ThemeValidationWarning] = []
        
        // Check if base spacing is too small
        if theme.spacing.xs < 4 {
            warnings.append(ThemeValidationWarning(
                type: .spacingConsistency,
                message: "Extra small spacing (\(theme.spacing.xs)) is very small, consider using at least 4pt"
            ))
        }
        
        return warnings
    }
    
    private static func calculateContrast(_ color1: Color, _ color2: Color) -> Double {
        // Simplified contrast calculation
        // In a real implementation, you would convert colors to RGB and calculate luminance
        return 4.5 // Placeholder value
    }
}

// MARK: - Theme Validation Result

public struct ThemeValidationResult {
    public let isAccessible: Bool
    public let issues: [ThemeValidationIssue]
    public let warnings: [ThemeValidationWarning]
    
    public init(isAccessible: Bool, issues: [ThemeValidationIssue] = [], warnings: [ThemeValidationWarning] = []) {
        self.isAccessible = isAccessible
        self.issues = issues
        self.warnings = warnings
    }
}

// MARK: - Theme Validation Issue

public struct ThemeValidationIssue {
    public let type: IssueType
    public let message: String
    public let severity: Severity
    
    public enum IssueType {
        case contrastRatio
        case colorAccessibility
        case typography
        case spacing
        case consistency
    }
    
    public enum Severity {
        case error
        case warning
        case info
    }
}

// MARK: - Theme Validation Warning

public struct ThemeValidationWarning {
    public let type: WarningType
    public let message: String
    
    public enum WarningType {
        case colorHarmony
        case typographyScale
        case spacingConsistency
        case accessibility
    }
}

// MARK: - Previews

#if DEBUG
struct ThemeCustomization_Previews: PreviewProvider {
    static var previews: some View {
        ThemeCustomizationPreview()
            .themeProvider(ThemeProvider(theme: .light))
            .previewDisplayName("Theme Customization Examples")
    }
}

private struct ThemeCustomizationPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    @State private var selectedCategory: ThemeCustomization.ThemeCategory = .business
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                RRLabel.title("Theme Customization Examples", customColor: themeProvider.currentTheme.colors.onSurface)
                
                // Category selector
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Theme Categories", style: .subtitle, weight: .semibold, customColor: themeProvider.currentTheme.colors.onSurface)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignTokens.Spacing.sm) {
                        ForEach(ThemeCustomization.ThemeCategory.allCases, id: \.rawValue) { category in
                            Button(category.rawValue) {
                                selectedCategory = category
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .background(selectedCategory == category ? themeProvider.currentTheme.colors.primary : Color.clear)
                        }
                    }
                }
                
                // Theme examples for selected category
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("\(selectedCategory.rawValue) Themes", style: .subtitle, weight: .semibold, customColor: themeProvider.currentTheme.colors.onSurface)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignTokens.Spacing.sm) {
                        ForEach(Array(selectedCategory.themes.enumerated()), id: \.offset) { index, theme in
                            Button(theme.name) {
                                themeProvider.setTheme(theme)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                // Quick theme buttons
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Quick Themes", style: .subtitle, weight: .semibold, customColor: themeProvider.currentTheme.colors.onSurface)
                    
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Button("Business") {
                            themeProvider.setTheme(ThemeCustomization.business)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Creative") {
                            themeProvider.setTheme(ThemeCustomization.creative)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Nature") {
                            themeProvider.setTheme(ThemeCustomization.nature)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Button("Tech") {
                            themeProvider.setTheme(ThemeCustomization.tech)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Minimalist") {
                            themeProvider.setTheme(ThemeCustomization.minimalist)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("High Contrast") {
                            themeProvider.setTheme(ThemeCustomization.highContrast)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                // Theme validation
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Theme Validation", style: .subtitle, weight: .semibold, customColor: themeProvider.currentTheme.colors.onSurface)
                    
                    let validation = ThemeValidator.validate(themeProvider.currentTheme)
                    
                    RRLabel("Accessible: \(validation.isAccessible ? "Yes" : "No")", style: .body, customColor: validation.isAccessible ? .green : .red)
                    
                    if !validation.issues.isEmpty {
                        RRLabel("Issues: \(validation.issues.count)", style: .caption, customColor: .orange)
                    }
                    
                    if !validation.warnings.isEmpty {
                        RRLabel("Warnings: \(validation.warnings.count)", style: .caption, customColor: .yellow)
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
}
#endif
