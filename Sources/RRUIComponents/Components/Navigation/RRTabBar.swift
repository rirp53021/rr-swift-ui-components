// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Tab Item

public struct TabItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: String?
    
    public init(
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: String? = nil
    ) {
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
    }
}

// MARK: - RRTabBar

public struct RRTabBar: View {
    @Binding private var selectedTab: Int
    private let items: [TabItem]
    private let onTabSelected: (Int) -> Void
    
    public init(
        selectedTab: Binding<Int>,
        items: [TabItem],
        onTabSelected: @escaping (Int) -> Void = { _ in }
    ) {
        self._selectedTab = selectedTab
        self.items = items
        self.onTabSelected = onTabSelected
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: {
                    selectedTab = index
                    onTabSelected(index)
                }) {
                    VStack(spacing: RRSpacing.xs) {
                        ZStack {
                            Image(systemName: selectedTab == index ? (item.selectedIcon ?? item.icon) : item.icon)
                                .foregroundColor(selectedTab == index ? .blue : .gray)
                                .font(.title3)
                            
                            if let badge = item.badge, selectedTab == index {
                                Text(badge)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .cornerRadius(8)
                                    .offset(x: 12, y: -8)
                            }
                        }
                        
                        Text(item.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, RRSpacing.sm)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
        .keyboardNavigation(
            config: .navigation,
            onMovement: { action in
                switch action {
                case .moveLeft:
                    if selectedTab > 0 {
                        selectedTab -= 1
                        onTabSelected(selectedTab)
                    }
                case .moveRight:
                    if selectedTab < items.count - 1 {
                        selectedTab += 1
                        onTabSelected(selectedTab)
                    }
                case .moveToStart:
                    selectedTab = 0
                    onTabSelected(selectedTab)
                case .moveToEnd:
                    selectedTab = items.count - 1
                    onTabSelected(selectedTab)
                default:
                    break
                }
            }
        )
        .keyboardNavigationAccessibility(config: .navigation)
    }
}

// MARK: - Tab Bar with Content

public struct RRTabBarWithContent<Content: View>: View {
    @Binding private var selectedTab: Int
    private let items: [TabItem]
    private let content: Content
    private let onTabSelected: (Int) -> Void
    
    public init(
        selectedTab: Binding<Int>,
        items: [TabItem],
        onTabSelected: @escaping (Int) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedTab = selectedTab
        self.items = items
        self.onTabSelected = onTabSelected
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            content
            
            RRTabBar(
                selectedTab: $selectedTab,
                items: items,
                onTabSelected: onTabSelected
            )
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Tab Bar")
                .font(.headline)
            
            RRTabBar(
                selectedTab: .constant(0),
                items: [
                    TabItem(title: "Home", icon: "house", selectedIcon: "house.fill"),
                    TabItem(title: "Search", icon: "magnifyingglass", badge: "3"),
                    TabItem(title: "Profile", icon: "person", selectedIcon: "person.fill"),
                    TabItem(title: "Settings", icon: "gear")
                ]
            )
        }
        .padding()
    }
}
#endif
