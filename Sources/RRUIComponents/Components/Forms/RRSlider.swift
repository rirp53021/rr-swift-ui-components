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
        VStack(spacing: RRSpacing.sm) {
            HStack {
                Text("\(range.lowerBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(value, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(range.upperBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: range, step: step) { isEditing in
                if !isEditing {
                    onValueChanged(value)
                }
            }
            .accentColor(.blue)
        }
    }
}

// MARK: - Range Slider

public struct RRRangeSlider: View {
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
        VStack(spacing: RRSpacing.sm) {
            HStack {
                Text("\(range.lowerBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(lowerValue, specifier: "%.1f") - \(upperValue, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(range.upperBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Slider(value: $lowerValue, in: range, step: step) { isEditing in
                    if !isEditing {
                        onValueChanged(lowerValue, upperValue)
                    }
                }
                .accentColor(.blue)
                
                Slider(value: $upperValue, in: range, step: step) { isEditing in
                    if !isEditing {
                        onValueChanged(lowerValue, upperValue)
                    }
                }
                .accentColor(.blue)
            }
        }
    }
}

// MARK: - Stepped Slider

public struct RRSteppedSlider: View {
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
        VStack(spacing: RRSpacing.sm) {
            HStack {
                Text("\(range.lowerBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(value, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(range.upperBound, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: range, step: step) { isEditing in
                if !isEditing {
                    onValueChanged(value)
                }
            }
            .accentColor(.blue)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRSlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Slider Styles")
                .font(.headline)
            
            VStack(spacing: 20) {
                RRSlider(value: .constant(0.5), in: 0...1, step: 0.01)
                
                RRRangeSlider(
                    lowerValue: .constant(0.2),
                    upperValue: .constant(0.8),
                    in: 0...1,
                    step: 0.01
                )
                
                RRSteppedSlider(
                    value: .constant(0.5),
                    in: 0...1,
                    step: 0.1
                )
            }
        }
        .padding()
    }
}
#endif
