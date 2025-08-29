import Testing
import SwiftUI
@testable import RRUIComponents

@MainActor
final class RRUIComponentsTests {
    
    @Test("Theme Manager should initialize with default values")
    func testThemeManagerInitialization() throws {
        let themeManager = ThemeManager()
        
        // Verify default values
        #expect(themeManager.colorScheme.primary.main == RRColorScheme.light.primary.main)
        #expect(themeManager.typography.title == Typography.default.title)
        #expect(themeManager.spacing.md == Spacing.md)
    }
    
    @Test("Theme Manager should switch between light and dark themes")
    func testThemeManagerThemeSwitching() throws {
        let themeManager = ThemeManager()
        
        // Start with light theme
        #expect(themeManager.colorScheme.primary.main == RRColorScheme.light.primary.main)
        
        // Switch to dark theme
        themeManager.switchToDark()
        #expect(themeManager.colorScheme.primary.main == RRColorScheme.dark.primary.main)
        
        // Switch back to light theme
        themeManager.switchToLight()
        #expect(themeManager.colorScheme.primary.main == RRColorScheme.light.primary.main)
    }
    
    @Test("Theme Manager should switch between typography styles")
    func testThemeManagerTypographySwitching() throws {
        let themeManager = ThemeManager()
        
        // Start with default typography
        #expect(themeManager.typography.title == Typography.default.title)
        
        // Switch to rounded typography
        themeManager.switchToRoundedTypography()
        #expect(themeManager.typography.title == Typography.rounded.title)
        
        // Switch to monospaced typography
        themeManager.switchToMonospacedTypography()
        #expect(themeManager.typography.title == Typography.monospaced.title)
        
        // Switch back to default typography
        themeManager.switchToDefaultTypography()
        #expect(themeManager.typography.title == Typography.default.title)
    }
    
    @Test("Spacing should provide correct values")
    func testSpacingValues() throws {
        #expect(Spacing.xs == 4)
        #expect(Spacing.sm == 8)
        #expect(Spacing.md == 16)
        #expect(Spacing.lg == 24)
        #expect(Spacing.xl == 32)
        #expect(Spacing.xxl == 48)
        #expect(Spacing.xxxl == 64)
        
        // Test common spacing combinations
        #expect(Spacing.content == 16)
        #expect(Spacing.section == 24)
        #expect(Spacing.screen == 16)
        #expect(Spacing.card == 16)
        #expect(Spacing.button == 12)
        #expect(Spacing.input == 12)
    }
    
    @Test("Color Scheme should provide light and dark variants")
    func testColorSchemeVariants() throws {
        let lightScheme = RRColorScheme.light
        let darkScheme = RRColorScheme.dark
        
        // Verify light scheme has expected colors
        #expect(lightScheme.neutral.background == .white)
        #expect(lightScheme.neutral.text == Color(red: 0.1, green: 0.1, blue: 0.1))
        
        // Verify dark scheme has expected colors
        #expect(darkScheme.neutral.background == Color(red: 0.1, green: 0.1, blue: 0.1))
        #expect(darkScheme.neutral.text == Color(red: 0.9, green: 0.9, blue: 0.9))
    }
    
    @Test("Typography should provide different font styles")
    func testTypographyStyles() throws {
        let defaultTypography = Typography.default
        let roundedTypography = Typography.rounded
        let monospacedTypography = Typography.monospaced
        
        // Verify different typography systems exist
        #expect(defaultTypography.title != roundedTypography.title)
        #expect(defaultTypography.title != monospacedTypography.title)
        #expect(roundedTypography.title != monospacedTypography.title)
    }
    
    @Test("RRButton should initialize with correct properties")
    func testRRButtonInitialization() throws {
        let button = RRButton(
            title: "Test Button",
            icon: Image(systemName: "star"),
            style: .primary,
            size: .medium,
            isDisabled: false,
            isLoading: false
        ) {
            // Action
        }
        
        #expect(button.title == "Test Button")
        #expect(button.style == .primary)
        #expect(button.size == .medium)
        #expect(button.isDisabled == false)
        #expect(button.isLoading == false)
    }
    
    @Test("RRButton convenience initializers should work correctly")
    func testRRButtonConvenienceInitializers() throws {
        let primaryButton = RRButton.primary(title: "Primary") {}
        let secondaryButton = RRButton.secondary(title: "Secondary") {}
        let outlineButton = RRButton.outline(title: "Outline") {}
        
        #expect(primaryButton.style == .primary)
        #expect(secondaryButton.style == .secondary)
        #expect(outlineButton.style == .outline)
    }
    
    @Test("RRLoadingIndicator should initialize with correct properties")
    func testRRLoadingIndicatorInitialization() throws {
        let indicator = RRLoadingIndicator(
            style: .circular,
            size: .medium,
            color: .blue,
            isAnimating: true
        )
        
        #expect(indicator.style == .circular)
        #expect(indicator.size == .medium)
        #expect(indicator.color == .blue)
        #expect(indicator.isAnimating == true)
    }
    
    @Test("RRLoadingIndicator convenience initializers should work correctly")
    func testRRLoadingIndicatorConvenienceInitializers() throws {
        let circular = RRLoadingIndicator.circular()
        let linear = RRLoadingIndicator.linear()
        let dots = RRLoadingIndicator.dots()
        let pulse = RRLoadingIndicator.pulse()
        
        #expect(circular.style == .circular)
        #expect(linear.style == .linear)
        #expect(dots.style == .dots)
        #expect(pulse.style == .pulse)
    }
    
    @Test("RREmptyState should initialize with correct properties")
    func testRREmptyStateInitialization() throws {
        let emptyState = RREmptyState(
            icon: Image(systemName: "info.circle"),
            title: "No Data",
            subtitle: "There's no data to display",
            style: .info,
            size: .medium
        )
        
        #expect(emptyState.title == "No Data")
        #expect(emptyState.subtitle == "There's no data to display")
        #expect(emptyState.style == .info)
        #expect(emptyState.size == .medium)
    }
    
    @Test("RREmptyState convenience initializers should work correctly")
    func testRREmptyStateConvenienceInitializers() throws {
        let infoState = RREmptyState.info(title: "Info")
        let warningState = RREmptyState.warning(title: "Warning")
        let errorState = RREmptyState.error(title: "Error")
        let successState = RREmptyState.success(title: "Success")
        
        #expect(infoState.style == .info)
        #expect(warningState.style == .warning)
        #expect(errorState.style == .error)
        #expect(successState.style == .success)
    }
    
    @Test("RREmptyState common states should work correctly")
    func testRREmptyStateCommonStates() throws {
        let noResults = RREmptyState.noSearchResults(query: "test")
        let noInternet = RREmptyState.noInternet()
        let emptyList = RREmptyState.emptyList()
        
        #expect(noResults.title == "No results found")
        #expect(noInternet.title == "No Internet Connection")
        #expect(emptyList.title == "No Items")
    }
}
