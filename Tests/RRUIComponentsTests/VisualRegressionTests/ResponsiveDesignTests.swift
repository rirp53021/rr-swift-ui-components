import Testing
import SwiftUI
@testable import RRUIComponents

/// Visual regression tests for responsive design
@MainActor
struct ResponsiveDesignTests {
    
    @Test("Component responsiveness on different screen sizes")
    func testComponentResponsivenessOnDifferentScreenSizes() {
        // Test components in different container sizes
        let smallContainer = VStack {
            RRButton("Small Screen Button", action: {})
            RRLabel("Small Screen Text", style: .body)
            RRCard {
                RRLabel("Small Screen Card", style: .body)
            }
        }
        .frame(width: 200, height: 300)
        let _ = smallContainer
        
        let mediumContainer = VStack {
            RRButton("Medium Screen Button", action: {})
            RRLabel("Medium Screen Text", style: .body)
            RRCard {
                RRLabel("Medium Screen Card", style: .body)
            }
        }
        .frame(width: 400, height: 600)
        let _ = mediumContainer
        
        let largeContainer = VStack {
            RRButton("Large Screen Button", action: {})
            RRLabel("Large Screen Text", style: .body)
            RRCard {
                RRLabel("Large Screen Card", style: .body)
            }
        }
        .frame(width: 800, height: 1200)
        let _ = largeContainer
    }
    
    @Test("Grid responsiveness")
    func testGridResponsiveness() {
        let testData = [
            GridTestItem(id: "1", title: "Item 1"),
            GridTestItem(id: "2", title: "Item 2"),
            GridTestItem(id: "3", title: "Item 3"),
            GridTestItem(id: "4", title: "Item 4"),
            GridTestItem(id: "5", title: "Item 5"),
            GridTestItem(id: "6", title: "Item 6")
        ]
        
        // Test grid with different column counts
        let twoColumnGrid = RRGridView(testData, columns: 2, spacing: 16) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 400)
        let _ = twoColumnGrid
        
        let threeColumnGrid = RRGridView(testData, columns: 3, spacing: 12) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 600)
        let _ = threeColumnGrid
        
        let fourColumnGrid = RRGridView(testData, columns: 4, spacing: 8) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 800)
        let _ = fourColumnGrid
    }
    
    @Test("Carousel responsiveness")
    func testCarouselResponsiveness() {
        let testData = [
            CarouselTestItem(id: "1", title: "Item 1"),
            CarouselTestItem(id: "2", title: "Item 2"),
            CarouselTestItem(id: "3", title: "Item 3")
        ]
        
        // Test carousel in different container sizes
        let smallCarousel = RRCarousel(data: testData) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 200, height: 150)
        let _ = smallCarousel
        
        let mediumCarousel = RRCarousel(data: testData) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 400, height: 200)
        let _ = mediumCarousel
        
        let largeCarousel = RRCarousel(data: testData) { item in
            RRCard {
                RRLabel(item.title, style: .body)
            }
        }
        .frame(width: 600, height: 250)
        let _ = largeCarousel
    }
    
    @Test("Navigation bar responsiveness")
    func testNavigationBarResponsiveness() {
        // Test navigation bar in different widths
        let narrowNavBar = RRNavigationBar(
            title: "Narrow Nav",
            leadingButton: { AnyView(RRButton("Back", action: {})) },
            trailingButton: { AnyView(RRButton("Next", action: {})) }
        )
        .frame(width: 200)
        let _ = narrowNavBar
        
        let wideNavBar = RRNavigationBar(
            title: "Wide Navigation Bar",
            leadingButton: { AnyView(RRButton("Back", action: {})) },
            trailingButton: { AnyView(RRButton("Next", action: {})) }
        )
        .frame(width: 600)
        let _ = wideNavBar
    }
    
    @Test("Tab bar responsiveness")
    func testTabBarResponsiveness() {
        let tabItems = [
            TabItem(title: "Home", icon: "house"),
            TabItem(title: "Search", icon: "magnifyingglass"),
            TabItem(title: "Profile", icon: "person"),
            TabItem(title: "Settings", icon: "gear")
        ]
        
        // Test tab bar with different numbers of items
        let twoTabBar = RRTabBar(
            selectedTab: .constant(0),
            items: Array(tabItems.prefix(2))
        )
        .frame(width: 200)
        let _ = twoTabBar
        
        let fourTabBar = RRTabBar(
            selectedTab: .constant(0),
            items: tabItems
        )
        .frame(width: 400)
        let _ = fourTabBar
    }
    
    @Test("Modal responsiveness")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testModalResponsiveness() {
        // Test modal in different container sizes
        let smallModal = RRModal(isPresented: .constant(true)) {
            VStack {
                RRLabel("Small Modal", style: .body)
                RRLabel("This is a small modal", style: .body)
                RRButton("Close", action: {})
            }
            .padding()
        }
        .frame(width: 200, height: 150)
        let _ = smallModal
        
        let largeModal = RRModal(isPresented: .constant(true)) {
            VStack {
                RRLabel("Large Modal", style: .body)
                RRLabel("This is a large modal with more content", style: .body)
                RRTextField("Enter text", text: .constant(""))
                RRButton("Submit", action: {})
                RRButton("Cancel", action: {})
            }
            .padding()
        }
        .frame(width: 500, height: 400)
        let _ = largeModal
    }
    
    @Test("Form responsiveness")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testFormResponsiveness() {
        // Test form layout in different container sizes
        let smallForm = VStack(spacing: 12) {
            RRLabel("Small Form", style: .body)
            RRTextField("Name", text: .constant(""))
            RRTextField("Email", text: .constant(""))
            RRButton("Submit", action: {})
        }
        .frame(width: 200)
        let _ = smallForm
        
        let largeForm = VStack(spacing: 16) {
            RRLabel("Large Form", style: .body)
            RRTextField("Full Name", text: .constant(""))
            RRTextField("Email Address", text: .constant(""))
            RRTextField("Phone Number", text: .constant(""))
            RRDatePicker(selection: .constant(Date()))
            RRToggle(isOn: .constant(false), title: "Accept Terms")
            HStack {
                RRButton("Cancel", action: {})
                RRButton("Submit", action: {})
            }
        }
        .frame(width: 500)
        let _ = largeForm
    }
    
    @Test("Card responsiveness")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testCardResponsiveness() {
        // Test cards in different container sizes
        let smallCard = RRCard {
            VStack {
                RRLabel("Small Card", style: .body)
                RRLabel("Content", style: .body)
            }
        }
        .frame(width: 150, height: 100)
        let _ = smallCard
        
        let mediumCard = RRCard {
            VStack {
                RRLabel("Medium Card", style: .body)
                RRLabel("This is a medium card with more content", style: .body)
                RRButton("Action", action: {})
            }
        }
        .frame(width: 300, height: 200)
        let _ = mediumCard
        
        let largeCard = RRCard {
            VStack {
                RRLabel("Large Card", style: .body)
                RRLabel("This is a large card with extensive content that should wrap properly", style: .body)
                RRTextField("Input field", text: .constant(""))
                HStack {
                    RRButton("Primary", action: {})
                    RRButton("Secondary", action: {})
                }
            }
        }
        .frame(width: 500, height: 300)
        let _ = largeCard
    }
    
    @Test("Text responsiveness")
    func testTextResponsiveness() {
        // Test text wrapping in different container sizes
        let shortText = RRLabel("Short text", style: .body)
        .frame(width: 100)
        let _ = shortText
        
        let mediumText = RRLabel("This is a medium length text that should wrap nicely", style: .body)
        .frame(width: 200)
        let _ = mediumText
        
        let longText = RRLabel("This is a very long text that should wrap properly across multiple lines and maintain good readability", style: .body)
        .frame(width: 300)
        let _ = longText
    }
    
    @Test("Button responsiveness")
    func testButtonResponsiveness() {
        // Test buttons in different container sizes
        let smallButton = RRButton("Small", action: {})
        .frame(width: 80)
        let _ = smallButton
        
        let mediumButton = RRButton("Medium Button", action: {})
        .frame(width: 150)
        let _ = mediumButton
        
        let largeButton = RRButton("Large Button with Long Text", action: {})
        .frame(width: 250)
        let _ = largeButton
    }
}

// MARK: - Test Helpers

struct GridTestItem: Identifiable {
    let id: String
    let title: String
}


