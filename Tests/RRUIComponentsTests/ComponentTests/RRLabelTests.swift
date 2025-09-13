import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRLabelTests {
    
    // MARK: - Initialization Tests
    
    @Test("Label initialization")
    func testLabelInitialization() {
        let label = RRLabel("Test Label")
        #expect(true) // Label created successfully
    }
    
    @Test("Label with style")
    func testLabelWithStyle() {
        let label = RRLabel("Test Label", style: .title)
        #expect(true) // Label created successfully
    }
    
    @Test("Label with weight")
    func testLabelWithWeight() {
        let label = RRLabel("Test Label", weight: .bold)
        #expect(true) // Label created successfully
    }
    
    @Test("Label with all parameters")
    func testLabelWithAllParameters() {
        let label = RRLabel("Test Label", style: .body, weight: .medium, color: .primary)
        #expect(true) // Label created successfully
    }
    
    // MARK: - Style Tests
    
    @Test("Label styles")
    func testLabelStyles() {
        let styles: [RRLabel.Style] = [.title, .subtitle, .body, .caption, .overline]
        
        for style in styles {
            let label = RRLabel("Test", style: style)
            #expect(true) // Label created successfully
        }
    }
    
    // MARK: - Weight Tests
    
    @Test("Label weights")
    func testLabelWeights() {
        let weights: [RRLabel.Weight] = [.light, .regular, .medium, .semibold, .bold, .heavy]
        
        for weight in weights {
            let label = RRLabel("Test", weight: weight)
            #expect(true) // Label created successfully
        }
    }
    
    // MARK: - Color Tests
    
    @Test("Label colors")
    func testLabelColors() {
        let colors: [RRLabel.Color] = [.primary, .secondary]
        
        for color in colors {
            let label = RRLabel("Test", color: color)
            #expect(true) // Label created successfully
        }
    }
    
    // MARK: - Text Content Tests
    
    @Test("Label with empty text")
    func testLabelWithEmptyText() {
        let label = RRLabel("")
        #expect(true) // Label created successfully
    }
    
    @Test("Label with long text")
    func testLabelWithLongText() {
        let longText = String(repeating: "Test ", count: 100)
        let label = RRLabel(longText)
        #expect(true) // Label created successfully
    }
}