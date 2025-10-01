# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.4] - 2025-10-01

### Fixed
- **Bundle Loading**: Use `Bundle.module` for SPM resource loading
  - Correctly loads `Colors.xcassets` when used as Swift Package dependency
  - Fixes "No color named 'Primary' found in asset catalog" errors in consuming apps
  - Maintains backward compatibility with non-SPM builds

## [2.2.3] - 2025-10-01

### Fixed
- **Package.swift**: Added `Colors.xcassets` as a resource
  - Fixes "No color named 'Primary' found in asset catalog" errors
  - Ensures asset catalog is properly bundled when used as SPM dependency

## [2.2.2] - 2025-10-01

### Fixed
- **XcodeGen**: Added missing scheme configuration for Xcode project
  - RRUIComponents scheme now properly generated
  - Enables building and testing from Xcode UI

## [2.2.0] - 2025-10-01

### Changed
- **RRTabBar**: Updated `TabItem` to use `Image` instead of `String` for icons
  - `icon` property changed from `String` to `Image`
  - `selectedIcon` property changed from `String?` to `Image?`
  - Allows for more flexible icon usage (SF Symbols, custom images, etc.)
  - **Breaking Change**: Existing code using string-based icons must be updated to use `Image(systemName:)`

### Fixed
- **Module Interface**: Renamed `RRUIComponents` enum to `RRUIComponentsInfo` to fix module interface generation bug
  - Resolves Xcode build errors where types were incorrectly nested inside the enum
  - Fixes "is not a member type of enum 'RRUIComponents.RRUIComponents'" errors

### Migration Guide
```swift
// Before (v2.1.0)
TabItem(title: "Home", icon: "house", selectedIcon: "house.fill")

// After (v2.2.0)
TabItem(title: "Home", icon: Image(systemName: "house"), selectedIcon: Image(systemName: "house.fill"))

// Library info access (if used)
// Before: RRUIComponents.version
// After: RRUIComponentsInfo.version
```

## [1.0.0] - 2024-08-28

### Added
- **Centralized Theming System**
  - Color schemes with light and dark variants
  - Typography systems (default, rounded, monospaced)
  - Consistent spacing scale
  - Theme manager with environment support

- **UI Components**
  - RRButton with multiple styles and states
  - RRLoadingIndicator with various animation types
  - RREmptyState for common empty scenarios

- **Layout Helpers**
  - Responsive design utilities
  - Device-specific layout modifiers
  - Safe area and keyboard handling
  - Common layout patterns

- **Testing**
  - Comprehensive unit tests using Testing framework
  - Test coverage for all major components
  - Preview support for SwiftUI components

### Features
- Support for iOS 13.0+, macOS 11.0+, tvOS 13.0+, watchOS 6.0+, visionOS 1.0+
- SwiftUI-based components with modern design patterns
- Clean Architecture with MVVM principles
- Full Swift Package Manager support
- XcodeGen integration for project management

### Technical Details
- Swift 5.9+ compatibility
- Xcode 15.0+ support
- Dependency on RRFoundation v1.7.1+
- Comprehensive SwiftDoc documentation
- MIT License

---

## Version History

- **1.0.0**: Initial release with core UI components and theming system

## Migration Guides

### From Unreleased to 1.0.0
This is the initial release, so no migration is required.

## Deprecation Notices

No deprecations in this release.

## Breaking Changes

No breaking changes in this release.

## Known Issues

None known at this time.

## Future Plans

- Additional UI components (cards, forms, navigation)
- Advanced theming options (custom color palettes)
- Animation and transition libraries
- Accessibility improvements
- Performance optimizations


