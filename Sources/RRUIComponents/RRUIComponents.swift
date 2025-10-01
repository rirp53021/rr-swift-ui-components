// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import RRFoundation

/// Main entry point for RRUIComponents library
@_exported import SwiftUI
#if canImport(UIKit)
@_exported import UIKit
#endif
@_exported import RRFoundation

// MARK: - Re-exported Foundation Utilities
// RRFoundation provides core utilities including Logger, colors, formatters, etc.

// MARK: - Library Information
public enum RRUIComponentsInfo {
    public static let version = "1.2.2"
    public static let name = "RRUIComponents"
}

// MARK: - Accessibility Compliance
/// WCAG AA compliance utilities for color contrast validation
/// Access via: AccessibilityUtils, WCAGLevel, WCAGCompliance
