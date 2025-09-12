# Forms - RRUIComponents

## Overview

Form components provide interactive input elements for user data collection. The RRUIComponents library includes comprehensive form controls with validation, theming, and accessibility support.

## Components

- `RRCheckbox` - Checkbox input
- `RRDatePicker` - Date and time selection
- `RRDropdown` - Dropdown selection
- `RRSlider` - Range input slider
- `RRToggle` - Toggle switch
- `RRTextField` - Text input field

## RRCheckbox

A checkbox input component with multiple visual styles.

### Basic Usage

```swift
@State private var isAccepted = false

RRCheckbox("I agree to the terms", isChecked: $isAccepted)
```

### Initialization

```swift
RRCheckbox(_ title: String, isChecked: Binding<Bool>)
```

### Styles

| Style | Description | Appearance |
|-------|-------------|------------|
| `.square` | Square checkbox (default) | Standard square checkbox |
| `.circle` | Circular checkbox | Rounded checkbox |
| `.rounded` | Rounded square checkbox | Square with rounded corners |

### Examples

#### Basic Checkbox
```swift
@State private var isSelected = false

RRCheckbox("Select item", isChecked: $isSelected)
```

#### Styled Checkbox
```swift
@State private var isEnabled = false

RRCheckbox("Enable notifications", isChecked: $isEnabled)
    .style(.rounded)
    .color(.primary)
```

#### Checkbox Group
```swift
@State private var selectedItems: Set<String> = []

VStack {
    RRCheckbox("Option 1", isChecked: Binding(
        get: { selectedItems.contains("option1") },
        set: { isSelected in
            if isSelected {
                selectedItems.insert("option1")
            } else {
                selectedItems.remove("option1")
            }
        }
    ))
    
    RRCheckbox("Option 2", isChecked: Binding(
        get: { selectedItems.contains("option2") },
        set: { isSelected in
            if isSelected {
                selectedItems.insert("option2")
            } else {
                selectedItems.remove("option2")
            }
        }
    ))
}
```

## RRDatePicker

A date and time picker component with multiple display modes.

### Basic Usage

```swift
@State private var selectedDate = Date()

RRDatePicker("Select Date", selection: $selectedDate)
```

### Initialization

```swift
RRDatePicker(_ title: String, selection: Binding<Date>)
RRDatePicker(_ title: String, selection: Binding<Date>, mode: DatePickerMode)
```

### Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `.date` | Date only | Birthdays, appointments |
| `.time` | Time only | Meeting times, reminders |
| `.dateAndTime` | Date and time | Events, deadlines |

### Examples

#### Date Only
```swift
@State private var birthDate = Date()

RRDatePicker("Birth Date", selection: $birthDate)
    .mode(.date)
    .style(.compact)
```

#### Time Only
```swift
@State private var meetingTime = Date()

RRDatePicker("Meeting Time", selection: $meetingTime)
    .mode(.time)
    .style(.wheel)
```

#### Date and Time
```swift
@State private var eventDateTime = Date()

RRDatePicker("Event Date & Time", selection: $eventDateTime)
    .mode(.dateAndTime)
    .style(.graphical)
```

#### With Date Range
```swift
@State private var startDate = Date()
@State private var endDate = Date().addingTimeInterval(86400) // +1 day

VStack {
    RRDatePicker("Start Date", selection: $startDate)
        .mode(.date)
    
    RRDatePicker("End Date", selection: $endDate)
        .mode(.date)
        .disabled(startDate > endDate)
}
```

## RRDropdown

A dropdown selection component with search and filtering capabilities.

### Basic Usage

```swift
@State private var selectedOption = ""

RRDropdown("Choose Option", selection: $selectedOption, options: ["Option 1", "Option 2", "Option 3"])
```

### Initialization

```swift
RRDropdown(_ title: String, selection: Binding<String>, options: [String])
```

### Examples

#### Basic Dropdown
```swift
@State private var selectedCountry = ""

RRDropdown("Country", selection: $selectedCountry, options: [
    "United States", "Canada", "Mexico", "United Kingdom", "Germany"
])
```

#### With Search
```swift
@State private var selectedCity = ""

RRDropdown("City", selection: $selectedCity, options: cities)
    .searchable(true)
    .placeholder("Search cities...")
```

#### With Custom Display
```swift
struct Country {
    let name: String
    let code: String
    let flag: String
}

@State private var selectedCountry: Country?

RRDropdown("Country", selection: $selectedCountry, options: countries) { country in
    HStack {
        Text(country.flag)
        Text(country.name)
        Spacer()
        Text(country.code)
            .foregroundColor(.secondary)
    }
}
```

## RRSlider

A range input slider component with multiple styles and configurations.

### Basic Usage

```swift
@State private var sliderValue = 50.0

RRSlider(value: $sliderValue, in: 0...100)
```

### Initialization

```swift
RRSlider(value: Binding<Double>, in: ClosedRange<Double>)
RRSlider(value: Binding<Double>, in: ClosedRange<Double>, step: Double)
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.standard` | Standard slider | General range input |
| `.range` | Range slider | Min/max selection |
| `.stepped` | Stepped slider | Discrete values |

### Examples

#### Basic Slider
```swift
@State private var volume = 50.0

RRSlider(value: $volume, in: 0...100)
    .accentColor(.blue)
```

#### Stepped Slider
```swift
@State private var rating = 3.0

RRSlider(value: $rating, in: 1...5, step: 1)
    .style(.stepped)
    .accentColor(.yellow)
```

#### Range Slider
```swift
@State private var priceRange = 100.0...500.0

RRSlider(value: $priceRange, in: 0...1000)
    .style(.range)
    .accentColor(.green)
```

#### With Labels
```swift
@State private var temperature = 20.0

VStack {
    RRLabel("Temperature: \(Int(temperature))°C")
        .style(.headline)
    
    RRSlider(value: $temperature, in: -10...40)
        .accentColor(.red)
    
    HStack {
        RRLabel("-10°C")
            .style(.caption)
        Spacer()
        RRLabel("40°C")
            .style(.caption)
    }
}
```

## RRToggle

A toggle switch component with multiple visual styles.

### Basic Usage

```swift
@State private var isEnabled = false

RRToggle("Enable Notifications", isOn: $isEnabled)
```

### Initialization

```swift
RRToggle(_ title: String, isOn: Binding<Bool>)
```

### Styles

| Style | Description | Appearance |
|-------|-------------|------------|
| `.standard` | Standard toggle (default) | iOS-style toggle |
| `.custom` | Custom styled toggle | Custom colors and styling |
| `.switch` | Switch-style toggle | Android-style switch |

### Examples

#### Basic Toggle
```swift
@State private var notificationsEnabled = false

RRToggle("Push Notifications", isOn: $notificationsEnabled)
```

#### Styled Toggle
```swift
@State private var darkModeEnabled = false

RRToggle("Dark Mode", isOn: $darkModeEnabled)
    .style(.custom)
    .accentColor(.blue)
```

#### Switch Toggle
```swift
@State private var wifiEnabled = true

RRToggle("Wi-Fi", isOn: $wifiEnabled)
    .style(.switch)
    .accentColor(.green)
```

## RRTextField

A customizable text input field with validation and theming.

### Basic Usage

```swift
@State private var email = ""

RRTextField("Email", text: $email)
```

### Initialization

```swift
RRTextField(_ title: String, text: Binding<String>)
RRTextField(_ title: String, text: Binding<String>, placeholder: String?)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Field label |
| `text` | `Binding<String>` | Binding to text value |
| `placeholder` | `String?` | Placeholder text |
| `isSecure` | `Bool` | Secure text entry |
| `keyboardType` | `UIKeyboardType` | Keyboard type |
| `validationState` | `ValidationState` | Validation state |

### Examples

#### Basic Text Field
```swift
@State private var name = ""

RRTextField("Name", text: $name)
    .placeholder("Enter your name")
```

#### Email Field with Validation
```swift
@State private var email = ""

RRTextField("Email", text: $email)
    .keyboardType(.emailAddress)
    .validationState(email.isValidEmail ? .valid : .invalid)
    .placeholder("Enter your email")
```

#### Secure Password Field
```swift
@State private var password = ""

RRTextField("Password", text: $password)
    .isSecure(true)
    .placeholder("Enter your password")
    .validationState(password.count >= 8 ? .valid : .invalid)
```

#### Multi-line Text Field
```swift
@State private var message = ""

RRTextField("Message", text: $message)
    .multiline(true)
    .lineLimit(3...6)
    .placeholder("Enter your message")
```

## Form Validation

### Validation States

| State | Description | Visual Indicator |
|-------|-------------|------------------|
| `.none` | No validation | Default appearance |
| `.valid` | Valid input | Green border/checkmark |
| `.invalid` | Invalid input | Red border/error icon |
| `.warning` | Warning state | Yellow border/warning icon |

### Example: Complete Form with Validation

```swift
struct UserRegistrationForm: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAccepted = false
    
    var isFormValid: Bool {
        !name.isEmpty &&
        email.isValidEmail &&
        password.count >= 8 &&
        password == confirmPassword &&
        isAccepted
    }
    
    var body: some View {
        VStack(spacing: 20) {
            RRTextField("Full Name", text: $name)
                .validationState(name.isEmpty ? .none : .valid)
            
            RRTextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .validationState(email.isEmpty ? .none : (email.isValidEmail ? .valid : .invalid))
            
            RRTextField("Password", text: $password)
                .isSecure(true)
                .validationState(password.isEmpty ? .none : (password.count >= 8 ? .valid : .invalid))
            
            RRTextField("Confirm Password", text: $confirmPassword)
                .isSecure(true)
                .validationState(confirmPassword.isEmpty ? .none : (password == confirmPassword ? .valid : .invalid))
            
            RRCheckbox("I agree to the terms and conditions", isChecked: $isAccepted)
            
            RRButton("Register") {
                registerUser()
            }
            .style(.primary)
            .disabled(!isFormValid)
        }
        .padding()
    }
}
```

## Best Practices

### Form Design

1. **Clear Labels**: Use descriptive labels for all form fields
2. **Logical Order**: Arrange fields in a logical sequence
3. **Grouping**: Group related fields together
4. **Validation**: Provide immediate feedback for validation errors

### Accessibility

1. **Labels**: Ensure all form elements have proper accessibility labels
2. **Hints**: Provide helpful hints for complex fields
3. **Error Messages**: Use clear, actionable error messages
4. **Keyboard Navigation**: Ensure proper tab order

### Performance

1. **Debouncing**: Debounce validation for real-time feedback
2. **Lazy Loading**: Use lazy loading for large option lists
3. **Memory Management**: Properly manage state and bindings

## Common Patterns

### Form State Management
```swift
class FormViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    init() {
        Publishers.CombineLatest3($name, $email, $password)
            .map { name, email, password in
                !name.isEmpty && email.isValidEmail && password.count >= 8
            }
            .assign(to: &$isFormValid)
    }
}
```

### Dynamic Form Fields
```swift
@State private var additionalFields: [AdditionalField] = []

ForEach(additionalFields) { field in
    switch field.type {
    case .text:
        RRTextField(field.label, text: Binding(
            get: { field.value },
            set: { field.value = $0 }
        ))
    case .toggle:
        RRToggle(field.label, isOn: Binding(
            get: { field.boolValue },
            set: { field.boolValue = $0 }
        ))
    }
}
```

## Troubleshooting

### Common Issues

1. **Validation not updating**: Ensure validation state is properly bound
2. **Keyboard not appearing**: Check if the field is properly focused
3. **Styling not applied**: Verify style modifiers are called in correct order

### Debug Tips

1. Use `.background(.red)` to visualize field bounds
2. Check console for validation warnings
3. Verify bindings are properly connected
