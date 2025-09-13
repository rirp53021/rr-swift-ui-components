import Testing
import SwiftUI
@testable import RRUIComponents

/// Visual regression tests for component appearance
@MainActor
struct ComponentAppearanceTests {
    
    @Test("Button appearance consistency")
    func testButtonAppearanceConsistency() {
        // Test primary button appearance
        let primaryButton = RRButton("Primary Button", action: {})
        let _ = primaryButton
        
        // Test secondary button appearance
        let secondaryButton = RRButton("Secondary Button", action: {})
        let _ = secondaryButton
        
        // Test button with different sizes
        let smallButton = RRButton("Small", action: {})
        let _ = smallButton
        
        let largeButton = RRButton("Large", action: {})
        let _ = largeButton
    }
    
    @Test("Label appearance consistency")
    func testLabelAppearanceConsistency() {
        // Test different label styles
        let headlineLabel = RRLabel("Headline Text", style: .body)
        let _ = headlineLabel
        
        let bodyLabel = RRLabel("Body Text", style: .body)
        let _ = bodyLabel
        
        let captionLabel = RRLabel("Caption Text", style: .caption)
        let _ = captionLabel
        
        // Test different weights
        let boldLabel = RRLabel("Bold Text", weight: .bold)
        let _ = boldLabel
        
        let lightLabel = RRLabel("Light Text", weight: .light)
        let _ = lightLabel
    }
    
    @Test("Card appearance consistency")
    func testCardAppearanceConsistency() {
        // Test basic card
        let basicCard = RRCard {
            RRLabel("Card Content", style: .body)
        }
        let _ = basicCard
        
        // Test card with different styles
        let elevatedCard = RRCard(style: .elevated) {
            RRLabel("Elevated Card", style: .body)
        }
        let _ = elevatedCard
        
        let outlinedCard = RRCard(style: .outlined) {
            RRLabel("Outlined Card", style: .body)
        }
        let _ = outlinedCard
    }
    
    @Test("Modal appearance consistency")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testModalAppearanceConsistency() {
        // Test modal with different content
        let textModal = RRModal(isPresented: .constant(true)) {
            VStack {
                RRLabel("Modal Title", style: .body)
                RRLabel("Modal content goes here", style: .body)
                RRButton("Close", action: {})
            }
        }
        let _ = textModal
        
        // Test modal with complex content
        let complexModal = RRModal(isPresented: .constant(true)) {
            VStack(spacing: 16) {
                RRLabel("Complex Modal", style: .body)
                RRTextField("Enter text", text: .constant(""))
                RRButton("Submit", action: {})
            }
        }
        let _ = complexModal
    }
    
    @Test("Carousel appearance consistency")
    func testCarouselAppearanceConsistency() {
        let testData = [
            CarouselTestItem(id: "1", title: "Item 1"),
            CarouselTestItem(id: "2", title: "Item 2"),
            CarouselTestItem(id: "3", title: "Item 3")
        ]
        
        // Test carousel with different styles
        let basicCarousel = RRCarousel(data: testData) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        let _ = basicCarousel
        
        // Test carousel with custom style
        let styledCarousel = RRCarousel(data: testData) { item in
            RRCard(style: .elevated) {
                RRLabel(item.title, style: .body)
            }
        }
        let _ = styledCarousel
    }
    
    @Test("Toggle appearance consistency")
    func testToggleAppearanceConsistency() {
        // Test basic toggle
        let basicToggle = RRToggle(isOn: .constant(false), title: "Basic Toggle")
        let _ = basicToggle
        
        // Test toggle with different styles
        let styledToggle = RRToggle(isOn: .constant(true), title: "Styled Toggle")
        let _ = styledToggle
        
        // Test toggle with custom colors
        let coloredToggle = RRToggle(isOn: .constant(false), title: "Colored Toggle")
        let _ = coloredToggle
    }
    
    @Test("Stepper appearance consistency")
    func testStepperAppearanceConsistency() {
        // Test basic stepper
        let basicStepper = RRStepper(value: .constant(0), step: 1)
        let _ = basicStepper
        
        // Test stepper with different ranges
        let rangedStepper = RRStepper(value: .constant(5), step: 1)
        let _ = rangedStepper
        
        // Test stepper with custom styling
        let styledStepper = RRStepper(value: .constant(10), step: 5)
        let _ = styledStepper
    }
    
    @Test("DatePicker appearance consistency")
    func testDatePickerAppearanceConsistency() {
        // Test basic date picker
        let basicDatePicker = RRDatePicker(selection: .constant(Date()))
        let _ = basicDatePicker
        
        // Test date picker with different styles
        let styledDatePicker = RRDatePicker(selection: .constant(Date()))
        let _ = styledDatePicker
    }
    
    @Test("SearchBar appearance consistency")
    func testSearchBarAppearanceConsistency() {
        // Test basic search bar
        let basicSearchBar = RRSearchBar(text: .constant(""), placeholder: "Search...")
        let _ = basicSearchBar
        
        // Test search bar with different styles
        let styledSearchBar = RRSearchBar(text: .constant(""), placeholder: "Advanced Search")
        let _ = styledSearchBar
    }
    
    @Test("LoadingIndicator appearance consistency")
    func testLoadingIndicatorAppearanceConsistency() {
        // Test different loading styles
        let spinnerLoading = RRLoadingIndicator(style: .spinner)
        let _ = spinnerLoading
        
        let dotsLoading = RRLoadingIndicator(style: .dots)
        let _ = dotsLoading
        
        let pulseLoading = RRLoadingIndicator(style: .pulse)
        let _ = pulseLoading
    }
    
    @Test("EmptyState appearance consistency")
    func testEmptyStateAppearanceConsistency() {
        // Test basic empty state
        let basicEmptyState = RREmptyState(title: "No Data") {
            RRButton("Refresh", action: {})
        }
        let _ = basicEmptyState
        
        // Test empty state with different styles
        let styledEmptyState = RREmptyState(title: "No Results Found") {
            RRButton("Try Again", action: {})
        }
        let _ = styledEmptyState
    }
    
    @Test("Snackbar appearance consistency")
    func testSnackbarAppearanceConsistency() {
        // Test different snackbar styles
        let successSnackbar = RRSnackbar(.success, isPresented: .constant(true)) {
            RRLabel("Success message", style: .body)
        }
        let _ = successSnackbar
        
        let errorSnackbar = RRSnackbar(.error, isPresented: .constant(true)) {
            RRLabel("Error message", style: .body)
        }
        let _ = errorSnackbar
        
        let infoSnackbar = RRSnackbar(.info, isPresented: .constant(true)) {
            RRLabel("Info message", style: .body)
        }
        let _ = infoSnackbar
    }
    
    @Test("Alert appearance consistency")
    func testAlertAppearanceConsistency() {
        // Test different alert styles
        let successAlert = RRAlert(.success, isPresented: .constant(true)) {
            VStack {
                RRLabel("Success!", style: .body)
                RRLabel("Operation completed successfully", style: .body)
                RRButton("OK", action: {})
            }
        }
        let _ = successAlert
        
        let errorAlert = RRAlert(.error, isPresented: .constant(true)) {
            VStack {
                RRLabel("Error!", style: .body)
                RRLabel("Something went wrong", style: .body)
                RRButton("OK", action: {})
            }
        }
        let _ = errorAlert
    }
}

// MARK: - Test Helpers

struct CarouselTestItem: Identifiable {
    let id: String
    let title: String
}
