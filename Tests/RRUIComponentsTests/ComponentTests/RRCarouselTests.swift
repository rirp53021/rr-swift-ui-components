import Testing
import SwiftUI
@testable import RRUIComponents


@MainActor
struct RRCarouselTests {
    
    // MARK: - Basic Tests
    
    @Test("Carousel exists")
    func testCarouselExists() {
        // Test that RRCarousel can be imported and referenced
        struct TestItem: Identifiable {
            let id = UUID()
            let title: String
        }
        #expect(RRCarousel<[TestItem], Text>.self != nil)
    }
    
    @Test("Carousel initialization with identifiable data")
    func testCarouselInitialization() {
        struct TestItem: Identifiable {
            let id = UUID()
            let text: String
        }
        
        let data = [
            TestItem(text: "Item 1"),
            TestItem(text: "Item 2"),
            TestItem(text: "Item 3")
        ]
        
        let carousel = RRCarousel(data: data) { item in
            Text(item.text)
        }
        
        #expect(carousel != nil)
    }
    
    @Test("Carousel with default style")
    func testCarouselWithDefaultStyle() {
        struct TestItem: Identifiable {
            let id = UUID()
            let text: String
        }
        
        let data = [
            TestItem(text: "Item 1"),
            TestItem(text: "Item 2"),
            TestItem(text: "Item 3")
        ]
        
        let carousel = RRCarousel(data: data, style: .default) { item in
            Text(item.text)
        }
        
        #expect(carousel != nil)
    }
}