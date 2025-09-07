// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Toggle Style

public enum ToggleStyle {
    case standard
    case custom
    case toggleSwitch
}

// MARK: - RRToggle

public struct RRToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let style: ToggleStyle
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        style: ToggleStyle = .standard,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.style = style
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: RRSpacing.sm) {
            if let title = title {
                Text(title)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Button(action: {
                isOn.toggle()
                onToggle(isOn)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isOn ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 30)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.spring(response: 0.3), value: isOn)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Custom Toggle

public struct RRCustomToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: RRSpacing.sm) {
            if let title = title {
                Text(title)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Button(action: {
                isOn.toggle()
                onToggle(isOn)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isOn ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 20)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .offset(x: isOn ? 10 : -10)
                        .animation(.spring(response: 0.3), value: isOn)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Switch Toggle

public struct RRSwitchToggle: View {
    @Binding private var isOn: Bool
    private let title: String?
    private let onToggle: (Bool) -> Void
    
    public init(
        isOn: Binding<Bool>,
        title: String? = nil,
        onToggle: @escaping (Bool) -> Void = { _ in }
    ) {
        self._isOn = isOn
        self.title = title
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: RRSpacing.sm) {
            if let title = title {
                Text(title)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        isOn.toggle()
                        onToggle(isOn)
                    }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { newValue in
                    onToggle(newValue)
                }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Toggle Styles")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 15) {
                RRToggle(isOn: .constant(true), title: "Standard Toggle")
                RRCustomToggle(isOn: .constant(false), title: "Custom Toggle")
                RRSwitchToggle(isOn: .constant(true), title: "Switch Toggle")
            }
        }
        .padding()
    }
}
#endif
