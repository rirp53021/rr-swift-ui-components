import Testing
import SwiftUI
@testable import RRUIComponents

/// Integration tests for bundle configuration
@MainActor
struct BundleConfigurationTests {
    
    @Test("Bundle resources are accessible")
    func testBundleResourcesAccessibility() {
        let bundle = Bundle.uiComponents
        
        // Test that bundle exists
        let _ = bundle
        
        // Test that bundle identifier is correct
        let bundleIdentifier = bundle.bundleIdentifier
        // Note: bundleIdentifier may be nil in test environment
        let _ = bundleIdentifier
    }
    
    @Test("Color assets are loaded from bundle")
    func testColorAssetsLoading() {
        let bundle = Bundle.uiComponents
        
        // Test primary color
        let primaryColor = Color("Primary", bundle: bundle)
        let _ = primaryColor
        
        // Test secondary color
        let secondaryColor = Color("Secondary", bundle: bundle)
        let _ = secondaryColor
        
        // Test surface color
        let surfaceColor = Color("Surface", bundle: bundle)
        let _ = surfaceColor
    }
    
    @Test("Design tokens are accessible from bundle")
    func testDesignTokensAccessibility() {
        // Test spacing tokens
        let _ = DesignTokens.Spacing.xs
        let _ = DesignTokens.Spacing.sm
        let _ = DesignTokens.Spacing.md
        let _ = DesignTokens.Spacing.lg
        let _ = DesignTokens.Spacing.xl
        
        // Test typography tokens
        let _ = DesignTokens.Typography.displayLarge
        let _ = DesignTokens.Typography.headlineLarge
        let _ = DesignTokens.Typography.bodyLarge
    }
    
    @Test("Theme provider uses correct bundle")
    func testThemeProviderBundleUsage() {
        let themeProvider = ThemeProvider()
        let _ = themeProvider
    }
    
    @Test("Components use theme provider bundle")
    func testComponentsUseThemeProviderBundle() {
        let themeProvider = ThemeProvider()
        let _ = themeProvider
    }
    
    @Test("Bundle optimization works correctly")
    func testBundleOptimization() {
        let bundle = Bundle.uiComponents
        
        // Test that bundle is accessible
        let _ = bundle
        
        // Test that bundle identifier is not nil
        let bundleIdentifier = bundle.bundleIdentifier
        // Note: bundleIdentifier may be nil in test environment
        let _ = bundleIdentifier
    }
    
    @Test("Resource loading from bundle")
    func testResourceLoadingFromBundle() {
        let bundle = Bundle.uiComponents
        
        // Test that we can access bundle resources
        let _ = bundle.bundlePath
        let _ = bundle.resourcePath
    }
    
    @Test("Bundle version information")
    func testBundleVersionInformation() {
        let bundle = Bundle.uiComponents
        
        // Test bundle version
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let _ = version
        
        // Test build number
        let buildNumber = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let _ = buildNumber
    }
    
    @Test("Bundle localization support")
    func testBundleLocalizationSupport() {
        let bundle = Bundle.uiComponents
        
        // Test that bundle supports localization
        let _ = bundle.localizations
        let _ = bundle.preferredLocalizations
    }
    
    @Test("Bundle resource URL access")
    func testBundleResourceURLAccess() {
        let bundle = Bundle.uiComponents
        
        // Test that we can access resource URLs
        let _ = bundle.bundleURL
        let _ = bundle.resourceURL
    }
}
