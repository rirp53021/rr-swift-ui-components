import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct ThemeProviderTests {
    
    // MARK: - Initialization Tests
    
    @Test("ThemeProvider initialization")
    func testThemeProviderInitialization() {
        let themeProvider = ThemeProvider()
        #expect(themeProvider != nil)
        #expect(themeProvider.currentTheme == .light)
    }
    
    @Test("ThemeProvider with custom theme")
    func testThemeProviderWithCustomTheme() {
        let customTheme = Theme.light
        let provider = ThemeProvider(theme: customTheme)
        
        #expect(provider != nil)
        #expect(provider.currentTheme == customTheme)
    }
    
    // MARK: - Theme Switching Tests
    
    @Test("Theme switching")
    func testThemeSwitching() {
        let themeProvider = ThemeProvider()
        
        // Test switching to dark theme
        themeProvider.setTheme(.dark)
        #expect(themeProvider.currentTheme == .dark)
        
        // Test switching back to light theme
        themeProvider.setTheme(.light)
        #expect(themeProvider.currentTheme == .light)
    }
    
    // MARK: - Theme Properties Tests
    
    @Test("Theme has required properties")
    func testThemeHasRequiredProperties() {
        let themeProvider = ThemeProvider()
        let theme = themeProvider.currentTheme
        
        #expect(theme.colors != nil)
        #expect(theme.typography != nil)
        #expect(theme.spacing != nil)
        #expect(theme.borderRadius != nil)
    }
}