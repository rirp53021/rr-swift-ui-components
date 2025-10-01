// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Tab Item

public struct TabItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: Image
    public let selectedIcon: Image?
    public let badge: String?
    
    public init(
        title: String,
        icon: Image,
        selectedIcon: Image? = nil,
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
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
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
                tabButton(for: item, at: index)
            }
        }
        .background(theme.colors.surfaceVariant)
        .shadow(color: theme.colors.outline.opacity(0.1), radius: DesignTokens.Elevation.level1.radius, x: 0, y: 1)
        .keyboardNavigation(
            config: .navigation,
            onMovement: { action in
                handleKeyboardMovement(action)
            }
        )
        .keyboardNavigationAccessibility(config: .navigation)
    }
    
    private func tabButton(for item: TabItem, at index: Int) -> some View {
        Button(action: {
            selectedTab = index
            onTabSelected(index)
        }) {
            VStack(spacing: DesignTokens.Spacing.xs) {
                tabIcon(for: item, at: index)
                tabTitle(for: item, at: index)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func tabIcon(for item: TabItem, at index: Int) -> some View {
        ZStack {
            let displayIcon = selectedTab == index ? (item.selectedIcon ?? item.icon) : item.icon
            displayIcon
                .foregroundColor(selectedTab == index ? theme.colors.primary : theme.colors.secondaryText)
                .font(DesignTokens.Typography.titleSmall)
            
            if let badge = item.badge, selectedTab == index {
                badgeView(badge)
            }
        }
    }
    
    private func tabTitle(for item: TabItem, at index: Int) -> some View {
        RRLabel(
            item.title,
            style: .caption,
            weight: .medium,
            customColor: selectedTab == index ? theme.colors.primary : theme.colors.secondaryText
        )
    }
    
    private func badgeView(_ badge: String) -> some View {
        RRLabel(
            badge,
            style: .caption,
            weight: .medium,
            customColor: theme.colors.onError
        )
        .padding(.horizontal, DesignTokens.Spacing.xs)
        .padding(.vertical, DesignTokens.Spacing.xs)
        .background(theme.colors.error)
        .cornerRadius(DesignTokens.BorderRadius.sm)
        .offset(x: 12, y: -8)
    }
    
    private func handleKeyboardMovement(_ action: KeyboardMovementAction) {
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
        RRTabBarPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRTabBar Examples")
    }
}

private struct RRTabBarPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel.title("Tab Bar")
            
            RRTabBar(
                selectedTab: .constant(0),
                items: [
                    TabItem(title: "Home", icon: Image(systemName: "house"), selectedIcon: Image(systemName: "house.fill")),
                    TabItem(title: "Search", icon: Image(systemName: "magnifyingglass"), badge: "3"),
                    TabItem(title: "Profile", icon: Image(systemName: "person"), selectedIcon: Image(systemName: "person.fill")),
                    TabItem(title: "Settings", icon: Image(systemName: "gear"))
                ]
            )
        }
        .padding(DesignTokens.Spacing.md)
    }
}
#endif
