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
    @Binding private var isChecked: Bool
    private let title: String?
    private let style: CheckboxStyle
    private let size: CGFloat
    private let onToggle: (Bool) -> Void
    
    public init(
        isChecked: Binding<Bool>,
        title: String? = nil,
        style: CheckboxStyle = .square,
        size: CGFloat = 20,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isChecked = isChecked
        self.title = title
        self.style = style
        self.size = size
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: RRSpacing.sm) {
            Button(action: {
                isChecked.toggle()
                onToggle(isChecked)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: size, height: size)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .font(.system(size: size * 0.6, weight: .bold))
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if let title = title {
                Text(title)
                    .foregroundColor(.primary)
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
        case .square: return 4
        case .circle: return size / 2
        case .rounded: return 6
        }
    }
}

// MARK: - Checkbox Group

public struct RRCheckboxGroup<Item: Identifiable & Hashable>: View {
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
        size: CGFloat = 20,
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
        VStack(alignment: .leading, spacing: RRSpacing.sm) {
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
        VStack(spacing: 20) {
            Text("Checkbox Styles")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                RRCheckbox(isChecked: .constant(true), title: "Square Checkbox", style: .square)
                RRCheckbox(isChecked: .constant(false), title: "Circle Checkbox", style: .circle)
                RRCheckbox(isChecked: .constant(true), title: "Rounded Checkbox", style: .rounded)
            }
            
            Text("Checkbox Group")
                .font(.headline)
            
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
        .padding()
    }
}

struct CheckboxItem: Identifiable, Hashable {
    let id: Int
    let title: String
}
#endif
