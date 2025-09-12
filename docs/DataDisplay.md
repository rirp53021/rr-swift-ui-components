# Data Display - RRUIComponents

## Overview

Data display components provide structured ways to present and interact with data. The RRUIComponents library includes components for tables, lists, grids, and charts.

## Components

- `RRTable` - Data table
- `RRList` - Enhanced list
- `RRDataGrid` - Grid data display
- `RRChart` - Basic charts

## RRTable

A data table component for displaying tabular data with sorting, filtering, and selection capabilities.

### Basic Usage

```swift
RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
```

### Initialization

```swift
RRTable<Data>(data: [Data], columns: [TableColumn<Data>])
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `data` | `[Data]` | Array of data items |
| `columns` | `[TableColumn<Data>]` | Table column definitions |
| `sortable` | `Bool` | Enable column sorting |
| `selectable` | `Bool` | Enable row selection |
| `searchable` | `Bool` | Enable table search |

### Examples

#### Basic Table
```swift
struct User {
    let name: String
    let email: String
    let age: Int
}

let users = [
    User(name: "John Doe", email: "john@example.com", age: 30),
    User(name: "Jane Smith", email: "jane@example.com", age: 25),
    User(name: "Bob Johnson", email: "bob@example.com", age: 35)
]

RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
```

#### With Sorting
```swift
RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
.sortable(true)
```

#### With Selection
```swift
@State private var selectedUsers: Set<User> = []

RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
.selectable(true)
.selection($selectedUsers)
```

#### With Search
```swift
@State private var searchText = ""

RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
.searchable(true)
.searchText($searchText)
```

#### With Custom Styling
```swift
RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age)
    ]
)
.headerStyle(.bold)
.rowStyle(.alternating)
.borderStyle(.solid)
```

#### With Actions
```swift
RRTable(
    data: users,
    columns: [
        TableColumn("Name", \.name),
        TableColumn("Email", \.email),
        TableColumn("Age", \.age),
        TableColumn("Actions", { _ in "" }) { user in
            HStack {
                RRButton("Edit") {
                    editUser(user)
                }
                .style(.ghost)
                .size(.small)
                
                RRButton("Delete") {
                    deleteUser(user)
                }
                .style(.ghost)
                .size(.small)
                .foregroundColor(.red)
            }
        }
    ]
)
```

## RRList

An enhanced list component with various styles and interactive features.

### Basic Usage

```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
```

### Initialization

```swift
RRList<Data, Content>(data: [Data], content: @escaping (Data) -> Content)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `data` | `[Data]` | Array of data items |
| `content` | `(Data) -> Content` | Content builder for each item |
| `style` | `ListStyle` | List visual style |
| `separator` | `SeparatorStyle` | Separator style |
| `selection` | `Binding<Set<Data>>` | Selected items |

### Examples

#### Basic List
```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
```

#### Grouped List
```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.style(.grouped)
```

#### With Selection
```swift
@State private var selectedItems: Set<Item> = []

RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.selection($selectedItems)
```

#### With Custom Separator
```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.separator(.custom) {
    RRDivider()
        .color(.primary)
        .thickness(1)
}
```

#### With Headers and Footers
```swift
RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.header {
    RRLabel("Items")
        .style(.headline)
        .padding()
}
.footer {
    RRLabel("\(items.count) items")
        .style(.caption)
        .foregroundColor(.secondary)
        .padding()
}
```

#### With Pull to Refresh
```swift
@State private var isRefreshing = false

RRList(data: items) { item in
    RRRowItem(
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon
    )
}
.refreshable {
    await refreshData()
}
```

## RRDataGrid

A grid data display component for presenting data in a grid format.

### Basic Usage

```swift
RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price),
        GridColumn("Stock", \.stock)
    ]
)
```

### Initialization

```swift
RRDataGrid<Data>(data: [Data], columns: [GridColumn<Data>])
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `data` | `[Data]` | Array of data items |
| `columns` | `[GridColumn<Data>]` | Grid column definitions |
| `sortable` | `Bool` | Enable column sorting |
| `filterable` | `Bool` | Enable column filtering |
| `resizable` | `Bool` | Enable column resizing |

### Examples

#### Basic Data Grid
```swift
struct Product {
    let name: String
    let price: Double
    let stock: Int
}

let products = [
    Product(name: "iPhone", price: 999.99, stock: 50),
    Product(name: "iPad", price: 799.99, stock: 30),
    Product(name: "MacBook", price: 1299.99, stock: 20)
]

RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price),
        GridColumn("Stock", \.stock)
    ]
)
```

#### With Sorting
```swift
RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price),
        GridColumn("Stock", \.stock)
    ]
)
.sortable(true)
```

#### With Filtering
```swift
RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price),
        GridColumn("Stock", \.stock)
    ]
)
.filterable(true)
```

#### With Custom Cell Content
```swift
RRDataGrid(
    data: products,
    columns: [
        GridColumn("Name", \.name),
        GridColumn("Price", \.price) { product in
            HStack {
                RRLabel("$\(product.price, specifier: "%.2f")")
                    .style(.body)
                    .foregroundColor(.primary)
                
                if product.price < 1000 {
                    RRBadge("Sale")
                        .style(.success)
                        .size(.small)
                }
            }
        },
        GridColumn("Stock", \.stock) { product in
            HStack {
                RRLabel("\(product.stock)")
                    .style(.body)
                
                if product.stock < 10 {
                    RRBadge("Low Stock")
                        .style(.warning)
                        .size(.small)
                }
            }
        }
    ]
)
```

## RRChart

A basic chart component for displaying data visualizations.

### Basic Usage

```swift
RRChart(
    data: [
        ChartDataPoint(label: "Jan", value: 100),
        ChartDataPoint(label: "Feb", value: 150),
        ChartDataPoint(label: "Mar", value: 200)
    ],
    type: .bar
)
```

### Initialization

```swift
RRChart(data: [ChartDataPoint], type: ChartType)
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `data` | `[ChartDataPoint]` | Chart data points |
| `type` | `ChartType` | Chart type |
| `style` | `ChartStyle` | Chart visual style |
| `showLabels` | `Bool` | Show data labels |
| `showLegend` | `Bool` | Show chart legend |

### Chart Types

| Type | Description | Use Case |
|------|-------------|----------|
| `.bar` | Bar chart | Comparing values |
| `.line` | Line chart | Trends over time |
| `.pie` | Pie chart | Parts of a whole |
| `.area` | Area chart | Filled line chart |

### Examples

#### Bar Chart
```swift
RRChart(
    data: [
        ChartDataPoint(label: "Q1", value: 100),
        ChartDataPoint(label: "Q2", value: 150),
        ChartDataPoint(label: "Q3", value: 200),
        ChartDataPoint(label: "Q4", value: 175)
    ],
    type: .bar
)
.showLabels(true)
.showLegend(true)
```

#### Line Chart
```swift
RRChart(
    data: monthlyData,
    type: .line
)
.style(.smooth)
.showLabels(true)
```

#### Pie Chart
```swift
RRChart(
    data: [
        ChartDataPoint(label: "iOS", value: 60),
        ChartDataPoint(label: "Android", value: 30),
        ChartDataPoint(label: "Other", value: 10)
    ],
    type: .pie
)
.showLegend(true)
```

#### Area Chart
```swift
RRChart(
    data: yearlyData,
    type: .area
)
.style(.gradient)
.showLabels(true)
```

#### With Custom Styling
```swift
RRChart(
    data: chartData,
    type: .bar
)
.style(.custom)
.color(.blue)
.backgroundColor(.surface)
.cornerRadius(8)
```

#### Interactive Chart
```swift
@State private var selectedDataPoint: ChartDataPoint?

RRChart(
    data: chartData,
    type: .line
)
.onDataPointTap { dataPoint in
    selectedDataPoint = dataPoint
}
.overlay(
    Group {
        if let selected = selectedDataPoint {
            VStack {
                RRLabel(selected.label)
                    .style(.headline)
                RRLabel("\(selected.value)")
                    .style(.body)
            }
            .padding()
            .background(.surface)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
    }
)
```

## Best Practices

### Data Display Design

1. **Clear Headers**: Use clear, descriptive column headers
2. **Consistent Formatting**: Maintain consistent data formatting
3. **Appropriate Density**: Balance information density with readability
4. **Visual Hierarchy**: Use typography and spacing to create hierarchy

### Performance

1. **Lazy Loading**: Use lazy loading for large datasets
2. **Efficient Rendering**: Minimize unnecessary re-renders
3. **Memory Management**: Properly manage data state
4. **Caching**: Implement appropriate data caching

### Accessibility

1. **Screen Readers**: Ensure data is accessible to screen readers
2. **Keyboard Navigation**: Support keyboard navigation
3. **Clear Labels**: Use clear, descriptive labels
4. **Focus Management**: Manage focus appropriately

## Common Patterns

### Data Table with Search and Filter
```swift
struct SearchableDataTable: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var sortOrder: SortOrder = .ascending
    
    let items: [Item]
    let categories: [String]
    
    var filteredItems: [Item] {
        var filtered = items
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { item1, item2 in
            switch sortOrder {
            case .ascending:
                return item1.title < item2.title
            case .descending:
                return item1.title > item2.title
            }
        }
    }
    
    var body: some View {
        VStack {
            // Search and filter controls
            HStack {
                RRSearchBar(text: $searchText)
                
                RRDropdown("Category", selection: $selectedCategory, options: categories)
            }
            .padding()
            
            // Data table
            RRTable(
                data: filteredItems,
                columns: [
                    TableColumn("Title", \.title),
                    TableColumn("Category", \.category),
                    TableColumn("Date", \.date)
                ]
            )
            .sortable(true)
        }
    }
}
```

### Dashboard with Charts
```swift
struct DashboardView: View {
    let salesData: [ChartDataPoint]
    let revenueData: [ChartDataPoint]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Sales chart
                VStack(alignment: .leading) {
                    RRLabel("Sales Overview")
                        .style(.headline)
                    
                    RRChart(data: salesData, type: .bar)
                        .frame(height: 200)
                }
                .padding()
                .background(.surface)
                .cornerRadius(12)
                
                // Revenue chart
                VStack(alignment: .leading) {
                    RRLabel("Revenue Trends")
                        .style(.headline)
                    
                    RRChart(data: revenueData, type: .line)
                        .frame(height: 200)
                }
                .padding()
                .background(.surface)
                .cornerRadius(12)
                
                // Data table
                VStack(alignment: .leading) {
                    RRLabel("Recent Transactions")
                        .style(.headline)
                    
                    RRTable(
                        data: recentTransactions,
                        columns: [
                            TableColumn("Date", \.date),
                            TableColumn("Amount", \.amount),
                            TableColumn("Status", \.status)
                        ]
                    )
                }
                .padding()
                .background(.surface)
                .cornerRadius(12)
            }
            .padding()
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Table not sorting**: Check if sortable is enabled and data is sortable
2. **Chart not displaying**: Verify data format and chart type
3. **List not updating**: Check if data binding is properly connected

### Debug Tips

1. Use `.background(.red)` to visualize component bounds
2. Check console for data-related warnings
3. Verify data format and structure
4. Test with different data sets
