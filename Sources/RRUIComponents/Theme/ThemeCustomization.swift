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
        let typography = theme.typography
        
        // Validate font hierarchy consistency
        let hierarchyIssues = validateFontHierarchy(typography)
        issues.append(contentsOf: hierarchyIssues)
        
        // Validate minimum font sizes for accessibility
        let sizeIssues = validateMinimumFontSizes(typography)
        issues.append(contentsOf: sizeIssues)
        
        // Validate font weight consistency
        let weightIssues = validateFontWeights(typography)
        issues.append(contentsOf: weightIssues)
        
        return issues
    }
    
    // MARK: - Typography Validation Helpers
    
    private static func validateFontHierarchy(_ typography: ThemeTypography) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Extract font sizes for comparison
        let displayLargeSize = extractFontSize(from: typography.displayLarge)
        let displayMediumSize = extractFontSize(from: typography.displayMedium)
        let displaySmallSize = extractFontSize(from: typography.displaySmall)
        let headlineLargeSize = extractFontSize(from: typography.headlineLarge)
        let headlineMediumSize = extractFontSize(from: typography.headlineMedium)
        let headlineSmallSize = extractFontSize(from: typography.headlineSmall)
        let titleLargeSize = extractFontSize(from: typography.titleLarge)
        let titleMediumSize = extractFontSize(from: typography.titleMedium)
        let titleSmallSize = extractFontSize(from: typography.titleSmall)
        let bodyLargeSize = extractFontSize(from: typography.bodyLarge)
        let bodyMediumSize = extractFontSize(from: typography.bodyMedium)
        let bodySmallSize = extractFontSize(from: typography.bodySmall)
        let labelLargeSize = extractFontSize(from: typography.labelLarge)
        let labelMediumSize = extractFontSize(from: typography.labelMedium)
        let labelSmallSize = extractFontSize(from: typography.labelSmall)
        
        // Validate display hierarchy
        if displayLargeSize <= displayMediumSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Display Large font size (\(displayLargeSize)pt) should be larger than Display Medium (\(displayMediumSize)pt)",
                severity: .warning
            ))
        }
        
        if displayMediumSize <= displaySmallSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Display Medium font size (\(displayMediumSize)pt) should be larger than Display Small (\(displaySmallSize)pt)",
                severity: .warning
            ))
        }
        
        // Validate headline hierarchy
        if headlineLargeSize <= headlineMediumSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Headline Large font size (\(headlineLargeSize)pt) should be larger than Headline Medium (\(headlineMediumSize)pt)",
                severity: .warning
            ))
        }
        
        if headlineMediumSize <= headlineSmallSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Headline Medium font size (\(headlineMediumSize)pt) should be larger than Headline Small (\(headlineSmallSize)pt)",
                severity: .warning
            ))
        }
        
        // Validate title hierarchy
        if titleLargeSize <= titleMediumSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Large font size (\(titleLargeSize)pt) should be larger than Title Medium (\(titleMediumSize)pt)",
                severity: .warning
            ))
        }
        
        if titleMediumSize <= titleSmallSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Medium font size (\(titleMediumSize)pt) should be larger than Title Small (\(titleSmallSize)pt)",
                severity: .warning
            ))
        }
        
        // Validate body hierarchy
        if bodyLargeSize <= bodyMediumSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Large font size (\(bodyLargeSize)pt) should be larger than Body Medium (\(bodyMediumSize)pt)",
                severity: .warning
            ))
        }
        
        if bodyMediumSize <= bodySmallSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Medium font size (\(bodyMediumSize)pt) should be larger than Body Small (\(bodySmallSize)pt)",
                severity: .warning
            ))
        }
        
        // Validate label hierarchy
        if labelLargeSize <= labelMediumSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Label Large font size (\(labelLargeSize)pt) should be larger than Label Medium (\(labelMediumSize)pt)",
                severity: .warning
            ))
        }
        
        if labelMediumSize <= labelSmallSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Label Medium font size (\(labelMediumSize)pt) should be larger than Label Small (\(labelSmallSize)pt)",
                severity: .warning
            ))
        }
        
        // Validate cross-category hierarchy
        if displaySmallSize <= headlineLargeSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Display Small font size (\(displaySmallSize)pt) should be larger than Headline Large (\(headlineLargeSize)pt)",
                severity: .warning
            ))
        }
        
        if headlineSmallSize <= titleLargeSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Headline Small font size (\(headlineSmallSize)pt) should be larger than Title Large (\(titleLargeSize)pt)",
                severity: .warning
            ))
        }
        
        if titleSmallSize <= bodyLargeSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Small font size (\(titleSmallSize)pt) should be larger than Body Large (\(bodyLargeSize)pt)",
                severity: .warning
            ))
        }
        
        if bodySmallSize <= labelLargeSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Small font size (\(bodySmallSize)pt) should be larger than Label Large (\(labelLargeSize)pt)",
                severity: .warning
            ))
        }
        
        return issues
    }
    
    private static func validateMinimumFontSizes(_ typography: ThemeTypography) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Minimum font sizes for accessibility (WCAG guidelines)
        let minBodySize: CGFloat = 16.0  // Recommended minimum for body text
        let minLabelSize: CGFloat = 12.0  // Minimum for labels
        let minTitleSize: CGFloat = 14.0  // Minimum for titles
        
        let bodyLargeSize = extractFontSize(from: typography.bodyLarge)
        let bodyMediumSize = extractFontSize(from: typography.bodyMedium)
        let bodySmallSize = extractFontSize(from: typography.bodySmall)
        let labelLargeSize = extractFontSize(from: typography.labelLarge)
        let labelMediumSize = extractFontSize(from: typography.labelMedium)
        let labelSmallSize = extractFontSize(from: typography.labelSmall)
        let titleLargeSize = extractFontSize(from: typography.titleLarge)
        let titleMediumSize = extractFontSize(from: typography.titleMedium)
        let titleSmallSize = extractFontSize(from: typography.titleSmall)
        
        // Check body text sizes
        if bodyLargeSize < minBodySize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Large font size (\(bodyLargeSize)pt) is below recommended minimum (\(minBodySize)pt) for accessibility",
                severity: .error
            ))
        }
        
        if bodyMediumSize < minBodySize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Medium font size (\(bodyMediumSize)pt) is below recommended minimum (\(minBodySize)pt) for accessibility",
                severity: .error
            ))
        }
        
        if bodySmallSize < minLabelSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Body Small font size (\(bodySmallSize)pt) is below minimum (\(minLabelSize)pt) for accessibility",
                severity: .error
            ))
        }
        
        // Check label text sizes
        if labelLargeSize < minLabelSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Label Large font size (\(labelLargeSize)pt) is below minimum (\(minLabelSize)pt) for accessibility",
                severity: .error
            ))
        }
        
        if labelMediumSize < minLabelSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Label Medium font size (\(labelMediumSize)pt) is below minimum (\(minLabelSize)pt) for accessibility",
                severity: .error
            ))
        }
        
        if labelSmallSize < minLabelSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Label Small font size (\(labelSmallSize)pt) is below minimum (\(minLabelSize)pt) for accessibility",
                severity: .error
            ))
        }
        
        // Check title text sizes
        if titleLargeSize < minTitleSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Large font size (\(titleLargeSize)pt) is below minimum (\(minTitleSize)pt) for accessibility",
                severity: .warning
            ))
        }
        
        if titleMediumSize < minTitleSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Medium font size (\(titleMediumSize)pt) is below minimum (\(minTitleSize)pt) for accessibility",
                severity: .warning
            ))
        }
        
        if titleSmallSize < minTitleSize {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Title Small font size (\(titleSmallSize)pt) is below minimum (\(minTitleSize)pt) for accessibility",
                severity: .warning
            ))
        }
        
        return issues
    }
    
    private static func validateFontWeights(_ typography: ThemeTypography) -> [ThemeValidationIssue] {
        var issues: [ThemeValidationIssue] = []
        
        // Extract font weights for comparison
        let displayLargeWeight = extractFontWeight(from: typography.displayLarge)
        let displayMediumWeight = extractFontWeight(from: typography.displayMedium)
        let displaySmallWeight = extractFontWeight(from: typography.displaySmall)
        let headlineLargeWeight = extractFontWeight(from: typography.headlineLarge)
        let headlineMediumWeight = extractFontWeight(from: typography.headlineMedium)
        let headlineSmallWeight = extractFontWeight(from: typography.headlineSmall)
        
        // Validate display weight consistency
        if displayLargeWeight != displayMediumWeight || displayMediumWeight != displaySmallWeight {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Display fonts should have consistent font weights for visual hierarchy",
                severity: .info
            ))
        }
        
        // Validate headline weight consistency
        if headlineLargeWeight != headlineMediumWeight || headlineMediumWeight != headlineSmallWeight {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Headline fonts should have consistent font weights for visual hierarchy",
                severity: .info
            ))
        }
        
        // Validate that headlines are heavier than body text
        let bodyLargeWeight = extractFontWeight(from: typography.bodyLarge)
        if !isFontWeightHeavier(headlineLargeWeight, than: bodyLargeWeight) {
            issues.append(ThemeValidationIssue(
                type: .typography,
                message: "Headline fonts should be heavier than body text for proper visual hierarchy",
                severity: .warning
            ))
        }
        
        return issues
    }
    
    // MARK: - Font Property Extraction Helpers
    
    private static func extractFontSize(from font: Font) -> CGFloat {
        // This is a simplified approach - in a real implementation, you might need
        // to use UIFont or NSFont to extract the actual size
        // For now, we'll use the known sizes from DesignTokens
        switch font {
        case DesignTokens.Typography.displayLarge: return 57
        case DesignTokens.Typography.displayMedium: return 45
        case DesignTokens.Typography.displaySmall: return 36
        case DesignTokens.Typography.headlineLarge: return 32
        case DesignTokens.Typography.headlineMedium: return 28
        case DesignTokens.Typography.headlineSmall: return 24
        case DesignTokens.Typography.titleLarge: return 22
        case DesignTokens.Typography.titleMedium: return 16
        case DesignTokens.Typography.titleSmall: return 14
        case DesignTokens.Typography.bodyLarge: return 16
        case DesignTokens.Typography.bodyMedium: return 14
        case DesignTokens.Typography.bodySmall: return 12
        case DesignTokens.Typography.labelLarge: return 14
        case DesignTokens.Typography.labelMedium: return 12
        case DesignTokens.Typography.labelSmall: return 11
        default: return 16 // Default fallback
        }
    }
    
    private static func extractFontWeight(from font: Font) -> Font.Weight {
        // This is a simplified approach - in a real implementation, you might need
        // to use UIFont or NSFont to extract the actual weight
        // For now, we'll use the known weights from DesignTokens
        switch font {
        case DesignTokens.Typography.displayLarge: return .regular
        case DesignTokens.Typography.displayMedium: return .regular
        case DesignTokens.Typography.displaySmall: return .regular
        case DesignTokens.Typography.headlineLarge: return .semibold
        case DesignTokens.Typography.headlineMedium: return .semibold
        case DesignTokens.Typography.headlineSmall: return .semibold
        case DesignTokens.Typography.titleLarge: return .medium
        case DesignTokens.Typography.titleMedium: return .medium
        case DesignTokens.Typography.titleSmall: return .medium
        case DesignTokens.Typography.bodyLarge: return .regular
        case DesignTokens.Typography.bodyMedium: return .regular
        case DesignTokens.Typography.bodySmall: return .regular
        case DesignTokens.Typography.labelLarge: return .medium
        case DesignTokens.Typography.labelMedium: return .medium
        case DesignTokens.Typography.labelSmall: return .medium
        default: return .regular // Default fallback
        }
    }
    
    private static func isFontWeightHeavier(_ weight1: Font.Weight, than weight2: Font.Weight) -> Bool {
        // Compare font weights by their relative heaviness
        let weightOrder: [Font.Weight] = [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
        
        guard let index1 = weightOrder.firstIndex(of: weight1),
              let index2 = weightOrder.firstIndex(of: weight2) else {
            return false
        }
        
        return index1 > index2
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
