import SwiftUI
import Foundation

// MARK: - Segmented Control Component

/// A customizable segmented control component with various styles and animations
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSegmentedControl<SelectionValue: Hashable>: View {
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
                                .foregroundColor(selectedItemIndex == index ? style.selectedIconColor : style.iconColor)
                        }
                        
                        if let title = item.title {
                            Text(title)
                                .font(style.font)
                                .foregroundColor(selectedItemIndex == index ? style.selectedTextColor : style.textColor)
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
                                    .fill(style.selectionIndicatorColor)
                                    .opacity(selectedItemIndex == index ? 1 : 0)
                            }
                            
                            if style.showBackground {
                                RoundedRectangle(cornerRadius: style.cornerRadius)
                                    .fill(selectedItemIndex == index ? style.selectedBackgroundColor : style.backgroundColor)
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(selectedItemIndex == index ? style.selectedBorderColor : style.borderColor, lineWidth: style.borderWidth)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.containerBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.containerBorderColor, lineWidth: style.containerBorderWidth)
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
    public let containerBackgroundColor: Color
    public let containerBorderColor: Color
    public let containerBorderWidth: CGFloat
    public let backgroundColor: Color
    public let selectedBackgroundColor: Color
    public let textColor: Color
    public let selectedTextColor: Color
    public let iconColor: Color
    public let selectedIconColor: Color
    public let borderColor: Color
    public let selectedBorderColor: Color
    public let borderWidth: CGFloat
    public let font: Font
    public let iconFont: Font
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat
    public let showBackground: Bool
    public let showSelectionIndicator: Bool
    public let selectionIndicatorColor: Color
    public let selectionIndicatorCornerRadius: CGFloat
    
    public static let `default` = SegmentedControlStyle(
        containerBackgroundColor: Color(.systemGray6),
        containerBorderColor: Color.clear,
        containerBorderWidth: 0,
        backgroundColor: Color.clear,
        selectedBackgroundColor: Color(.systemBackground),
        textColor: .primary,
        selectedTextColor: .primary,
        iconColor: .secondary,
        selectedIconColor: .primary,
        borderColor: Color.clear,
        selectedBorderColor: Color.clear,
        borderWidth: 0,
        font: .body,
        iconFont: .body,
        horizontalPadding: 16,
        verticalPadding: 8,
        itemSpacing: 4,
        cornerRadius: 8,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: Color(.systemBlue),
        selectionIndicatorCornerRadius: 6
    )
    
    public static let pill = SegmentedControlStyle(
        containerBackgroundColor: Color(.systemGray6),
        containerBorderColor: Color.clear,
        containerBorderWidth: 0,
        backgroundColor: Color.clear,
        selectedBackgroundColor: Color(.systemBlue),
        textColor: .primary,
        selectedTextColor: .white,
        iconColor: .secondary,
        selectedIconColor: .white,
        borderColor: Color.clear,
        selectedBorderColor: Color.clear,
        borderWidth: 0,
        font: .body,
        iconFont: .body,
        horizontalPadding: 20,
        verticalPadding: 10,
        itemSpacing: 6,
        cornerRadius: 20,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: Color.clear,
        selectionIndicatorCornerRadius: 0
    )
    
    public static let outlined = SegmentedControlStyle(
        containerBackgroundColor: Color.clear,
        containerBorderColor: Color(.systemGray4),
        containerBorderWidth: 1,
        backgroundColor: Color.clear,
        selectedBackgroundColor: Color(.systemBlue).opacity(0.1),
        textColor: .primary,
        selectedTextColor: .blue,
        iconColor: .secondary,
        selectedIconColor: .blue,
        borderColor: Color.clear,
        selectedBorderColor: Color(.systemBlue),
        borderWidth: 1,
        font: .body,
        iconFont: .body,
        horizontalPadding: 16,
        verticalPadding: 8,
        itemSpacing: 4,
        cornerRadius: 8,
        showBackground: true,
        showSelectionIndicator: false,
        selectionIndicatorColor: Color.clear,
        selectionIndicatorCornerRadius: 0
    )
    
    public static let indicator = SegmentedControlStyle(
        containerBackgroundColor: Color(.systemGray6),
        containerBorderColor: Color.clear,
        containerBorderWidth: 0,
        backgroundColor: Color.clear,
        selectedBackgroundColor: Color.clear,
        textColor: .primary,
        selectedTextColor: .white,
        iconColor: .secondary,
        selectedIconColor: .white,
        borderColor: Color.clear,
        selectedBorderColor: Color.clear,
        borderWidth: 0,
        font: .body,
        iconFont: .body,
        horizontalPadding: 16,
        verticalPadding: 8,
        itemSpacing: 4,
        cornerRadius: 8,
        showBackground: false,
        showSelectionIndicator: true,
        selectionIndicatorColor: Color(.systemBlue),
        selectionIndicatorCornerRadius: 6
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
        VStack(spacing: 30) {
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
        .padding()
        .previewDisplayName("RRSegmentedControl")
    }
}
