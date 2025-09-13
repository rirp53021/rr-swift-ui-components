import Testing
import SwiftUI
@testable import RRUIComponents

/// Integration tests for cross-platform compatibility
@MainActor
struct CrossPlatformTests {
    
    @Test("Components work on iOS")
    func testComponentsWorkOnIOS() {
        #if os(iOS)
        let _ = RRButton("iOS Button", action: {})
        let _ = RRLabel("iOS Label", style: .body)
        let _ = RRModal(isPresented: .constant(false), content: { Text("iOS Modal") })
        #endif
    }
    
    @Test("Components work on macOS")
    func testComponentsWorkOnMacOS() {
        #if os(macOS)
        let _ = RRButton("macOS Button", action: {})
        let _ = RRLabel("macOS Label", style: .body)
        let _ = RRModal(isPresented: .constant(false), content: { Text("macOS Modal") })
        #endif
    }
    
    @Test("Components work on watchOS")
    func testComponentsWorkOnWatchOS() {
        #if os(watchOS)
        let _ = RRButton("watchOS Button", action: {})
        let _ = RRLabel("watchOS Label", style: .body)
        let _ = RRModal(isPresented: .constant(false), content: { Text("watchOS Modal") })
        #endif
    }
    
    @Test("Components work on tvOS")
    func testComponentsWorkOnTVOS() {
        #if os(tvOS)
        let _ = RRButton("tvOS Button", action: {})
        let _ = RRLabel("tvOS Label", style: .body)
        let _ = RRModal(isPresented: .constant(false), content: { Text("tvOS Modal") })
        #endif
    }
    
    @Test("Theme provider works across platforms")
    func testThemeProviderCrossPlatform() {
        let themeProvider = ThemeProvider()
        
        // Should work on all platforms
        let _ = themeProvider
    }
    
    @Test("Design tokens work across platforms")
    func testDesignTokensCrossPlatform() {
        // Spacing should work on all platforms
        let _ = DesignTokens.Spacing.xs
        let _ = DesignTokens.Spacing.sm
        let _ = DesignTokens.Spacing.md
        let _ = DesignTokens.Spacing.lg
        let _ = DesignTokens.Spacing.xl
        
        // Typography should work on all platforms
        let _ = DesignTokens.Typography.displayLarge
        let _ = DesignTokens.Typography.headlineLarge
        let _ = DesignTokens.Typography.bodyLarge
    }
    
    @Test("Bundle access works across platforms")
    func testBundleAccessCrossPlatform() {
        let bundle = Bundle.uiComponents
        
        // Should work on all platforms
        let _ = bundle
        let _ = bundle.bundleIdentifier
    }
    
    @Test("Performance optimizers work across platforms")
    func testPerformanceOptimizersCrossPlatform() {
        // Should work on all platforms
        let _ = PerformanceOptimizer.shared
        let _ = MemoryOptimizer.shared
    }
    
    @Test("Color extensions work across platforms")
    func testColorExtensionsCrossPlatform() {
        let color = Color.blue
        
        // Should work on all platforms
        let _ = color.hexString
    }
    
    @Test("Font extensions work across platforms")
    func testFontExtensionsCrossPlatform() {
        let font = Font.system(size: 16)
        
        // Should work on all platforms
        let _ = font.weight
    }
    
    @Test("View extensions work across platforms")
    func testViewExtensionsCrossPlatform() {
        let view = Text("Test")
        
        // Should work on all platforms
        let _ = view.background(Color.blue)
        let _ = view.foregroundColor(Color.red)
        let _ = view.padding()
    }
    
    @Test("Animation extensions work across platforms")
    func testAnimationExtensionsCrossPlatform() {
        // Should work on all platforms
        let _ = Animation.easeInOut
        let _ = Animation.spring()
        let _ = Animation.linear
    }
    
    @Test("Gesture extensions work across platforms")
    func testGestureExtensionsCrossPlatform() {
        let view = Text("Test")
        
        // Should work on all platforms
        let _ = view.onTapGesture {}
        let _ = view.onLongPressGesture {}
    }
    
    @Test("Accessibility extensions work across platforms")
    func testAccessibilityExtensionsCrossPlatform() {
        let view = Text("Test")
        
        // Should work on all platforms
        let _ = view.accessibilityLabel("Test Label")
        let _ = view.accessibilityHint("Test Hint")
        let _ = view.accessibilityValue("Test Value")
    }
}
