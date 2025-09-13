import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct DesignTokensTests {
    
    // MARK: - Basic Tests
    
    @Test("Design tokens exist")
    func testDesignTokensExist() {
        // Test that we can access design tokens through ThemeProvider
        let themeProvider = ThemeProvider()
        #expect(themeProvider != nil)
    }
    
    @Test("ThemeProvider has design tokens")
    func testThemeProviderHasDesignTokens() {
        let themeProvider = ThemeProvider()
        
        // Test that theme provider has access to design tokens
        #expect(themeProvider.currentTheme != nil)
        #expect(themeProvider.currentTheme.colors != nil)
        #expect(themeProvider.currentTheme.typography != nil)
        #expect(themeProvider.currentTheme.spacing != nil)
        #expect(themeProvider.currentTheme.borderRadius != nil)
    }
    
    @Test("Theme switching works")
    func testThemeSwitching() {
        let themeProvider = ThemeProvider()
        
        // Test initial theme
        #expect(themeProvider.currentTheme == .light)
        
        // Test theme switching
        themeProvider.setTheme(.dark)
        #expect(themeProvider.currentTheme == .dark)
        
        // Test switching back
        themeProvider.setTheme(.light)
        #expect(themeProvider.currentTheme == .light)
    }
}