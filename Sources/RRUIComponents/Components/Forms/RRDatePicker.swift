import SwiftUI
import Foundation

// MARK: - Validation State

public enum ValidationState {
    case none
    case valid
    case invalid
    case warning
    
    func borderColor(theme: Theme) -> Color {
        switch self {
        case .none: return theme.colors.outline
        case .valid: return theme.colors.success
        case .invalid: return theme.colors.error
        case .warning: return theme.colors.warning
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
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var selection: Date
    @State private var isExpanded = false
    
    private let title: String
    private let mode: DatePickerMode
    private let style: DatePickerStyleType
    private let validationState: ValidationState
    private let dateRange: ClosedRange<Date>
    private let formatter: DateFormatter
    
    public init(
        selection: Binding<Date>,
        title: String = "Select Date",
        mode: DatePickerMode = .date,
        style: DatePickerStyleType = .default,
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
        let themeStyle: DatePickerStyle = {
            switch style {
            case .default: return DatePickerStyle.default(theme: theme)
            case .filled: return DatePickerStyle.filled(theme: theme)
            case .outlined: return DatePickerStyle.outlined(theme: theme)
            }
        }()
        
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            if !title.isEmpty {
                RRLabel(title, style: .caption, weight: .medium, color: .primary)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: mode.iconName)
                        .foregroundColor(themeStyle.iconColor)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeSM))
                    
                    RRLabel(
                        displayText,
                        style: .body,
                        weight: .medium,
                        customColor: themeStyle.textColor
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(themeStyle.chevronColor)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeXS, weight: .medium))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(DesignTokens.Animation.dropdownToggle, value: isExpanded)
                }
                .padding(.horizontal, themeStyle.horizontalPadding)
                .padding(.vertical, themeStyle.verticalPadding)
                .background(themeStyle.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: themeStyle.cornerRadius)
                        .stroke(validationState.borderColor(theme: theme), lineWidth: validationState.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: themeStyle.cornerRadius))
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
                    #if os(iOS)
                    .datePickerStyle(.wheel)
                    #else
                    .datePickerStyle(.compact)
                    #endif
                    .labelsHidden()
                    .padding()
                    .background(themeStyle.pickerBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: themeStyle.cornerRadius)
                            .stroke(themeStyle.pickerBorderColor, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: themeStyle.cornerRadius))
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

public enum DatePickerStyleType: CaseIterable {
    case `default`
    case filled
    case outlined
}

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
    
    public static func `default`(theme: Theme = .light) -> DatePickerStyle {
        DatePickerStyle(
            backgroundColor: theme.colors.surface,
            textColor: theme.colors.primaryText,
            titleColor: theme.colors.primaryText,
            iconColor: theme.colors.onSurfaceVariant,
            chevronColor: theme.colors.onSurfaceVariant,
            font: DesignTokens.Typography.bodyMedium,
            titleFont: DesignTokens.Typography.labelMedium,
            horizontalPadding: DesignTokens.Spacing.inputPadding,
            verticalPadding: DesignTokens.Spacing.inputPadding,
            cornerRadius: DesignTokens.BorderRadius.input,
            pickerBackgroundColor: theme.colors.surface,
            pickerBorderColor: theme.colors.outline
        )
    }
    
    public static func filled(theme: Theme = .light) -> DatePickerStyle {
        DatePickerStyle(
            backgroundColor: theme.colors.surfaceVariant,
            textColor: theme.colors.primaryText,
            titleColor: theme.colors.primaryText,
            iconColor: theme.colors.onSurfaceVariant,
            chevronColor: theme.colors.onSurfaceVariant,
            font: DesignTokens.Typography.bodyMedium,
            titleFont: DesignTokens.Typography.labelMedium,
            horizontalPadding: DesignTokens.Spacing.inputPadding,
            verticalPadding: DesignTokens.Spacing.inputPadding,
            cornerRadius: DesignTokens.BorderRadius.input,
            pickerBackgroundColor: theme.colors.surface,
            pickerBorderColor: theme.colors.outline
        )
    }
    
    public static func outlined(theme: Theme = .light) -> DatePickerStyle {
        DatePickerStyle(
            backgroundColor: Color.clear,
            textColor: theme.colors.primaryText,
            titleColor: theme.colors.primaryText,
            iconColor: theme.colors.onSurfaceVariant,
            chevronColor: theme.colors.onSurfaceVariant,
            font: DesignTokens.Typography.bodyMedium,
            titleFont: DesignTokens.Typography.labelMedium,
            horizontalPadding: DesignTokens.Spacing.inputPadding,
            verticalPadding: DesignTokens.Spacing.inputPadding,
            cornerRadius: DesignTokens.BorderRadius.input,
            pickerBackgroundColor: theme.colors.surface,
            pickerBorderColor: theme.colors.outline
        )
    }
}

// MARK: - Compact Date Picker

/// A compact date picker that shows inline without expansion
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCompactDatePicker: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var selection: Date
    
    private let title: String
    private let mode: DatePickerMode
    private let style: DatePickerStyleType
    private let validationState: ValidationState
    private let dateRange: ClosedRange<Date>
    
    public init(
        selection: Binding<Date>,
        title: String = "Select Date",
        mode: DatePickerMode = .date,
        style: DatePickerStyleType = .default,
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
        let themeStyle: DatePickerStyle = {
            switch style {
            case .default: return DatePickerStyle.default(theme: theme)
            case .filled: return DatePickerStyle.filled(theme: theme)
            case .outlined: return DatePickerStyle.outlined(theme: theme)
            }
        }()
        
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            if !title.isEmpty {
                RRLabel(title, style: .caption, weight: .medium, color: .primary)
            }
            
            DatePicker(
                "",
                selection: $selection,
                in: dateRange,
                displayedComponents: mode.displayedComponents
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, themeStyle.horizontalPadding)
            .padding(.vertical, themeStyle.verticalPadding)
            .background(themeStyle.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: themeStyle.cornerRadius)
                    .stroke(validationState.borderColor(theme: theme), lineWidth: validationState.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: themeStyle.cornerRadius))
        }
    }
}

// MARK: - Time Range Picker

/// A time range picker for selecting start and end times
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTimeRangePicker: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var startTime: Date
    @Binding private var endTime: Date
    @State private var isExpanded = false
    
    private let title: String
    private let style: DatePickerStyleType
    private let validationState: ValidationState
    
    public init(
        startTime: Binding<Date>,
        endTime: Binding<Date>,
        title: String = "Select Time Range",
        style: DatePickerStyleType = .default,
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
        let themeStyle: DatePickerStyle = {
            switch style {
            case .default: return DatePickerStyle.default(theme: theme)
            case .filled: return DatePickerStyle.filled(theme: theme)
            case .outlined: return DatePickerStyle.outlined(theme: theme)
            }
        }()
        
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            if !title.isEmpty {
                RRLabel(title, style: .caption, weight: .medium, color: .primary)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(themeStyle.iconColor)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeSM))
                    
                    RRLabel(
                        displayText,
                        style: .body,
                        weight: .medium,
                        customColor: themeStyle.textColor
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(themeStyle.chevronColor)
                        .font(.system(size: DesignTokens.ComponentSize.iconSizeXS, weight: .medium))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(DesignTokens.Animation.dropdownToggle, value: isExpanded)
                }
                .padding(.horizontal, themeStyle.horizontalPadding)
                .padding(.vertical, themeStyle.verticalPadding)
                .background(themeStyle.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: themeStyle.cornerRadius)
                        .stroke(validationState.borderColor(theme: theme), lineWidth: validationState.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: themeStyle.cornerRadius))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: DesignTokens.Spacing.md) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        RRLabel("Start Time", style: .caption, color: .secondary)
                        
                        DatePicker(
                            "",
                            selection: $startTime,
                            displayedComponents: .hourAndMinute
                        )
                        #if os(iOS)
                    .datePickerStyle(.wheel)
                    #else
                    .datePickerStyle(.compact)
                    #endif
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        RRLabel("End Time", style: .caption, color: .secondary)
                        
                        DatePicker(
                            "",
                            selection: $endTime,
                            displayedComponents: .hourAndMinute
                        )
                        #if os(iOS)
                    .datePickerStyle(.wheel)
                    #else
                    .datePickerStyle(.compact)
                    #endif
                        .labelsHidden()
                    }
                }
                .padding()
                .background(themeStyle.pickerBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: themeStyle.cornerRadius)
                        .stroke(themeStyle.pickerBorderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: themeStyle.cornerRadius))
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
        VStack(spacing: DesignTokens.Spacing.lg) {
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
        .padding(DesignTokens.Spacing.componentPadding)
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRDatePicker")
    }
}
