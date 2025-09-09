import SwiftUI

/// A utility component for creating stacked views with consistent spacing and padding
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRStackedView<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let axis: Axis
    private let alignment: Alignment
    private let spacing: CGFloat?
    private let contentPadding: EdgeInsets
    private let backgroundColor: Color?
    private let cornerRadius: CGFloat?
    
    // MARK: - Initialization
    
    public init(
        axis: Axis = .vertical,
        alignment: Alignment = .center,
        spacing: CGFloat? = nil,
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.contentPadding = contentPadding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch axis {
            case .horizontal:
                HStack(alignment: .center, spacing: spacing) {
                    content
                }
            case .vertical:
                VStack(alignment: .center, spacing: spacing) {
                    content
                }
            }
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius ?? 0)
    }
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRStackedView {
    /// Creates a vertical stack with standard spacing
    static func vertical(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = RRSpacing.md,
        contentPadding: EdgeInsets = RRSpacing.paddingMD,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> RRStackedView {
        RRStackedView(
            axis: .vertical,
            alignment: Alignment(horizontal: alignment, vertical: .center),
            spacing: spacing,
            contentPadding: contentPadding,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            content: content
        )
    }
    
    /// Creates a horizontal stack with standard spacing
    static func horizontal(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = RRSpacing.sm,
        contentPadding: EdgeInsets = RRSpacing.paddingSM,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> RRStackedView {
        RRStackedView(
            axis: .horizontal,
            alignment: Alignment(horizontal: .center, vertical: alignment),
            spacing: spacing,
            contentPadding: contentPadding,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            content: content
        )
    }
}

// MARK: - Spacing Utilities

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSpacing {
    /// Standard spacing values
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
    
    /// Padding presets
    public static let paddingXS = EdgeInsets(top: xs, leading: xs, bottom: xs, trailing: xs)
    public static let paddingSM = EdgeInsets(top: sm, leading: sm, bottom: sm, trailing: sm)
    public static let paddingMD = EdgeInsets(top: md, leading: md, bottom: md, trailing: md)
    public static let paddingLG = EdgeInsets(top: lg, leading: lg, bottom: lg, trailing: lg)
    public static let paddingXL = EdgeInsets(top: xl, leading: xl, bottom: xl, trailing: xl)
    
    /// Horizontal padding presets
    public static let paddingHorizontalXS = EdgeInsets(top: 0, leading: xs, bottom: 0, trailing: xs)
    public static let paddingHorizontalSM = EdgeInsets(top: 0, leading: sm, bottom: 0, trailing: sm)
    public static let paddingHorizontalMD = EdgeInsets(top: 0, leading: md, bottom: 0, trailing: md)
    public static let paddingHorizontalLG = EdgeInsets(top: 0, leading: lg, bottom: 0, trailing: lg)
    public static let paddingHorizontalXL = EdgeInsets(top: 0, leading: xl, bottom: 0, trailing: xl)
    
    /// Vertical padding presets
    public static let paddingVerticalXS = EdgeInsets(top: xs, leading: 0, bottom: xs, trailing: 0)
    public static let paddingVerticalSM = EdgeInsets(top: sm, leading: 0, bottom: sm, trailing: 0)
    public static let paddingVerticalMD = EdgeInsets(top: md, leading: 0, bottom: md, trailing: 0)
    public static let paddingVerticalLG = EdgeInsets(top: lg, leading: 0, bottom: lg, trailing: 0)
    public static let paddingVerticalXL = EdgeInsets(top: xl, leading: 0, bottom: xl, trailing: 0)
}

// MARK: - Spacer Utilities

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSpacer {
    /// Creates a spacer with specific height
    public static func height(_ height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
    
    /// Creates a spacer with specific width
    public static func width(_ width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
    }
    
    /// Creates a spacer with specific size
    public static func size(_ size: CGSize) -> some View {
        Spacer()
            .frame(width: size.width, height: size.height)
    }
}

// MARK: - Divider Utilities

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRDivider {
    /// Creates a horizontal divider with custom styling
    public static func horizontal(
        color: Color = Color.gray.opacity(0.3),
        thickness: CGFloat = 0.5,
        contentPadding: EdgeInsets = EdgeInsets(top: RRSpacing.sm, leading: 0, bottom: RRSpacing.sm, trailing: 0)
    ) -> some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
    }
    
    /// Creates a vertical divider with custom styling
    public static func vertical(
        color: Color = Color.gray.opacity(0.3),
        thickness: CGFloat = 0.5,
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: RRSpacing.sm, bottom: 0, trailing: RRSpacing.sm)
    ) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: thickness)
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRStackedView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: RRSpacing.lg) {
                // Vertical stacks
                VStack(spacing: RRSpacing.md) {
                    Text("Vertical Stacks")
                        .font(.headline)
                    
                    RRStackedView.vertical(
                        alignment: .leading,
                        spacing: RRSpacing.sm,
                        contentPadding: RRSpacing.paddingMD,
                        backgroundColor: Color.gray.opacity(0.1),
                        cornerRadius: 8
                    ) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    
                    RRStackedView.vertical(
                        alignment: .center,
                        spacing: RRSpacing.md,
                        contentPadding: RRSpacing.paddingLG
                    ) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Centered Content")
                            .font(.headline)
                        Text("With proper spacing")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Horizontal stacks
                VStack(spacing: RRSpacing.md) {
                    Text("Horizontal Stacks")
                        .font(.headline)
                    
                    RRStackedView.horizontal(
                        alignment: .center,
                        spacing: RRSpacing.sm,
                        contentPadding: RRSpacing.paddingMD,
                        backgroundColor: Color.gray.opacity(0.1),
                        cornerRadius: 8
                    ) {
                        Image(systemName: "person.circle")
                        Text("User Name")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    RRStackedView.horizontal(
                        alignment: .top,
                        spacing: RRSpacing.sm,
                        contentPadding: RRSpacing.paddingSM
                    ) {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.headline)
                            Text("Subtitle")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Action") { }
                    }
                }
                
                // Spacing examples
                VStack(spacing: RRSpacing.md) {
                    Text("Spacing Utilities")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: RRSpacing.sm) {
                        Text("Different spacing values:")
                        HStack {
                            Text("XS")
                            RRSpacer.width(RRSpacing.xs)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                        }
                        HStack {
                            Text("SM")
                            RRSpacer.width(RRSpacing.sm)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                        }
                        HStack {
                            Text("MD")
                            RRSpacer.width(RRSpacing.md)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                        }
                        HStack {
                            Text("LG")
                            RRSpacer.width(RRSpacing.lg)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(RRSpacing.paddingMD)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Divider examples
                VStack(spacing: RRSpacing.md) {
                    Text("Divider Utilities")
                        .font(.headline)
                    
                    VStack {
                        Text("Section 1")
                        RRDivider.horizontal()
                        Text("Section 2")
                        RRDivider.horizontal(color: .red, thickness: 2)
                        Text("Section 3")
                    }
                    .padding(RRSpacing.paddingMD)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .previewDisplayName("RRStackedView Examples")
    }
}
#endif
