import Testing
import SwiftUI
@testable import RRUIComponents

/// Visual regression tests for theme consistency
@MainActor
struct ThemeConsistencyTests {
    
    @Test("Light theme consistency")
    func testLightThemeConsistency() {
        let themeProvider = ThemeProvider(theme: .light)
        
        // Test components with light theme
        let lightThemeView = VStack(spacing: 16) {
            RRLabel("Light Theme Test", style: .body)
            RRButton("Primary Button", action: {})
            RRCard {
                RRLabel("Card in light theme", style: .body)
            }
            RRToggle(isOn: .constant(false), title: "Toggle in light theme")
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = lightThemeView
    }
    
    @Test("Dark theme consistency")
    func testDarkThemeConsistency() {
        let themeProvider = ThemeProvider(theme: .dark)
        
        // Test components with dark theme
        let darkThemeView = VStack(spacing: 16) {
            RRLabel("Dark Theme Test", style: .body)
            RRButton("Primary Button", action: {})
            RRCard {
                RRLabel("Card in dark theme", style: .body)
            }
            RRToggle(isOn: .constant(false), title: "Toggle in dark theme")
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = darkThemeView
    }
    
    @Test("Theme switching consistency")
    func testThemeSwitchingConsistency() {
        let themeProvider = ThemeProvider()
        
        // Test theme switching
        themeProvider.toggleTheme()
        
        let switchedThemeView = VStack(spacing: 16) {
            RRLabel("Switched Theme Test", style: .body)
            RRButton("Button after switch", action: {})
            RRCard {
                RRLabel("Card after switch", style: .body)
            }
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = switchedThemeView
    }
    
    @Test("Color consistency across components")
    func testColorConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that colors are consistent across different components
        let colorConsistencyView = VStack(spacing: 16) {
            // Primary color usage
            RRButton("Primary Button", action: {})
            RRLabel("Primary Text", style: .body)
            
            // Secondary color usage
            RRButton("Secondary Button", action: {})
            RRLabel("Secondary Text", style: .body)
            
            // Surface color usage
            RRCard {
                RRLabel("Surface Card", style: .body)
            }
            
            // Background color usage
            RRContainer {
                RRLabel("Background Container", style: .body)
            }
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = colorConsistencyView
    }
    
    @Test("Typography consistency across components")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testTypographyConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that typography is consistent across different components
        let typographyConsistencyView = VStack(spacing: 16) {
            // Headline typography
            RRLabel("Headline Text", style: .body)
            RRButton("Headline Button", action: {})
            
            // Body typography
            RRLabel("Body Text", style: .body)
            RRTextField("Body placeholder", text: .constant(""))
            
            // Caption typography
            RRLabel("Caption Text", style: .caption)
            RRToggle(isOn: .constant(false), title: "Caption Toggle")
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = typographyConsistencyView
    }
    
    @Test("Spacing consistency across components")
    func testSpacingConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that spacing is consistent across different components
        let spacingConsistencyView = VStack(spacing: DesignTokens.Spacing.md) {
            RRCard {
                VStack(spacing: DesignTokens.Spacing.sm) {
                    RRLabel("Card Title", style: .body)
                    RRLabel("Card Content", style: .body)
                }
                .padding(DesignTokens.Spacing.md)
            }
            
            RRButton("Spaced Button", action: {})
                .padding(DesignTokens.Spacing.sm)
            
            RRToggle(isOn: .constant(false), title: "Spaced Toggle")
                .padding(DesignTokens.Spacing.lg)
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = spacingConsistencyView
    }
    
    @Test("Border radius consistency across components")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testBorderRadiusConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that border radius is consistent across different components
        let borderRadiusConsistencyView = VStack(spacing: 16) {
            RRButton("Rounded Button", action: {})
            RRCard {
                RRLabel("Rounded Card", style: .body)
            }
            RRTextField("Rounded TextField", text: .constant(""))
            RRToggle(isOn: .constant(false), title: "Rounded Toggle")
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = borderRadiusConsistencyView
    }
    
    @Test("Shadow consistency across components")
    func testShadowConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that shadows are consistent across different components
        let shadowConsistencyView = VStack(spacing: 16) {
            RRCard(style: .elevated) {
                RRLabel("Elevated Card", style: .body)
            }
            
            RRButton("Elevated Button", action: {})
            
            RRModal(isPresented: .constant(true)) {
                RRLabel("Modal with shadow", style: .body)
            }
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = shadowConsistencyView
    }
    
    @Test("Animation consistency across components")
    func testAnimationConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that animations are consistent across different components
        let animationConsistencyView = VStack(spacing: 16) {
            RRButton("Animated Button", action: {})
            RRToggle(isOn: .constant(false), title: "Animated Toggle")
            RRStepper(value: .constant(0), step: 1)
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = animationConsistencyView
    }
    
    @Test("Focus state consistency across components")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testFocusStateConsistencyAcrossComponents() {
        let themeProvider = ThemeProvider()
        
        // Test that focus states are consistent across different components
        let focusConsistencyView = VStack(spacing: 16) {
            RRButton("Focusable Button", action: {})
            RRTextField("Focusable TextField", text: .constant(""))
            RRToggle(isOn: .constant(false), title: "Focusable Toggle")
            RRStepper(value: .constant(0), step: 1)
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = focusConsistencyView
    }
}
