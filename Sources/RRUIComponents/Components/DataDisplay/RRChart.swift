import SwiftUI

/// A basic chart component for displaying simple data visualizations
public struct RRChart<Data: RandomAccessCollection>: View where Data.Element: ChartDataPoint {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let data: Data
    private let style: ChartStyle
    private let type: ChartType
    private let showValues: Bool
    private let showGrid: Bool
    
    // MARK: - Initialization
    
    /// Creates a chart with the specified data and style
    /// - Parameters:
    ///   - data: The data to display
    ///   - type: The chart type
    ///   - style: The chart style
    ///   - showValues: Whether to show data values
    ///   - showGrid: Whether to show grid lines
    public init(
        _ data: Data,
        type: ChartType = .bar,
        style: ChartStyle = .default,
        showValues: Bool = false,
        showGrid: Bool = true
    ) {
        self.data = data
        self.type = type
        self.style = style
        self.showValues = showValues
        self.showGrid = showGrid
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            // Chart content
            ZStack {
                // Grid
                if showGrid {
                    ChartGrid(style: style)
                }
                
                // Chart data
                ChartContent(
                    data: data,
                    type: type,
                    style: style,
                    showValues: showValues
                )
            }
            .frame(height: style.height)
            .padding(style.padding)
            .background(theme.colors.surface)
            .cornerRadius(style.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(theme.colors.outline, lineWidth: style.borderWidth)
            )
        }
    }
}

// MARK: - Chart Content

private struct ChartContent<Data: RandomAccessCollection>: View where Data.Element: ChartDataPoint {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let data: Data
    let type: ChartType
    let style: ChartStyle
    let showValues: Bool
    
    var body: some View {
        GeometryReader { geometry in
            switch type {
            case .bar:
                BarChart(
                    data: data,
                    geometry: geometry,
                    style: style,
                    showValues: showValues
                )
            case .line:
                LineChart(
                    data: data,
                    geometry: geometry,
                    style: style,
                    showValues: showValues
                )
            case .pie:
                PieChart(
                    data: data,
                    geometry: geometry,
                    style: style,
                    showValues: showValues
                )
            }
        }
    }
}

// MARK: - Bar Chart

private struct BarChart<Data: RandomAccessCollection>: View where Data.Element: ChartDataPoint {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let data: Data
    let geometry: GeometryProxy
    let style: ChartStyle
    let showValues: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: style.barSpacing) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                VStack(spacing: DesignTokens.Spacing.xs) {
                    if showValues {
                        RRLabel(String(format: "%.1f", item.value), style: .caption, color: .secondary)
                    }
                    
                    Rectangle()
                        .fill(theme.colors.primary)
                        .frame(
                            width: style.barWidth,
                            height: barHeight(for: item.value, in: geometry)
                        )
                        .cornerRadius(style.barCornerRadius)
                    
                    RRLabel(item.label, style: .caption, color: .secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func barHeight(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let maxValue = data.map(\.value).max() ?? 1
        let availableHeight = geometry.size.height - 40 // Account for labels
        return CGFloat(value / maxValue) * availableHeight
    }
}

// MARK: - Line Chart

private struct LineChart<Data: RandomAccessCollection>: View where Data.Element: ChartDataPoint {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let data: Data
    let geometry: GeometryProxy
    let style: ChartStyle
    let showValues: Bool
    
    var body: some View {
        ZStack {
            // Line path
            Path { path in
                let points = dataPoints(in: geometry)
                guard let firstPoint = points.first else { return }
                
                path.move(to: firstPoint)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(theme.colors.primary, lineWidth: style.lineWidth)
            
            // Data points
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                let point = dataPoint(for: item, at: index, in: geometry)
                Circle()
                    .fill(theme.colors.primary)
                    .frame(width: style.pointSize, height: style.pointSize)
                    .position(point)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func dataPoints(in geometry: GeometryProxy) -> [CGPoint] {
        return data.enumerated().map { index, item in
            dataPoint(for: item, at: index, in: geometry)
        }
    }
    
    private func dataPoint(for item: Data.Element, at index: Int, in geometry: GeometryProxy) -> CGPoint {
        let maxValue = data.map(\.value).max() ?? 1
        let x = CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width
        let y = geometry.size.height - (CGFloat(item.value / maxValue) * geometry.size.height)
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Pie Chart

private struct PieChart<Data: RandomAccessCollection>: View where Data.Element: ChartDataPoint {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let data: Data
    let geometry: GeometryProxy
    let style: ChartStyle
    let showValues: Bool
    
    private let colors: [Color] = [
        Color.blue, Color.green, Color.orange, Color.red, Color.purple, Color.pink, Color.cyan
    ]
    
    var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: colors[index % colors.count]
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func startAngle(for index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let start = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (start / total) * 360)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let end = data.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: (end / total) * 360)
    }
}

// MARK: - Pie Slice

private struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 150, y: 150) // Fixed center for simplicity
            let radius: CGFloat = 100
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
    }
}

// MARK: - Chart Grid

private struct ChartGrid: View {
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let style: ChartStyle
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Horizontal grid lines
                for i in 0...4 {
                    let y = CGFloat(i) / 4 * geometry.size.height
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                
                // Vertical grid lines
                for i in 0...4 {
                    let x = CGFloat(i) / 4 * geometry.size.width
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .stroke(theme.colors.outlineVariant, lineWidth: 0.5)
        }
    }
}

// MARK: - Chart Data Point

public protocol ChartDataPoint {
    var label: String { get }
    var value: Double { get }
}

// MARK: - Chart Type

public enum ChartType {
    case bar
    case line
    case pie
}

// MARK: - Chart Style

public struct ChartStyle {
    public let height: CGFloat
    public let padding: CGFloat
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let barWidth: CGFloat
    public let barSpacing: CGFloat
    public let barCornerRadius: CGFloat
    public let lineWidth: CGFloat
    public let pointSize: CGFloat
    
    public init(
        height: CGFloat = 200,
        padding: CGFloat = DesignTokens.Spacing.md,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        borderWidth: CGFloat = 1,
        barWidth: CGFloat = 30,
        barSpacing: CGFloat = DesignTokens.Spacing.sm,
        barCornerRadius: CGFloat = DesignTokens.BorderRadius.sm,
        lineWidth: CGFloat = 2,
        pointSize: CGFloat = 8
    ) {
        self.height = height
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.barWidth = barWidth
        self.barSpacing = barSpacing
        self.barCornerRadius = barCornerRadius
        self.lineWidth = lineWidth
        self.pointSize = pointSize
    }
    
    public static let `default` = ChartStyle()
    public static let compact = ChartStyle(
        height: 150,
        padding: DesignTokens.Spacing.sm,
        barWidth: 20,
        barSpacing: DesignTokens.Spacing.xs
    )
    public static let spacious = ChartStyle(
        height: 300,
        padding: DesignTokens.Spacing.lg,
        barWidth: 40,
        barSpacing: DesignTokens.Spacing.md
    )
}

// MARK: - Previews

#if DEBUG
struct RRChart_Previews: PreviewProvider {
    static var previews: some View {
        RRChartPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRChart Examples")
    }
}

private struct RRChartPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let sampleData = [
        ChartData(label: "Jan", value: 20),
        ChartData(label: "Feb", value: 35),
        ChartData(label: "Mar", value: 28),
        ChartData(label: "Apr", value: 42),
        ChartData(label: "May", value: 38),
        ChartData(label: "Jun", value: 45)
    ]
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Chart Examples")
            
            // Bar chart
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                RRLabel("Bar Chart", style: .subtitle, weight: .semibold)
                RRChart(sampleData, type: .bar, showValues: true)
            }
            
            // Line chart
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                RRLabel("Line Chart", style: .subtitle, weight: .semibold)
                RRChart(sampleData, type: .line, showValues: true)
            }
            
            // Pie chart
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                RRLabel("Pie Chart", style: .subtitle, weight: .semibold)
                RRChart(sampleData, type: .pie, showValues: true)
            }
        }
        .padding(DesignTokens.Spacing.md)
    }
}

private struct ChartData: ChartDataPoint {
    let label: String
    let value: Double
}
#endif
