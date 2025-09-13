import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRButtonTests {
    
    // MARK: - Initialization Tests
    
    @Test("Button initialization")
    func testButtonInitialization() {
        let _ = RRButton("Test Button") {
            // Action
        }
    }
    
    @Test("Button with style")
    func testButtonWithStyle() {
        let _ = RRButton("Test Button", style: .primary) {
            // Action
        }
    }
    
    @Test("Button with size")
    func testButtonWithSize() {
        let _ = RRButton("Test Button", size: .lg) {
            // Action
        }
        
    }
    
    @Test("Button with all parameters")
    func testButtonWithAllParameters() {
        let _ = RRButton("Test Button", style: .secondary, size: .sm, isEnabled: false) {
            // Action
        }
        
    }
    
    // MARK: - Style Tests
    
    @Test("Button styles")
    func testButtonStyles() {
        let styles: [RRButtonStyle] = [.primary, .secondary, .destructive, .ghost]
        
        for style in styles {
            let _ = RRButton("Test", style: style) { }
        }
    }
    
    // MARK: - Size Tests
    
    @Test("Button sizes")
    func testButtonSizes() {
        let sizes: [RRButtonSize] = [.xs, .sm, .md, .lg, .xl]
        
        for size in sizes {
            let _ = RRButton("Test", size: size) { }
        }
    }
    
    // MARK: - State Tests
    
    @Test("Button enabled state")
    func testButtonEnabledState() {
        let _ = RRButton("Enabled", isEnabled: true) { }
        let _ = RRButton("Disabled", isEnabled: false) { }
        
    }
}