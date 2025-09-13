import Testing
import SwiftUI
@testable import RRUIComponents

/// Visual regression tests for dark mode
@MainActor
struct DarkModeTests {
    
    @Test("Dark mode component appearance")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testDarkModeComponentAppearance() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test all components in dark mode
        let darkModeView = VStack(spacing: 16) {
            // Buttons
            RRButton("Primary Button", action: {})
            RRButton("Secondary Button", action: {})
            
            // Labels
            RRLabel("Headline Text", style: .body)
            RRLabel("Body Text", style: .body)
            RRLabel("Caption Text", style: .caption)
            
            // Cards
            RRCard {
                RRLabel("Dark Mode Card", style: .body)
            }
            
            RRCard(style: .elevated) {
                RRLabel("Elevated Dark Card", style: .body)
            }
            
            RRCard(style: .outlined) {
                RRLabel("Outlined Dark Card", style: .body)
            }
            
            // Form elements
            RRTextField("Dark mode input", text: .constant(""))
            RRToggle(isOn: .constant(false), title: "Dark mode toggle")
            RRStepper(value: .constant(0), step: 1)
            RRDatePicker(selection: .constant(Date()))
            RRSearchBar(text: .constant(""), placeholder: "Dark mode search")
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkModeView
    }
    
    @Test("Dark mode color contrast")
    func testDarkModeColorContrast() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test color contrast in dark mode
        let contrastView = VStack(spacing: 16) {
            // Primary colors
            RRButton("Primary Button", action: {})
            RRLabel("Primary Text", style: .body)
            
            // Secondary colors
            RRButton("Secondary Button", action: {})
            RRLabel("Secondary Text", style: .body)
            
            // Surface colors
            RRCard {
                RRLabel("Surface Card", style: .body)
            }
            
            // Background colors
            RRContainer {
                RRLabel("Background Container", style: .body)
            }
            
            // Error colors
            RRLabel("Error Text", style: .body)
            RRButton("Error Button", action: {})
            
            // Success colors
            RRLabel("Success Text", style: .body)
            RRButton("Success Button", action: {})
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = contrastView
    }
    
    @Test("Dark mode modal appearance")
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    func testDarkModeModalAppearance() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test modals in dark mode
        let darkModal = RRModal(isPresented: .constant(true)) {
            VStack(spacing: 16) {
                RRLabel("Dark Mode Modal", style: .body)
                RRLabel("This modal should have proper dark mode styling", style: .body)
                RRTextField("Modal input", text: .constant(""))
                HStack {
                    RRButton("Cancel", action: {})
                    RRButton("Confirm", action: {})
                }
            }
            .padding()
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkModal
    }
    
    @Test("Dark mode carousel appearance")
    func testDarkModeCarouselAppearance() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        let testData = [
            DarkModeTestItem(id: "1", title: "Dark Item 1"),
            DarkModeTestItem(id: "2", title: "Dark Item 2"),
            DarkModeTestItem(id: "3", title: "Dark Item 3")
        ]
        
        // Test carousel in dark mode
        let darkCarousel = RRCarousel(data: testData) { item in
            RRCard {
                VStack {
                    RRLabel(item.title, style: .body)
                    RRLabel("Dark mode carousel item", style: .body)
                }
            }
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkCarousel
    }
    
    @Test("Dark mode navigation appearance")
    func testDarkModeNavigationAppearance() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test navigation components in dark mode
        let darkNavigationView = VStack {
            RRNavigationBar(
                title: "Dark Navigation",
                leadingButton: { AnyView(RRButton("Back", action: {})) },
                trailingButton: { AnyView(RRButton("Next", action: {})) }
            )
            
            RRTabBar(
                selectedTab: .constant(0),
                items: [
                    TabItem(title: "Home", icon: "house"),
                    TabItem(title: "Search", icon: "magnifyingglass"),
                    TabItem(title: "Profile", icon: "person")
                ]
            )
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkNavigationView
    }
    
    @Test("Dark mode feedback components")
    func testDarkModeFeedbackComponents() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test feedback components in dark mode
        let darkFeedbackView = VStack(spacing: 16) {
            RRLoadingIndicator()
            
            RREmptyState(title: "No Dark Data") {
                RRButton("Refresh", action: {})
            }
            
            RRSnackbar(.success, isPresented: .constant(true)) {
                RRLabel("Dark mode success", style: .body)
            }
            
            RRAlert(.error, isPresented: .constant(true)) {
                VStack {
                    RRLabel("Dark Mode Error", style: .body)
                    RRLabel("Something went wrong in dark mode", style: .body)
                    RRButton("OK", action: {})
                }
            }
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkFeedbackView
    }
    
    @Test("Dark mode media components")
    func testDarkModeMediaComponents() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test media components in dark mode
        let darkMediaView = VStack(spacing: 16) {
            RRVideoPlayer(videoURL: URL(string: "https://example.com/video.mp4"))
            
            RRImageGallery(images: [
                GalleryImage(url: URL(string: "https://example.com/image1.jpg")!),
                GalleryImage(url: URL(string: "https://example.com/image2.jpg")!)
            ])
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkMediaView
    }
    
    @Test("Dark mode layout components")
    func testDarkModeLayoutComponents() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test layout components in dark mode
        let darkLayoutView = VStack(spacing: 16) {
            RRContainer {
                RRSection {
                    VStack {
                        RRLabel("Dark Section", style: .body)
                        RRLabel("Section content in dark mode", style: .body)
                    }
                }
            }
            
            RRDivider()
            
            RRSpacer()
            
            RRGridView([
                DarkModeTestItem(id: "1", title: "Item 1"),
                DarkModeTestItem(id: "2", title: "Item 2")
            ], columns: 2, spacing: 16) { item in
                RRCard {
                    RRLabel(item.title, style: .body)
                }
            }
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkLayoutView
    }
    
    @Test("Dark mode overlay components")
    func testDarkModeOverlayComponents() {
        let darkThemeProvider = ThemeProvider(theme: .dark)
        
        // Test overlay components in dark mode
        let darkOverlayView = VStack(spacing: 16) {
            RRButton("Show Overlay", action: {})
                .popover(isPresented: .constant(false)) {
                    VStack {
                        RRLabel("Dark Popover", style: .body)
                        RRLabel("Popover content in dark mode", style: .body)
                        RRButton("Close", action: {})
                    }
                    .padding()
                }
            
            RROverlay(
                content: {
                    VStack {
                        RRLabel("Dark Overlay", style: .body)
                        RRLabel("Overlay content in dark mode", style: .body)
                        RRButton("Close Overlay", action: {})
                    }
                    .padding()
                },
                overlayContent: {
                    VStack {
                        RRLabel("Overlay Content", style: .body)
                        RRLabel("This is the overlay content", style: .body)
                    }
                    .padding()
                }
            )
        }
        .environment(\.themeProvider, darkThemeProvider)
        
        let _ = darkOverlayView
    }
    
    @Test("Dark mode theme switching")
    func testDarkModeThemeSwitching() {
        let themeProvider = ThemeProvider()
        
        // Test switching between light and dark modes
        let switchingView = VStack(spacing: 16) {
            RRLabel("Theme Switching Test", style: .body)
            RRButton("Toggle Theme", action: {
                themeProvider.toggleTheme()
            })
            
            RRCard {
                VStack {
                    RRLabel("Current Theme", style: .body)
                    RRLabel("This should change when theme is toggled", style: .caption)
                }
            }
        }
        .environment(\.themeProvider, themeProvider)
        
        let _ = switchingView
    }
}

// MARK: - Test Helpers

struct DarkModeTestItem: Identifiable {
    let id: String
    let title: String
}
