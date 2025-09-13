import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRModalTests {
    
    // MARK: - Initialization Tests
    
    @Test("Modal initialization")
    func testModalInitialization() {
        let modal = RRModal(isPresented: .constant(false)) {
            Text("Modal Content")
        }
        
        #expect(modal != nil)
    }
    
    @Test("Modal with onDismiss")
    func testModalWithOnDismiss() {
        let modal = RRModal(
            isPresented: .constant(false),
            onDismiss: { }
        ) {
            Text("Modal Content")
        }
        
        #expect(modal != nil)
    }
    
    // MARK: - Content Tests
    
    @Test("Modal with text content")
    func testModalWithTextContent() {
        let modal = RRModal(isPresented: .constant(false)) {
            Text("Simple Text Content")
        }
        
        #expect(modal != nil)
    }
    
    @Test("Modal with complex content")
    func testModalWithComplexContent() {
        let modal = RRModal(isPresented: .constant(false)) {
            VStack {
                Text("Title")
                Text("Subtitle")
                Button("Action") { }
            }
        }
        
        #expect(modal != nil)
    }
    
    @Test("Modal with empty content")
    func testModalWithEmptyContent() {
        let modal = RRModal(isPresented: .constant(false)) {
            EmptyView()
        }
        
        #expect(modal != nil)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("Modal with nil content")
    func testModalWithNilContent() {
        let modal = RRModal(isPresented: .constant(false)) {
            // Empty content
        }
        
        #expect(modal != nil)
    }
    
    @Test("Modal with long content")
    func testModalWithLongContent() {
        let longText = String(repeating: "Long content ", count: 100)
        let modal = RRModal(isPresented: .constant(false)) {
            Text(longText)
        }
        
        #expect(modal != nil)
    }
}