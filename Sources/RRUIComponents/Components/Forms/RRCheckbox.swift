// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Checkbox Style

public enum CheckboxStyle {
    case square
    case circle
    case rounded
}

// MARK: - RRCheckbox

public struct RRCheckbox: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var isChecked: Bool
    private let title: String?
    private let style: CheckboxStyle
    private let size: CGFloat
    private let onToggle: (Bool) -> Void
    
    public init(
        isChecked: Binding<Bool>,
        title: String? = nil,
        style: CheckboxStyle = .square,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeLG,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isChecked = isChecked
        self.title = title
        self.style = style
        self.size = size
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Button(action: {
                isChecked.toggle()
                onToggle(isChecked)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(isChecked ? theme.colors.primary : theme.colors.outline, lineWidth: 2)
                        .frame(width: size, height: size)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .foregroundColor(theme.colors.primary)
                            .font(.system(size: size * 0.6, weight: DesignTokens.Typography.weightBold))
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if let title = title {
                RRLabel(title, style: .body, weight: .medium, color: .primary)
                    .onTapGesture {
                        isChecked.toggle()
                        onToggle(isChecked)
                    }
            }
        }
        .keyboardNavigation(
            config: .button,
            onActivate: {
                isChecked.toggle()
                onToggle(isChecked)
            }
        )
        .keyboardNavigationAccessibility(config: .button)
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .square: return DesignTokens.BorderRadius.sm
        case .circle: return size / 2
        case .rounded: return DesignTokens.BorderRadius.md
        }
    }
}

// MARK: - Checkbox Group

public struct RRCheckboxGroup<Item: Identifiable & Hashable>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let items: [Item]
    private let selection: Binding<Set<Item>>
    private let titleKeyPath: KeyPath<Item, String>
    private let style: CheckboxStyle
    private let size: CGFloat
    private let onSelectionChange: (Set<Item>) -> Void
    
    public init(
        _ items: [Item],
        selection: Binding<Set<Item>>,
        titleKeyPath: KeyPath<Item, String>,
        style: CheckboxStyle = .square,
        size: CGFloat = DesignTokens.ComponentSize.iconSizeLG,
        onSelectionChange: @escaping (Set<Item>) -> Void = { _ in }
    ) {
        self.items = items
        self.selection = selection
        self.titleKeyPath = titleKeyPath
        self.style = style
        self.size = size
        self.onSelectionChange = onSelectionChange
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            ForEach(items) { item in
                RRCheckbox(
                    isChecked: Binding(
                        get: { selection.wrappedValue.contains(item) },
                        set: { isChecked in
                            if isChecked {
                                selection.wrappedValue.insert(item)
                            } else {
                                selection.wrappedValue.remove(item)
                            }
                            onSelectionChange(selection.wrappedValue)
                        }
                    ),
                    title: item[keyPath: titleKeyPath],
                    style: style,
                    size: size
                )
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Checkbox Styles", style: .title, weight: .bold, color: .primary)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                RRCheckbox(isChecked: .constant(true), title: "Square Checkbox", style: .square)
                RRCheckbox(isChecked: .constant(false), title: "Circle Checkbox", style: .circle)
                RRCheckbox(isChecked: .constant(true), title: "Rounded Checkbox", style: .rounded)
            }
            
            RRLabel("Checkbox Group", style: .title, weight: .bold, color: .primary)
            
            RRCheckboxGroup(
                [
                    CheckboxItem(id: 1, title: "Option 1"),
                    CheckboxItem(id: 2, title: "Option 2"),
                    CheckboxItem(id: 3, title: "Option 3")
                ],
                selection: .constant([CheckboxItem(id: 1, title: "Option 1")]),
                titleKeyPath: \.title
            )
        }
        .padding(DesignTokens.Spacing.componentPadding)
        .themeProvider(ThemeProvider())
    }
}

struct CheckboxItem: Identifiable, Hashable {
    let id: Int
    let title: String
}
#endif
