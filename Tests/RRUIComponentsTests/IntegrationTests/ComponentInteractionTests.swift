import Testing
import SwiftUI
@testable import RRUIComponents

/// Integration tests for component interactions
@MainActor
struct ComponentInteractionTests {
    
    @Test("Button and Modal interaction")
    func testButtonModalInteraction() {
        let _ = RRButton("Open Modal", action: {})
        let _ = RRModal(isPresented: .constant(true), content: { Text("Modal Content") })
    }
    
    @Test("Carousel and Label interaction")
    func testCarouselLabelInteraction() {
        let testData = [TestItem(id: "1", title: "Item 1")]
        let _ = RRCarousel(data: testData, content: { item in
            RRLabel(item.title, style: .body)
        })
    }
    
    @Test("Card and Button interaction")
    func testCardButtonInteraction() {
        let _ = RRCard {
            VStack {
                RRLabel("Card Title", style: .body)
                RRButton("Action", action: {})
            }
        }
    }
    
    @Test("LoadingIndicator and EmptyState interaction")
    func testLoadingEmptyStateInteraction() {
        let _ = RRLoadingIndicator()
        let _ = RREmptyState(title: "No Data", action: {
            RRButton("Refresh", action: {})
        })
    }
    
    @Test("Stepper and Toggle interaction")
    func testStepperToggleInteraction() {
        let _ = RRStepper(value: .constant(0), step: 1)
        let _ = RRToggle(isOn: .constant(false), title: "Toggle Option")
    }
    
    @Test("DatePicker and SearchBar interaction")
    func testDatePickerSearchBarInteraction() {
        let _ = RRDatePicker(selection: .constant(Date()))
        let _ = RRSearchBar(text: .constant(""), placeholder: "Search...")
    }
    
    @Test("VideoPlayer and ImageGallery interaction")
    func testVideoPlayerImageGalleryInteraction() {
        let _ = RRVideoPlayer(videoURL: URL(string: "https://example.com/video.mp4"))
        let _ = RRImageGallery(images: [
            GalleryImage(url: URL(string: "https://example.com/image1.jpg")!)
        ])
    }
}

// MARK: - Test Helpers

struct TestItem: Identifiable {
    let id: String
    let title: String
}
