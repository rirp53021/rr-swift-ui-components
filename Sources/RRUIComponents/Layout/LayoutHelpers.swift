import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Layout Modifiers
public extension View {
    /// Centers the view horizontally and vertically in its parent
    func centerInParent() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// Centers the view horizontally in its parent
    func centerHorizontally() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    /// Centers the view vertically in its parent
    func centerVertically() -> some View {
        self.frame(maxHeight: .infinity)
    }
    
    /// Makes the view take up the full width of its parent
    func fullWidth() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Makes the view take up the full height of its parent
    func fullHeight() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    
    /// Makes the view take up the full size of its parent
    func fullSize() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    /// Applies a fixed width to the view
    /// - Parameter width: The fixed width
    func fixedWidth(_ width: CGFloat) -> some View {
        self.frame(width: width)
    }
    
    /// Applies a fixed height to the view
    /// - Parameter height: The fixed height
    func fixedHeight(_ height: CGFloat) -> some View {
        self.frame(height: height)
    }
    
    /// Applies fixed dimensions to the view
    /// - Parameters:
    ///   - width: The fixed width
    ///   - height: The fixed height
    func fixedSize(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
    }
    
    /// Applies a minimum width to the view
    /// - Parameter width: The minimum width
    func minWidth(_ width: CGFloat) -> some View {
        self.frame(minWidth: width)
    }
    
    /// Applies a minimum height to the view
    /// - Parameter height: The minimum height
    func minHeight(_ height: CGFloat) -> some View {
        self.frame(minHeight: height)
    }
    
    /// Applies a maximum width to the view
    /// - Parameter width: The maximum width
    func maxWidth(_ width: CGFloat) -> some View {
        self.frame(maxWidth: width)
    }
    
    /// Applies a maximum height to the view
    /// - Parameter height: The maximum height
    func maxHeight(_ height: CGFloat) -> some View {
        self.frame(maxHeight: height)
    }
}

// MARK: - Conditional Layout
public extension View {
    /// Conditionally applies a modifier
    /// - Parameters:
    ///   - condition: The condition to check
    ///   - modifier: The modifier to apply if the condition is true
    func conditional<M: ViewModifier>(_ condition: Bool, _ modifier: M) -> some View {
        if condition {
            AnyView(self.modifier(modifier))
        } else {
            AnyView(self)
        }
    }
    
    /// Conditionally applies a transform
    /// - Parameters:
    ///   - condition: The condition to check
    ///   - transform: The transform to apply if the condition is true
    func conditional<M: View>(_ condition: Bool, _ transform: @escaping (Self) -> M) -> some View {
        if condition {
            AnyView(transform(self))
        } else {
            AnyView(self)
        }
    }
}

// MARK: - Responsive Layout
public extension View {
    /// Applies different modifiers based on device orientation
    /// - Parameters:
    ///   - portrait: The modifier to apply in portrait orientation
    ///   - landscape: The modifier to apply in landscape orientation
    func responsive<P: ViewModifier, L: ViewModifier>(
        portrait: P,
        landscape: L
    ) -> some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                self.modifier(landscape)
            } else {
                self.modifier(portrait)
            }
        }
    }
    
    /// Applies different transforms based on device orientation
    /// - Parameters:
    ///   - portrait: The transform to apply in portrait orientation
    ///   - landscape: The transform to apply in landscape orientation
    func responsive<P: View, L: View>(
        portrait: @escaping (Self) -> P,
        landscape: @escaping (Self) -> L
    ) -> some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                landscape(self)
            } else {
                portrait(self)
            }
        }
    }
}

// MARK: - Safe Area Helpers
public extension View {
    /// Ignores safe areas on all edges
    func ignoreSafeArea() -> some View {
        self.ignoresSafeArea(.all, edges: .all)
    }
    
    /// Ignores safe areas on specific edges
    /// - Parameter edges: The edges to ignore safe areas on
    func ignoreSafeArea(_ edges: Edge.Set) -> some View {
        self.ignoresSafeArea(.all, edges: edges)
    }
    
    /// Applies padding to respect safe areas
    /// - Parameter edges: The edges to apply safe area padding to
    func safeAreaPadding(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges)
    }
}

// MARK: - Keyboard Handling
public extension View {
    /// Dismisses the keyboard when tapping outside
    func dismissKeyboardOnTap() -> some View {
        #if canImport(UIKit)
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        #else
        self
        #endif
    }
    
    /// Adapts to keyboard appearance
    func adaptsToKeyboard() -> some View {
        #if canImport(UIKit)
        self.modifier(KeyboardAdaptiveModifier())
        #else
        self
        #endif
    }
}

// MARK: - Keyboard Adaptive Modifier
#if canImport(UIKit)
private struct KeyboardAdaptiveModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
    }
}
#endif

// MARK: - Device Type Helpers
public extension View {
    /// Applies different modifiers based on device type
    /// - Parameters:
    ///   - iPhone: The modifier to apply on iPhone
    ///   - iPad: The modifier to apply on iPad
    func deviceSpecific<IPhone: ViewModifier, IPad: ViewModifier>(
        iPhone: IPhone,
        iPad: IPad
    ) -> some View {
        self.modifier(DeviceSpecificModifier(iPhone: iPhone, iPad: iPad))
    }
    
    /// Applies different transforms based on device type
    /// - Parameters:
    ///   - iPhone: The transform to apply on iPhone
    ///   - iPad: The transform to apply on iPad
    func deviceSpecific<IPhone: View, IPad: View>(
        iPhone: @escaping (Self) -> IPhone,
        iPad: @escaping (Self) -> IPad
    ) -> some View {
        #if canImport(UIKit)
        if UIDevice.current.userInterfaceIdiom == .pad {
            AnyView(iPad(self))
        } else {
            AnyView(iPhone(self))
        }
        #else
        AnyView(iPhone(self))
        #endif
    }
}

// MARK: - Device Specific Modifiers
private struct DeviceSpecificModifier<IPhone: ViewModifier, IPad: ViewModifier>: ViewModifier {
    let iPhone: IPhone
    let iPad: IPad
    
    func body(content: Content) -> some View {
        #if canImport(UIKit)
        if UIDevice.current.userInterfaceIdiom == .pad {
            content.modifier(iPad)
        } else {
            content.modifier(iPhone)
        }
        #else
        content.modifier(iPhone)
        #endif
    }
}



// MARK: - Preview Helpers
#if DEBUG
public extension View {
    /// Preview helper for different device orientations
    @available(macOS 12.0, *)
    func previewOrientation() -> some View {
        Group {
            self
                .previewDisplayName("Portrait")
                .previewInterfaceOrientation(.portrait)
            
            self
                .previewDisplayName("Landscape")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
    
    /// Preview helper for different device types
    func previewDevices() -> some View {
        Group {
            self
                .previewDisplayName("iPhone")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
            
            self
                .previewDisplayName("iPad")
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
        }
    }
}
#endif
