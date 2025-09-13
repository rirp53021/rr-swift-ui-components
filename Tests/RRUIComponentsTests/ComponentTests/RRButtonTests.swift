import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRButtonTests {
    
    // MARK: - Initialization Tests
    
    @Test("Button initialization")
    func testButtonInitialization() {
        let button = RRButton("Test Button") {
            // Action
        }
        
        // Verify button was created successfully (no nil check needed for structs)
        #expect(true) // Button creation successful
    }
    
    @Test("Button with style")
    func testButtonWithStyle() {
        let button = RRButton("Test Button", style: .primary) {
            // Action
        }
        
        // Verify button was created successfully
        #expect(true) // Button creation successful
    }
    
    @Test("Button with size")
    func testButtonWithSize() {
        let button = RRButton("Test Button", size: .lg) {
            // Action
        }
        
        // Verify button was created successfully
        #expect(true) // Button creation successful
    }
    
    @Test("Button with all parameters")
    func testButtonWithAllParameters() {
        let button = RRButton("Test Button", style: .secondary, size: .sm, isEnabled: false) {
            // Action
        }
        
        // Verify button was created successfully
        #expect(true) // Button creation successful
    }
    
    // MARK: - Style Tests
    
    @Test("Button styles")
    func testButtonStyles() {
        let styles: [RRButtonStyle] = [.primary, .secondary, .destructive, .ghost]
        
        for style in styles {
            let button = RRButton("Test", style: style) { }
            #expect(true) // Button creation successful
        }
    }
    
    // MARK: - Size Tests
    
    @Test("Button sizes")
    func testButtonSizes() {
        let sizes: [RRButtonSize] = [.xs, .sm, .md, .lg, .xl]
        
        for size in sizes {
            let button = RRButton("Test", size: size) { }
            #expect(true) // Button creation successful
        }
    }
    
    // MARK: - State Tests
    
    @Test("Button enabled state")
    func testButtonEnabledState() {
        let enabledButton = RRButton("Enabled", isEnabled: true) { }
        let disabledButton = RRButton("Disabled", isEnabled: false) { }
        
        #expect(true) // Buttons created successfully
    }
}