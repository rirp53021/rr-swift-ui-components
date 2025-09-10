// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Search Bar

public struct RRSearchBar: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var text: String
    private let placeholder: String
    private let onSearch: (String) -> Void
    private let onCancel: () -> Void
    private let suggestions: [Suggestion]
    private let onSuggestionTap: (Suggestion) -> Void
    
    @State private var isSearching = false
    @State private var showSuggestions = false
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        suggestions: [Suggestion] = [],
        onSearch: @escaping (String) -> Void = { _ in },
        onCancel: @escaping () -> Void = {},
        onSuggestionTap: @escaping (Suggestion) -> Void = { _ in }
    ) {
        self._text = text
        self.placeholder = placeholder
        self.suggestions = suggestions
        self.onSearch = onSearch
        self.onCancel = onCancel
        self.onSuggestionTap = onSuggestionTap
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(theme.colors.secondaryText)
                    
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(theme.colors.primaryText)
                        .onSubmit {
                            onSearch(text)
                        }
                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(theme.colors.secondaryText)
                        }
                    }
                }
                .padding(DesignTokens.Spacing.sm)
                .background(theme.colors.surfaceVariant)
                .cornerRadius(DesignTokens.BorderRadius.md)
                
                if isSearching {
                    Button("Cancel", action: {
                        withAnimation {
                            isSearching = false
                            text = ""
                            showSuggestions = false
                        }
                        onCancel()
                    })
                    .foregroundColor(theme.colors.primary)
                }
            }
            
            if showSuggestions && !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions, id: \.id) { suggestion in
                        SuggestionRow(suggestion: suggestion) {
                            onSuggestionTap(suggestion)
                            showSuggestions = false
                        }
                    }
                }
                .background(theme.colors.surface)
                .cornerRadius(DesignTokens.BorderRadius.md)
                .shadow(color: theme.colors.outline.opacity(0.1), radius: DesignTokens.Elevation.level1.radius, x: 0, y: 2)
                .padding(.top, DesignTokens.Spacing.xs)
            }
        }
        .onChange(of: text) { newValue in
            showSuggestions = !newValue.isEmpty && !suggestions.isEmpty
        }
        .onTapGesture {
            withAnimation {
                isSearching = true
            }
        }
    }
}

// MARK: - Suggestion

public struct Suggestion {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let icon: String?
    
    public init(title: String, subtitle: String? = nil, icon: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

// MARK: - Suggestion Row

private struct SuggestionRow: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let suggestion: Suggestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if let icon = suggestion.icon {
                    Image(systemName: icon)
                        .foregroundColor(theme.colors.secondaryText)
                        .frame(width: DesignTokens.ComponentSize.iconSizeMD)
                }
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    RRLabel(suggestion.title, style: .body, weight: .medium, color: .primary)
                    
                    if let subtitle = suggestion.subtitle {
                        RRLabel(subtitle, style: .caption, weight: .regular, color: .secondary)
                    }
                }
                
                Spacer()
            }
            .padding(DesignTokens.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#if DEBUG
struct RRSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        RRSearchBarPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRSearchBar Examples")
    }
}

private struct RRSearchBarPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRLabel("Search Bar", style: .title, weight: .bold, color: .primary)
            
            RRSearchBar(
                text: $searchText,
                placeholder: "Search for something...",
                suggestions: [
                    Suggestion(title: "First Result", subtitle: "This is a subtitle", icon: "magnifyingglass"),
                    Suggestion(title: "Second Result", subtitle: "Another subtitle", icon: "star"),
                    Suggestion(title: "Third Result", subtitle: "Yet another subtitle", icon: "heart")
                ],
                onSearch: { query in
                    print("Searching for: \(query)")
                },
                onSuggestionTap: { suggestion in
                    print("Tapped suggestion: \(suggestion.title)")
                }
            )
        }
        .padding(DesignTokens.Spacing.componentPadding)
    }
}
#endif
