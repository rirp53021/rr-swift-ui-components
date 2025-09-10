// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Stepper Style

public enum StepperStyle {
    case standard
    case compact
    case large
}

// MARK: - RRStepper

public struct RRStepper: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var value: Int
    private let range: ClosedRange<Int>
    private let step: Int
    private let style: StepperStyle
    private let onValueChanged: (Int) -> Void
    
    public init(
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        style: StepperStyle = .standard,
        onValueChanged: @escaping (Int) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.style = style
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Button(action: {
                if value > range.lowerBound {
                    value = max(range.lowerBound, value - step)
                    onValueChanged(value)
                }
            }) {
                Image(systemName: "minus")
                    .foregroundColor(value <= range.lowerBound ? theme.colors.disabled : theme.colors.primary)
                    .font(style == .large ? .title2 : .title3)
            }
            .disabled(value <= range.lowerBound)
            
            RRLabel(
                "\(value)",
                style: style == .large ? .title : .subtitle,
                weight: .medium,
                color: .primary
            )
            .frame(minWidth: 40)
            
            Button(action: {
                if value < range.upperBound {
                    value = min(range.upperBound, value + step)
                    onValueChanged(value)
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(value >= range.upperBound ? theme.colors.disabled : theme.colors.primary)
                    .font(style == .large ? .title2 : .title3)
            }
            .disabled(value >= range.upperBound)
        }
        .padding(style == .compact ? DesignTokens.Spacing.xs : DesignTokens.Spacing.sm)
        .background(theme.colors.surfaceVariant)
        .cornerRadius(DesignTokens.BorderRadius.md)
    }
}

// MARK: - Stepper with Label

public struct RRStepperWithLabel: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var value: Int
    private let label: String
    private let range: ClosedRange<Int>
    private let step: Int
    private let style: StepperStyle
    private let onValueChanged: (Int) -> Void
    
    public init(
        label: String,
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        style: StepperStyle = .standard,
        onValueChanged: @escaping (Int) -> Void = { _ in }
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.style = style
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            RRLabel(
                label,
                style: .subtitle,
                weight: .medium,
                color: .primary
            )
            
            RRStepper(
                value: $value,
                in: range,
                step: step,
                style: style,
                onValueChanged: onValueChanged
            )
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRStepper_Previews: PreviewProvider {
    static var previews: some View {
        RRStepperPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRStepper Examples")
    }
}

private struct RRStepperPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Stepper Styles")
            
            VStack(spacing: DesignTokens.Spacing.md) {
                RRStepper(value: .constant(5), in: 0...10, style: .standard)
                
                RRStepper(value: .constant(3), in: 0...5, style: .compact)
                
                RRStepper(value: .constant(7), in: 0...10, style: .large)
                
                RRStepperWithLabel(
                    label: "Quantity",
                    value: .constant(2),
                    in: 0...10,
                    step: 1,
                    style: .standard
                )
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
