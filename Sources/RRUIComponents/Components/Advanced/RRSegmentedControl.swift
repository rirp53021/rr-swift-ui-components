import SwiftUI
import Foundation

// MARK: - Segmented Control Component

/// A customizable segmented control component with various styles and animations
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSegmentedControl<SelectionValue: Hashable>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var selection: SelectionValue
    @State private var selectedIndex: Int = 0
    
    private let items: [SegmentedItem<SelectionValue>]
    private let style: SegmentedControlStyle
    private let animation: Animation
    
    public init(
        selection: Binding<SelectionValue>,
        items: [SegmentedItem<SelectionValue>],
        style: SegmentedControlStyle = .default,
        animation: Animation = .easeInOut(duration: 0.2)
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.animation = animation
    }
    
    private var selectedItemIndex: Int {
        items.firstIndex { $0.value == selection } ?? 0
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: {
                    withAnimation(animation) {
                        selection = item.value
                    }
                }) {
                    HStack(spacing: style.itemSpacing) {
                        if let icon = item.icon {
                            icon
                                .font(style.iconFont)
                                .foregroundColor(selectedItemIndex == index ? style.selectedIconColor(theme) : style.iconColor(theme))
                        }
                        
                        if let title = item.title {
                            RRLabel(title, style: style.labelStyle, weight: .medium, customColor: selectedItemIndex == index ? style.selectedTextColor(theme) : style.textColor(theme))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, style.horizontalPadding)
                    .padding(.vertical, style.verticalPadding)
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if style.showSelectionIndicator {
                                RoundedRectangle(cornerRadius: style.selectionIndicatorCornerRadius)
                                    .fill(style.selectionIndicatorColor(theme))
                                    .opacity(selectedItemIndex == index ? 1 : 0)
                            }
                            
                            if style.showBackground {
                                RoundedRectangle(cornerRadius: style.cornerRadius)
                                    .fill(selectedItemIndex == index ? style.selectedBackgroundColor(theme) : style.backgroundColor(theme))
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(selectedItemIndex == index ? style.selectedBorderColor(theme) : style.borderColor(theme), lineWidth: style.borderWidth)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.containerBackgroundColor(theme))
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.containerBorderColor(theme), lineWidth: style.containerBorderWidth)
                )
        )
        .onAppear {
            selectedIndex = selectedItemIndex
        }
        .onChange(of: selection) { _ in
            selectedIndex = selectedItemIndex
        }
    }
}

// MARK: - Segmented Item

public struct SegmentedItem<Value: Hashable> {
    public let value: Value
    public let title: String?
    public let icon: Image?
    
    public init(value: Value, title: String? = nil, icon: Image? = nil) {
        self.value = value
        self.title = title
        self.icon = icon
    }
    
    public init(value: Value, title: String) {
        self.value = value
        self.title = title
        self.icon = nil
    }
    
    public init(value: Value, icon: Image) {
        self.value = value
        self.title = nil
        self.icon = icon
    }
}

// MARK: - Segmented Control Style

public struct SegmentedControlStyle {
    public let containerBackgroundColor: (Theme) -> Color
    public let containerBorderColor: (Theme) -> Color
    public let containerBorderWidth: CGFloat
    public let backgroundColor: (Theme) -> Color
    public let selectedBackgroundColor: (Theme) -> Color
    public let textColor: (Theme) -> Color
    public let selectedTextColor: (Theme) -> Color
    public let iconColor: (Theme) -> Color
    public let selectedIconColor: (Theme) -> Color
    public let borderColor: (Theme) -> Color
    public let selectedBorderColor: (Theme) -> Color
    public let borderWidth: CGFloat
    public let labelStyle: RRLabel.Style
    public let iconFont: Font
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat
    public let showBackground: Bool
    public let showSelectionIndicator: Bool
    public let selectionIndicatorColor: (Theme) -> Color
    public let selectionIndicatorCornerRadius: CGFloat
    
    public static let `default` = SegmentedControlStyle(
        containerBackgroundColor: { theme in theme.colors.surfaceVariant },
        containerBorderColor: { theme in Color.clear },
        containerBorderWidth: 0,
        backgroundColor: { theme in Color.clear },
        selectedBackgroundColor: { theme in theme.colors.primary },
        textColor: { theme in theme.colors.primaryText },
        selectedTextColor: { theme in theme.colors.onPrimary },
        iconColor: { theme in theme.colors.secondaryText },
        selectedIconColor: { theme in theme.colors.onPrimary },
        borderColor: { theme in Color.clear },
        selectedBorderColor: { theme in Color.clear },
        borderWidth: 0,
        labelStyle: .body,
        iconFont: .body,
        horizontalPadding: DesignTokens.Spacing.md,
        verticalPadding: DesignTokens.Spacing.sm,
        itemSpacing: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.md,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: { theme in theme.colors.primary },
        selectionIndicatorCornerRadius: DesignTokens.BorderRadius.sm
    )
    
    public static let pill = SegmentedControlStyle(
        containerBackgroundColor: { theme in theme.colors.surfaceVariant },
        containerBorderColor: { theme in Color.clear },
        containerBorderWidth: 0,
        backgroundColor: { theme in Color.clear },
        selectedBackgroundColor: { theme in theme.colors.primary },
        textColor: { theme in theme.colors.primaryText },
        selectedTextColor: { theme in theme.colors.onPrimary },
        iconColor: { theme in theme.colors.secondaryText },
        selectedIconColor: { theme in theme.colors.onPrimary },
        borderColor: { theme in Color.clear },
        selectedBorderColor: { theme in Color.clear },
        borderWidth: 0,
        labelStyle: .body,
        iconFont: .body,
        horizontalPadding: DesignTokens.Spacing.lg,
        verticalPadding: DesignTokens.Spacing.md,
        itemSpacing: DesignTokens.Spacing.sm,
        cornerRadius: DesignTokens.BorderRadius.xl,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: { theme in Color.clear },
        selectionIndicatorCornerRadius: 0
    )
    
    public static let outlined = SegmentedControlStyle(
        containerBackgroundColor: { theme in Color.clear },
        containerBorderColor: { theme in theme.colors.outline },
        containerBorderWidth: 1,
        backgroundColor: { theme in Color.clear },
        selectedBackgroundColor: { theme in theme.colors.primary.opacity(0.1) },
        textColor: { theme in theme.colors.primaryText },
        selectedTextColor: { theme in theme.colors.primary },
        iconColor: { theme in theme.colors.secondaryText },
        selectedIconColor: { theme in theme.colors.primary },
        borderColor: { theme in Color.clear },
        selectedBorderColor: { theme in theme.colors.primary },
        borderWidth: 1,
        labelStyle: .body,
        iconFont: .body,
        horizontalPadding: DesignTokens.Spacing.md,
        verticalPadding: DesignTokens.Spacing.sm,
        itemSpacing: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.md,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: { theme in Color.clear },
        selectionIndicatorCornerRadius: 0
    )
    
    public static let indicator = SegmentedControlStyle(
        containerBackgroundColor: { theme in theme.colors.surfaceVariant },
        containerBorderColor: { theme in Color.clear },
        containerBorderWidth: 0,
        backgroundColor: { theme in Color.clear },
        selectedBackgroundColor: { theme in Color.clear },
        textColor: { theme in theme.colors.primaryText },
        selectedTextColor: { theme in theme.colors.onPrimary },
        iconColor: { theme in theme.colors.secondaryText },
        selectedIconColor: { theme in theme.colors.onPrimary },
        borderColor: { theme in Color.clear },
        selectedBorderColor: { theme in Color.clear },
        borderWidth: 0,
        labelStyle: .body,
        iconFont: .body,
        horizontalPadding: DesignTokens.Spacing.md,
        verticalPadding: DesignTokens.Spacing.sm,
        itemSpacing: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.md,
        showBackground: false,
        showSelectionIndicator: true,
        selectionIndicatorColor: { theme in theme.colors.primary },
        selectionIndicatorCornerRadius: DesignTokens.BorderRadius.sm
    )
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRSegmentedControl where SelectionValue == String {
    init(
        selection: Binding<String>,
        items: [String],
        style: SegmentedControlStyle = .default,
        animation: Animation = .easeInOut(duration: 0.2)
    ) {
        let segmentedItems = items.map { SegmentedItem(value: $0, title: $0) }
        self.init(selection: selection, items: segmentedItems, style: style, animation: animation)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRSegmentedControl where SelectionValue == Int {
    init(
        selection: Binding<Int>,
        items: [String],
        style: SegmentedControlStyle = .default,
        animation: Animation = .easeInOut(duration: 0.2)
    ) {
        let segmentedItems = items.enumerated().map { index, title in
            SegmentedItem(value: index, title: title)
        }
        self.init(selection: selection, items: segmentedItems, style: style, animation: animation)
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRSegmentedControl_Previews: PreviewProvider {
    @State static var selectedTab = "Home"
    @State static var selectedIndex = 0
    @State static var selectedOption = "Option 1"
    
    static var previews: some View {
        RRSegmentedControlPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRSegmentedControl Examples")
    }
}

private struct RRSegmentedControlPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var selectedTab = "Home"
    @State private var selectedIndex = 0
    @State private var selectedOption = "Option 1"
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            // Default style
            RRSegmentedControl(
                selection: $selectedTab,
                items: ["Home", "Search", "Profile"],
                style: .default
            )
            
            // Pill style
            RRSegmentedControl(
                selection: $selectedIndex,
                items: ["All", "Active", "Completed"],
                style: .pill
            )
            
            // Outlined style
            RRSegmentedControl(
                selection: $selectedOption,
                items: ["Option 1", "Option 2", "Option 3"],
                style: .outlined
            )
            
            // Indicator style
            RRSegmentedControl(
                selection: $selectedTab,
                items: [
                    SegmentedItem(value: "Home", title: "Home", icon: Image(systemName: "house")),
                    SegmentedItem(value: "Search", title: "Search", icon: Image(systemName: "magnifyingglass")),
                    SegmentedItem(value: "Profile", title: "Profile", icon: Image(systemName: "person"))
                ],
                style: .indicator
            )
            
            // Icon only
            RRSegmentedControl(
                selection: $selectedTab,
                items: [
                    SegmentedItem(value: "Home", icon: Image(systemName: "house")),
                    SegmentedItem(value: "Search", icon: Image(systemName: "magnifyingglass")),
                    SegmentedItem(value: "Profile", icon: Image(systemName: "person"))
                ],
                style: .pill
            )
        }
        .padding(DesignTokens.Spacing.componentPadding)
    }
}
