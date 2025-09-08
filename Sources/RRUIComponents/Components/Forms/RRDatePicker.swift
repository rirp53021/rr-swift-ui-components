import SwiftUI
import Foundation

// MARK: - Validation State

public enum ValidationState {
    case none
    case valid
    case invalid
    case warning
    
    var borderColor: Color {
        switch self {
        case .none: return .gray.opacity(0.3)
        case .valid: return .green
        case .invalid: return .red
        case .warning: return .orange
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .none: return 1
        case .valid, .invalid, .warning: return 2
        }
    }
}

// MARK: - Date & Time Picker Component

/// A customizable date and time picker component with various display modes
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRDatePicker: View {
    @Binding private var selection: Date
    @State private var isExpanded = false
    
    private let title: String
    private let mode: DatePickerMode
    private let style: DatePickerStyle
    private let validationState: ValidationState
    private let dateRange: ClosedRange<Date>
    private let formatter: DateFormatter
    
    public init(
        selection: Binding<Date>,
        title: String = "Select Date",
        mode: DatePickerMode = .date,
        style: DatePickerStyle = .default,
        validationState: ValidationState = .none,
        in dateRange: ClosedRange<Date> = Date.distantPast...Date.distantFuture
    ) {
        self._selection = selection
        self.title = title
        self.mode = mode
        self.style = style
        self.validationState = validationState
        self.dateRange = dateRange
        
        self.formatter = DateFormatter()
        switch mode {
        case .date:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
        case .dateAndTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        }
    }
    
    private var displayText: String {
        formatter.string(from: selection)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: mode.iconName)
                        .foregroundColor(style.iconColor)
                        .font(.system(size: 16))
                    
                    Text(displayText)
                        .foregroundColor(style.textColor)
                        .font(style.font)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(style.chevronColor)
                        .font(.system(size: 12, weight: .medium))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.horizontal, style.horizontalPadding)
                .padding(.vertical, style.verticalPadding)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(validationState.borderColor, lineWidth: validationState.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 0) {
                    DatePicker(
                        "",
                        selection: $selection,
                        in: dateRange,
                        displayedComponents: mode.displayedComponents
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                    .background(style.pickerBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(style.pickerBorderColor, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}

// MARK: - Date Picker Mode

public enum DatePickerMode {
    case date
    case time
    case dateAndTime
    
    var iconName: String {
        switch self {
        case .date: return "calendar"
        case .time: return "clock"
        case .dateAndTime: return "calendar.badge.clock"
        }
    }
    
    var displayedComponents: DatePickerComponents {
        switch self {
        case .date: return .date
        case .time: return .hourAndMinute
        case .dateAndTime: return [.date, .hourAndMinute]
        }
    }
}

// MARK: - Date Picker Style

public struct DatePickerStyle {
    public let backgroundColor: Color
    public let textColor: Color
    public let titleColor: Color
    public let iconColor: Color
    public let chevronColor: Color
    public let font: Font
    public let titleFont: Font
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let cornerRadius: CGFloat
    public let pickerBackgroundColor: Color
    public let pickerBorderColor: Color
    
    public static let `default` = DatePickerStyle(
        backgroundColor: Color(.systemBackground),
        textColor: .primary,
        titleColor: .primary,
        iconColor: .secondary,
        chevronColor: .secondary,
        font: .body,
        titleFont: .caption,
        horizontalPadding: 12,
        verticalPadding: 12,
        cornerRadius: 8,
        pickerBackgroundColor: Color(.systemBackground),
        pickerBorderColor: Color(.systemGray4)
    )
    
    public static let filled = DatePickerStyle(
        backgroundColor: Color(.systemGray6),
        textColor: .primary,
        titleColor: .primary,
        iconColor: .secondary,
        chevronColor: .secondary,
        font: .body,
        titleFont: .caption,
        horizontalPadding: 12,
        verticalPadding: 12,
        cornerRadius: 8,
        pickerBackgroundColor: Color(.systemBackground),
        pickerBorderColor: Color(.systemGray4)
    )
    
    public static let outlined = DatePickerStyle(
        backgroundColor: Color.clear,
        textColor: .primary,
        titleColor: .primary,
        iconColor: .secondary,
        chevronColor: .secondary,
        font: .body,
        titleFont: .caption,
        horizontalPadding: 12,
        verticalPadding: 12,
        cornerRadius: 8,
        pickerBackgroundColor: Color(.systemBackground),
        pickerBorderColor: Color(.systemGray4)
    )
}

// MARK: - Compact Date Picker

/// A compact date picker that shows inline without expansion
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCompactDatePicker: View {
    @Binding private var selection: Date
    
    private let title: String
    private let mode: DatePickerMode
    private let style: DatePickerStyle
    private let validationState: ValidationState
    private let dateRange: ClosedRange<Date>
    
    public init(
        selection: Binding<Date>,
        title: String = "Select Date",
        mode: DatePickerMode = .date,
        style: DatePickerStyle = .default,
        validationState: ValidationState = .none,
        in dateRange: ClosedRange<Date> = Date.distantPast...Date.distantFuture
    ) {
        self._selection = selection
        self.title = title
        self.mode = mode
        self.style = style
        self.validationState = validationState
        self.dateRange = dateRange
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            
            DatePicker(
                "",
                selection: $selection,
                in: dateRange,
                displayedComponents: mode.displayedComponents
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(validationState.borderColor, lineWidth: validationState.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        }
    }
}

// MARK: - Time Range Picker

/// A time range picker for selecting start and end times
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTimeRangePicker: View {
    @Binding private var startTime: Date
    @Binding private var endTime: Date
    @State private var isExpanded = false
    
    private let title: String
    private let style: DatePickerStyle
    private let validationState: ValidationState
    
    public init(
        startTime: Binding<Date>,
        endTime: Binding<Date>,
        title: String = "Select Time Range",
        style: DatePickerStyle = .default,
        validationState: ValidationState = .none
    ) {
        self._startTime = startTime
        self._endTime = endTime
        self.title = title
        self.style = style
        self.validationState = validationState
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    private var displayText: String {
        let start = timeFormatter.string(from: startTime)
        let end = timeFormatter.string(from: endTime)
        return "\(start) - \(end)"
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !title.isEmpty {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(style.iconColor)
                        .font(.system(size: 16))
                    
                    Text(displayText)
                        .foregroundColor(style.textColor)
                        .font(style.font)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(style.chevronColor)
                        .font(.system(size: 12, weight: .medium))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.horizontal, style.horizontalPadding)
                .padding(.vertical, style.verticalPadding)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(validationState.borderColor, lineWidth: validationState.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Start Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker(
                            "",
                            selection: $startTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("End Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker(
                            "",
                            selection: $endTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                }
                .padding()
                .background(style.pickerBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.pickerBorderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRDatePicker_Previews: PreviewProvider {
    @State static var selectedDate = Date()
    @State static var selectedTime = Date()
    @State static var startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State static var endTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date()
    
    static var previews: some View {
        VStack(spacing: 20) {
            RRDatePicker(
                selection: $selectedDate,
                title: "Select Date",
                mode: .date,
                style: .default
            )
            
            RRDatePicker(
                selection: $selectedTime,
                title: "Select Time",
                mode: .time,
                style: .filled,
                validationState: .valid
            )
            
            RRCompactDatePicker(
                selection: $selectedDate,
                title: "Compact Date",
                mode: .dateAndTime,
                style: .outlined
            )
            
            RRTimeRangePicker(
                startTime: $startTime,
                endTime: $endTime,
                title: "Working Hours",
                style: .default,
                validationState: .none
            )
        }
        .padding()
        .previewDisplayName("RRDatePicker")
    }
}
