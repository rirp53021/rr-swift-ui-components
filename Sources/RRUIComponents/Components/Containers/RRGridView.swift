// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Grid View

public struct RRGridView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: Int
    private let spacing: CGFloat
    private let content: (Data.Element) -> Content
    
    public init(
        _ data: Data,
        columns: Int,
        spacing: CGFloat = RRSpacing.md,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                content(item)
            }
        }
    }
    
    /// Safely gets an item at the specified index
    /// - Parameter index: The index of the item
    /// - Returns: The item at the index, or nil if out of bounds
    public func safeItem(at index: Int) -> Data.Element? {
        let dataArray = Array(data)
        guard index >= 0 && index < dataArray.count else { return nil }
        return dataArray[index]
    }
}

// MARK: - Grid Presets

public struct RRGridPresets {
    public static let twoColumn = 2
    public static let threeColumn = 3
    public static let fourColumn = 4
    public static let fiveColumn = 5
    
    public static let compactSpacing: CGFloat = RRSpacing.xs
    public static let standardSpacing: CGFloat = RRSpacing.md
    public static let relaxedSpacing: CGFloat = RRSpacing.lg
}

// MARK: - Grid View with Padding

public struct RRGridViewWithPadding<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: Int
    private let spacing: CGFloat
    private let padding: CGFloat
    private let content: (Data.Element) -> Content
    
    public init(
        _ data: Data,
        columns: Int,
        spacing: CGFloat = RRSpacing.md,
        padding: CGFloat = RRSpacing.md,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.padding = padding
        self.content = content
    }
    
    public var body: some View {
        RRGridView(data, columns: columns, spacing: spacing, content: content)
            .padding(padding)
    }
}

// MARK: - Preview

#if DEBUG
struct RRGridView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = (0..<10).map { id in
            SampleItem(id: id, title: "Item \(id)")
        }
        
        VStack(spacing: 20) {
            Text("2 Column Grid")
                .font(.headline)
            
            RRGridView(sampleData, columns: 2) { item in
                VStack {
                    Text(item.title)
                        .font(.caption)
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(height: 50)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text("3 Column Grid")
                .font(.headline)
            
            RRGridView(sampleData, columns: 3) { item in
                VStack {
                    Text(item.title)
                        .font(.caption)
                    Rectangle()
                        .fill(Color.green.opacity(0.3))
                        .frame(height: 40)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct SampleItem: Identifiable {
    let id: Int
    let title: String
}
#endif
