//
//  KeyboardNavigation.swift
//  RRUIComponents
//
//  Created by RRUIComponents on 2025-09-07.
//

import SwiftUI

/// Configuration for keyboard navigation behavior of a component.
public struct NavigationConfig {
    public var isEnabled: Bool
    public var focusGroup: String? // For grouping related components
    public var focusPriority: Int // Higher value means higher priority
    public var focusOrder: Int // For explicit ordering within a group
    public var focusTraits: AccessibilityTraits // Traits for keyboard accessibility

    public init(
        isEnabled: Bool = true,
        focusGroup: String? = nil,
        focusPriority: Int = 0,
        focusOrder: Int = 0,
        focusTraits: AccessibilityTraits = .isButton // Default to button-like behavior
    ) {
        self.isEnabled = isEnabled
        self.focusGroup = focusGroup
        self.focusPriority = focusPriority
        self.focusOrder = focusOrder
        self.focusTraits = focusTraits
    }

    // Predefined configurations for common component types
    public static let button = NavigationConfig(focusTraits: .isButton)
    public static let textField = NavigationConfig(focusTraits: .isKeyboardKey)
    @available(iOS 17.0, *)
    public static let toggle = NavigationConfig(focusTraits: .isToggle)
    public static let slider = NavigationConfig(focusTraits: .isButton) // Fallback for older iOS versions
    public static let navigation = NavigationConfig(focusTraits: .isHeader) // For tab bars, nav bars
    public static let link = NavigationConfig(focusTraits: .isLink)
}

/// Actions that can be triggered by keyboard movement.
public enum KeyboardMovementAction {
    case moveUp
    case moveDown
    case moveLeft
    case moveRight
    case activate
    case cancel
    case moveToNext // For moving to the next logical input field
    case moveToPrevious // For moving to the previous logical input field
    case moveToStart // For moving to the first item in a group
    case moveToEnd // For moving to the last item in a group
    case custom(String) // For custom actions
}

public extension View {
    /// Adds keyboard navigation support to a view.
    /// - Parameters:
    ///   - config: The navigation configuration for this view.
    ///   - onActivate: Closure to execute when the component is activated (e.g., Space or Enter key).
    ///   - onCancel: Closure to execute when a cancel action is performed (e.g., Escape key).
    ///   - onMovement: Closure to execute for directional movements (e.g., arrow keys).
    func keyboardNavigation(
        config: NavigationConfig,
        onActivate: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        onMovement: ((KeyboardMovementAction) -> Void)? = nil
    ) -> some View {
        self
            .accessibilityAddTraits(config.focusTraits)
            .accessibility(sortPriority: Double(config.focusPriority))
            .accessibilityAction(named: "Activate") {
                if config.isEnabled { onActivate?() }
            }
            .accessibilityAction(named: "Cancel") {
                if config.isEnabled { onCancel?() }
            }
            .accessibilityAction(named: "Move Up") {
                if config.isEnabled { onMovement?(.moveUp) }
            }
            .accessibilityAction(named: "Move Down") {
                if config.isEnabled { onMovement?(.moveDown) }
            }
            .accessibilityAction(named: "Move Left") {
                if config.isEnabled { onMovement?(.moveLeft) }
            }
            .accessibilityAction(named: "Move Right") {
                if config.isEnabled { onMovement?(.moveRight) }
            }
    }

    /// Applies accessibility modifiers related to keyboard navigation.
    /// - Parameter config: The navigation configuration for this view.
    func keyboardNavigationAccessibility(config: NavigationConfig) -> some View {
        self.accessibilityAddTraits(config.focusTraits)
            .accessibility(sortPriority: Double(config.focusPriority))
            // You might add accessibilityCustomActions here for more complex interactions
    }
}
