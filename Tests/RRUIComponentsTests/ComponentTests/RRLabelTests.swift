import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRLabelTests {
    
    // MARK: - Initialization Tests
    
    @Test("Label initialization")
    func testLabelInitialization() {
        let _ = RRLabel("Test Label")
    }
    
    @Test("Label with style")
    func testLabelWithStyle() {
        let _ = RRLabel("Test Label", style: .title)
    }
    
    @Test("Label with weight")
    func testLabelWithWeight() {
        let _ = RRLabel("Test Label", weight: .bold)
    }
    
    @Test("Label with all parameters")
    func testLabelWithAllParameters() {
        let _ = RRLabel("Test Label", style: .body, weight: .medium, color: .primary)
    }
    
    // MARK: - Style Tests
    
    @Test("Label styles")
    func testLabelStyles() {
        let styles: [RRLabel.Style] = [.title, .subtitle, .body, .caption, .overline]
        
        for style in styles {
            let _ = RRLabel("Test", style: style)
        }
    }
    
    // MARK: - Weight Tests
    
    @Test("Label weights")
    func testLabelWeights() {
        let weights: [RRLabel.Weight] = [.light, .regular, .medium, .semibold, .bold, .heavy]
        
        for weight in weights {
            let _ = RRLabel("Test", weight: weight)
        }
    }
    
    // MARK: - Color Tests
    
    @Test("Label colors")
    func testLabelColors() {
        let colors: [RRLabel.Color] = [.primary, .secondary]
        
        for color in colors {
            let _ = RRLabel("Test", color: color)
        }
    }
    
    // MARK: - Text Content Tests
    
    @Test("Label with empty text")
    func testLabelWithEmptyText() {
        let _ = RRLabel("")
    }
    
    @Test("Label with long text")
    func testLabelWithLongText() {
        let longText = String(repeating: "Test ", count: 100)
        let _ = RRLabel(longText)
    }
}