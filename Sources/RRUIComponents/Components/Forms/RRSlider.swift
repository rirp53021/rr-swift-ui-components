// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Slider Style

public enum SliderStyle {
    case standard
    case range
    case stepped
}

// MARK: - RRSlider

public struct RRSlider: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let style: SliderStyle
    private let onValueChanged: (Double) -> Void
    
    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0.01,
        style: SliderStyle = .standard,
        onValueChanged: @escaping (Double) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.style = style
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                RRLabel(String(format: "%.1f", range.lowerBound), style: .caption, color: .secondary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f", value), style: .caption, color: .primary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f", range.upperBound), style: .caption, color: .secondary)
            }
            
            Slider(value: $value, in: range, step: step) { isEditing in
                if !isEditing {
                    onValueChanged(value)
                }
            }
            .accentColor(theme.colors.primary)
        }
    }
}

// MARK: - Range Slider

public struct RRRangeSlider: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var lowerValue: Double
    @Binding private var upperValue: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let onValueChanged: (Double, Double) -> Void
    
    public init(
        lowerValue: Binding<Double>,
        upperValue: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0.01,
        onValueChanged: @escaping (Double, Double) -> Void = { _, _ in }
    ) {
        self._lowerValue = lowerValue
        self._upperValue = upperValue
        self.range = range
        self.step = step
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                RRLabel(String(format: "%.1f", range.lowerBound), style: .caption, color: .secondary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f - %.1f", lowerValue, upperValue), style: .caption, color: .primary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f", range.upperBound), style: .caption, color: .secondary)
            }
            
            HStack {
                Slider(value: $lowerValue, in: range, step: step) { isEditing in
                    if !isEditing {
                        onValueChanged(lowerValue, upperValue)
                    }
                }
                .accentColor(theme.colors.primary)
                
                Slider(value: $upperValue, in: range, step: step) { isEditing in
                    if !isEditing {
                        onValueChanged(lowerValue, upperValue)
                    }
                }
                .accentColor(theme.colors.primary)
            }
        }
    }
}

// MARK: - Stepped Slider

public struct RRSteppedSlider: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let onValueChanged: (Double) -> Void
    
    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0.1,
        onValueChanged: @escaping (Double) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.onValueChanged = onValueChanged
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                RRLabel(String(format: "%.1f", range.lowerBound), style: .caption, color: .secondary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f", value), style: .caption, color: .primary)
                
                Spacer()
                
                RRLabel(String(format: "%.1f", range.upperBound), style: .caption, color: .secondary)
            }
            
            Slider(value: $value, in: range, step: step) { isEditing in
                if !isEditing {
                    onValueChanged(value)
                }
            }
            .accentColor(theme.colors.primary)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRSlider_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveSliderPreview()
    }
}

struct InteractiveSliderPreview: View {
    @State private var sliderValue = 0.5
    @State private var lowerValue = 0.2
    @State private var upperValue = 0.8
    @State private var steppedValue = 0.5
    
    var body: some View {
        VStack(spacing: 20) {
            RRLabel("Slider Styles", style: .title, weight: .bold, color: .primary)
            
            VStack(spacing: 20) {
                RRSlider(value: $sliderValue, in: 0...1, step: 0.01)
                
                RRRangeSlider(
                    lowerValue: $lowerValue,
                    upperValue: $upperValue,
                    in: 0...1,
                    step: 0.01
                )
                
                RRSteppedSlider(
                    value: $steppedValue,
                    in: 0...1,
                    step: 0.1
                )
            }
        }
        .padding()
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRSlider")
    }
}
#endif
