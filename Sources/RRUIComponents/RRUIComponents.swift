// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

/// Main entry point for RRUIComponents library
@_exported import SwiftUI

// MARK: - Re-exported Foundation Utilities
// Note: RRFoundation is no longer imported as UI utilities have been moved here

// Re-export utilities for convenience
// Note: These are automatically available since they're in the same module

// Logger is available through direct import in files that need it

// MARK: - Library Information
public enum RRUIComponents {
    public static let version = "1.0.0"
    public static let name = "RRUIComponents"
}

// MARK: - Accessibility Compliance
/// WCAG AA compliance utilities for color contrast validation
/// Access via: AccessibilityUtils, WCAGLevel, WCAGCompliance
