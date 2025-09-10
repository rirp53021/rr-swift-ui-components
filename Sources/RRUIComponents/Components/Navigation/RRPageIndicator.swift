// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI

// MARK: - Page Indicator Style

public enum PageIndicatorStyle {
    case dots
    case lines
    case numbers
}

// MARK: - RRPageIndicator

/// A customizable page indicator component for carousels and paginated content
public struct RRPageIndicator: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let currentPage: Int
    private let totalPages: Int
    private let style: PageIndicatorStyle
    private let onPageSelected: (Int) -> Void
    
    public init(
        currentPage: Int,
        totalPages: Int,
        style: PageIndicatorStyle = .dots,
        onPageSelected: @escaping (Int) -> Void = { _ in }
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.style = style
        self.onPageSelected = onPageSelected
    }
    
    public var body: some View {
        switch style {
        case .dots:
            dotsIndicator
        case .lines:
            linesIndicator
        case .numbers:
            numbersIndicator
        }
    }
    
    // MARK: - Dots Indicator
    
    private var dotsIndicator: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(action: {
                    onPageSelected(index)
                }) {
                    Circle()
                        .fill(index == currentPage ? theme.colors.primary : theme.colors.outlineVariant)
                        .frame(width: DesignTokens.Spacing.sm, height: DesignTokens.Spacing.sm)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(DesignTokens.Animation.easeInOut, value: currentPage)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Lines Indicator
    
    private var linesIndicator: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(action: {
                    onPageSelected(index)
                }) {
                    RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                        .fill(index == currentPage ? theme.colors.primary : theme.colors.outlineVariant)
                        .frame(width: index == currentPage ? DesignTokens.Spacing.lg : DesignTokens.Spacing.sm, height: DesignTokens.Spacing.xs)
                        .animation(DesignTokens.Animation.easeInOut, value: currentPage)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Numbers Indicator
    
    private var numbersIndicator: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(0..<totalPages, id: \.self) { index in
                Button(action: {
                    onPageSelected(index)
                }) {
                    Text("\(index + 1)")
                        .font(DesignTokens.Typography.labelMedium)
                        .fontWeight(index == currentPage ? DesignTokens.Typography.weightSemibold : DesignTokens.Typography.weightRegular)
                        .foregroundColor(index == currentPage ? theme.colors.onPrimary : theme.colors.onSurfaceVariant)
                        .frame(width: DesignTokens.Spacing.lg, height: DesignTokens.Spacing.lg)
                        .background(
                            Circle()
                                .fill(index == currentPage ? theme.colors.primary : theme.colors.surfaceVariant)
                        )
                        .animation(DesignTokens.Animation.easeInOut, value: currentPage)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct RRPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignTokens.Spacing.sectionSpacing) {
            RRLabel.title("Page Indicators")
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                // Dots style
                VStack {
                    RRLabel.subtitle("Dots Style")
                    RRPageIndicator(
                        currentPage: 1,
                        totalPages: 5,
                        style: .dots
                    )
                }
                
                // Lines style
                VStack {
                    RRLabel.subtitle("Lines Style")
                    RRPageIndicator(
                        currentPage: 2,
                        totalPages: 4,
                        style: .lines
                    )
                }
                
                // Numbers style
                VStack {
                    RRLabel.subtitle("Numbers Style")
                    RRPageIndicator(
                        currentPage: 0,
                        totalPages: 3,
                        style: .numbers
                    )
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .previewDisplayName("RRPageIndicator")
    }
}
#endif
