import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRModalTests {
    
    // MARK: - Initialization Tests
    
    @Test("Modal initialization")
    func testModalInitialization() {
        let _ = RRModal(isPresented: .constant(false)) {
            Text("Modal Content")
        }
        
    }
    
    @Test("Modal with onDismiss")
    func testModalWithOnDismiss() {
        let _ = RRModal(
            isPresented: .constant(false),
            onDismiss: { }
        ) {
            Text("Modal Content")
        }
        
    }
    
    // MARK: - Content Tests
    
    @Test("Modal with text content")
    func testModalWithTextContent() {
        let _ = RRModal(isPresented: .constant(false)) {
            Text("Simple Text Content")
        }
        
    }
    
    @Test("Modal with complex content")
    func testModalWithComplexContent() {
        let _ = RRModal(isPresented: .constant(false)) {
            VStack {
                Text("Title")
                Text("Subtitle")
                Button("Action") { }
            }
        }
        
    }
    
    @Test("Modal with empty content")
    func testModalWithEmptyContent() {
        let _ = RRModal(isPresented: .constant(false)) {
            EmptyView()
        }
        
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("Modal with nil content")
    func testModalWithNilContent() {
        let _ = RRModal(isPresented: .constant(false)) {
            // Empty content
        }
        
    }
    
    @Test("Modal with long content")
    func testModalWithLongContent() {
        let longText = String(repeating: "Long content ", count: 100)
        let _ = RRModal(isPresented: .constant(false)) {
            Text(longText)
        }
        
    }
}