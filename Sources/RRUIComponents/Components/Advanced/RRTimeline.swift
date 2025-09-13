import SwiftUI
import Foundation

// MARK: - Timeline Component

/// A customizable timeline/progress tracker component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTimeline: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let items: [TimelineItem]
    private let style: TimelineStyle
    private let orientation: TimelineOrientation
    
    public init(
        items: [TimelineItem],
        style: TimelineStyle = .default,
        orientation: TimelineOrientation = .vertical
    ) {
        self.items = items
        self.style = style
        self.orientation = orientation
    }
    
    public var body: some View {
        if orientation == .vertical {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    TimelineItemView(
                        item: item,
                        style: style,
                        isFirst: index == 0,
                        isLast: index == items.count - 1,
                        isCompleted: item.status == .completed,
                        isCurrent: item.status == .current
                    )
                }
            }
        } else {
            HStack(alignment: .top, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    TimelineItemView(
                        item: item,
                        style: style,
                        isFirst: index == 0,
                        isLast: index == items.count - 1,
                        isCompleted: item.status == .completed,
                        isCurrent: item.status == .current
                    )
                }
            }
        }
    }
}

// MARK: - Timeline Item

public struct TimelineItem {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let description: String?
    public let status: TimelineStatus
    public let icon: Image?
    public let date: Date?
    public let customView: AnyView?
    
    public init(
        title: String,
        subtitle: String? = nil,
        description: String? = nil,
        status: TimelineStatus = .pending,
        icon: Image? = nil,
        date: Date? = nil,
        customView: AnyView? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.status = status
        self.icon = icon
        self.date = date
        self.customView = customView
    }
}

// MARK: - Timeline Status
@MainActor
public enum TimelineStatus {
    case pending
    case current
    case completed
    case error
    case skipped
    
    func color(theme: Theme) -> Color {
        switch self {
        case .pending: return theme.colors.outlineVariant
        case .current: return theme.colors.primary
        case .completed: return theme.colors.success
        case .error: return theme.colors.error
        case .skipped: return theme.colors.outline
        }
    }
    
    var iconName: String {
        switch self {
        case .pending: return "circle"
        case .current: return "circle.fill"
        case .completed: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .skipped: return "minus.circle.fill"
        }
    }
}

// MARK: - Timeline Orientation

public enum TimelineOrientation {
    case vertical
    case horizontal
}

// MARK: - Timeline Item View

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct TimelineItemView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let item: TimelineItem
    let style: TimelineStyle
    let isFirst: Bool
    let isLast: Bool
    let isCompleted: Bool
    let isCurrent: Bool
    
    private var connectorColor: Color {
        if isCompleted {
            return style.completedConnectorColor == Color.clear ? theme.colors.success : style.completedConnectorColor
        } else if isCurrent {
            return style.currentConnectorColor == Color.clear ? theme.colors.primary : style.currentConnectorColor
        } else {
            return style.pendingConnectorColor == Color.clear ? theme.colors.outlineVariant : style.pendingConnectorColor
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: style.itemSpacing) {
            // Timeline line and icon
            VStack(spacing: 0) {
                if !isFirst {
                    Rectangle()
                        .fill(connectorColor)
                        .frame(width: style.lineWidth, height: style.lineHeight)
                }
                
                ZStack {
                    Circle()
                        .fill(style.iconBackgroundColor == Color.clear ? theme.colors.surface : style.iconBackgroundColor)
                        .frame(width: style.iconSize, height: style.iconSize)
                        .overlay(
                            Circle()
                                .stroke(theme.colors.outline, lineWidth: 1)
                        )
                    
                    if let customIcon = item.icon {
                        customIcon
                            .font(.system(size: style.iconSize * 0.6, weight: .medium))
                            .foregroundColor(style.iconColor == Color.clear ? item.status.color(theme: theme) : style.iconColor)
                    } else {
                        Image(systemName: item.status.iconName)
                            .font(.system(size: style.iconSize * 0.6, weight: .medium))
                            .foregroundColor(item.status.color(theme: theme))
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(connectorColor)
                        .frame(width: style.lineWidth, height: style.lineHeight)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: style.contentSpacing) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        RRLabel(item.title, style: style.titleLabelStyle, weight: .medium, customColor: style.titleColor(theme))
                        
                        if let subtitle = item.subtitle {
                            RRLabel(subtitle, style: style.subtitleLabelStyle, weight: .regular, customColor: style.subtitleColor(theme))
                        }
                    }
                    
                    Spacer()
                    
                    if let date = item.date {
                        RRLabel(date.formatted(date: .abbreviated, time: .omitted), style: style.dateLabelStyle, weight: .regular, customColor: style.dateColor(theme))
                    }
                }
                
                if let description = item.description {
                    RRLabel(description, style: style.descriptionLabelStyle, weight: .regular, customColor: style.descriptionColor(theme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let customView = item.customView {
                    customView
                }
            }
            .padding(.leading, style.contentLeadingPadding)
        }
    }
}

// MARK: - Timeline Style
@MainActor
public struct TimelineStyle {
    public let lineWidth: CGFloat
    public let lineHeight: CGFloat
    public let iconSize: CGFloat
    public let iconBackgroundColor: Color
    public let iconColor: Color
    public let itemSpacing: CGFloat
    public let contentSpacing: CGFloat
    public let contentLeadingPadding: CGFloat
    public let titleLabelStyle: RRLabel.Style
    public let titleColor: (Theme) -> Color
    public let subtitleLabelStyle: RRLabel.Style
    public let subtitleColor: (Theme) -> Color
    public let descriptionLabelStyle: RRLabel.Style
    public let descriptionColor: (Theme) -> Color
    public let dateLabelStyle: RRLabel.Style
    public let dateColor: (Theme) -> Color
    public let pendingConnectorColor: Color
    public let currentConnectorColor: Color
    public let completedConnectorColor: Color
    
    public static let `default` = TimelineStyle(
        lineWidth: 2,
        lineHeight: DesignTokens.Spacing.lg,
        iconSize: DesignTokens.ComponentSize.iconSizeMD,
        iconBackgroundColor: Color.clear, // Will be set dynamically
        iconColor: Color.clear, // Will be set dynamically
        itemSpacing: DesignTokens.Spacing.md,
        contentSpacing: DesignTokens.Spacing.sm,
        contentLeadingPadding: DesignTokens.Spacing.sm,
        titleLabelStyle: .subtitle,
        titleColor: { theme in theme.colors.primaryText },
        subtitleLabelStyle: .body,
        subtitleColor: { theme in theme.colors.secondaryText },
        descriptionLabelStyle: .body,
        descriptionColor: { theme in theme.colors.secondaryText },
        dateLabelStyle: .caption,
        dateColor: { theme in theme.colors.onSurfaceVariant },
        pendingConnectorColor: Color.clear, // Will be set dynamically
        currentConnectorColor: Color.clear, // Will be set dynamically
        completedConnectorColor: Color.clear // Will be set dynamically
    )
    
    public static let minimal = TimelineStyle(
        lineWidth: 1,
        lineHeight: DesignTokens.Spacing.md,
        iconSize: DesignTokens.ComponentSize.iconSizeSM,
        iconBackgroundColor: Color.clear, // Will be set dynamically
        iconColor: Color.clear, // Will be set dynamically
        itemSpacing: DesignTokens.Spacing.sm,
        contentSpacing: DesignTokens.Spacing.xs,
        contentLeadingPadding: DesignTokens.Spacing.xs,
        titleLabelStyle: .body,
        titleColor: { theme in theme.colors.primaryText },
        subtitleLabelStyle: .caption,
        subtitleColor: { theme in theme.colors.secondaryText },
        descriptionLabelStyle: .caption,
        descriptionColor: { theme in theme.colors.secondaryText },
        dateLabelStyle: .caption,
        dateColor: { theme in theme.colors.onSurfaceVariant },
        pendingConnectorColor: Color.clear, // Will be set dynamically
        currentConnectorColor: Color.clear, // Will be set dynamically
        completedConnectorColor: Color.clear // Will be set dynamically
    )
    
    public static let bold = TimelineStyle(
        lineWidth: 3,
        lineHeight: DesignTokens.Spacing.xl,
        iconSize: DesignTokens.ComponentSize.iconSizeLG,
        iconBackgroundColor: Color.clear, // Will be set dynamically
        iconColor: Color.clear, // Will be set dynamically
        itemSpacing: DesignTokens.Spacing.lg,
        contentSpacing: DesignTokens.Spacing.md,
        contentLeadingPadding: DesignTokens.Spacing.md,
        titleLabelStyle: .title,
        titleColor: { theme in theme.colors.primaryText },
        subtitleLabelStyle: .subtitle,
        subtitleColor: { theme in theme.colors.secondaryText },
        descriptionLabelStyle: .body,
        descriptionColor: { theme in theme.colors.secondaryText },
        dateLabelStyle: .body,
        dateColor: { theme in theme.colors.onSurfaceVariant },
        pendingConnectorColor: Color.clear, // Will be set dynamically
        currentConnectorColor: Color.clear, // Will be set dynamically
        completedConnectorColor: Color.clear // Will be set dynamically
    )
}

// MARK: - Progress Tracker

/// A specialized timeline for tracking progress through steps
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRProgressTracker: View {
    private let steps: [String]
    private let currentStep: Int
    private let style: TimelineStyle
    private let orientation: TimelineOrientation
    
    public init(
        steps: [String],
        currentStep: Int,
        style: TimelineStyle = .default,
        orientation: TimelineOrientation = .vertical
    ) {
        self.steps = steps
        self.currentStep = currentStep
        self.style = style
        self.orientation = orientation
    }
    
    private var timelineItems: [TimelineItem] {
        steps.enumerated().map { index, step in
            let status: TimelineStatus
            if index < currentStep {
                status = .completed
            } else if index == currentStep {
                status = .current
            } else {
                status = .pending
            }
            
            return TimelineItem(
                title: step,
                status: status,
                icon: Image(systemName: "\(index + 1).circle")
            )
        }
    }
    
    public var body: some View {
        RRTimeline(
            items: timelineItems,
            style: style,
            orientation: orientation
        )
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRTimeline_Previews: PreviewProvider {
    static let sampleItems = [
        TimelineItem(
            title: "Order Placed",
            subtitle: "Your order has been placed",
            description: "We've received your order and are preparing it for shipment.",
            status: .completed,
            icon: Image(systemName: "cart"),
            date: Date().addingTimeInterval(-3600)
        ),
        TimelineItem(
            title: "Processing",
            subtitle: "Your order is being processed",
            description: "Our team is preparing your items for shipment.",
            status: .completed,
            icon: Image(systemName: "gearshape"),
            date: Date().addingTimeInterval(-1800)
        ),
        TimelineItem(
            title: "Shipped",
            subtitle: "Your order is on the way",
            description: "Your order has been shipped and is on its way to you.",
            status: .current,
            icon: Image(systemName: "truck"),
            date: Date()
        ),
        TimelineItem(
            title: "Delivered",
            subtitle: "Your order has been delivered",
            description: "Your order has been successfully delivered.",
            status: .pending,
            icon: Image(systemName: "checkmark.circle"),
            date: nil
        )
    ]
    
    static let progressSteps = [
        "Account Setup",
        "Profile Information",
        "Preferences",
        "Verification",
        "Complete"
    ]
    
    static var previews: some View {
        RRTimelinePreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRTimeline Examples")
    }
}

private struct RRTimelinePreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            // Basic timeline
            VStack {
                RRLabel("Order Timeline", style: .subtitle, weight: .bold, color: .primary)
                
                RRTimeline(
                    items: RRTimeline_Previews.sampleItems,
                    style: .default
                )
            }
            
            // Progress tracker
            VStack {
                RRLabel("Progress Tracker", style: .subtitle, weight: .bold, color: .primary)
                
                RRProgressTracker(
                    steps: RRTimeline_Previews.progressSteps,
                    currentStep: 2,
                    style: .minimal
                )
            }
            
            // Horizontal timeline
            VStack {
                RRLabel("Horizontal Timeline", style: .subtitle, weight: .bold, color: .primary)
                
                RRTimeline(
                    items: Array(RRTimeline_Previews.sampleItems.prefix(3)),
                    style: .minimal,
                    orientation: .horizontal
                )
            }
        }
        .padding(DesignTokens.Spacing.componentPadding)
    }
}
