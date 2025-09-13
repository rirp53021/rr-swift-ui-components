import SwiftUI

/// A customizable divider component for separating content sections
public struct RRDivider: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let style: DividerStyle
    private let orientation: DividerOrientation
    private let color: Color?
    private let thickness: CGFloat
    private let spacing: CGFloat
    private let label: String?
    private let labelPosition: LabelPosition
    
    // MARK: - Initialization
    
    /// Creates a divider with the specified style and configuration
    /// - Parameters:
    ///   - style: The divider style
    ///   - orientation: The divider orientation
    ///   - color: Optional custom color (uses theme color if nil)
    ///   - thickness: The thickness of the divider line
    ///   - spacing: The spacing around the divider
    ///   - label: Optional label text
    ///   - labelPosition: The position of the label
    public init(
        style: DividerStyle = .default,
        orientation: DividerOrientation = .horizontal,
        color: Color? = nil,
        thickness: CGFloat = 1,
        spacing: CGFloat = DesignTokens.Spacing.md,
        label: String? = nil,
        labelPosition: LabelPosition = .center
    ) {
        self.style = style
        self.orientation = orientation
        self.color = color
        self.thickness = thickness
        self.spacing = spacing
        self.label = label
        self.labelPosition = labelPosition
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if label != nil {
                labeledDivider
            } else {
                simpleDivider
            }
        }
    }
    
    // MARK: - Simple Divider
    
    private var simpleDivider: some View {
        Group {
            if orientation == .horizontal {
                Rectangle()
                    .fill(dividerColor)
                    .frame(height: thickness)
                    .padding(.vertical, spacing)
            } else {
                Rectangle()
                    .fill(dividerColor)
                    .frame(width: thickness)
                    .padding(.horizontal, spacing)
            }
        }
    }
    
    // MARK: - Labeled Divider
    
    private var labeledDivider: some View {
        Group {
            if orientation == .horizontal {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    if labelPosition == .leading || labelPosition == .center {
                        Rectangle()
                            .fill(dividerColor)
                            .frame(height: thickness)
                            .frame(maxWidth: labelPosition == .center ? .infinity : nil)
                    }
                    
                    RRLabel(label!, style: .caption, color: .secondary)
                        .padding(.horizontal, DesignTokens.Spacing.sm)
                    
                    if labelPosition == .trailing || labelPosition == .center {
                        Rectangle()
                            .fill(dividerColor)
                            .frame(height: thickness)
                            .frame(maxWidth: labelPosition == .center ? .infinity : nil)
                    }
                }
                .padding(.vertical, spacing)
            } else {
                VStack(spacing: DesignTokens.Spacing.sm) {
                    if labelPosition == .leading || labelPosition == .center {
                        Rectangle()
                            .fill(dividerColor)
                            .frame(width: thickness)
                            .frame(maxHeight: labelPosition == .center ? .infinity : nil)
                    }
                    
                    RRLabel(label!, style: .caption, color: .secondary)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .rotationEffect(.degrees(orientation == .vertical ? -90 : 0))
                    
                    if labelPosition == .trailing || labelPosition == .center {
                        Rectangle()
                            .fill(dividerColor)
                            .frame(width: thickness)
                            .frame(maxHeight: labelPosition == .center ? .infinity : nil)
                    }
                }
                .padding(.horizontal, spacing)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var dividerColor: Color {
        if let color = color {
            return color
        }
        
        switch style {
        case .default:
            return theme.colors.outlineVariant
        case .subtle:
            return theme.colors.outlineVariant.opacity(0.5)
        case .strong:
            return theme.colors.outline
        case .accent:
            return theme.colors.primary
        case .success:
            return theme.colors.success
        case .warning:
            return theme.colors.warning
        case .error:
            return theme.colors.error
        case .info:
            return theme.colors.info
        }
    }
}

// MARK: - Divider Style

public enum DividerStyle {
    case `default`
    case subtle
    case strong
    case accent
    case success
    case warning
    case error
    case info
}

// MARK: - Divider Orientation

public enum DividerOrientation {
    case horizontal
    case vertical
}

// MARK: - Label Position

public enum LabelPosition {
    case leading
    case center
    case trailing
}

// MARK: - Previews

#if DEBUG
struct RRDivider_Previews: PreviewProvider {
    static var previews: some View {
        RRDividerPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRDivider Examples")
    }
}

private struct RRDividerPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Divider Examples")
            
            // Basic dividers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Basic Dividers", style: .subtitle, weight: .semibold)
                
                RRLabel("Content above", style: .body)
                RRDivider()
                RRLabel("Content below", style: .body)
                
                RRDivider(style: .subtle)
                RRLabel("Subtle divider", style: .body)
                
                RRDivider(style: .strong)
                RRLabel("Strong divider", style: .body)
                
                RRDivider(style: .accent)
                RRLabel("Accent divider", style: .body)
            }
            
            // Labeled dividers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Labeled Dividers", style: .subtitle, weight: .semibold)
                
                RRDivider(label: "Section 1", labelPosition: .center)
                RRLabel("Content in section 1", style: .body)
                
                RRDivider(label: "Section 2", labelPosition: .leading)
                RRLabel("Content in section 2", style: .body)
                
                RRDivider(label: "Section 3", labelPosition: .trailing)
                RRLabel("Content in section 3", style: .body)
            }
            
            // State dividers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("State Dividers", style: .subtitle, weight: .semibold)
                
                RRDivider(style: .success, label: "Success")
                RRLabel("Success content", style: .body)
                
                RRDivider(style: .warning, label: "Warning")
                RRLabel("Warning content", style: .body)
                
                RRDivider(style: .error, label: "Error")
                RRLabel("Error content", style: .body)
                
                RRDivider(style: .info, label: "Info")
                RRLabel("Info content", style: .body)
            }
            
            // Vertical dividers
            HStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Left", style: .body)
                RRDivider(orientation: .vertical, thickness: 2)
                RRLabel("Right", style: .body)
            }
            
            // Custom dividers
            VStack(spacing: DesignTokens.Spacing.md) {
                RRLabel("Custom Dividers", style: .subtitle, weight: .semibold)
                
                RRDivider(
                    style: .accent,
                    thickness: 3,
                    spacing: DesignTokens.Spacing.lg,
                    label: "Custom",
                    labelPosition: .center
                )
                RRLabel("Custom styled divider", style: .body)
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
