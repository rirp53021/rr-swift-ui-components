import SwiftUI
import Foundation

// MARK: - Timeline Component

/// A customizable timeline/progress tracker component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTimeline: View {
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

public enum TimelineStatus {
    case pending
    case current
    case completed
    case error
    case skipped
    
    var color: Color {
        switch self {
        case .pending: return Color(.systemGray4)
        case .current: return .blue
        case .completed: return .green
        case .error: return .red
        case .skipped: return Color(.systemGray3)
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
    let item: TimelineItem
    let style: TimelineStyle
    let isFirst: Bool
    let isLast: Bool
    let isCompleted: Bool
    let isCurrent: Bool
    
    private var connectorColor: Color {
        if isCompleted {
            return style.completedConnectorColor
        } else if isCurrent {
            return style.currentConnectorColor
        } else {
            return style.pendingConnectorColor
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
                        .fill(style.iconBackgroundColor)
                        .frame(width: style.iconSize, height: style.iconSize)
                    
                    if let customIcon = item.icon {
                        customIcon
                            .font(.system(size: style.iconSize * 0.6, weight: .medium))
                            .foregroundColor(style.iconColor)
                    } else {
                        Image(systemName: item.status.iconName)
                            .font(.system(size: style.iconSize * 0.6, weight: .medium))
                            .foregroundColor(item.status.color)
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
                        Text(item.title)
                            .font(style.titleFont)
                            .foregroundColor(style.titleColor)
                        
                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(style.subtitleFont)
                                .foregroundColor(style.subtitleColor)
                        }
                    }
                    
                    Spacer()
                    
                    if let date = item.date {
                        Text(date, style: .date)
                            .font(style.dateFont)
                            .foregroundColor(style.dateColor)
                    }
                }
                
                if let description = item.description {
                    Text(description)
                        .font(style.descriptionFont)
                        .foregroundColor(style.descriptionColor)
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

public struct TimelineStyle {
    public let lineWidth: CGFloat
    public let lineHeight: CGFloat
    public let iconSize: CGFloat
    public let iconBackgroundColor: Color
    public let iconColor: Color
    public let itemSpacing: CGFloat
    public let contentSpacing: CGFloat
    public let contentLeadingPadding: CGFloat
    public let titleFont: Font
    public let titleColor: Color
    public let subtitleFont: Font
    public let subtitleColor: Color
    public let descriptionFont: Font
    public let descriptionColor: Color
    public let dateFont: Font
    public let dateColor: Color
    public let pendingConnectorColor: Color
    public let currentConnectorColor: Color
    public let completedConnectorColor: Color
    
    public static let `default` = TimelineStyle(
        lineWidth: 2,
        lineHeight: 20,
        iconSize: 24,
        iconBackgroundColor: Color(.systemBackground),
        iconColor: .primary,
        itemSpacing: 12,
        contentSpacing: 8,
        contentLeadingPadding: 0,
        titleFont: .headline,
        titleColor: .primary,
        subtitleFont: .subheadline,
        subtitleColor: .secondary,
        descriptionFont: .body,
        descriptionColor: .secondary,
        dateFont: .caption,
        dateColor: .secondary,
        pendingConnectorColor: Color(.systemGray4),
        currentConnectorColor: .blue,
        completedConnectorColor: .green
    )
    
    public static let minimal = TimelineStyle(
        lineWidth: 1,
        lineHeight: 16,
        iconSize: 16,
        iconBackgroundColor: Color(.systemBackground),
        iconColor: .primary,
        itemSpacing: 8,
        contentSpacing: 4,
        contentLeadingPadding: 0,
        titleFont: .subheadline,
        titleColor: .primary,
        subtitleFont: .caption,
        subtitleColor: .secondary,
        descriptionFont: .caption,
        descriptionColor: .secondary,
        dateFont: .caption2,
        dateColor: .secondary,
        pendingConnectorColor: Color(.systemGray5),
        currentConnectorColor: .blue,
        completedConnectorColor: .green
    )
    
    public static let bold = TimelineStyle(
        lineWidth: 3,
        lineHeight: 24,
        iconSize: 32,
        iconBackgroundColor: Color(.systemBackground),
        iconColor: .primary,
        itemSpacing: 16,
        contentSpacing: 12,
        contentLeadingPadding: 0,
        titleFont: .title2,
        titleColor: .primary,
        subtitleFont: .headline,
        subtitleColor: .secondary,
        descriptionFont: .body,
        descriptionColor: .secondary,
        dateFont: .subheadline,
        dateColor: .secondary,
        pendingConnectorColor: Color(.systemGray4),
        currentConnectorColor: .blue,
        completedConnectorColor: .green
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
        VStack(spacing: 30) {
            // Basic timeline
            VStack {
                Text("Order Timeline")
                    .font(.headline)
                
                RRTimeline(
                    items: sampleItems,
                    style: .default
                )
            }
            
            // Progress tracker
            VStack {
                Text("Progress Tracker")
                    .font(.headline)
                
                RRProgressTracker(
                    steps: progressSteps,
                    currentStep: 2,
                    style: .minimal
                )
            }
            
            // Horizontal timeline
            VStack {
                Text("Horizontal Timeline")
                    .font(.headline)
                
                RRTimeline(
                    items: Array(sampleItems.prefix(3)),
                    style: .minimal,
                    orientation: .horizontal
                )
            }
        }
        .padding()
        .previewDisplayName("RRTimeline")
    }
}
